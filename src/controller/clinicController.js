const {
    createClinic,
    getClinic,
    getClinicDetail,
    deleteClinic,
    editClinic,
    updateClinicOrder,
    changeStatusClinic,
    getClinicContentSections,
    createClinicContentSection,
    editClinicContentSection,
    deleteClinicContentSection,
    changeStatusClinicContentSection,
    updateClinicContentSectionOrder,
} = require("../service/ClinicService");
const {
    FORBIDDEN_RESPONSE,
    canManageClinic,
} = require("../service/clinicAccessService");

const postCreateClinic = async (req, res) => {
    try {
        let response = await createClinic(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postCreateClinic error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const getAllClinic = async (req, res) => {
    try {
        const managedOnly = req.query?.managedOnly === "1";
        if (managedOnly && !["R2", "R4"].includes(req.user?.roleId)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let respone = await getClinic(
            managedOnly ? { ...req.query, managerUserId: req.user.id } : req.query
        );

        if (managedOnly && respone?.errCode === 0 && respone.data.length === 0) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        return res.status(200).json(respone);
    } catch (error) {
        console.log("getAllClinic error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getDetailClinicById = async (req, res) => {
    try {
        if (req.query?.managedOnly === "1") {
            const allowed = await canManageClinic(req.user, req.query?.id);
            if (!allowed) {
                return res.status(403).json(FORBIDDEN_RESPONSE);
            }
        }

        let response = await getClinicDetail(req.query);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getDetailClinicById error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const handleDeleteClinic = async (req, res) => {
    try {
        const clinicId = req.body.id;
        const allowed = await canManageClinic(req.user, clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await deleteClinic(clinicId);
        return res.status(200).json(response);
    }
    catch (error) {
        console.log("handleDeleteClinic error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleEditClinic = async (req, res) => {
    try {
        const data = { ...req.body };
        const allowed = await canManageClinic(req.user, data?.id);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        if (req.user?.roleId === "R2") {
            data.managerUserId = req.user.id;
        }

        let response = await editClinic(data);
        return res.status(200).json(response);
    }
    catch (error) {
        console.log("handleEditClinic error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleUpdateClinicOrder = async (req, res) => {
    try {
        let response = await updateClinicOrder(req.body?.items);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleUpdateClinicOrder error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusClinic = async (req, res) => {
    try {
        let response = await changeStatusClinic(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusClinic error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleGetClinicContentSections = async (req, res) => {
    try {
        const clinicId = req.query?.clinicId;
        const allowed = await canManageClinic(req.user, clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await getClinicContentSections(clinicId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleGetClinicContentSections error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const postCreateClinicContentSection = async (req, res) => {
    try {
        const allowed = await canManageClinic(req.user, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await createClinicContentSection(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postCreateClinicContentSection error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleEditClinicContentSection = async (req, res) => {
    try {
        const allowed = await canManageClinic(req.user, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await editClinicContentSection(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleEditClinicContentSection error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleDeleteClinicContentSection = async (req, res) => {
    try {
        const allowed = await canManageClinic(req.user, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await deleteClinicContentSection(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleDeleteClinicContentSection error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusClinicContentSection = async (req, res) => {
    try {
        const allowed = await canManageClinic(req.user, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await changeStatusClinicContentSection(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusClinicContentSection error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleUpdateClinicContentSectionOrder = async (req, res) => {
    try {
        const allowed = await canManageClinic(req.user, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await updateClinicContentSectionOrder(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleUpdateClinicContentSectionOrder error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
    postCreateClinic,
    getAllClinic,
    getDetailClinicById,
    handleDeleteClinic,
    handleEditClinic,
    handleUpdateClinicOrder,
    handleChangeStatusClinic,
    handleGetClinicContentSections,
    postCreateClinicContentSection,
    handleEditClinicContentSection,
    handleDeleteClinicContentSection,
    handleChangeStatusClinicContentSection,
    handleUpdateClinicContentSectionOrder,
};
