const connection = require("../config/data");
const moment = require("moment");
require("moment/locale/vi"); // bắt buộc để moment hiểu tiếng Việt
const { v4: uuidv4 } = require("uuid");
require("dotenv").config();
const { sendSimpleEmail } = require("./emailService");
const { ensurePriceAtBookingColumn, getSchedulePriceAtBooking } = require("./adminDashboardService");
const { withTransaction } = require("./transactionService");
const { assignBookingQueueNumberInCurrentTransaction } = require("./bookingQueueService");
const { createDoctorNotification } = require("./doctorNotificationService");
const {
  buildCapacitySummary,
  getCapacityExcludedStatusIds,
  updateBookingStatus,
} = require("./bookingStatusService");
const {
  isDateInBookingWindow,
  isScheduleStarted,
  normalizeDate,
} = require("./doctor/doctorSchedulePolicy");
const {
  canPatientJoinVideoBooking,
} = require("./videoConsultationService");
const { getReviewEligibilityFromBooking } = require("./doctorReviewService");

const CAPACITY_EXCLUDED_STATUS_IDS = getCapacityExcludedStatusIds();
const activeStatusPlaceholders = () => CAPACITY_EXCLUDED_STATUS_IDS.map(() => "?").join(", ");

// Tạo link xác nhận lịch gửi qua email cho bệnh nhân.
const buildUrlEmail = (scheduleId, token) => {
  return `${process.env.URL_REACT}/verify-booking?token=${token}&scheduleId=${scheduleId}`;
};

// Lấy thông tin lịch khám và bác sĩ từ scheduleId để phục vụ đặt lịch.
const getScheduleMeta = async (scheduleId) => {
  const [rows] = await connection.promise().query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
        s.startTime,
        s.endTime,
        s.appointmentTypeId,
        COALESCE(s.capacity, 1) AS capacity,
        COALESCE(s.isActive, 1) AS isActive,
        COALESCE(s.minBookingNoticeDays, 0) AS minBookingNoticeDays,
        COALESCE(s.maxBookingAheadDays, 30) AS maxBookingAheadDays,
        u.firstName,
        u.lastName
      FROM schedule s
      LEFT JOIN users u
        ON s.doctorId = u.id
      WHERE s.id = ?
      LIMIT 1
    `,
    [scheduleId]
  );

  return rows[0] || null;
};

// Khóa lịch trong transaction rồi kiểm tra booking chưa hủy để tránh đặt trùng slot.
const getScheduleAvailabilityInCurrentTransaction = async (scheduleId, db) => {
  const [scheduleRows] = await db.query(
    `
      SELECT
        id,
        doctorId,
        date,
        timeType,
        startTime,
        endTime,
        appointmentTypeId,
        COALESCE(capacity, 1) AS capacity,
        COALESCE(isActive, 1) AS isActive,
        COALESCE(minBookingNoticeDays, 0) AS minBookingNoticeDays,
        COALESCE(maxBookingAheadDays, 30) AS maxBookingAheadDays,
        price,
        discountPercent
      FROM schedule
      WHERE id = ?
      LIMIT 1
      FOR UPDATE
    `,
    [scheduleId]
  );

  if (scheduleRows.length === 0) {
    return null;
  }

  const [bookingRows] = await db.query(
    `
      SELECT COUNT(*) AS bookedCount
      FROM booking
      WHERE scheduleId = ?
        AND statusId NOT IN (${activeStatusPlaceholders()})
    `,
    [scheduleId, ...CAPACITY_EXCLUDED_STATUS_IDS]
  );
  const bookedCount = Number(bookingRows[0]?.bookedCount) || 0;

  return {
    ...scheduleRows[0],
    ...buildCapacitySummary(bookedCount, scheduleRows[0].capacity),
  };
};

const normalizeOptionalReason = (value) => {
  const reason = typeof value === "string" ? value.trim() : "";
  return reason || null;
};

const isValidBookingPrice = (value) => {
  const price = Number(value);
  return Number.isInteger(price) && price > 0;
};

const getBookingPatient = async (patientId, db) => {
  const [rows] = await db.query(
    `
      SELECT id, email, firstName, lastName
      FROM users
      WHERE id = ? AND roleId = 'R3'
      LIMIT 1
    `,
    [patientId]
  );

  return rows[0] || null;
};

// Đặt lịch khám, tạo booking và cấp STT hàng đợi trong cùng transaction.
const bookAppointment = async (data, authenticatedPatientId) => {
  try {
    if (!data || !data.scheduleId || !authenticatedPatientId) {
      return { errCode: 1, errMessage: "Missing required parameters" };
    }

    const { scheduleId } = data;
    const reason = normalizeOptionalReason(data.reason);

    const scheduleMeta = await getScheduleMeta(scheduleId);
    if (!scheduleMeta) {
      return {
        errCode: 3,
        errMessage: "Selected schedule does not exist",
      };
    }

    const token = uuidv4();
    await ensurePriceAtBookingColumn();

    // Gói tạo/cập nhật bệnh nhân, chống đặt trùng và cấp queue trong một transaction.
    const bookingResult = await withTransaction(async (db) => {
      const availability = await getScheduleAvailabilityInCurrentTransaction(scheduleId, db);
      if (!availability) {
        return { missingSchedule: true };
      }

      if (Number(availability.isActive) !== 1) {
        return { inactiveSchedule: true };
      }

      if (availability.remaining <= 0) {
        return { booked: true };
      }

      if (isScheduleStarted(availability)) {
        return { scheduleStarted: true };
      }

      if (
        !isDateInBookingWindow(
          availability.date,
          availability.minBookingNoticeDays,
          availability.maxBookingAheadDays
        )
      ) {
        return { outsideBookingWindow: true };
      }

      if (availability.appointmentTypeId === "AT2") {
        return { onlinePaymentUnavailable: true };
      }

      const patient = await getBookingPatient(authenticatedPatientId, db);
      if (!patient) {
        return { missingPatient: true };
      }

      const [existingBookings] = await db.query(
        `
          SELECT id
          FROM booking
          WHERE scheduleId = ?
            AND patientId = ?
            AND statusId NOT IN (${activeStatusPlaceholders()})
          LIMIT 1
        `,
        [scheduleId, patient.id, ...CAPACITY_EXCLUDED_STATUS_IDS]
      );

      if (existingBookings.length > 0) {
        return { duplicateBooking: true };
      }

      // Tạo booking ở trạng thái chờ xác nhận, sau đó cấp STT để bệnh nhân thấy số thứ tự.
      const bookingDate = normalizeDate(availability.date);
      const priceAtBooking = await getSchedulePriceAtBooking(
        scheduleId,
        availability.doctorId,
        availability.appointmentTypeId,
        db
      );

      if (!isValidBookingPrice(priceAtBooking)) {
        return { invalidPrice: true };
      }

      const [booking] = await db.query(
        `
          INSERT INTO booking
            (statusId, scheduleId, patientId, date, reason, token, priceAtBooking, statusUpdatedAt)
          VALUES ('S1', ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        `,
        [
          scheduleId,
          patient.id,
          bookingDate,
          reason,
          token,
          priceAtBooking,
        ]
      );

      const queue = await assignBookingQueueNumberInCurrentTransaction(
        {
          bookingId: booking.insertId,
          doctorId: availability.doctorId,
          appointmentDate: bookingDate,
        },
        db
      );

      return {
        booking,
        bookingDate,
        queue: queue.data,
        patient,
        priceAtBooking,
      };
    });

    if (bookingResult.missingSchedule) {
      return {
        errCode: 3,
        errMessage: "Selected schedule does not exist",
      };
    }

    if (bookingResult.booked) {
      return {
        errCode: 4,
        errMessage: "Selected schedule is full.",
      };
    }

    if (bookingResult.inactiveSchedule) {
      return {
        errCode: 4,
        errMessage: "Selected schedule is not active.",
      };
    }

    if (bookingResult.scheduleStarted) {
      return {
        errCode: 4,
        errMessage: "Selected schedule has already started.",
      };
    }

    if (bookingResult.outsideBookingWindow) {
      return {
        errCode: 4,
        errMessage: "Selected schedule is outside the booking window.",
      };
    }

    if (bookingResult.onlinePaymentUnavailable) {
      return {
        errCode: 6,
        errMessage: "Online payment is not configured.",
      };
    }

    if (bookingResult.missingPatient) {
      return {
        errCode: 2,
        errMessage: "Patient profile was not found",
      };
    }

    if (bookingResult.duplicateBooking) {
      return {
        errCode: 4,
        errMessage: "You already have an active booking for this schedule.",
      };
    }

    if (bookingResult.invalidPrice) {
      return {
        errCode: 5,
        errMessage: "Consultation price is unavailable.",
      };
    }

    const doctorName =
      `${scheduleMeta.firstName || ""} ${scheduleMeta.lastName || ""}`.trim() || "Bac si";

    // Gửi email xác nhận sau khi transaction đã commit thành công.
    await sendSimpleEmail({
      reciverEmail: bookingResult.patient.email,
      patientName: `${bookingResult.patient.firstName} ${bookingResult.patient.lastName}`.trim(),
      time: `${scheduleMeta.startTime || scheduleMeta.timeType || ""}${
        scheduleMeta.endTime ? ` - ${scheduleMeta.endTime}` : ""
      } - ${moment(scheduleMeta.date).format("DD/MM/YYYY")}`,
      doctorName,
      redirectLink: buildUrlEmail(scheduleId, token),
    });

    return {
      errCode: 0,
      errMessage: "Booking appointment successfully!",
      data: {
        ...bookingResult.booking,
        queueId: bookingResult.queue?.id || null,
        queueNumber: bookingResult.queue?.queueNumber || null,
        queueAppointmentDate: bookingResult.queue?.appointmentDate || bookingResult.bookingDate,
        priceAtBooking: bookingResult.priceAtBooking,
      },
    };
  } catch (error) {
    console.log("bookAppointment error:", error);
    return {
      errCode: 1,
      errMessage: error.message,
      data: [],
    };
  }
};

// Xác nhận lịch hẹn từ token email và đảm bảo booking đã có STT hàng đợi.
const verifyBookAppointment = async (data) => {
  const status = {};
  try {
    // Kiểm tra tham số bắt buộc
    if (!data || !data.token || !data.scheduleId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { token, scheduleId } = data;

    // Khóa booking theo token để tránh hai request xác nhận cùng lúc làm lệch trạng thái/queue.
    const verifyResult = await withTransaction(async (db) => {
      const [rows] = await db.query(
        `
          SELECT
            b.id,
            b.date,
            b.statusId,
            s.doctorId
          FROM booking b
          INNER JOIN schedule s
            ON s.id = b.scheduleId
          WHERE b.scheduleId = ?
            AND b.token = ?
            AND b.statusId IN ('S1', 'S2')
          LIMIT 1
          FOR UPDATE
        `,
        [scheduleId, token]
      );

      if (rows.length === 0) {
        return null;
      }

      const booking = rows[0];

      // Chỉ nâng trạng thái S1 -> S2; booking đã S2 vẫn được trả lại thông tin queue.
      if (booking.statusId === "S1") {
        await db.query(
          `
            UPDATE booking
            SET statusId = 'S2', statusUpdatedAt = CURRENT_TIMESTAMP
            WHERE id = ? AND statusId = 'S1'
          `,
          [booking.id]
        );
        await createDoctorNotification({
          doctorId: booking.doctorId,
          bookingId: booking.id,
          type: "NEW_BOOKING",
        }, db);
      }

      const queue = await assignBookingQueueNumberInCurrentTransaction(
        {
          bookingId: booking.id,
          doctorId: booking.doctorId,
          appointmentDate: booking.date,
        },
        db
      );

      return {
        bookingId: booking.id,
        queue: queue.data,
      };
    });

    if (!verifyResult) {
      status.errCode = 2;
      status.errMessage = "Appointment has been activated or does not exist!";
      return status;
    }

    status.errCode = 0;
    status.errMessage = "Appointment activated successfully!";
    status.data = {
      bookingId: verifyResult.bookingId,
      queueId: verifyResult.queue?.id || null,
      queueNumber: verifyResult.queue?.queueNumber || null,
      queueAppointmentDate: verifyResult.queue?.appointmentDate || null,
    };
    return status;
  } catch (error) {
    console.log("verifyBookAppointment error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    return status;
  }
};

// Lấy toàn bộ user bệnh nhân trong hệ thống.
const AllPatient = async () => {
  const status = {};
  try {
    const [rows] = await connection
      .promise()
      .query(`SELECT * FROM users WHERE roleId = "R3"`);
    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("AllPatient error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

// Lấy danh sách lịch hẹn của một bệnh nhân kèm STT, trạng thái và thông tin bác sĩ.
const ListBookingForPatient = async (patientId) => {
  const status = {};
  try {
    const [rows] = await connection.promise().query(
      `
        SELECT
          b.id,
          b.scheduleId,
          b.date,
          s.timeType,
          s.appointmentTypeId,
          s.doctorId,
          b.statusId,
          b.cancelReason,
          b.rejectReason,
          b.noShowNote,
          b.statusUpdatedAt,
          bq.queueNumber,
          bq.appointmentDate AS queueAppointmentDate,
          ls.value_en AS statusEn,
          ls.value_vi AS statusVi,
          COALESCE(lt.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeEn,
          COALESCE(lt.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeVi,
          lat.value_en AS appointmentTypeEn,
          lat.value_vi AS appointmentTypeVi,
          u.firstName AS doctorFirstName,
          u.lastName AS doctorLastName,
          u.image AS doctorImage,
          clinic.name AS clinicName,
          clinic.address AS clinicAddress,
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.email AS patientEmail,
          patient.phoneNumber AS patientPhoneNumber,
          patient.address AS patientAddress,
          patient.gender AS patientGender,
          pp.medicalCode,
          pp.dateOfBirth,
          mr.id AS medicalRecordId,
          mr.doctorConclusion,
          mr.preliminaryDiagnosis,
          mr.followUpDate,
          mr.statusId AS medicalRecordStatusId,
          dr.id AS reviewId,
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt,
          ar.remindAt,
          ar.emailSentAt,
          ar.smsSentAt,
          ar.inAppNotifiedAt,
          ar.smsSkippedAt,
          ar.lastError AS reminderLastError
        FROM booking b
        INNER JOIN schedule s
          ON b.scheduleId = s.id
        INNER JOIN users u
          ON s.doctorId = u.id
        INNER JOIN users patient
          ON b.patientId = patient.id
        LEFT JOIN doctor_info di
          ON di.doctorId = s.doctorId
        LEFT JOIN clinic
          ON clinic.id = di.clinicId
        LEFT JOIN booking_queue bq
          ON bq.bookingId = b.id
        LEFT JOIN patient_profile pp
          ON pp.patientId = patient.id
        LEFT JOIN medical_record mr
          ON mr.bookingId = b.id
        LEFT JOIN doctor_reviews dr
          ON dr.bookingId = b.id
        LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id
        LEFT JOIN appointment_reminders ar
          ON ar.bookingId = b.id
        LEFT JOIN lookup ls
          ON b.statusId = ls.keyMap
         AND ls.type = 'STATUS'
        LEFT JOIN lookup lt
          ON s.timeType = lt.keyMap
         AND lt.type = 'TIME'
        LEFT JOIN lookup lat
          ON s.appointmentTypeId = lat.keyMap
         AND lat.type = 'APPOINTMENT_TYPE'
        WHERE b.patientId = ?
        ORDER BY b.date DESC, COALESCE(bq.queueNumber, 999999) ASC, COALESCE(TIME_TO_SEC(s.startTime), CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED)) ASC
      `,
      [patientId]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = (rows || []).map((row) => {
      const reviewEligibility = getReviewEligibilityFromBooking(row);
      return {
        ...row,
        reviewEligibility,
        canReviewDoctor: reviewEligibility.eligible,
        reviewedDoctor: reviewEligibility.reviewed,
        reviewReason: reviewEligibility.reason,
        canJoinVideo: canPatientJoinVideoBooking(row),
      };
    });
    return status;
  } catch (error) {
    console.log("ListBookingForPatient error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

// Hủy lịch hẹn của bệnh nhân theo cùng policy chuyển trạng thái với doctor/admin.
const cancelBookAppointment = async (data) => {
  return updateBookingStatus({
    bookingId: data?.BookingId,
    statusId: "S4",
    note: data?.cancelReason,
    actor: { id: data?.patientId, roleId: "R3" },
  });
};

module.exports = {
  bookAppointment,
  normalizeOptionalReason,
  isValidBookingPrice,
  verifyBookAppointment,
  AllPatient,
  ListBookingForPatient,
  cancelBookAppointment,
};
