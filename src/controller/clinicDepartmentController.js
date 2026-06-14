const {
  getClinicDepartment,
  createClinicDepartment,
  editClinicDepartment,
  changeStatusClinicDepartment,
} = require("../service/clinicDepartmentService");
const {
  FORBIDDEN_RESPONSE,
  canManageClinic,
  canManageDepartment,
} = require("../service/clinicAccessService");

const getAllClinicDepartment = async (req, res) => {
  try {
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
