const {
    getTopDoctorHome,
    getDetailDoctorById,
    getAllDoctorHome,
    saveDetailInfoDoctor,
    PostScheduleDoctor,
    GetcheScheduleDoctorByDate,
    GetListPatientForDoctor,
    sendRemedy,
    deleteScheduleDoctor,
    GetListAppointment,
    ListBooking,
    getRelatedDoctorsById,
    updateDoctorInfoOrder,
    changeStatusDoctorInfo
} = require("../service/DoctorService");
const {
    FORBIDDEN_RESPONSE,
    canSaveDoctorInfo,
    canManageDoctorSchedule,
    canManageSchedule,
    canManageBooking,
    canViewBookingList,
} = require("../service/clinicAccessService");
const getTopDoctor = async (req, res) => {
    let limit = req.query.limit;
    if (!limit) {
        limit = 5;
    }
    try {
        const respone = await getTopDoctorHome(limit);
        return res.status(200).json(respone);
    } catch (error) {
        console.log("error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: error,
        });
    }
};
const getAllDoctor = async (req, res) => {
    try {
        const respone = await getAllDoctorHome();
        return res.status(200).json(respone);
    } catch (error) {
        console.log("getAllDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const getDetailDoctor = async (req, res) => {
    try {
        let respone = await getDetailDoctorById(req.query);
        return res.status(200).json(respone);
    } catch (error) {
        console.log("getDetailDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const postInfoDoctor = async (req, res) => {
    try {
        const allowed = await canSaveDoctorInfo(req.user, req.body?.doctorId, req.body?.clinicId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await saveDetailInfoDoctor(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postInfoDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const CreateScheduleDoctor = async (req, res) => {
    try {
        const allowed = await canManageDoctorSchedule(req.user, req.body?.doctorId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await PostScheduleDoctor(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("CreateScheduleDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const GetcheScheduleDoctor = async (req, res) => {
    try {
        let doctorId = req.query.doctorId;
        let date = req.query.date;
        let response = await GetcheScheduleDoctorByDate(doctorId, date);
        console.log('response', response);

        return res.status(200).json(response);

    } catch (error) {
        console.log("GetcheScheduleDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
}

const getListPatientForDoctor = async (req, res) => {
    try {
        let doctorId = req.query.id;
        const allowed = await canManageDoctorSchedule(req.user, doctorId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let date = req.query.date;
        let response = await GetListPatientForDoctor(doctorId, date);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getListPatientForDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const postSendRemedy = async (req, res) => {
    try {
        const allowed = await canManageBooking(req.user, req.body?.bookingId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await sendRemedy(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postSendRemedy error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleDeleteScheduleDoctor = async (req, res) => {
    try {
        let scheduleId = req.body.id;
        const allowed = await canManageSchedule(req.user, scheduleId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await deleteScheduleDoctor(scheduleId);
        return res.status(200).json(response);
    }
    catch (error) {
        console.log("handleDeleteScheduleDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getListAppointmentForDoctor = async (req, res) => {
    try {
        let doctorId = req.query.id;
        const allowed = await canManageDoctorSchedule(req.user, doctorId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await GetListAppointment(doctorId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getListAppointmentForDoctor error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getListBooking = async (req, res) => {
    try {
        if (!canViewBookingList(req.user)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let response = await ListBooking(req.user);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getListBooking error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getRelatedDoctors = async (req, res) => {
    try {
        let doctorId = req.query.id;
        let response = await getRelatedDoctorsById(doctorId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getRelatedDoctors error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleUpdateDoctorInfoOrder = async (req, res) => {
    try {
        let response = await updateDoctorInfoOrder(req.body?.items);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleUpdateDoctorInfoOrder error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusDoctorInfo = async (req, res) => {
    try {
        let response = await changeStatusDoctorInfo(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusDoctorInfo error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
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
};
