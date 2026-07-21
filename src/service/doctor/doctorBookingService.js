const connection = require("../../config/data");
const { sendResultEmail } = require("../emailService");
const { getBookingListScope } = require("../clinicAccessService");
const { normalizeDate } = require("./doctorScheduleService");
const { getPublicPaymentStatus } = require("../paymentService");

const GetListPatientForDoctor = async (doctorId, date) => {
  const status = {};
  try {
    if (!doctorId || !date) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      status.data = [];
      return status;
    }
    const normalizedDate = normalizeDate(date);
    const [rows] = await connection.promise().query(
      `
         SELECT b.id, b.scheduleId, b.date, s.timeType, s.appointmentTypeId, b.statusId, b.reason,
         s.doctorId, b.patientId, bq.queueNumber, bq.appointmentDate AS queueAppointmentDate,
                u.email, u.firstName, u.lastName, u.address, u.phoneNumber,
                COALESCE(a.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeTypeVi,
                COALESCE(a.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeTypeEn,
                appointmentType.value_vi AS appointmentTypeVi,
                appointmentType.value_en AS appointmentTypeEn,
                vcs.statusId AS videoSessionStatusId,
                vcs.startedAt AS videoStartedAt,
                vcs.endedAt AS videoEndedAt
         FROM booking AS b
            INNER JOIN schedule AS s ON b.scheduleId = s.id
            LEFT JOIN booking_queue AS bq ON bq.bookingId = b.id
            LEFT JOIN users AS u ON b.patientId = u.id
            LEFT JOIN lookup AS a
                ON s.timeType = a.keyMap AND a.type = 'TIME'
            LEFT JOIN lookup AS appointmentType
                ON s.appointmentTypeId = appointmentType.keyMap AND appointmentType.type = 'APPOINTMENT_TYPE'
            LEFT JOIN video_consultation_session AS vcs
                ON vcs.bookingId = b.id
         WHERE s.doctorId = ? AND b.date = ? AND b.statusId = 'S8'
         ORDER BY COALESCE(bq.queueNumber, 999999) ASC, COALESCE(TIME_TO_SEC(s.startTime), CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED)) ASC
        `,
      [doctorId, normalizedDate]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("GetListPatientForDoctor error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const sendRemedy = async (data) => {
  const status = {};
  try {
    const patientName = String(
      data?.patientName ||
        `${data?.firstNamePatient || ""} ${data?.lastNamePatient || ""}`
    ).trim();

    if (
      !data ||
      !data.email ||
      !data.bookingId ||
      !data.time ||
      !patientName
    ) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }
    const {
      email,
      bookingId,
      time,
      reason,
      doctorConclusion,
      prescriptionItems,
      prescription,
      paraclinicalResults,
      followUpDate,
    } = data;
    const shouldUpdateBookingStatus = data.skipBookingStatusUpdate !== true;

    // Cập nhật trạng thái booking
    const [bookingRows] = await connection.promise().query(
      `
        SELECT b.id, u.firstName, u.lastName
        FROM booking b
        INNER JOIN schedule s
          ON b.scheduleId = s.id
        INNER JOIN users u
          ON s.doctorId = u.id
        WHERE b.id = ? ${shouldUpdateBookingStatus ? "AND b.statusId = 'S8'" : ""}
        LIMIT 1
      `,
      [bookingId]
    );

    if (bookingRows.length === 0) {
      status.errCode = 2;
      status.errMessage = shouldUpdateBookingStatus
        ? "Appointment does not exist or is not ready for completion"
        : "Appointment does not exist";
      return status;
    }

    if (shouldUpdateBookingStatus) {
      await connection.promise().query(
        `
          UPDATE booking
          SET statusId = 'S3'
          WHERE id = ? AND statusId = 'S8'
        `,
        [bookingId]
      );
    }

    // Gửi email (giả lập)
    console.log(`Sending remedy to ${email}...`);
    // Thực tế bạn sẽ sử dụng một thư viện gửi email như nodemailer để thực hiện việc này
    // await new Promise((resolve) => setTimeout(resolve, 1000)); // Giả lập delay

    // Lấy tên bác sĩ và bệnh nhân
    const doctorInfo = bookingRows;
    const doctorName =
      doctorInfo.length > 0
        ? `${doctorInfo[0].firstName} ${doctorInfo[0].lastName}`
        : "Bác sĩ";

    await sendResultEmail({
      reciverEmail: email,
      patientName: patientName,
      doctorName: doctorName,
      time: time,
      reason: reason,
      doctorConclusion,
      bookingId,
      prescriptionItems: prescriptionItems || prescription?.items || [],
      paraclinicalResults: paraclinicalResults || [],
      followUpDate,
    });

    console.log(`Remedy sent to ${email} successfully.`);
    status.errCode = 0;
    status.errMessage = "Remedy sent successfully";
    return status;
  } catch (error) {
    console.log("sendRemedy error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const GetListAppointment = async (doctorId) => {
  const status = {};
  try {
    if (!doctorId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      status.data = [];
      return status;
    }
    const [rows] = await connection.promise().query(
      `
         SELECT b.id, b.scheduleId, b.date, s.timeType, s.appointmentTypeId, b.statusId, b.reason, b.patientId,
                s.doctorId, bq.queueNumber, bq.appointmentDate AS queueAppointmentDate,
                u.email, u.firstName, u.lastName, u.address, u.phoneNumber,
                COALESCE(a.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeTypeVi,
                COALESCE(a.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeTypeEn,
                appointmentType.value_vi AS appointmentTypeVi,
                appointmentType.value_en AS appointmentTypeEn,
                vcs.statusId AS videoSessionStatusId,
                vcs.startedAt AS videoStartedAt,
                vcs.endedAt AS videoEndedAt
         FROM booking AS b
            INNER JOIN schedule AS s ON b.scheduleId = s.id
            LEFT JOIN booking_queue AS bq ON bq.bookingId = b.id
            LEFT JOIN users AS u ON b.patientId = u.id
            LEFT JOIN lookup AS a
                ON s.timeType = a.keyMap AND a.type = 'TIME'
            LEFT JOIN lookup AS appointmentType
                ON s.appointmentTypeId = appointmentType.keyMap AND appointmentType.type = 'APPOINTMENT_TYPE'
            LEFT JOIN video_consultation_session AS vcs
                ON vcs.bookingId = b.id
          WHERE s.doctorId = ?
          ORDER BY b.date DESC, COALESCE(bq.queueNumber, 999999) ASC, COALESCE(TIME_TO_SEC(s.startTime), CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED)) ASC
        `,
      [doctorId]
    );
    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  }
  catch (error) {
    console.log("GetListAppointment error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};


const ListBooking = async (user) => {
  try {
    const scope = getBookingListScope(user);
    if (!scope.allowed) {
      return {
        errCode: 403,
        errMessage: "Permission denied",
        data: [],
      };
    }

    const [rows] = await connection.promise().query(
      `
      SELECT
          b.id,
          b.scheduleId,
          b.date,
          s.timeType,
          s.appointmentTypeId,
          b.statusId,
          b.reason,
          b.token,
          p.statusId AS paymentStatusId,
          p.amount AS paymentAmount,
          b.paymentMethodId,
          p.paymentCode,
          p.paidAt,
          paymentStatus.value_vi AS paymentStatusVi,
          paymentStatus.value_en AS paymentStatusEn,
          bq.queueNumber,
          bq.appointmentDate AS queueAppointmentDate,

          -- Trạng thái khám bệnh
          ls.value_en AS statusEn,
          ls.value_vi AS statusVi,

          -- Khung giờ khám
          COALESCE(lt.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeEn,
          COALESCE(lt.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeVi,

          appointmentType.value_en AS appointmentTypeEn,
          appointmentType.value_vi AS appointmentTypeVi,
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt,

          -- Thông tin bác sĩ
          doctor.firstName AS doctorFirstName,
          doctor.lastName AS doctorLastName,
          doctor.email AS doctorEmail,

          -- Thông tin bệnh nhân
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.email AS patientEmail,
          patient.phoneNumber AS patientPhoneNumber,
          patient.address AS patientAddress,
          patient.gender AS patientGender

      FROM booking b
      JOIN schedule s
          ON b.scheduleId = s.id

      -- JOIN bảng users cho bác sĩ
      JOIN users doctor
          ON s.doctorId = doctor.id

      LEFT JOIN booking_queue bq
          ON bq.bookingId = b.id

      LEFT JOIN doctor_info di
          ON di.doctorId = s.doctorId

      LEFT JOIN clinic c
          ON c.id = di.clinicId

      -- JOIN bảng users cho bệnh nhân
      JOIN users patient
          ON b.patientId = patient.id

      -- Lookup STATUS
      LEFT JOIN lookup ls
          ON b.statusId = ls.keyMap
         AND ls.type = 'STATUS'

      -- Lookup TIME
      LEFT JOIN lookup lt
          ON s.timeType = lt.keyMap
         AND lt.type = 'TIME'

      LEFT JOIN lookup appointmentType
          ON s.appointmentTypeId = appointmentType.keyMap
         AND appointmentType.type = 'APPOINTMENT_TYPE'

      LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id

      LEFT JOIN appointment_payments p
          ON p.bookingId = b.id

      LEFT JOIN lookup paymentStatus
          ON p.statusId = paymentStatus.keyMap
         AND paymentStatus.type = 'PAYMENT_TRANSACTION_STATUS'

      ${scope.whereClause}
      ORDER BY b.date DESC, COALESCE(bq.queueNumber, 999999) ASC, COALESCE(TIME_TO_SEC(s.startTime), CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED)) ASC
      `,
      scope.params
    );

    return {
      errCode: 0,
      errMessage: "OK",
      data: (rows || []).map((row) => ({ ...row, paymentStatus: getPublicPaymentStatus(row.paymentStatusId) })),
    };
  } catch (error) {
    console.log("ListBooking error:", error);
    return {
      errCode: 1,
      errMessage: error.message || "Database error",
      data: [],
    };
  }
};

module.exports = {
  GetListPatientForDoctor,
  sendRemedy,
  GetListAppointment,
  ListBooking,
};
