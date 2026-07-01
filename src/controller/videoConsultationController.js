const {
  FORBIDDEN_RESPONSE,
  canViewBooking,
} = require("../service/clinicAccessService");
const {
  getJoinToken,
  markStarted,
} = require("../service/videoConsultationService");

const sendResponse = (res, response) => {
  if (response?.errCode === 403) {
    return res.status(403).json(response);
  }

  if (response?.errCode === 409) {
    return res.status(409).json(response);
  }

  if (response?.errCode === 500) {
    return res.status(500).json(response);
  }

  return res.status(200).json(response);
};

const handleControllerError = (res, label, error) => {
  console.error(`${label} error`, error);
  return res.status(400).json({
    errCode: -1,
    errMessage: "Error from server",
  });
};

const postJoinToken = async (req, res) => {
  try {
    const bookingId = req.body?.bookingId;
    const allowed = await canViewBooking(req.user, bookingId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getJoinToken({ bookingId, user: req.user });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "postJoinToken", error);
  }
};

const postMarkStarted = async (req, res) => {
  try {
    const bookingId = req.body?.bookingId;
    const allowed = await canViewBooking(req.user, bookingId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await markStarted({ bookingId, user: req.user });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "postMarkStarted", error);
  }
};

module.exports = {
  postJoinToken,
  postMarkStarted,
};
