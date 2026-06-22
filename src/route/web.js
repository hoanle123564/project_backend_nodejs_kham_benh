const express = require("express");

// middleware
const authMiddleware = require("../MiddleWare/authMiddleware");
const adminMiddleware = require("../MiddleWare/adminMiddleware");

// user controller
const {
  handleLogin,
  handleGetAllUser,
  handleCreateNewUserAPI,
  handleEditUserAPI,
  handleChangePasswordAPI,
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
  getRelatedDoctors,
  handleUpdateDoctorInfoOrder,
  handleChangeStatusDoctorInfo
} = require("../controller/doctorController");

// patient controller
const {
  postBookAppointment,
  postVerifyBookAppointment,
  getAllPatient,
  getListBookingForPatient,
  postCancelBookAppointment,
  getPatientProfileAPI,
  updatePatientProfileAPI
} = require("../controller/patientController");

const {
  getDoctorPatients,
  getDoctorPatientDetailApi,
  getDoctorPatientHistoryApi,
  getDoctorQueueApi,
  getDoctorAppointmentDetailApi,
  getDoctorMedicalRecordsApi,
  ensureDoctorExaminationVisit,
  getDoctorExaminationVisitDetail,
  ensureDoctorMedicalRecord,
  getMedicalRecordDetailApi,
  saveMedicalRecordDraftApi,
  ensureMedicalRecordPrescription,
  saveMedicalRecordPrescription,
  createMedicalRecordParaclinicalResult,
  saveMedicalRecordParaclinicalResults,
  completeMedicalRecordVisitApi,
  getVisitPaymentSummaryApi,
  collectVisitPaymentApi,
  closeMedicalRecordApi,
} = require("../controller/workflowController");

// specialty controller
const {
  postCreateSpecialty,
  getAllSpecialty,
  getDetailSpecialtyById,
  handleDeleteSpecialty,
  handleEditSpecialty,
  handleUpdateSpecialtyOrder,
  handleChangeStatusSpecialty,
} = require("../controller/specialtyController");

// clinic controller
const {
  postCreateClinic,
  getAllClinic,
  getDetailClinicById,
  handleDeleteClinic,
  handleEditClinic,
  handleUpdateClinicOrder,
  handleChangeStatusClinic,
} = require("../controller/clinicController");
const {
  getAllClinicDepartment,
  postCreateClinicDepartment,
  handleEditClinicDepartment,
  handleChangeStatusClinicDepartment,
} = require("../controller/clinicDepartmentController");

// post category controller
const {
  postCreatePostCategory,
  getAllPostCategory,
  getPublicPostCategories,
  getDetailPostCategoryById,
  getPublicPostCategoryDetail,
  handleEditPostCategory,
  handleDeletePostCategory,
  handleUpdatePostCategoryOrder,
  handleChangeStatusPostCategory,
} = require("../controller/postCategoryController");

// post controller
const {
  postCreatePost,
  getAllPost,
  getPublicPostListByCategory,
  getDetailPostById,
  getPublicPostDetailBySlug,
  getPublicRelatedPostList,
  handleEditPost,
  handleDeletePost,
  handleChangeStatusPost,
  handleUpdatePostOrder,
} = require("../controller/postController");
const router = express.Router();

router.post("/api/login", handleLogin);
router.get("/api/get-all-user", handleGetAllUser);
router.post("/api/create-new-user", handleCreateNewUserAPI);
router.put("/api/edit-user", authMiddleware, handleEditUserAPI);
router.put("/api/change-password", authMiddleware, handleChangePasswordAPI);
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
router.get("/api/doctor/patients", authMiddleware, getDoctorPatients);
router.get("/api/doctor/patient-detail", authMiddleware, getDoctorPatientDetailApi);
router.get("/api/doctor/patient-history", authMiddleware, getDoctorPatientHistoryApi);
router.get("/api/doctor/queue", authMiddleware, getDoctorQueueApi);
router.get("/api/doctor/appointment-detail", authMiddleware, getDoctorAppointmentDetailApi);
router.get("/api/doctor/medical-records", authMiddleware, getDoctorMedicalRecordsApi);
router.post("/api/doctor/examination-visit", authMiddleware, ensureDoctorExaminationVisit);
router.get("/api/doctor/examination-visit-detail", authMiddleware, getDoctorExaminationVisitDetail);
router.post("/api/doctor/medical-record", authMiddleware, ensureDoctorMedicalRecord);
router.get("/api/medical-record/detail", authMiddleware, getMedicalRecordDetailApi);
router.post("/api/medical-record/draft", authMiddleware, saveMedicalRecordDraftApi);
router.post("/api/medical-record/prescription", authMiddleware, ensureMedicalRecordPrescription);
router.put("/api/medical-record/prescription", authMiddleware, saveMedicalRecordPrescription);
router.post("/api/medical-record/paraclinical-result", authMiddleware, createMedicalRecordParaclinicalResult);
router.put("/api/medical-record/paraclinical-results", authMiddleware, saveMedicalRecordParaclinicalResults);
router.post("/api/medical-record/complete-visit", authMiddleware, completeMedicalRecordVisitApi);
router.get("/api/doctor/visit-payment-summary", authMiddleware, getVisitPaymentSummaryApi);
router.post("/api/doctor/collect-visit-payment", authMiddleware, collectVisitPaymentApi);
router.post("/api/medical-record/close", authMiddleware, closeMedicalRecordApi);
router.post("/api/send-remedy", authMiddleware, postSendRemedy);
router.delete("/api/delete-schedule-doctor", authMiddleware, handleDeleteScheduleDoctor);
router.get("/api/get-list-booking-appointment-doctor", authMiddleware, getListAppointmentForDoctor);
router.get("/api/get-all-list-booking", authMiddleware, getListBooking);
router.get("/api/get-related-doctors", getRelatedDoctors);
router.put("/api/update-doctor-info-order", authMiddleware, adminMiddleware, handleUpdateDoctorInfoOrder);
router.put("/api/change-status-doctor-info", authMiddleware, adminMiddleware, handleChangeStatusDoctorInfo);

// patient routes
router.post("/api/patient-book-appointment", postBookAppointment);
router.post("/api/verify-book-appointment", postVerifyBookAppointment);
router.get("/api/all-patien", getAllPatient);
router.get("/api/patient/profile", authMiddleware, getPatientProfileAPI);
router.put("/api/patient/profile", authMiddleware, updatePatientProfileAPI);
router.get("/api/get-list-booking-appointment-patient", authMiddleware, getListBookingForPatient);
router.post("/api/cancel-book-appointment", authMiddleware, postCancelBookAppointment);


// specialty routes
router.post("/api/create-specialty", authMiddleware, postCreateSpecialty);
router.delete("/api/delete-specialty", authMiddleware, handleDeleteSpecialty);
router.put("/api/edit-specialty", authMiddleware, handleEditSpecialty);
router.put("/api/update-specialty-order", authMiddleware, adminMiddleware, handleUpdateSpecialtyOrder);
router.put("/api/change-status-specialty", authMiddleware, adminMiddleware, handleChangeStatusSpecialty);
router.get("/api/get-specialty", getAllSpecialty);
router.get("/api/get-detail-specialty-by-id", getDetailSpecialtyById);

// clinic routes
router.post("/api/create-clinic", authMiddleware, adminMiddleware, postCreateClinic);
router.delete("/api/delete-clinic", authMiddleware, handleDeleteClinic);
router.put("/api/edit-clinic", authMiddleware, handleEditClinic);
router.put("/api/update-clinic-order", authMiddleware, adminMiddleware, handleUpdateClinicOrder);
router.put("/api/change-status-clinic", authMiddleware, adminMiddleware, handleChangeStatusClinic);
router.get("/api/get-clinic", getAllClinic);
router.get("/api/get-detail-clinic-by-id", getDetailClinicById);
router.get("/api/get-clinic-department", authMiddleware, getAllClinicDepartment);
router.post("/api/create-clinic-department", authMiddleware, postCreateClinicDepartment);
router.put("/api/edit-clinic-department", authMiddleware, handleEditClinicDepartment);
router.put("/api/change-status-clinic-department", authMiddleware, handleChangeStatusClinicDepartment);

// public post routes
router.get("/api/public/post-categories", getPublicPostCategories);
router.get("/api/public/post-category-detail", getPublicPostCategoryDetail);
router.get("/api/public/posts-by-category", getPublicPostListByCategory);
router.get("/api/public/post-detail", getPublicPostDetailBySlug);
router.get("/api/public/related-posts", getPublicRelatedPostList);

// post category routes
router.post("/api/create-post-category", authMiddleware, adminMiddleware, postCreatePostCategory);
router.delete("/api/delete-post-category", authMiddleware, adminMiddleware, handleDeletePostCategory);
router.put("/api/edit-post-category", authMiddleware, adminMiddleware, handleEditPostCategory);
router.put("/api/update-post-category-order", authMiddleware, adminMiddleware, handleUpdatePostCategoryOrder);
router.put("/api/change-status-post-category", authMiddleware, adminMiddleware, handleChangeStatusPostCategory);
router.get("/api/get-post-category", authMiddleware, adminMiddleware, getAllPostCategory);
router.get("/api/get-detail-post-category-by-id", authMiddleware, adminMiddleware, getDetailPostCategoryById);

// post routes
router.post("/api/create-post", authMiddleware, adminMiddleware, postCreatePost);
router.delete("/api/delete-post", authMiddleware, adminMiddleware, handleDeletePost);
router.put("/api/edit-post", authMiddleware, adminMiddleware, handleEditPost);
router.put("/api/change-status-post", authMiddleware, adminMiddleware, handleChangeStatusPost);
router.put("/api/update-post-order", authMiddleware, adminMiddleware, handleUpdatePostOrder);
router.get("/api/get-post", authMiddleware, adminMiddleware, getAllPost);
router.get("/api/get-detail-post-by-id", authMiddleware, adminMiddleware, getDetailPostById);

module.exports = router;
