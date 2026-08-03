const {
  createClinicDoctor,
  getClinicPatient,
  getClinicPatients,
  updateClinicDoctor,
  updateClinicPatient,
} = require("../service/clinicManagerService");
const { changeStatusDoctorInfo } = require("../service/DoctorService");
const {
  CONFLICT_RESPONSE,
  FORBIDDEN_RESPONSE,
  canManageDoctorSchedule,
  getR4ClinicScope,
} = require("../service/clinicAccessService");

const send = (res, response) =>
  res.status(response?.errCode === 409 ? 409 : response?.errCode === 403 ? 403 : 200).json(response);

const scopeFor = async (req, res) => {
  const scope = await getR4ClinicScope(req.user);
  if (scope.errCode === 0) return scope;
  send(res, scope.errCode === 409 ? CONFLICT_RESPONSE : FORBIDDEN_RESPONSE);
  return null;
};

const getPatients = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    return send(res, await getClinicPatients(scope.clinicId, req.query));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: [] });
  }
};

const getPatient = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    return send(res, await getClinicPatient(scope.clinicId, req.params.patientId));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: {} });
  }
};

const putPatient = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    return send(res, await updateClinicPatient(scope.clinicId, req.params.patientId, req.body));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: {} });
  }
};

const postDoctor = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    return send(res, await createClinicDoctor(scope.clinicId, req.body));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: {} });
  }
};

const putDoctor = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    return send(res, await updateClinicDoctor(scope.clinicId, req.params.doctorId, req.body));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: {} });
  }
};

const patchDoctorStatus = async (req, res) => {
  try {
    const scope = await scopeFor(req, res);
    if (!scope) return;
    if (!(await canManageDoctorSchedule(req.user, req.params.doctorId))) {
      return send(res, FORBIDDEN_RESPONSE);
    }
    return send(res, await changeStatusDoctorInfo({
      doctorId: req.params.doctorId,
      isActive: req.body?.isActive,
    }));
  } catch (error) {
    return send(res, { errCode: 1, errMessage: "Error from server", data: {} });
  }
};

module.exports = {
  getPatient,
  getPatients,
  patchDoctorStatus,
  postDoctor,
  putDoctor,
  putPatient,
};
