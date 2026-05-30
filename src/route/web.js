const express = require("express");

// middleware
const authMiddleware = require("../MiiddleWare/authMiddleware");
const adminMiddleware = require("../MiiddleWare/adminMiddleware");

// user controller
const {
  handleLogin,
  handleGetAllUser,
  handleCreateNewUserAPI,
  handleEditUserAPI,
  handleDeleteNewUserAPI,
  getLookUp,
} = require("../controller/userController");

// admin controller
const {
  getAdminDashboardStatistics
} = require("../controller/adminController");

// doctor controller
const {
  getTopDoctor,
  getDetailDoctor,
  getAllDoctor,
  postInfoDoctor,
  CreateScheduleDoctor,
  GetcheScheduleDoctor,
  getListPatientForDoctor,
  postSendRemedy,
  handleDeleteScheduleDoctor,
  getListAppointmentForDoctor,
  getListBooking,
  getRelatedDoctors
} = require("../controller/doctorController");

// patient controller
const {
  postBookAppointment,
  postVerifyBookAppointment,
  getAllPatient,
  getListBookingForPatient,
  postCancelBookAppointment
} = require("../controller/patientController");

// specialty controller
const {
  postCreateSpecialty,
  getAllSpecialty,
  getDetailSpecialtyById,
  handleDeleteSpecialty,
  handleEditSpecialty,
} = require("../controller/specialtyController");

// clinic controller
const {
  postCreateClinic,
  getAllClinic,
  getDetailClinicById,
  handleDeleteClinic,
  handleEditClinic,
} = require("../controller/clinicController");

// post category controller
const {
  postCreatePostCategory,
  getAllPostCategory,
  getDetailPostCategoryById,
  handleEditPostCategory,
  handleDeletePostCategory,
} = require("../controller/postCategoryController");

// post controller
const {
  postCreatePost,
  getAllPost,
  getDetailPostById,
  handleEditPost,
  handleDeletePost,
  handleChangeStatusPost,
} = require("../controller/postController");
const router = express.Router();

router.post("/api/login", handleLogin);
router.get("/api/get-all-user", handleGetAllUser);
router.post("/api/create-new-user", handleCreateNewUserAPI);
router.put("/api/edit-user", authMiddleware, handleEditUserAPI);
router.delete("/api/delete-user", authMiddleware, handleDeleteNewUserAPI);
router.get("/api/lookup", getLookUp);

// admin routes
router.get("/api/admin/dashboard-statistics", authMiddleware, adminMiddleware, getAdminDashboardStatistics);

// doctor routes
router.get("/api/top-doctor", getTopDoctor);
router.get("/api/all-doctor", getAllDoctor);
router.get("/api/detail-doctor", getDetailDoctor);
router.post("/api/save-doctor", authMiddleware, postInfoDoctor);
router.post("/api/create-schedule-doctor", authMiddleware, CreateScheduleDoctor);
router.get("/api/get-schedule-doctor", GetcheScheduleDoctor);
router.get("/api/get-list-patient-for-doctor", authMiddleware, getListPatientForDoctor);
router.post("/api/send-remedy", authMiddleware, postSendRemedy);
router.delete("/api/delete-schedule-doctor", authMiddleware, handleDeleteScheduleDoctor);
router.get("/api/get-list-booking-appointment-doctor", getListAppointmentForDoctor);
router.get("/api/get-all-list-booking", getListBooking);
router.get("/api/get-related-doctors", getRelatedDoctors);

// patient routes
router.post("/api/patient-book-appointment", postBookAppointment);
router.post("/api/verify-book-appointment", postVerifyBookAppointment);
router.get("/api/all-patien", getAllPatient);
router.get("/api/get-list-booking-appointment-patient", authMiddleware, getListBookingForPatient);
router.post("/api/cancel-book-appointment", authMiddleware, postCancelBookAppointment);


// specialty routes
router.post("/api/create-specialty", authMiddleware, postCreateSpecialty);
router.delete("/api/delete-specialty", authMiddleware, handleDeleteSpecialty);
router.put("/api/edit-specialty", authMiddleware, handleEditSpecialty);
router.get("/api/get-specialty", getAllSpecialty);
router.get("/api/get-detail-specialty-by-id", getDetailSpecialtyById);

// clinic routes
router.post("/api/create-clinic", authMiddleware, postCreateClinic);
router.delete("/api/delete-clinic", authMiddleware, handleDeleteClinic);
router.put("/api/edit-clinic", authMiddleware, handleEditClinic);
router.get("/api/get-clinic", getAllClinic);
router.get("/api/get-detail-clinic-by-id", getDetailClinicById);

// post category routes
router.post("/api/create-post-category", authMiddleware, adminMiddleware, postCreatePostCategory);
router.delete("/api/delete-post-category", authMiddleware, adminMiddleware, handleDeletePostCategory);
router.put("/api/edit-post-category", authMiddleware, adminMiddleware, handleEditPostCategory);
router.get("/api/get-post-category", authMiddleware, adminMiddleware, getAllPostCategory);
router.get("/api/get-detail-post-category-by-id", authMiddleware, adminMiddleware, getDetailPostCategoryById);

// post routes
router.post("/api/create-post", authMiddleware, adminMiddleware, postCreatePost);
router.delete("/api/delete-post", authMiddleware, adminMiddleware, handleDeletePost);
router.put("/api/edit-post", authMiddleware, adminMiddleware, handleEditPost);
router.put("/api/change-status-post", authMiddleware, adminMiddleware, handleChangeStatusPost);
router.get("/api/get-post", authMiddleware, adminMiddleware, getAllPost);
router.get("/api/get-detail-post-by-id", authMiddleware, adminMiddleware, getDetailPostById);

module.exports = router;
