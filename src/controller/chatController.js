const {
  createChatSession,
  getChatSessions,
  getChatMessages,
  handleChatMessage,
} = require("../service/chatService");

const isPatientUser = (user) => user?.roleId === "R3";

const forbiddenResponse = {
  errCode: -1,
  errMessage: "Bạn không có quyền truy cập tài nguyên này.",
};

const getPatientContext = (req, res) => {
  if (!isPatientUser(req.user)) {
    res.status(403).json(forbiddenResponse);
    return null;
  }

  return {
    patientId: req.user.id,
    patientEmail: req.user.email || null,
  };
};

const getErrorStatus = (error) => error?.statusCode || 500;

const getChatSessionList = async (req, res) => {
  try {
    const patient = getPatientContext(req, res);
    if (!patient) return;

    const data = await getChatSessions(patient.patientId);
    return res.status(200).json({ errCode: 0, errMessage: "OK", data });
  } catch (error) {
    console.log("getChatSessionList error:", error);
    return res.status(getErrorStatus(error)).json({
      errCode: -1,
      errMessage: error.message || "Error from server",
    });
  }
};

const postChatSession = async (req, res) => {
  try {
    const patient = getPatientContext(req, res);
    if (!patient) return;

    const data = await createChatSession(patient.patientId);
    return res.status(200).json({ errCode: 0, errMessage: "OK", data });
  } catch (error) {
    console.log("postChatSession error:", error);
    return res.status(getErrorStatus(error)).json({
      errCode: -1,
      errMessage: error.message || "Error from server",
    });
  }
};

const getChatSessionMessages = async (req, res) => {
  try {
    const patient = getPatientContext(req, res);
    if (!patient) return;

    const data = await getChatMessages(patient.patientId, req.params.sessionId);
    return res.status(200).json({ errCode: 0, errMessage: "OK", data });
  } catch (error) {
    console.log("getChatSessionMessages error:", error);
    return res.status(getErrorStatus(error)).json({
      errCode: -1,
      errMessage: error.message || "Error from server",
    });
  }
};

const postChatMessage = async (req, res) => {
  const sessionId = req.body?.session_id || req.body?.sessionId || null;

  try {
    const patient = getPatientContext(req, res);
    if (!patient) return;

    const response = await handleChatMessage({
      sessionId,
      message: req.body?.message,
      patientId: patient.patientId,
      patientEmail: patient.patientEmail,
    });

    return res.status(200).json(response);
  } catch (error) {
    const status = getErrorStatus(error);
    if (status >= 500) {
      console.log("postChatMessage error:", error);
    }

    return res.status(status).json({
      success: false,
      session_id: sessionId,
      state: "ERROR",
      reply: error.message || "Có lỗi xảy ra khi xử lý chatbot. Vui lòng thử lại.",
      data: {
        collected_info: {},
        doctors: [],
        slots: [],
        booking: null,
      },
    });
  }
};

module.exports = {
  getChatSessionList,
  postChatSession,
  getChatSessionMessages,
  postChatMessage,
};
