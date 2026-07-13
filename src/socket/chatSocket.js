const jwt = require("jsonwebtoken");
const { Server } = require("socket.io");
const { isUserInRoom } = require("../service/chatRoomService");

let io = null;

const roomName = (roomId) => `chat_room:${roomId}`;

const normalizeToken = (value) => {
  const token = String(value || "").trim();
  return token.startsWith("Bearer ") ? token.slice(7).trim() : token;
};

const emitChatError = (socket, message) => {
  socket.emit("chat_error", { message });
};

const initChatSocket = (server, options = {}) => {
  io = new Server(server, {
    cors: {
      origin: options.origin,
      credentials: true,
    },
  });

  io.use((socket, next) => {
    try {
      const token = normalizeToken(socket.handshake.auth?.token);
      if (!token) {
        return next(new Error("Missing token"));
      }

      socket.user = jwt.verify(token, process.env.JWT_SECRET);
      return next();
    } catch (error) {
      return next(new Error("Invalid or expired token"));
    }
  });

  io.on("connection", (socket) => {
    socket.on("join_room", async (roomId) => {
      const allowed = await isUserInRoom(socket.user, roomId);
      if (!allowed) {
        emitChatError(socket, "Permission denied");
        return;
      }

      socket.join(roomName(roomId));
    });

    socket.on("leave_room", (roomId) => {
      socket.leave(roomName(roomId));
    });

    socket.on("new_message", () => {
      emitChatError(socket, "Send messages through the REST API");
    });
  });

  return io;
};

const emitNewMessage = (roomId, payload) => {
  if (!io || !roomId) return;
  io.to(roomName(roomId)).emit("new_message", payload);
};

const emitMessageRead = (roomId, payload) => {
  if (!io || !roomId) return;
  io.to(roomName(roomId)).emit("message_read", payload);
};

module.exports = {
  initChatSocket,
  emitNewMessage,
  emitMessageRead,
};
