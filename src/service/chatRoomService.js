const connection = require("../config/data");
const { getDb, withTransaction } = require("./transactionService");
const { createDoctorNotification } = require("./doctorNotificationService");

const ROLE_DOCTOR = "R2";
const ROLE_PATIENT = "R3";
const APPOINTMENT_TYPE_ONLINE = "AT2";
const ROOM_STATUS_ACTIVE = "ACTIVE";
const ROOM_STATUS_DISABLED = "DISABLED";
const BOOKING_STATUS_CONFIRMED = "S8";
const BOOKING_STATUS_COMPLETED = "S3";
const BOOKING_STATUS_CANCELLED = "S4";
const CREATABLE_BOOKING_STATUSES = new Set([
  BOOKING_STATUS_CONFIRMED,
  BOOKING_STATUS_COMPLETED,
]);

const ok = (data = {}, extra = {}) => ({
  errCode: 0,
  errMessage: "OK",
  data,
  ...extra,
});

const makeError = (message, statusCode = 400, errCode = 1) => {
  const error = new Error(message);
  error.statusCode = statusCode;
  error.errCode = errCode;
  return error;
};

const normalizePositiveId = (value, fieldName = "id") => {
  const normalized = Number(value);
  if (Number.isInteger(normalized) && normalized > 0) {
    return normalized;
  }

  throw makeError(`Missing required parameter: ${fieldName}`, 400, 1);
};

const normalizePagination = (query = {}) => {
  const page = Math.max(Number(query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(query.limit) || 30, 1), 100);
  return {
    page,
    limit,
    offset: (page - 1) * limit,
  };
};

const assertChatRole = (user = {}) => {
  if (![ROLE_DOCTOR, ROLE_PATIENT].includes(user.roleId)) {
    throw makeError("Permission denied", 403, 403);
  }
};

const assertRoomMember = (user = {}, room = {}) => {
  assertChatRole(user);
  const userId = Number(user.id);

  if (
    (user.roleId === ROLE_DOCTOR && userId === Number(room.doctorId)) ||
    (user.roleId === ROLE_PATIENT && userId === Number(room.patientId))
  ) {
    return;
  }

  throw makeError("Permission denied", 403, 403);
};

const roomSelectFields = `
  cr.id AS roomId,
  cr.bookingId,
  cr.doctorId,
  cr.patientId,
  cr.status,
  cr.createdAt,
  cr.updatedAt,
  b.date AS appointmentDate,
  b.statusId AS bookingStatusId,
  s.timeType,
  s.appointmentTypeId,
  lt.value_vi AS timeTypeVi,
  lt.value_en AS timeTypeEn,
  lat.value_vi AS appointmentTypeVi,
  lat.value_en AS appointmentTypeEn,
  doctor.firstName AS doctorFirstName,
  doctor.lastName AS doctorLastName,
  doctor.image AS doctorImage,
  patient.firstName AS patientFirstName,
  patient.lastName AS patientLastName,
  patient.image AS patientImage,
  patient.phoneNumber AS patientPhoneNumber,
  clinic.name AS clinicName
`;

const roomFromClause = `
  FROM chat_rooms cr
  INNER JOIN booking b
    ON b.id = cr.bookingId
  INNER JOIN schedule s
    ON s.id = b.scheduleId
  INNER JOIN users doctor
    ON doctor.id = cr.doctorId
  INNER JOIN users patient
    ON patient.id = cr.patientId
  LEFT JOIN doctor_info di
    ON di.doctorId = cr.doctorId
  LEFT JOIN clinic
    ON clinic.id = di.clinicId
  LEFT JOIN lookup lt
    ON lt.keyMap = s.timeType AND lt.type = 'TIME'
  LEFT JOIN lookup lat
    ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
`;

const getBookingContext = async (bookingId, db, options = {}) => {
  const executor = getDb(db);
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const [rows] = await executor.query(
    `
      SELECT
        b.id AS bookingId,
        b.statusId AS bookingStatusId,
        b.patientId,
        b.date AS appointmentDate,
        s.id AS scheduleId,
        s.doctorId,
        s.timeType,
        s.appointmentTypeId,
        lt.value_vi AS timeTypeVi,
        lt.value_en AS timeTypeEn,
        lat.value_vi AS appointmentTypeVi,
        lat.value_en AS appointmentTypeEn,
        doctor.firstName AS doctorFirstName,
        doctor.lastName AS doctorLastName,
        doctor.image AS doctorImage,
        patient.firstName AS patientFirstName,
        patient.lastName AS patientLastName,
        patient.image AS patientImage,
        patient.phoneNumber AS patientPhoneNumber,
        clinic.name AS clinicName
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      INNER JOIN users doctor
        ON doctor.id = s.doctorId
      INNER JOIN users patient
        ON patient.id = b.patientId
      LEFT JOIN doctor_info di
        ON di.doctorId = s.doctorId
      LEFT JOIN clinic
        ON clinic.id = di.clinicId
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      LEFT JOIN lookup lat
        ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
      WHERE b.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

const getRoomByBookingId = async (bookingId, db) => {
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT ${roomSelectFields}
      ${roomFromClause}
      WHERE cr.bookingId = ?
      LIMIT 1
    `,
    [bookingId]
  );

  return rows[0] || null;
};

const getRoomById = async (roomId, db) => {
  const executor = getDb(db);
  const normalizedRoomId = normalizePositiveId(roomId, "roomId");
  const [rows] = await executor.query(
    `
      SELECT ${roomSelectFields}
      ${roomFromClause}
      WHERE cr.id = ?
      LIMIT 1
    `,
    [normalizedRoomId]
  );

  return rows[0] || null;
};

const getMessageById = async (messageId, db) => {
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        m.id,
        m.roomId,
        m.senderId,
        m.message,
        m.messageType,
        m.isRead,
        m.createdAt,
        m.updatedAt,
        sender.firstName AS senderFirstName,
        sender.lastName AS senderLastName
      FROM chat_room_messages m
      INNER JOIN users sender
        ON sender.id = m.senderId
      WHERE m.id = ?
      LIMIT 1
    `,
    [messageId]
  );

  return rows[0] || null;
};

const formatRoom = (row = {}, viewerId) => {
  const isDoctorViewer = Number(viewerId) === Number(row.doctorId);
  const opponent = isDoctorViewer
    ? {
        id: row.patientId,
        firstName: row.patientFirstName,
        lastName: row.patientLastName,
        image: row.patientImage,
        phoneNumber: row.patientPhoneNumber,
        roleId: ROLE_PATIENT,
      }
    : {
        id: row.doctorId,
        firstName: row.doctorFirstName,
        lastName: row.doctorLastName,
        image: row.doctorImage,
        roleId: ROLE_DOCTOR,
      };

  return {
    ...row,
    id: row.roomId,
    unreadCount: Number(row.unreadCount) || 0,
    opponent,
  };
};

const formatMessage = (row = {}) => ({
  ...row,
  id: row.id,
  roomId: row.roomId,
  senderId: row.senderId,
  isRead: Number(row.isRead) === 1,
});

const createRoomFromBooking = async ({ bookingId, user }) => {
  assertChatRole(user);

  const result = await withTransaction(async (db) => {
    const booking = await getBookingContext(bookingId, db, { forUpdate: true });
    if (!booking) {
      throw makeError("Booking not found", 404, 2);
    }

    assertRoomMember(user, booking);

    if (booking.appointmentTypeId !== APPOINTMENT_TYPE_ONLINE) {
      throw makeError("Chat room is only available for online bookings", 409, 409);
    }

    const existingRoom = await getRoomByBookingId(booking.bookingId, db);
    if (existingRoom) {
      return { created: false, room: existingRoom };
    }

    if (
      booking.bookingStatusId === BOOKING_STATUS_CANCELLED ||
      !CREATABLE_BOOKING_STATUSES.has(booking.bookingStatusId)
    ) {
      throw makeError("Chat room is available after booking confirmation", 409, 409);
    }

    const [insertResult] = await db.query(
      `
        INSERT INTO chat_rooms
          (bookingId, doctorId, patientId, status)
        VALUES (?, ?, ?, ?)
      `,
      [
        booking.bookingId,
        booking.doctorId,
        booking.patientId,
        ROOM_STATUS_ACTIVE,
      ]
    );

    const room = await getRoomById(insertResult.insertId, db);
    return { created: true, room };
  });

  return ok(formatRoom(result.room, user.id), { created: result.created });
};

const getMyRooms = async (user) => {
  assertChatRole(user);
  const userId = normalizePositiveId(user.id, "userId");
  const scopeColumn = user.roleId === ROLE_DOCTOR ? "cr.doctorId" : "cr.patientId";
  const [rows] = await connection.promise().query(
    `
      SELECT
        ${roomSelectFields},
        lastMessage.message AS lastMessage,
        lastMessage.messageType AS lastMessageType,
        lastMessage.senderId AS lastSenderId,
        lastMessage.createdAt AS lastMessageAt,
        (
          SELECT COUNT(*)
          FROM chat_room_messages unread
          WHERE unread.roomId = cr.id
            AND unread.senderId <> ?
            AND unread.isRead = 0
        ) AS unreadCount
      ${roomFromClause}
      LEFT JOIN chat_room_messages lastMessage
        ON lastMessage.id = (
          SELECT m.id
          FROM chat_room_messages m
          WHERE m.roomId = cr.id
          ORDER BY m.createdAt DESC, m.id DESC
          LIMIT 1
        )
      WHERE ${scopeColumn} = ?
        AND cr.status <> ?
      ORDER BY COALESCE(lastMessage.createdAt, cr.updatedAt) DESC, cr.id DESC
    `,
    [userId, userId, ROOM_STATUS_DISABLED]
  );

  return ok((rows || []).map((row) => formatRoom(row, userId)));
};

const getRoomMessages = async ({ roomId, query, user }) => {
  const room = await getRoomById(roomId);
  if (!room) {
    throw makeError("Chat room not found", 404, 2);
  }

  assertRoomMember(user, room);
  const pagination = normalizePagination(query);
  const [rows] = await connection.promise().query(
    `
      SELECT
        m.id,
        m.roomId,
        m.senderId,
        m.message,
        m.messageType,
        m.isRead,
        m.createdAt,
        m.updatedAt,
        sender.firstName AS senderFirstName,
        sender.lastName AS senderLastName
      FROM chat_room_messages m
      INNER JOIN users sender
        ON sender.id = m.senderId
      WHERE m.roomId = ?
      ORDER BY m.createdAt DESC, m.id DESC
      LIMIT ? OFFSET ?
    `,
    [room.roomId, pagination.limit, pagination.offset]
  );

  const [countRows] = await connection.promise().query(
    `
      SELECT COUNT(*) AS total
      FROM chat_room_messages
      WHERE roomId = ?
    `,
    [room.roomId]
  );

  return ok({
    room: formatRoom(room, user.id),
    messages: (rows || []).reverse().map(formatMessage),
    pagination: {
      page: pagination.page,
      limit: pagination.limit,
      total: Number(countRows[0]?.total) || 0,
    },
  });
};

const createRoomMessage = async ({ roomId, body, user }) => {
  const message = String(body?.message || "").trim();
  if (!message) {
    throw makeError("Message is required", 400, 1);
  }

  const messageType = String(body?.messageType || "TEXT").trim().toUpperCase() || "TEXT";
  const result = await withTransaction(async (db) => {
    const room = await getRoomById(roomId, db);
    if (!room) {
      throw makeError("Chat room not found", 404, 2);
    }

    assertRoomMember(user, room);
    if (room.status !== ROOM_STATUS_ACTIVE) {
      throw makeError("Chat room is not active", 409, 409);
    }

    const [insertResult] = await db.query(
      `
        INSERT INTO chat_room_messages
          (roomId, senderId, message, messageType, isRead)
        VALUES (?, ?, ?, ?, 0)
      `,
      [room.roomId, user.id, message, messageType]
    );

    await db.query(
      `
        UPDATE chat_rooms
        SET updatedAt = CURRENT_TIMESTAMP
        WHERE id = ?
      `,
      [room.roomId]
    );

    const createdMessage = await getMessageById(insertResult.insertId, db);
    if (Number(user.id) === Number(room.patientId)) {
      await createDoctorNotification({
        doctorId: room.doctorId,
        bookingId: room.bookingId,
        chatRoomId: room.roomId,
        sourceMessageId: createdMessage.id,
        type: "NEW_MESSAGE",
        content: createdMessage.message,
      }, db);
    }

    return {
      room,
      message: createdMessage,
    };
  });

  return ok({
    room: formatRoom(result.room, user.id),
    message: formatMessage(result.message),
  });
};

const markRoomRead = async ({ roomId, user }) => {
  const room = await getRoomById(roomId);
  if (!room) {
    throw makeError("Chat room not found", 404, 2);
  }

  assertRoomMember(user, room);
  const [result] = await connection.promise().query(
    `
      UPDATE chat_room_messages
      SET isRead = 1
      WHERE roomId = ?
        AND senderId <> ?
        AND isRead = 0
    `,
    [room.roomId, user.id]
  );

  return ok({
    roomId: room.roomId,
    readByUserId: user.id,
    readCount: Number(result.changedRows) || 0,
  });
};

const isUserInRoom = async (user, roomId) => {
  try {
    const room = await getRoomById(roomId);
    if (!room) return false;
    assertRoomMember(user, room);
    return true;
  } catch (error) {
    return false;
  }
};

module.exports = {
  createRoomFromBooking,
  getMyRooms,
  getRoomMessages,
  createRoomMessage,
  markRoomRead,
  isUserInRoom,
};
