const {
  createBookingReview,
  getAdminReviews,
  getBookingReviewEligibility,
  getDoctorReviews,
  getPublicDoctorReviews,
  saveDoctorReviewReply,
  updateReviewVisibility,
} = require("../service/doctorReviewService");

const sendResponse = (res, response) => {
  const statusCode = response?.statusCode || (response?.errCode === 0 ? 200 : 400);
  const { statusCode: _statusCode, ...payload } = response || {};
  return res.status(statusCode).json(payload);
};

const handleError = (res, label, error) => {
  console.error(`${label} error`, error);
  return res.status(400).json({ errCode: -1, errMessage: "Error from server" });
};

const getPublicDoctorReviewList = async (req, res) => {
  try {
    return sendResponse(res, await getPublicDoctorReviews(req.params.doctorId, req.query));
  } catch (error) {
    return handleError(res, "getPublicDoctorReviewList", error);
  }
};

const getBookingReviewEligibilityApi = async (req, res) => {
  try {
    return sendResponse(res, await getBookingReviewEligibility(req.user, req.params.bookingId));
  } catch (error) {
    return handleError(res, "getBookingReviewEligibilityApi", error);
  }
};

const postBookingReview = async (req, res) => {
  try {
    return sendResponse(res, await createBookingReview(req.user, req.params.bookingId, req.body));
  } catch (error) {
    return handleError(res, "postBookingReview", error);
  }
};

const getMyDoctorReviews = async (req, res) => {
  try {
    return sendResponse(res, await getDoctorReviews(req.user, req.query));
  } catch (error) {
    return handleError(res, "getMyDoctorReviews", error);
  }
};

const postDoctorReviewReply = async (req, res) => {
  try {
    return sendResponse(res, await saveDoctorReviewReply(req.user, req.params.reviewId, req.body, "create"));
  } catch (error) {
    return handleError(res, "postDoctorReviewReply", error);
  }
};

const patchDoctorReviewReply = async (req, res) => {
  try {
    return sendResponse(res, await saveDoctorReviewReply(req.user, req.params.reviewId, req.body, "update"));
  } catch (error) {
    return handleError(res, "patchDoctorReviewReply", error);
  }
};

const getAdminReviewList = async (req, res) => {
  try {
    return sendResponse(res, await getAdminReviews(req.user, req.query));
  } catch (error) {
    return handleError(res, "getAdminReviewList", error);
  }
};

const patchAdminReviewVisibility = async (req, res) => {
  try {
    return sendResponse(res, await updateReviewVisibility(req.user, req.params.reviewId, req.body));
  } catch (error) {
    return handleError(res, "patchAdminReviewVisibility", error);
  }
};

module.exports = {
  getAdminReviewList,
  getBookingReviewEligibilityApi,
  getMyDoctorReviews,
  getPublicDoctorReviewList,
  patchAdminReviewVisibility,
  patchDoctorReviewReply,
  postBookingReview,
  postDoctorReviewReply,
};
