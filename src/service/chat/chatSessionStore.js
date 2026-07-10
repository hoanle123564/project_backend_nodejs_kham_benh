const { v4: uuidv4 } = require("uuid");
const connection = require("../../config/data");
const {
  STATES,
  DEFAULT_SESSION_TITLE,
  SESSION_ACCESS_ERROR,
  defaultCollectedInfo,
} = require("./chatState");
const { parseJson, createChatError, requirePatientId } = require("./chatUtils");

const rowToSession = (row) => {
  const collectedInfo = {
    ...defaultCollectedInfo(),
    ...parseJson(row.collectedInfo, {}),
  };

  return {
    id: row.id,
    sessionId: row.sessionId,
    patientId: row.patientId || null,
    title: row.title || DEFAULT_SESSION_TITLE,
    state: row.state || STATES.START,
    collectedInfo,
    selectedDoctorId: row.selectedDoctorId || null,
    selectedScheduleId: row.selectedScheduleId || null,
    bookingId: row.bookingId || null,
    lastAiResult: parseJson(row.lastAiResult, null),
    createdAt: row.createdAt || null,
    updatedAt: row.updatedAt || null,
    expiresAt: row.expiresAt || null,
  };
};

const createSessionObject = (sessionId, patientId) => ({
  sessionId: sessionId || uuidv4(),
  patientId: patientId || null,
  title: DEFAULT_SESSION_TITLE,
  state: STATES.START,
  collectedInfo: defaultCollectedInfo(),
  selectedDoctorId: null,
  selectedScheduleId: null,
  bookingId: null,
  lastAiResult: null,
  expiresAt: null,
});

const sessionListItem = (session) => ({
  sessionId: session.sessionId,
  session_id: session.sessionId,
  title: session.title || DEFAULT_SESSION_TITLE,
  state: session.state || STATES.START,
  createdAt: session.createdAt || null,
  updatedAt: session.updatedAt || null,
});

const getOwnedSession = async (sessionId, patientId) => {
  requirePatientId(patientId);

  const normalizedSessionId = String(sessionId || "").trim();
  if (!normalizedSessionId) {
    throw createChatError(400, "Thiếu sessionId cuộc trò chuyện.");
  }

  const [rows] = await connection.promise().query(
    `
      SELECT *
      FROM chat_sessions
      WHERE sessionId = ?
      LIMIT 1
    `,
    [normalizedSessionId]
  );

  if (!rows.length || Number(rows[0].patientId) !== Number(patientId)) {
    throw createChatError(404, SESSION_ACCESS_ERROR);
  }

  return rowToSession(rows[0]);
};

const createChatSession = async (patientId) => {
  requirePatientId(patientId);

  const session = createSessionObject(uuidv4(), patientId);
  await connection.promise().query(
    `
      INSERT INTO chat_sessions
        (sessionId, patientId, title, state, collectedInfo)
      VALUES (?, ?, ?, ?, ?)
    `,
    [
      session.sessionId,
      session.patientId,
      session.title,
      session.state,
      JSON.stringify(session.collectedInfo),
    ]
  );

  const [rows] = await connection.promise().query(
    `
      SELECT *
      FROM chat_sessions
      WHERE sessionId = ?
      LIMIT 1
    `,
    [session.sessionId]
  );

  return sessionListItem(rowToSession(rows[0]));
};

const getOrCreateSession = async (sessionId, patientId) => {
  if (sessionId) return getOwnedSession(sessionId, patientId);
  const created = await createChatSession(patientId);
  return getOwnedSession(created.sessionId, patientId);
};

const getChatSessions = async (patientId) => {
  requirePatientId(patientId);

  const [rows] = await connection.promise().query(
    `
      SELECT sessionId,
             COALESCE(NULLIF(title, ''), ?) AS title,
             state,
             createdAt,
             updatedAt
      FROM chat_sessions
      WHERE patientId = ?
      ORDER BY updatedAt DESC, id DESC
      LIMIT 50
    `,
    [DEFAULT_SESSION_TITLE, patientId]
  );

  return rows.map(sessionListItem);
};

const getChatMessages = async (patientId, sessionId) => {
  const session = await getOwnedSession(sessionId, patientId);
  const [rows] = await connection.promise().query(
    `
      SELECT id, role, message, state, data, createdAt, updatedAt
      FROM chat_messages
      WHERE chatSessionId = ?
      ORDER BY createdAt ASC, id ASC
    `,
    [session.id]
  );

  return rows.map((row) => ({
    id: row.id,
    role: row.role,
    text: row.message,
    message: row.message,
    state: row.state || null,
    data: parseJson(row.data, null),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  }));
};

const saveSession = async (session) => {
  await connection.promise().query(
    `
      UPDATE chat_sessions
      SET title = ?,
          patientId = ?,
          state = ?,
          collectedInfo = ?,
          selectedDoctorId = ?,
          selectedScheduleId = ?,
          bookingId = ?,
          lastAiResult = ?,
          expiresAt = ?
      WHERE sessionId = ?
    `,
    [
      session.title || DEFAULT_SESSION_TITLE,
      session.patientId || null,
      session.state,
      JSON.stringify(session.collectedInfo || defaultCollectedInfo()),
      session.selectedDoctorId || null,
      session.selectedScheduleId || null,
      session.bookingId || null,
      session.lastAiResult ? JSON.stringify(session.lastAiResult) : null,
      session.expiresAt || null,
      session.sessionId,
    ]
  );
};

const resetSession = async (sessionId, patientId) => {
  const session = await getOwnedSession(sessionId, patientId);
  session.state = STATES.START;
  session.collectedInfo = defaultCollectedInfo();
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;
  session.bookingId = null;
  session.lastAiResult = null;
  await saveSession(session);
  return session;
};

const saveChatMessage = async (session, role, message, state = null, data = null) => {
  await connection.promise().query(
    `
      INSERT INTO chat_messages
        (chatSessionId, role, message, state, data)
      VALUES (?, ?, ?, ?, ?)
    `,
    [
      session.id,
      role,
      String(message || ""),
      state || null,
      data ? JSON.stringify(data) : null,
    ]
  );
};

module.exports = {
  rowToSession,
  createSessionObject,
  sessionListItem,
  getOwnedSession,
  createChatSession,
  getOrCreateSession,
  getChatSessions,
  getChatMessages,
  saveSession,
  resetSession,
  saveChatMessage,
};
