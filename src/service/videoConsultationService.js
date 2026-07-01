const crypto = require("crypto");
const { v4: uuidv4 } = require("uuid");
const connection = require("../config/data");
const { getDb, withTransaction } = require("./transactionService");

const APPOINTMENT_TYPE_ONLINE = "AT2";
const BOOKING_STATUS_CONFIRMED = "S2";
const VIDEO_STATUS_NOT_OPENED = "VCS1";
const VIDEO_STATUS_IN_CALL = "VCS2";
const VIDEO_STATUS_ENDED = "VCS3";
const VIDEO_STATUS_CANCELLED = "VCS4";
const ZEGO_TOKEN_TTL_SECONDS = 60 * 60;
const DOCTOR_VIDEO_ROLES = new Set(["R1", "R2", "R4"]);
const PATIENT_ROLE = "R3";

const normalizePositiveId = (value, fieldName = "id") => {
  const normalized = Number(value);
  if (Number.isInteger(normalized) && normalized > 0) {
    return normalized;
  }

  const error = new Error(`Missing required parameter: ${fieldName}`);
  error.errCode = 1;
  throw error;
};

const ok = (data = {}, extra = {}) => ({
  errCode: 0,
  errMessage: "OK",
  data,
  ...extra,
});

const errorResponse = (error, data = {}) => ({
  errCode: error?.errCode || 1,
  errMessage: error?.message || "Database error",
  data,
});

const buildZegoUser = (user = {}) => {
  const userId = `${user.roleId || "U"}_${user.id}`;
  const userName =
    `${user.firstName || ""} ${user.lastName || ""}`.replace(/\s+/g, " ").trim() ||
    user.email ||
    userId;

  return { userId, userName };
};

const getAesAlgorithm = (keyBuffer) => {
  switch (keyBuffer.length) {
    case 16:
      return "aes-128-cbc";
    case 24:
      return "aes-192-cbc";
    case 32:
      return "aes-256-cbc";
    default: {
      const error = new Error("ZEGO_SERVER_SECRET must be 16, 24, or 32 bytes");
      error.errCode = 500;
      throw error;
    }
  }
};

const generateRandomIv = () => crypto.randomBytes(8).toString("hex");

const base64EncodeJson = (value) =>
  Buffer.from(JSON.stringify(value), "utf8").toString("base64");

const generateZegoKitToken = ({ appId, serverSecret, roomId, userId, userName }) => {
  const numericAppId = Number(appId);
  if (!Number.isFinite(numericAppId) || numericAppId <= 0) {
    const error = new Error("ZEGO_APP_ID is not configured");
    error.errCode = 500;
    throw error;
  }

  if (!serverSecret) {
    const error = new Error("ZEGO_SERVER_SECRET is not configured");
    error.errCode = 500;
    throw error;
  }

  const now = Math.floor(Date.now() / 1000);
  const expire = now + ZEGO_TOKEN_TTL_SECONDS;
  const payload = {
    app_id: numericAppId,
    user_id: userId,
    nonce: Math.floor(Math.random() * 2147483647),
    ctime: now,
    expire,
  };
  const keyBuffer = Buffer.from(serverSecret, "utf8");
  const iv = generateRandomIv();
  const cipher = crypto.createCipheriv(
    getAesAlgorithm(keyBuffer),
    keyBuffer,
    Buffer.from(iv, "utf8")
  );
  const encryptedBase64 = Buffer.concat([
    cipher.update(JSON.stringify(payload), "utf8"),
    cipher.final(),
  ]).toString("base64");
  const encrypted = Buffer.from(encryptedBase64, "base64");
  const ivBuffer = Buffer.from(iv, "utf8");
  const expireBuffer = Buffer.alloc(4);
  expireBuffer.writeInt32BE(expire, 0);
  const tokenBuffer = Buffer.alloc(28 + encrypted.length);

  tokenBuffer.set([0, 0, 0, 0], 0);
  expireBuffer.copy(tokenBuffer, 4);
  tokenBuffer[8] = ivBuffer.length >> 8;
  tokenBuffer[9] = ivBuffer.length - (tokenBuffer[8] << 8);
  ivBuffer.copy(tokenBuffer, 10);
  tokenBuffer[26] = encrypted.length >> 8;
  tokenBuffer[27] = encrypted.length - (tokenBuffer[26] << 8);
  encrypted.copy(tokenBuffer, 28);

  const metadata = base64EncodeJson({
    userID: userId,
    roomID: roomId,
    userName: encodeURIComponent(userName),
    appID: numericAppId,
  });

  return `04${tokenBuffer.toString("base64")}#${metadata}`;
};

const isActiveOnlineBooking = (booking = {}) => {
  const bookingStatusId = booking.statusId || booking.bookingStatusId;

  return (
    booking.appointmentTypeId === APPOINTMENT_TYPE_ONLINE &&
    bookingStatusId === BOOKING_STATUS_CONFIRMED &&
    ![VIDEO_STATUS_ENDED, VIDEO_STATUS_CANCELLED].includes(booking.videoSessionStatusId)
  );
};

const canDoctorOpenVideoBooking = (booking = {}) => isActiveOnlineBooking(booking);

const canPatientJoinVideoBooking = (booking = {}) =>
  isActiveOnlineBooking(booking) && booking.videoSessionStatusId === VIDEO_STATUS_IN_CALL;

const canJoinVideoBooking = (booking = {}, roleId = PATIENT_ROLE) =>
  DOCTOR_VIDEO_ROLES.has(roleId)
    ? canDoctorOpenVideoBooking(booking)
    : canPatientJoinVideoBooking(booking);

const getVideoBookingContext = async (bookingId, db, options = {}) => {
  const executor = getDb(db);
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const [rows] = await executor.query(
    `
      SELECT
        b.id AS bookingId,
        b.date AS appointmentDate,
        b.statusId,
        b.patientId,
        s.id AS scheduleId,
        s.doctorId,
        s.timeType,
        s.appointmentTypeId,
        lt.value_vi AS timeTypeVi,
        lt.value_en AS timeTypeEn,
        ev.id AS examinationVisitId,
        vcs.id AS sessionId,
        vcs.roomId,
        vcs.statusId AS videoSessionStatusId,
        vcs.startedAt AS videoStartedAt,
        vcs.endedAt AS videoEndedAt
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      LEFT JOIN examination_visit ev
        ON ev.bookingId = b.id
      LEFT JOIN video_consultation_session vcs
        ON vcs.bookingId = b.id
      WHERE b.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

const assertJoinableBooking = (booking, user) => {
  if (!booking) {
    const error = new Error("Booking not found");
    error.errCode = 2;
    throw error;
  }

  if (booking.appointmentTypeId !== APPOINTMENT_TYPE_ONLINE) {
    const error = new Error("This booking is not an online appointment");
    error.errCode = 409;
    throw error;
  }

  if (booking.statusId !== BOOKING_STATUS_CONFIRMED) {
    const error = new Error("Booking is not ready for video consultation");
    error.errCode = 409;
    throw error;
  }

  if ([VIDEO_STATUS_ENDED, VIDEO_STATUS_CANCELLED].includes(booking.videoSessionStatusId)) {
    const error = new Error("Video consultation session is no longer available");
    error.errCode = 409;
    throw error;
  }

  if (user?.roleId === PATIENT_ROLE && booking.videoSessionStatusId !== VIDEO_STATUS_IN_CALL) {
    const error = new Error("Video room is not open yet");
    error.errCode = 409;
    throw error;
  }
};

const createVideoSessionInCurrentTransaction = async (booking, db) => {
  const roomId = uuidv4();
  try {
    const [result] = await db.query(
      `
        INSERT INTO video_consultation_session
          (bookingId, examinationVisitId, roomId, statusId)
        VALUES (?, ?, ?, ?)
      `,
      [
        booking.bookingId,
        booking.examinationVisitId || null,
        roomId,
        VIDEO_STATUS_NOT_OPENED,
      ]
    );

    return {
      sessionId: result.insertId,
      roomId,
      videoSessionStatusId: VIDEO_STATUS_NOT_OPENED,
    };
  } catch (error) {
    if (error?.code !== "ER_DUP_ENTRY") {
      throw error;
    }

    const refreshed = await getVideoBookingContext(booking.bookingId, db, { forUpdate: true });
    return {
      sessionId: refreshed.sessionId,
      roomId: refreshed.roomId,
      videoSessionStatusId: refreshed.videoSessionStatusId,
    };
  }
};

const ensureVideoSessionForBookingInCurrentTransaction = async (booking, db) => {
  if (booking.sessionId && booking.roomId) {
    if (booking.examinationVisitId) {
      await db.query(
        `
          UPDATE video_consultation_session
          SET examinationVisitId = COALESCE(examinationVisitId, ?)
          WHERE id = ?
        `,
        [booking.examinationVisitId, booking.sessionId]
      );
    }

    return {
      sessionId: booking.sessionId,
      roomId: booking.roomId,
      videoSessionStatusId: booking.videoSessionStatusId,
    };
  }

  return createVideoSessionInCurrentTransaction(booking, db);
};

const ensureVideoSessionForOnlineBookingInCurrentTransaction = async (bookingId, db) => {
  const executor = getDb(db);
  const booking = await getVideoBookingContext(bookingId, executor, { forUpdate: true });

  if (!booking || booking.appointmentTypeId !== APPOINTMENT_TYPE_ONLINE) {
    return null;
  }

  return ensureVideoSessionForBookingInCurrentTransaction(booking, executor);
};

const getJoinToken = async ({ bookingId, user }) => {
  try {
    const appId = Number(process.env.ZEGO_APP_ID);
    const serverSecret = process.env.ZEGO_SERVER_SECRET;
    const { userId, userName } = buildZegoUser(user);

    const result = await withTransaction(async (db) => {
      const booking = await getVideoBookingContext(bookingId, db, { forUpdate: true });
      assertJoinableBooking(booking, user);

      const session = await ensureVideoSessionForBookingInCurrentTransaction(booking, db);
      const token = generateZegoKitToken({
        appId,
        serverSecret,
        roomId: session.roomId,
        userId,
        userName,
      });

      return {
        appId,
        roomId: session.roomId,
        userId,
        userName,
        token,
        bookingId: booking.bookingId,
        sessionStatusId: session.videoSessionStatusId || VIDEO_STATUS_NOT_OPENED,
      };
    });

    return ok(result);
  } catch (error) {
    console.log("getJoinToken error:", error);
    return errorResponse(error, {});
  }
};

const markStarted = async ({ bookingId, user }) => {
  try {
    const result = await withTransaction(async (db) => {
      const booking = await getVideoBookingContext(bookingId, db, { forUpdate: true });
      assertJoinableBooking(booking, user);
      const session = await ensureVideoSessionForBookingInCurrentTransaction(booking, db);

      await db.query(
        `
          UPDATE video_consultation_session
          SET
            statusId = ?,
            startedAt = COALESCE(startedAt, CURRENT_TIMESTAMP),
            examinationVisitId = COALESCE(examinationVisitId, ?)
          WHERE id = ?
            AND statusId NOT IN (?, ?)
        `,
        [
          VIDEO_STATUS_IN_CALL,
          booking.examinationVisitId || null,
          session.sessionId,
          VIDEO_STATUS_ENDED,
          VIDEO_STATUS_CANCELLED,
        ]
      );

      return {
        bookingId: booking.bookingId,
        roomId: session.roomId,
        sessionStatusId: VIDEO_STATUS_IN_CALL,
      };
    });

    return ok(result);
  } catch (error) {
    console.log("markStarted error:", error);
    return errorResponse(error, {});
  }
};

const markVideoSessionEndedForBookingInCurrentTransaction = async (bookingId, db) => {
  if (!bookingId) return;

  const executor = getDb(db);
  await executor.query(
    `
      UPDATE video_consultation_session vcs
      INNER JOIN booking b
        ON b.id = vcs.bookingId
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      LEFT JOIN examination_visit ev
        ON ev.bookingId = b.id
      SET
        vcs.statusId = ?,
        vcs.endedAt = COALESCE(vcs.endedAt, CURRENT_TIMESTAMP),
        vcs.examinationVisitId = COALESCE(vcs.examinationVisitId, ev.id)
      WHERE b.id = ?
        AND s.appointmentTypeId = ?
        AND vcs.statusId <> ?
    `,
    [VIDEO_STATUS_ENDED, bookingId, APPOINTMENT_TYPE_ONLINE, VIDEO_STATUS_CANCELLED]
  );
};

const markVideoSessionCancelledForBooking = async (bookingId) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  await connection.promise().query(
    `
      UPDATE video_consultation_session vcs
      INNER JOIN booking b
        ON b.id = vcs.bookingId
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      SET
        vcs.statusId = ?,
        vcs.endedAt = COALESCE(vcs.endedAt, CURRENT_TIMESTAMP)
      WHERE b.id = ?
        AND s.appointmentTypeId = ?
        AND vcs.statusId <> ?
    `,
    [VIDEO_STATUS_CANCELLED, normalizedBookingId, APPOINTMENT_TYPE_ONLINE, VIDEO_STATUS_ENDED]
  );
};

module.exports = {
  APPOINTMENT_TYPE_ONLINE,
  VIDEO_STATUS_NOT_OPENED,
  VIDEO_STATUS_IN_CALL,
  VIDEO_STATUS_ENDED,
  VIDEO_STATUS_CANCELLED,
  canJoinVideoBooking,
  canDoctorOpenVideoBooking,
  canPatientJoinVideoBooking,
  getJoinToken,
  markStarted,
  ensureVideoSessionForOnlineBookingInCurrentTransaction,
  markVideoSessionEndedForBookingInCurrentTransaction,
  markVideoSessionCancelledForBooking,
};
