const {
    createClinic,
    getClinic,
    getClinicDetail,
    deleteClinic,
    editClinic,
    updateClinicOrder,
    changeStatusClinic
} = require("../service/ClinicService");

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
        let respone = await getClinic(req.query);
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
        const data = req.body;
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

module.exports = {
    postCreateClinic,
    getAllClinic,
    getDetailClinicById,
    handleDeleteClinic,
    handleEditClinic,
    handleUpdateClinicOrder,
    handleChangeStatusClinic,
};
