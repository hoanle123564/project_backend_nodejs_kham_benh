const connection = require("../config/data");
const { normalizeDate, normalizeTime } = require("./doctor/doctorSchedulePolicy");
const { sendAppointmentReminderEmail } = require("./emailService");
const { sendAppointmentReminderSms } = require("./smsService");
const { BOOKING_STATUS } = require("./workflowStatusService");

const REMINDER_MINUTES_BEFORE = 30;
const DEFAULT_LIMIT = 20;
const DB_TIMEZONE = process.env.DB_TIMEZONE || "+07:00";
const APPOINTMENT_START_SQL = "TIMESTAMP(b.date, s.startTime)";
const REMIND_AT_SQL = `DATE_SUB(${APPOINTMENT_START_SQL}, INTERVAL ${REMINDER_MINUTES_BEFORE} MINUTE)`;
const UNFINISHED_SQL = `
  (ar.emailSentAt IS NULL OR ar.smsSentAt IS NULL)
`;

let schedulerHandle = null;

const normalizeDbTimezone = (timezone = DB_TIMEZONE) =>
  /^([+-]\d{2}:\d{2}|Z)$/.test(String(timezone || "")) ? timezone : "+07:00";

const buildAppointmentStartAt = (date, startTime, timezone = DB_TIMEZONE) => {
  const datePart = normalizeDate(date);
  const timePart = normalizeTime(startTime);
  if (!datePart || !timePart) return null;

  const parsed = new Date(`${datePart}T${timePart}${normalizeDbTimezone(timezone)}`);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
};

const hasPendingReminderChannel = (reminder = {}) =>
  !reminder.emailSentAt || !reminder.smsSentAt;

const getReminderDecision = (booking = {}, now = new Date(), timezone = DB_TIMEZONE) => {
  const checkedAt = now instanceof Date ? now : new Date(now);
  const appointmentStartAt = buildAppointmentStartAt(booking.date, booking.startTime, timezone);
  const remindAt = appointmentStartAt
    ? new Date(appointmentStartAt.getTime() - REMINDER_MINUTES_BEFORE * 60 * 1000)
    : null;

  if (!appointmentStartAt || Number.isNaN(checkedAt.getTime())) {
    return { due: false, reason: "INVALID_APPOINTMENT_TIME", appointmentStartAt, remindAt };
  }

  if (booking.statusId !== BOOKING_STATUS.DOCTOR_CONFIRMED) {
    return { due: false, reason: "BOOKING_NOT_S8", appointmentStartAt, remindAt };
  }

  if (appointmentStartAt <= checkedAt) {
    return { due: false, reason: "APPOINTMENT_STARTED", appointmentStartAt, remindAt };
  }

  if (!hasPendingReminderChannel(booking)) {
    return { due: false, reason: "ALREADY_SENT", appointmentStartAt, remindAt };
  }

  if (remindAt > checkedAt) {
    return { due: false, reason: "NOT_DUE", appointmentStartAt, remindAt };
  }

  return { due: true, reason: "DUE", appointmentStartAt, remindAt };
};

const ensureReminderForBooking = async (bookingId) => {
  const normalizedBookingId = Number(bookingId);
  if (!Number.isInteger(normalizedBookingId) || normalizedBookingId <= 0) return null;

  const [result] = await connection.promise().query(
    `
      INSERT INTO appointment_reminders (bookingId, remindAt)
      SELECT b.id, ${REMIND_AT_SQL}
      FROM booking b
      INNER JOIN schedule s ON s.id = b.scheduleId
      WHERE b.id = ?
        AND b.statusId = ?
        AND ${APPOINTMENT_START_SQL} > NOW()
      ON DUPLICATE KEY UPDATE
        remindAt = VALUES(remindAt),
        updatedAt = CURRENT_TIMESTAMP
    `,
    [normalizedBookingId, BOOKING_STATUS.DOCTOR_CONFIRMED]
  );

  return result;
};

const ensureDueReminderRows = async () => {
  await connection.promise().query(
    `
      INSERT IGNORE INTO appointment_reminders (bookingId, remindAt)
      SELECT b.id, ${REMIND_AT_SQL}
      FROM booking b
      INNER JOIN schedule s ON s.id = b.scheduleId
      LEFT JOIN appointment_reminders ar ON ar.bookingId = b.id
      WHERE b.statusId = ?
        AND ar.bookingId IS NULL
        AND ${REMIND_AT_SQL} <= NOW()
        AND ${APPOINTMENT_START_SQL} > NOW()
    `,
    [BOOKING_STATUS.DOCTOR_CONFIRMED]
  );
};

const getDueReminders = async ({ bookingId = null, limit = DEFAULT_LIMIT } = {}) => {
  const params = [BOOKING_STATUS.DOCTOR_CONFIRMED];
  let bookingFilter = "";
  if (bookingId) {
    bookingFilter = "AND b.id = ?";
    params.push(Number(bookingId));
  }
  params.push(Math.max(1, Math.min(Number(limit) || DEFAULT_LIMIT, 100)));

  const [rows] = await connection.promise().query(
    `
      SELECT ar.id, ar.bookingId, ar.remindAt, ar.emailSentAt, ar.smsSentAt,
             b.date, b.reason, b.statusId,
             s.startTime, s.endTime, s.timeType,
             ${APPOINTMENT_START_SQL} AS appointmentStartAt,
             patient.email AS patientEmail,
             patient.phoneNumber AS patientPhoneNumber,
             patient.firstName AS patientFirstName,
             patient.lastName AS patientLastName,
             doctor.firstName AS doctorFirstName,
             doctor.lastName AS doctorLastName,
             clinic.name AS clinicName,
             COALESCE(lt.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeVi,
             COALESCE(lt.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeEn
      FROM appointment_reminders ar
      INNER JOIN booking b ON b.id = ar.bookingId
      INNER JOIN schedule s ON s.id = b.scheduleId
      INNER JOIN users patient ON patient.id = b.patientId
      INNER JOIN users doctor ON doctor.id = s.doctorId
      LEFT JOIN doctor_info di ON di.doctorId = s.doctorId
      LEFT JOIN clinic ON clinic.id = di.clinicId
      LEFT JOIN lookup lt ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE b.statusId = ?
        ${bookingFilter}
        AND ar.remindAt <= NOW()
        AND ${APPOINTMENT_START_SQL} > NOW()
        AND ${UNFINISHED_SQL}
      ORDER BY ar.remindAt ASC, ar.id ASC
      LIMIT ?
    `,
    params
  );

  return rows || [];
};

const getReminderDetails = async (reminderId) => {
  const [rows] = await connection.promise().query(
    `
      SELECT ar.id, ar.bookingId, ar.remindAt, ar.emailSentAt, ar.smsSentAt,
             b.date, b.reason, b.statusId,
             s.startTime, s.endTime, s.timeType,
             patient.email AS patientEmail,
             patient.phoneNumber AS patientPhoneNumber,
             patient.firstName AS patientFirstName,
             patient.lastName AS patientLastName,
             doctor.firstName AS doctorFirstName,
             doctor.lastName AS doctorLastName,
             clinic.name AS clinicName,
             COALESCE(lt.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeVi,
             COALESCE(lt.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeEn
      FROM appointment_reminders ar
      INNER JOIN booking b ON b.id = ar.bookingId
      INNER JOIN schedule s ON s.id = b.scheduleId
      INNER JOIN users patient ON patient.id = b.patientId
      INNER JOIN users doctor ON doctor.id = s.doctorId
      LEFT JOIN doctor_info di ON di.doctorId = s.doctorId
      LEFT JOIN clinic ON clinic.id = di.clinicId
      LEFT JOIN lookup lt ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE ar.id = ?
        AND b.statusId = ?
        AND ${APPOINTMENT_START_SQL} > NOW()
      LIMIT 1
    `,
    [reminderId, BOOKING_STATUS.DOCTOR_CONFIRMED]
  );

  return rows[0] || null;
};

const markEmailSent = (reminderId) =>
  connection.promise().query(
    `
      UPDATE appointment_reminders
      SET emailSentAt = COALESCE(emailSentAt, CURRENT_TIMESTAMP),
          updatedAt = CURRENT_TIMESTAMP
      WHERE id = ?
    `,
    [reminderId]
  );

const markSmsSent = (reminderId) =>
  connection.promise().query(
    `
      UPDATE appointment_reminders
      SET smsSentAt = COALESCE(smsSentAt, CURRENT_TIMESTAMP),
          updatedAt = CURRENT_TIMESTAMP
      WHERE id = ?
    `,
    [reminderId]
  );

const withReminderLock = async (reminderId, callback) => {
  const db = await connection.promise().getConnection();
  const lockName = `appointment-reminder:${reminderId}`;

  try {
    const [rows] = await db.query("SELECT GET_LOCK(?, 0) AS locked", [lockName]);
    if (Number(rows[0]?.locked) !== 1) return null;
    return await callback();
  } finally {
    await db.query("SELECT RELEASE_LOCK(?)", [lockName]);
    db.release();
  }
};

const getPersonName = (firstName, lastName, fallback) =>
  [firstName, lastName].filter(Boolean).join(" ").trim() || fallback;

const buildReminderPayload = (reminder) => {
  const appointmentDate = normalizeDate(reminder.date) || "";
  const appointmentTime =
    reminder.timeVi ||
    [normalizeTime(reminder.startTime), normalizeTime(reminder.endTime)]
      .filter(Boolean)
      .map((time) => time.slice(0, 5))
      .join(" - ");
  const patientName = getPersonName(reminder.patientFirstName, reminder.patientLastName, "patient");
  const doctorName = getPersonName(reminder.doctorFirstName, reminder.doctorLastName, "doctor");

  return {
    bookingId: reminder.bookingId,
    receiverEmail: reminder.patientEmail,
    toPhone: reminder.patientPhoneNumber,
    patientName,
    doctorName,
    clinicName: reminder.clinicName || "",
    appointmentDate,
    appointmentTime,
    message: `LifeCare reminder: Lịch hẹn của bạn sắp bắt đầu với ${doctorName} is at ${appointmentTime} on ${appointmentDate}.`,
  };
};

const processReminder = async (reminder) => {
  const result = await withReminderLock(reminder.id, async () => {
    const freshReminder = await getReminderDetails(reminder.id);
    if (!freshReminder) return { bookingId: reminder.bookingId, skipped: true, reason: "NO_LONGER_ELIGIBLE" };

    const errors = [];
    const payload = buildReminderPayload(freshReminder);

    if (!freshReminder.emailSentAt) {
      try {
        await sendAppointmentReminderEmail(payload);
        await markEmailSent(freshReminder.id);
      } catch (error) {
        errors.push(`email: ${error.message}`);
      }
    }

    if (!freshReminder.smsSentAt) {
      try {
        await sendAppointmentReminderSms(payload);
        await markSmsSent(freshReminder.id);
      } catch (error) {
        errors.push(`sms: ${error.message}`);
      }
    }

    if (errors.length) console.error("appointment reminder delivery error:", errors.join("; "));
    return { bookingId: freshReminder.bookingId, sent: errors.length === 0, errors };
  });

  return result || { bookingId: reminder.bookingId, skipped: true, reason: "LOCKED" };
};

const processDueReminders = async ({ bookingId = null, limit = DEFAULT_LIMIT } = {}) => {
  if (!bookingId) {
    await ensureDueReminderRows();
  }

  const reminders = await getDueReminders({ bookingId, limit });
  const results = [];
  for (const reminder of reminders) {
    results.push(await processReminder(reminder));
  }
  return results;
};

const dispatchReminderForBooking = async (bookingId) => {
  await ensureReminderForBooking(bookingId);
  return processDueReminders({ bookingId, limit: 1 });
};

const startAppointmentReminderScheduler = ({ intervalMs = 60 * 1000 } = {}) => {
  if (schedulerHandle) return schedulerHandle;

  const tick = () => {
    processDueReminders().catch((error) => {
      console.error("appointment reminder scheduler error:", error);
    });
  };

  schedulerHandle = setInterval(tick, intervalMs);
  if (typeof schedulerHandle.unref === "function") schedulerHandle.unref();
  tick();
  return schedulerHandle;
};

module.exports = {
  REMINDER_MINUTES_BEFORE,
  buildAppointmentStartAt,
  dispatchReminderForBooking,
  getReminderDecision,
  hasPendingReminderChannel,
  processDueReminders,
  startAppointmentReminderScheduler,
};
