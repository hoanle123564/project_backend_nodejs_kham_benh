const jwt = require("jsonwebtoken");
const { handleChatMessage } = require("../service/chatService");

const getOptionalUser = (req) => {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token) return null;

  try {
    return jwt.verify(token, process.env.JWT_SECRET);
  } catch (error) {
    return null;
  }
};

const postChatMessage = async (req, res) => {
  try {
    const user = getOptionalUser(req);
    const patientId = user?.roleId === "R3" ? user.id : null;
    const response = await handleChatMessage({
      sessionId: req.body?.session_id || req.body?.sessionId,
      message: req.body?.message,
      patientId,
      patientEmail: patientId ? user.email : null,
    });

    return res.status(200).json(response);
  } catch (error) {
    console.log("postChatMessage error:", error);
    return res.status(500).json({
      success: false,
      session_id: req.body?.session_id || req.body?.sessionId || null,
      state: "ERROR",
      reply: "Có lỗi xảy ra khi xử lý chatbot. Vui lòng thử lại.",
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
  postChatMessage,
};
