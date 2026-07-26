const {
  getPatientNotifications,
  markPatientNotificationsRead,
} = require("../service/notificationService");

const sendError = (res, error) => res.status(error?.statusCode || 500).json({
  errCode: error?.errCode || -1,
  errMessage: error?.message || "Error from server",
  data: {},
});

const getMyPatientNotifications = async (req, res) => {
  try { return res.status(200).json(await getPatientNotifications(req.user)); }
  catch (error) { return sendError(res, error); }
};

const markMyPatientNotificationsRead = async (req, res) => {
  try { return res.status(200).json(await markPatientNotificationsRead(req.user, req.params.notificationId)); }
  catch (error) { return sendError(res, error); }
};

module.exports = { getMyPatientNotifications, markMyPatientNotificationsRead };
