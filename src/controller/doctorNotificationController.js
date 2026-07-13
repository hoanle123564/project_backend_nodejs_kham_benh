const { getDoctorNotifications, markDoctorNotificationsRead } = require("../service/doctorNotificationService");

const sendError = (res, error) => res.status(error?.statusCode || 500).json({
  errCode: error?.errCode || -1,
  errMessage: error?.message || "Error from server",
  data: {},
});

const getMyDoctorNotifications = async (req, res) => {
  try { return res.status(200).json(await getDoctorNotifications(req.user)); }
  catch (error) { return sendError(res, error); }
};

const markMyDoctorNotificationsRead = async (req, res) => {
  try { return res.status(200).json(await markDoctorNotificationsRead(req.user, req.params.notificationId)); }
  catch (error) { return sendError(res, error); }
};

module.exports = { getMyDoctorNotifications, markMyDoctorNotificationsRead };
