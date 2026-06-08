const {
    createSpecialty,
    getSpecialty,
    getSpecialtyDetail,
    editSpecialty,
    deleteSpecialty,
    updateSpecialtyOrder,
    changeStatusSpecialty
} = require("../service/specialtyService");

const postCreateSpecialty = async (req, res) => {
    try {
        let response = await createSpecialty(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postCreateSpecialty error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
}

const getAllSpecialty = async (req, res) => {
    try {
        let respone = await getSpecialty(req.query);
        return res.status(200).json(respone);
    } catch (error) {
        console.log("getAllSpecialty error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
}

const getDetailSpecialtyById = async (req, res) => {
    try {
        let response = await getSpecialtyDetail(req.query);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getDetailSpecialtyById error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleDeleteSpecialty = async (req, res) => {
    try {
        const specialtyId = req.body.id;
        let response = await deleteSpecialty(specialtyId);
        return res.status(200).json(response);
    }
    catch (error) {
        console.log("handleDeleteSpecialty error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleEditSpecialty = async (req, res) => {
    try {
        const data = req.body;
        let response = await editSpecialty(data);
        return res.status(200).json(response);
    }
    catch (error) {
        console.log("handleEditSpecialty error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleUpdateSpecialtyOrder = async (req, res) => {
    try {
        let response = await updateSpecialtyOrder(req.body?.items);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleUpdateSpecialtyOrder error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusSpecialty = async (req, res) => {
    try {
        let response = await changeStatusSpecialty(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusSpecialty error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
    postCreateSpecialty,
    getAllSpecialty,
    getDetailSpecialtyById,
    handleDeleteSpecialty,
    handleEditSpecialty,
    handleUpdateSpecialtyOrder,
    handleChangeStatusSpecialty,
};
