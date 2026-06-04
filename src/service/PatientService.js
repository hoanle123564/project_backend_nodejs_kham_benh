const connection = require("../config/data");
const moment = require("moment");
require("moment/locale/vi"); // bắt buộc để moment hiểu tiếng Việt
const { v4: uuidv4 } = require("uuid");
require("dotenv").config();
const { sendSimpleEmail } = require("./emailService");
const { ensurePriceAtBookingColumn, getDoctorPriceAtBooking } = require("./adminDashboardService");

const buildUrlEmail = (scheduleId, token) => {
  return `${process.env.URL_REACT}/verify-booking?token=${token}&scheduleId=${scheduleId}`;
};

const getScheduleMeta = async (scheduleId) => {
  const [rows] = await connection.promise().query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
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

const resolvePatientId = async ({
  patientId,
  email,
  firstName,
  lastName,
  address,
  gender,
  phoneNumber,
}) => {
  if (patientId) {
    return patientId;
  }

  const [rows] = await connection.promise().query(
    `SELECT id FROM users WHERE email = ?`,
    [email]
  );

  if (rows.length === 0) {
    const [insertUser] = await connection.promise().query(
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

  await connection.promise().query(
    `
      UPDATE users
      SET firstName = ?, lastName = ?, address = ?, gender = ?, phoneNumber = ?
      WHERE id = ?
    `,
    [firstName, lastName, address, gender, phoneNumber, realPatientId]
  );

  return realPatientId;
};

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
    const realPatientId = await resolvePatientId({
      patientId,
      email,
      firstName,
      lastName,
      address,
      gender,
      phoneNumber,
    });

    const [existing] = await connection.promise().query(
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
        errCode: 2,
        errMessage: "You already booked this schedule.",
      };
    }

    const token = uuidv4();
    await ensurePriceAtBookingColumn();
    const priceAtBooking = await getDoctorPriceAtBooking(scheduleMeta.doctorId);

    const [booking] = await connection.promise().query(
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

    const doctorName =
      `${scheduleMeta.firstName || ""} ${scheduleMeta.lastName || ""}`.trim() || "Bac si";

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
      data: booking,
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

    const [rows] = await connection.promise().query(
      `
        SELECT id
        FROM booking
        WHERE scheduleId = ? AND token = ? AND statusId = 'S1'
      `,
      [scheduleId, token]
    );

    if (rows.length === 0) {
      status.errCode = 2;
      status.errMessage = "Appointment has been activated or does not exist!";
      return status;
    }

    await connection.promise().query(
      `
        UPDATE booking
        SET statusId = 'S2'
        WHERE scheduleId = ? AND token = ? AND statusId = 'S1'
      `,
      [scheduleId, token]
    );

    status.errCode = 0;
    status.errMessage = "Appointment activated successfully!";
    return status;
  } catch (error) {
    console.log("verifyBookAppointment error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    return status;
  }
};

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
          s.doctorId,
          b.statusId,
          ls.value_en AS statusEn,
          ls.value_vi AS statusVi,
          lt.value_en AS timeEn,
          lt.value_vi AS timeVi,
          u.firstName AS doctorFirstName,
          u.lastName AS doctorLastName
        FROM booking b
        INNER JOIN schedule s
          ON b.scheduleId = s.id
        INNER JOIN users u
          ON s.doctorId = u.id
        LEFT JOIN lookup ls
          ON b.statusId = ls.keyMap
         AND ls.type = 'STATUS'
        LEFT JOIN lookup lt
          ON s.timeType = lt.keyMap
         AND lt.type = 'TIME'
        WHERE b.patientId = ?
        ORDER BY b.date DESC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      [patientId]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows || [];
    return status;
  } catch (error) {
    console.log("ListBookingForPatient error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const cancelBookAppointment = async (data) => {
  const status = {};
  try {
    if (!data || !data.BookingId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { BookingId } = data;

    const [rows] = await connection.promise().query(
      `
        SELECT *
        FROM booking
        WHERE id = ? AND statusId <> 'S3' AND statusId <> 'S4'
      `,
      [BookingId]
    );

    if (rows.length === 0) {
      status.errCode = 2;
      status.errMessage = "Appointment cannot be canceled or does not exist!";
      return status;
    }

    await connection.promise().query(
      `
        UPDATE booking
        SET statusId = 'S4'
        WHERE id = ? AND statusId <> 'S3'
      `,
      [BookingId]
    );

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
