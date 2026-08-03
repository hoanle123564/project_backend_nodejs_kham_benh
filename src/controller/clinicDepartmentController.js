const {
  getClinicDepartment,
  createClinicDepartment,
  editClinicDepartment,
  changeStatusClinicDepartment,
} = require("../service/clinicDepartmentService");
const {
  CONFLICT_RESPONSE,
  FORBIDDEN_RESPONSE,
  canManageClinic,
  canManageDepartment,
  getR4ClinicScope,
} = require("../service/clinicAccessService");

const ensureR4Scope = async (req, res) => {
  if (req.user?.roleId !== "R4") return true;
  const scope = await getR4ClinicScope(req.user);
  if (scope.errCode === 0) return true;
  res.status(scope.errCode).json(scope.errCode === 409 ? CONFLICT_RESPONSE : FORBIDDEN_RESPONSE);
  return false;
};

const getAllClinicDepartment = async (req, res) => {
  try {
    if (!(await ensureR4Scope(req, res))) return;
    const allowed = await canManageClinic(req.user, req.query?.clinicId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getClinicDepartment(req.query);
    return res.status(200).json(response);
  } catch (error) {
    console.log("getAllClinicDepartment error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
    });
  }
};

const postCreateClinicDepartment = async (req, res) => {
  try {
    if (!(await ensureR4Scope(req, res))) return;
    const allowed = await canManageClinic(req.user, req.body?.clinicId);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await createClinicDepartment(req.body);
    return res.status(200).json(response);
  } catch (error) {
    console.log("postCreateClinicDepartment error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
    });
  }
};

const handleEditClinicDepartment = async (req, res) => {
  try {
    if (!(await ensureR4Scope(req, res))) return;
    const allowed = await canManageDepartment(req.user, req.body?.id);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await editClinicDepartment(req.body);
    return res.status(200).json(response);
  } catch (error) {
    console.log("handleEditClinicDepartment error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
    });
  }
};

const handleChangeStatusClinicDepartment = async (req, res) => {
  try {
    if (!(await ensureR4Scope(req, res))) return;
    const allowed = await canManageDepartment(req.user, req.body?.id);
    if (!allowed) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await changeStatusClinicDepartment(req.body);
    return res.status(200).json(response);
  } catch (error) {
    console.log("handleChangeStatusClinicDepartment error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
    });
  }
};

module.exports = {
  getAllClinicDepartment,
  postCreateClinicDepartment,
  handleEditClinicDepartment,
  handleChangeStatusClinicDepartment,
};
