const connection = require("../config/data");
const { getDb } = require("./transactionService");

const NOTIFICATION_ROLE = Object.freeze({ ADMIN: "R1", DOCTOR: "R2", PATIENT: "R3" });
const NOTIFICATION_TYPE = Object.freeze({
  NEW_MESSAGE: "NEW_MESSAGE",
  BOOKING_STATUS_CHANGED: "BOOKING_STATUS_CHANGED",
  APPOINTMENT_REMINDER: "APPOINTMENT_REMINDER",
  REFUND_REQUESTED: "REFUND_REQUESTED",
  REFUND_REJECTED: "REFUND_REJECTED",
  REVIEW_HIDDEN: "REVIEW_HIDDEN",
  REVIEW_RESTORED: "REVIEW_RESTORED",
});

const assertRecipient = (user = {}, role) => {
  if (user.roleId !== role || !Number(user.id)) {
    const error = new Error("Permission denied");
    error.statusCode = 403;
    error.errCode = 403;
    throw error;
  }
};

const createNotification = async ({
  recipientUserId,
  recipientRole,
  bookingId,
  chatRoomId = null,
  reviewId = null,
  sourceMessageId = null,
  reminderId = null,
  bookingStatusId = null,
  type,
  content = null,
}, db) => {
  const [result] = await getDb(db).query(
    `INSERT IGNORE INTO notifications
      (recipientUserId, recipientRole, bookingId, chatRoomId, reviewId, sourceMessageId, reminderId, bookingStatusId, type, content)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [recipientUserId, recipientRole, bookingId, chatRoomId, reviewId, sourceMessageId, reminderId, bookingStatusId, type, content == null ? null : String(content).slice(0, 500)]
  );
  return result.insertId;
};

const createDoctorNotification = ({ doctorId, ...data }, db) =>
  createNotification({ ...data, recipientUserId: doctorId, recipientRole: NOTIFICATION_ROLE.DOCTOR }, db);

const createAdminNotification = ({ adminId, ...data }, db) =>
  createNotification({ ...data, recipientUserId: adminId, recipientRole: NOTIFICATION_ROLE.ADMIN }, db);

const createAdminRefundNotifications = async ({ bookingId }, db) => {
  const [admins] = await getDb(db).query("SELECT id FROM users WHERE roleId = 'R1'");
  for (const admin of admins || []) {
    await createAdminNotification({
      adminId: admin.id,
      bookingId,
      type: NOTIFICATION_TYPE.REFUND_REQUESTED,
    }, db);
  }
};

const createPatientNotification = ({ patientId, ...data }, db) =>
  createNotification({ ...data, recipientUserId: patientId, recipientRole: NOTIFICATION_ROLE.PATIENT }, db);

const createPatientBookingStatusNotification = (data, db) =>
  createPatientNotification({ ...data, type: NOTIFICATION_TYPE.BOOKING_STATUS_CHANGED }, db);

const createPatientReviewModerationNotification = ({ patientId, bookingId, type }, db) =>
  createPatientNotification({ patientId, bookingId, reviewId: null, type }, db);

const getNotifications = async (user, role) => {
  assertRecipient(user, role);
  const [rows] = await connection.promise().query(
    `
      SELECT n.id, n.bookingId, n.chatRoomId, n.reviewId, n.bookingStatusId, n.type, n.content, n.isRead, n.createdAt,
        b.date AS appointmentDate, s.timeType,
        patient.firstName AS patientFirstName, patient.lastName AS patientLastName, patient.image AS patientImage,
        doctor.firstName AS doctorFirstName, doctor.lastName AS doctorLastName, doctor.image AS doctorImage,
        statusLookup.value_vi AS bookingStatusVi, statusLookup.value_en AS bookingStatusEn
      FROM notifications n
      LEFT JOIN booking b ON b.id = n.bookingId
      LEFT JOIN schedule s ON s.id = b.scheduleId
      LEFT JOIN users patient ON patient.id = b.patientId
      LEFT JOIN users doctor ON doctor.id = s.doctorId
      LEFT JOIN lookup statusLookup ON statusLookup.keyMap = n.bookingStatusId AND statusLookup.type = 'STATUS'
      WHERE n.recipientUserId = ? AND n.recipientRole = ?
      ORDER BY n.isRead ASC, n.createdAt DESC, n.id DESC
      LIMIT 50
    `,
    [user.id, role]
  );
  const data = (rows || []).map((item) => ({ ...item, isRead: Number(item.isRead) === 1 }));
  return { errCode: 0, errMessage: "OK", data, unreadCount: data.filter((item) => !item.isRead).length };
};

const markNotificationsRead = async (user, role, notificationId) => {
  assertRecipient(user, role);
  const params = [user.id, role];
  let where = "recipientUserId = ? AND recipientRole = ? AND isRead = 0";
  if (notificationId) {
    const normalizedNotificationId = Number(notificationId);
    if (!Number.isInteger(normalizedNotificationId) || normalizedNotificationId <= 0) {
      const error = new Error("Invalid notification id");
      error.statusCode = 400;
      error.errCode = 1;
      throw error;
    }
    where += " AND id = ?";
    params.push(normalizedNotificationId);
  }
  await connection.promise().query(
    `UPDATE notifications SET isRead = 1, readAt = CURRENT_TIMESTAMP WHERE ${where}`,
    params
  );
  return { errCode: 0, errMessage: "OK", data: {} };
};

const getDoctorNotifications = (user) => getNotifications(user, NOTIFICATION_ROLE.DOCTOR);
const markDoctorNotificationsRead = (user, notificationId) =>
  markNotificationsRead(user, NOTIFICATION_ROLE.DOCTOR, notificationId);
const getAdminNotifications = (user) => getNotifications(user, NOTIFICATION_ROLE.ADMIN);
const markAdminNotificationsRead = (user, notificationId) =>
  markNotificationsRead(user, NOTIFICATION_ROLE.ADMIN, notificationId);
const getPatientNotifications = (user) => getNotifications(user, NOTIFICATION_ROLE.PATIENT);
const markPatientNotificationsRead = (user, notificationId) =>
  markNotificationsRead(user, NOTIFICATION_ROLE.PATIENT, notificationId);

module.exports = {
  NOTIFICATION_ROLE,
  NOTIFICATION_TYPE,
  assertRecipient,
  createNotification,
  createAdminNotification,
  createAdminRefundNotifications,
  createDoctorNotification,
  createPatientNotification,
  createPatientBookingStatusNotification,
  createPatientReviewModerationNotification,
  getAdminNotifications,
  markAdminNotificationsRead,
  getDoctorNotifications,
  markDoctorNotificationsRead,
  getPatientNotifications,
  markPatientNotificationsRead,
};
