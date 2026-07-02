const connection = require("../config/data");
const moment = require("moment");
require("moment/locale/vi"); // bắt buộc để moment hiểu tiếng Việt
const { v4: uuidv4 } = require("uuid");
require("dotenv").config();
const { sendSimpleEmail } = require("./emailService");
const { ensurePriceAtBookingColumn, getDoctorPriceAtBooking } = require("./adminDashboardService");
const { withTransaction } = require("./transactionService");
const { assignBookingQueueNumberInCurrentTransaction } = require("./bookingQueueService");
const {
  APPOINTMENT_TYPE_ONLINE,
  VIDEO_STATUS_IN_CALL,
  canPatientJoinVideoBooking,
  markVideoSessionCancelledForBooking,
} = require("./videoConsultationService");

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
        s.appointmentTypeId,
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

// Khóa lịch trong transaction rồi kiểm tra số booking chưa hủy để tránh vượt maxNumber.
const getScheduleCapacityInCurrentTransaction = async (scheduleId, db) => {
  const [scheduleRows] = await db.query(
    `
      SELECT id, maxNumber
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

  const maxNumber = Number(scheduleRows[0].maxNumber) > 0
    ? Number(scheduleRows[0].maxNumber)
    : 1;
  const [bookingRows] = await db.query(
    `
      SELECT COUNT(*) AS bookedCount
      FROM booking
      WHERE scheduleId = ?
        AND statusId <> 'S4'
    `,
    [scheduleId]
  );
  const bookedCount = Number(bookingRows[0]?.bookedCount) || 0;

  return {
    maxNumber,
    bookedCount,
    remaining: Math.max(maxNumber - bookedCount, 0),
  };
};

// Xác định patientId: dùng id đăng nhập nếu có, nếu không thì tìm/tạo user bệnh nhân theo email.
const resolvePatientId = async ({
  patientId,
  email,
  firstName,
  lastName,
  address,
  gender,
  phoneNumber,
}, db) => {
  const executor = db || connection.promise();

  if (patientId) {
    return patientId;
  }

  // Nếu email chưa tồn tại thì tạo tài khoản bệnh nhân tối giản cho booking.
  const [rows] = await executor.query(
    `SELECT id FROM users WHERE email = ?`,
    [email]
  );

  if (rows.length === 0) {
    const [insertUser] = await executor.query(
      `
        INSERT INTO users
          (email, firstName, lastName, address, gender, phoneNumber, roleId)
        VALUES (?, ?, ?, ?, ?, ?, 'R3')
      `,
      [email, firstName, lastName, address, gender, phoneNumber]
    );

    return insertUser.insertId;
  }

  const realPatientId = rows[0].id;

  // Nếu email đã có, cập nhật lại thông tin liên hệ mới nhất từ form đặt lịch.
  await executor.query(
    `
      UPDATE users
      SET firstName = ?, lastName = ?, address = ?, gender = ?, phoneNumber = ?
      WHERE id = ?
    `,
    [firstName, lastName, address, gender, phoneNumber, realPatientId]
  );

  return realPatientId;
};

// Đặt lịch khám, tạo booking và cấp STT hàng đợi trong cùng transaction.
const bookAppointment = async (data) => {
  try {
    if (!data || !data.scheduleId) {
      return { errCode: 1, errMessage: "Missing required parameters" };
    }

    const {
      email,
      firstName,
      lastName,
      address,
      gender,
      phoneNumber,
      scheduleId,
      date,
      reason,
      timeString,
      patientId
    } = data;

    const scheduleMeta = await getScheduleMeta(scheduleId);
    if (!scheduleMeta) {
      return {
        errCode: 3,
        errMessage: "Selected schedule does not exist",
      };
    }

    const bookingDate = moment(date, ["DD/MM/YYYY", moment.ISO_8601]).format("YYYY-MM-DD");
    const token = uuidv4();
    await ensurePriceAtBookingColumn();
    const priceAtBooking = await getDoctorPriceAtBooking(
      scheduleMeta.doctorId,
      scheduleMeta.appointmentTypeId
    );

    // Gói tạo/cập nhật bệnh nhân, chống đặt trùng và cấp queue trong một transaction.
    const bookingResult = await withTransaction(async (db) => {
      const capacity = await getScheduleCapacityInCurrentTransaction(scheduleId, db);
      if (!capacity) {
        return { missingSchedule: true };
      }

      if (capacity.remaining <= 0) {
        return { full: true };
      }

      const realPatientId = await resolvePatientId({
        patientId,
        email,
        firstName,
        lastName,
        address,
        gender,
        phoneNumber,
      }, db);

      const [existing] = await db.query(
        `
          SELECT id
          FROM booking
          WHERE scheduleId = ?
            AND patientId = ?
            AND date = ?
        `,
        [scheduleId, realPatientId, bookingDate]
      );

      if (existing.length > 0) {
        return {
          duplicate: true,
        };
      }

      // Tạo booking ở trạng thái chờ xác nhận, sau đó cấp STT để bệnh nhân thấy số thứ tự.
      const [booking] = await db.query(
        `
          INSERT INTO booking
            (statusId, scheduleId, patientId, date, reason, token, priceAtBooking)
          VALUES ('S1', ?, ?, ?, ?, ?, ?)
        `,
        [
          scheduleId,
          realPatientId,
          bookingDate,
          reason || null,
          token,
          priceAtBooking,
        ]
      );

      const queue = await assignBookingQueueNumberInCurrentTransaction(
        {
          bookingId: booking.insertId,
          doctorId: scheduleMeta.doctorId,
          appointmentDate: bookingDate,
        },
        db
      );

      return {
        duplicate: false,
        booking,
        queue: queue.data,
      };
    });

    if (bookingResult.missingSchedule) {
      return {
        errCode: 3,
        errMessage: "Selected schedule does not exist",
      };
    }

    if (bookingResult.full) {
      return {
        errCode: 4,
        errMessage: "Selected schedule is full.",
      };
    }

    if (bookingResult.duplicate) {
      return {
        errCode: 2,
        errMessage: "You already booked this schedule.",
      };
    }

    const doctorName =
      `${scheduleMeta.firstName || ""} ${scheduleMeta.lastName || ""}`.trim() || "Bac si";

    // Gửi email xác nhận sau khi transaction đã commit thành công.
    await sendSimpleEmail({
      reciverEmail: email,
      patientName: `${firstName} ${lastName}`.trim(),
      time: timeString,
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
        queueAppointmentDate: bookingResult.queue?.appointmentDate || bookingDate,
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
            SET statusId = 'S2'
            WHERE id = ? AND statusId = 'S1'
          `,
          [booking.id]
        );
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
          bq.queueNumber,
          bq.appointmentDate AS queueAppointmentDate,
          ls.value_en AS statusEn,
          ls.value_vi AS statusVi,
          lt.value_en AS timeEn,
          lt.value_vi AS timeVi,
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
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt
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
        LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id
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
        ORDER BY b.date DESC, COALESCE(bq.queueNumber, 999999) ASC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      [patientId]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = (rows || []).map((row) => ({
      ...row,
      canJoinVideo: canPatientJoinVideoBooking(row),
    }));
    return status;
  } catch (error) {
    console.log("ListBookingForPatient error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

// Hủy lịch hẹn nếu booking chưa hoàn tất và chưa bị hủy trước đó.
const cancelBookAppointment = async (data) => {
  const status = {};
  try {
    if (!data || !data.BookingId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { BookingId } = data;

    const cancelResult = await withTransaction(async (db) => {
      const [rows] = await db.query(
        `
          SELECT
            b.id,
            b.statusId,
            s.appointmentTypeId,
            vcs.statusId AS videoSessionStatusId
          FROM booking b
          INNER JOIN schedule s
            ON s.id = b.scheduleId
          LEFT JOIN video_consultation_session vcs
            ON vcs.bookingId = b.id
          WHERE b.id = ?
            AND b.statusId <> 'S3'
            AND b.statusId <> 'S4'
          LIMIT 1
          FOR UPDATE
        `,
        [BookingId]
      );

      if (rows.length === 0) {
        return { blocked: "notFound" };
      }

      const booking = rows[0];
      if (
        booking.appointmentTypeId === APPOINTMENT_TYPE_ONLINE &&
        booking.videoSessionStatusId === VIDEO_STATUS_IN_CALL
      ) {
        return { blocked: "onlineInCall" };
      }

      await db.query(
        `
          UPDATE booking
          SET statusId = 'S4'
          WHERE id = ?
            AND statusId <> 'S3'
            AND statusId <> 'S4'
        `,
        [BookingId]
      );

      return { blocked: null };
    });

    if (cancelResult.blocked === "notFound") {
      status.errCode = 2;
      status.errMessage = "Appointment cannot be canceled or does not exist!";
      return status;
    }

    if (cancelResult.blocked === "onlineInCall") {
      status.errCode = 3;
      status.errMessage = "Online appointment cannot be canceled after the video room has started.";
      return status;
    }

    await markVideoSessionCancelledForBooking(BookingId);

    status.errCode = 0;
    status.errMessage = "Appointment canceled successfully!";
    return status;
  } catch (error) {
    console.log("cancelBookAppointment error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    return status;
  }
};

module.exports = {
  bookAppointment,
  verifyBookAppointment,
  AllPatient,
  ListBookingForPatient,
  cancelBookAppointment,
};
