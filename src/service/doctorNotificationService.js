const connection = require("../config/data");
const { getDb } = require("./transactionService");

const assertDoctor = (user = {}) => {
  if (user.roleId !== "R2" || !Number(user.id)) {
    const error = new Error("Permission denied");
    error.statusCode = 403;
    error.errCode = 403;
    throw error;
  }
};

const createDoctorNotification = async ({
  doctorId,
  bookingId,
  chatRoomId = null,
  reviewId = null,
  sourceMessageId = null,
  type,
  content = "",
}, db) => {
  const [result] = await getDb(db).query(
    `INSERT IGNORE INTO doctor_notifications
      (doctorId, bookingId, chatRoomId, reviewId, sourceMessageId, type, content)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [doctorId, bookingId, chatRoomId, reviewId, sourceMessageId, type, String(content).slice(0, 500)]
  );
  return result.insertId;
};

const getDoctorNotifications = async (user) => {
  assertDoctor(user);
  const [rows] = await connection.promise().query(
    `
      SELECT n.id, n.bookingId, n.chatRoomId, n.reviewId, n.type, n.content, n.isRead, n.createdAt,
        b.date AS appointmentDate, s.timeType,
        patient.firstName AS patientFirstName, patient.lastName AS patientLastName, patient.image AS patientImage
      FROM doctor_notifications n
      LEFT JOIN booking b ON b.id = n.bookingId
      LEFT JOIN schedule s ON s.id = b.scheduleId
      LEFT JOIN users patient ON patient.id = b.patientId
      WHERE n.doctorId = ?
      ORDER BY n.isRead ASC, n.createdAt DESC, n.id DESC
      LIMIT 50
    `,
    [user.id]
  );
  const data = (rows || []).map((item) => ({ ...item, isRead: Number(item.isRead) === 1 }));
  return { errCode: 0, errMessage: "OK", data, unreadCount: data.filter((item) => !item.isRead).length };
};

const markDoctorNotificationsRead = async (user, notificationId) => {
  assertDoctor(user);
  const params = [user.id];
  let where = "doctorId = ? AND isRead = 0";
  if (notificationId) {
    where += " AND id = ?";
    params.push(Number(notificationId));
  }
  await connection.promise().query(`UPDATE doctor_notifications SET isRead = 1, readAt = CURRENT_TIMESTAMP WHERE ${where}`, params);
  return { errCode: 0, errMessage: "OK", data: {} };
};

module.exports = { createDoctorNotification, getDoctorNotifications, markDoctorNotificationsRead };
