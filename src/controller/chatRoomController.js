const {
  createRoomFromBooking,
  getMyRooms,
  getRoomMessages,
  createRoomMessage,
  markRoomRead,
} = require("../service/chatRoomService");
const {
  emitMessageRead,
  emitNewMessage,
} = require("../socket/chatSocket");

const sendResponse = (res, response) => res.status(200).json(response);

const sendError = (res, label, error) => {
  const status = error?.statusCode || 500;
  if (status >= 500) {
    console.error(`${label} error`, error);
  }

  return res.status(status).json({
    errCode: error?.errCode || -1,
    errMessage: error?.message || "Error from server",
    data: {},
  });
};

const createFromBooking = async (req, res) => {
  try {
    const response = await createRoomFromBooking({
      bookingId: req.body?.bookingId,
      user: req.user,
    });
    return sendResponse(res, response);
  } catch (error) {
    return sendError(res, "createFromBooking", error);
  }
};

const getMyChatRooms = async (req, res) => {
  try {
    const response = await getMyRooms(req.user);
    return sendResponse(res, response);
  } catch (error) {
    return sendError(res, "getMyChatRooms", error);
  }
};

const getChatRoomMessages = async (req, res) => {
  try {
    const response = await getRoomMessages({
      roomId: req.params.roomId,
      query: req.query,
      user: req.user,
    });
    return sendResponse(res, response);
  } catch (error) {
    return sendError(res, "getChatRoomMessages", error);
  }
};

const postChatRoomMessage = async (req, res) => {
  try {
    const response = await createRoomMessage({
      roomId: req.params.roomId,
      body: req.body,
      user: req.user,
    });

    emitNewMessage(response.data.message.roomId, response.data);
    return sendResponse(res, response);
  } catch (error) {
    return sendError(res, "postChatRoomMessage", error);
  }
};

const patchChatRoomRead = async (req, res) => {
  try {
    const response = await markRoomRead({
      roomId: req.params.roomId,
      user: req.user,
    });

    emitMessageRead(response.data.roomId, response.data);
    return sendResponse(res, response);
  } catch (error) {
    return sendError(res, "patchChatRoomRead", error);
  }
};

module.exports = {
  createFromBooking,
  getMyChatRooms,
  getChatRoomMessages,
  postChatRoomMessage,
  patchChatRoomRead,
};
