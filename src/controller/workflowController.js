const {
  FORBIDDEN_RESPONSE,
  canManageDoctorSchedule,
  canManageBooking,
  canManageVisit,
  canViewMedicalRecord,
  canManageMedicalRecord,
} = require("../service/clinicAccessService");
const {
  getDoctorPatientList,
  getDoctorPatientDetail,
  getDoctorPatientHistory,
  getDoctorQueue,
  getDoctorAppointmentDetail,
  getDoctorMedicalRecordList,
  getAdminMedicalRecordList,
  startVisitForBooking,
  getExaminationVisitDetail,
  ensureRecordForVisit,
  getMedicalRecordDetail,
  saveMedicalRecordDraft,
  ensurePrescriptionForRecord,
  savePrescriptionItemsForRecord,
  createParaclinicalForRecord,
  saveParaclinicalListForRecord,
  completeMedicalRecordVisit,
  getVisitPaymentSummaryResponse,
  collectPaymentForVisit,
  closeMedicalRecord,
} = require("../service/workflowApiService");

const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const missingResponse = (fieldName) => ({
  errCode: 1,
  errMessage: `Missing required parameter: ${fieldName}`,
  data: {},
});

const sendResponse = (res, response) => {
  if (response?.errCode === 403) {
    return res.status(403).json(response);
  }

  if (response?.errCode === 409) {
    return res.status(409).json(response);
  }

  return res.status(200).json(response);
};

const resolveDoctorId = async (req) => {
  const requestedDoctorId = normalizePositiveId(
    req.query?.doctorId || req.query?.id || req.body?.doctorId
  );
  const doctorId =
    requestedDoctorId || (req.user?.roleId === "R2" ? normalizePositiveId(req.user?.id) : null);

  if (!doctorId) {
    return { response: missingResponse("doctorId") };
  }

  const allowed = await canManageDoctorSchedule(req.user, doctorId);
  if (!allowed) {
    return { status: 403, response: FORBIDDEN_RESPONSE };
  }

  return { doctorId };
};

const handleControllerError = (res, label, error) => {
  console.error(`${label} error`, error);
  return res.status(400).json({
    errCode: -1,
    errMessage: "Error from server",
  });
};

const getDoctorPatients = async (req, res) => {
  try {
    const doctorContext = await resolveDoctorId(req);
    if (doctorContext.response) {
      return res.status(doctorContext.status || 200).json(doctorContext.response);
    }

    const response = await getDoctorPatientList({
      ...req.query,
      doctorId: doctorContext.doctorId,
    });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorPatients", error);
  }
};

const getDoctorPatientDetailApi = async (req, res) => {
  try {
    const doctorContext = await resolveDoctorId(req);
    if (doctorContext.response) {
      return res.status(doctorContext.status || 200).json(doctorContext.response);
    }

    const response = await getDoctorPatientDetail({
      ...req.query,
      doctorId: doctorContext.doctorId,
    });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorPatientDetailApi", error);
  }
};

const getDoctorPatientHistoryApi = async (req, res) => {
  try {
    const doctorContext = await resolveDoctorId(req);
    if (doctorContext.response) {
      return res.status(doctorContext.status || 200).json(doctorContext.response);
    }

    const response = await getDoctorPatientHistory({
      ...req.query,
      doctorId: doctorContext.doctorId,
    });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorPatientHistoryApi", error);
  }
};

const getDoctorQueueApi = async (req, res) => {
  try {
    const doctorContext = await resolveDoctorId(req);
    if (doctorContext.response) {
      return res.status(doctorContext.status || 200).json(doctorContext.response);
    }

    const response = await getDoctorQueue({
      ...req.query,
      doctorId: doctorContext.doctorId,
    });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorQueueApi", error);
  }
};

const getDoctorAppointmentDetailApi = async (req, res) => {
  try {
    const bookingId = req.query?.bookingId || req.query?.id;
    const allowed = await canManageBooking(req.user, bookingId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getDoctorAppointmentDetail({ bookingId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorAppointmentDetailApi", error);
  }
};

const getDoctorMedicalRecordsApi = async (req, res) => {
  try {
    const doctorContext = await resolveDoctorId(req);
    if (doctorContext.response) {
      return res.status(doctorContext.status || 200).json(doctorContext.response);
    }

    const response = await getDoctorMedicalRecordList({
      ...req.query,
      doctorId: doctorContext.doctorId,
    });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorMedicalRecordsApi", error);
  }
};

const getAdminMedicalRecordsApi = async (req, res) => {
  try {
    const response = await getAdminMedicalRecordList(req.query);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getAdminMedicalRecordsApi", error);
  }
};

const ensureDoctorExaminationVisit = async (req, res) => {
  try {
    const bookingId = req.body?.bookingId;
    const allowed = await canManageBooking(req.user, bookingId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await startVisitForBooking({ bookingId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "ensureDoctorExaminationVisit", error);
  }
};

const getDoctorExaminationVisitDetail = async (req, res) => {
  try {
    const examinationVisitId = req.query?.examinationVisitId || req.query?.id;
    const allowed = await canManageVisit(req.user, examinationVisitId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getExaminationVisitDetail({ examinationVisitId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getDoctorExaminationVisitDetail", error);
  }
};

const ensureDoctorMedicalRecord = async (req, res) => {
  try {
    const examinationVisitId = req.body?.examinationVisitId;
    const allowed = await canManageVisit(req.user, examinationVisitId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await ensureRecordForVisit({ examinationVisitId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "ensureDoctorMedicalRecord", error);
  }
};

const getMedicalRecordDetailApi = async (req, res) => {
  try {
    const medicalRecordId = req.query?.medicalRecordId || req.query?.id;
    const allowed = await canViewMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getMedicalRecordDetail({ medicalRecordId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getMedicalRecordDetailApi", error);
  }
};

const saveMedicalRecordDraftApi = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await saveMedicalRecordDraft(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "saveMedicalRecordDraftApi", error);
  }
};

const ensureMedicalRecordPrescription = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await ensurePrescriptionForRecord(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "ensureMedicalRecordPrescription", error);
  }
};

const saveMedicalRecordPrescription = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await savePrescriptionItemsForRecord(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "saveMedicalRecordPrescription", error);
  }
};

const createMedicalRecordParaclinicalResult = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await createParaclinicalForRecord(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "createMedicalRecordParaclinicalResult", error);
  }
};

const saveMedicalRecordParaclinicalResults = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await saveParaclinicalListForRecord(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "saveMedicalRecordParaclinicalResults", error);
  }
};

const completeMedicalRecordVisitApi = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await completeMedicalRecordVisit(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "completeMedicalRecordVisitApi", error);
  }
};

const getVisitPaymentSummaryApi = async (req, res) => {
  try {
    const examinationVisitId = req.query?.examinationVisitId || req.query?.id;
    const allowed = await canManageVisit(req.user, examinationVisitId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getVisitPaymentSummaryResponse({ examinationVisitId });
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "getVisitPaymentSummaryApi", error);
  }
};

const collectVisitPaymentApi = async (req, res) => {
  try {
    const examinationVisitId = req.body?.examinationVisitId;
    const allowed = await canManageVisit(req.user, examinationVisitId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await collectPaymentForVisit(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "collectVisitPaymentApi", error);
  }
};

const closeMedicalRecordApi = async (req, res) => {
  try {
    const medicalRecordId = req.body?.medicalRecordId;
    const allowed = await canManageMedicalRecord(req.user, medicalRecordId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await closeMedicalRecord(req.body);
    return sendResponse(res, response);
  } catch (error) {
    return handleControllerError(res, "closeMedicalRecordApi", error);
  }
};

module.exports = {
  getDoctorPatients,
  getDoctorPatientDetailApi,
  getDoctorPatientHistoryApi,
  getDoctorQueueApi,
  getDoctorAppointmentDetailApi,
  getDoctorMedicalRecordsApi,
  getAdminMedicalRecordsApi,
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
};
