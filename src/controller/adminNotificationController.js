const {
  getAdminNotifications,
  markAdminNotificationsRead,
} = require("../service/notificationService");

const sendError = (res, error) => res.status(error?.statusCode || 500).json({
  errCode: error?.errCode || -1,
  errMessage: error?.message || "Error from server",
  data: {},
});

const getMyAdminNotifications = async (req, res) => {
  try { return res.status(200).json(await getAdminNotifications(req.user)); }
  catch (error) { return sendError(res, error); }
};

const markMyAdminNotificationsRead = async (req, res) => {
  try { return res.status(200).json(await markAdminNotificationsRead(req.user, req.params.notificationId)); }
  catch (error) { return sendError(res, error); }
};

module.exports = { getMyAdminNotifications, markMyAdminNotificationsRead };
