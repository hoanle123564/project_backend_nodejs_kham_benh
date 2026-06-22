const { bookAppointment, verifyBookAppointment, AllPatient, ListBookingForPatient, cancelBookAppointment } = require("../service/PatientService");
const { getPatientProfile, updatePatientProfile } = require("../service/patientProfileService");
const {
    FORBIDDEN_RESPONSE,
    isPatientOwnerOfBooking,
} = require("../service/clinicAccessService");

const isPatientUser = (user) => user?.roleId === "R3";

const postBookAppointment = async (req, res) => {
    try {
        let response = await bookAppointment(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postBookAppointment error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const postVerifyBookAppointment = async (req, res) => {
    try {
        // Logic for verifying booked appointment goes here
        let respone = await verifyBookAppointment(req.body);
        return res.status(200).json(respone);
    } catch (error) {
        console.log("postVerifyBookAppointment error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const getAllPatient = async (req, res) => {
    try {
        let respone = await AllPatient();
        return res.status(200).json(respone);
    } catch (error) {
        console.log("AllPatient error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getListBookingForPatient = async (req, res) => {
    try {
        if (!isPatientUser(req.user)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let patientId = req.user.id;
        let respone = await ListBookingForPatient(patientId);
        return res.status(200).json(respone);
    } catch (error) {
        console.log("getListBookingForPatient error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const postCancelBookAppointment = async (req, res) => {
    try {
        if (!isPatientUser(req.user)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        const bookingId = req.body?.BookingId || req.body?.bookingId;
        const allowed = await isPatientOwnerOfBooking(req.user, bookingId);
        if (!allowed) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        let respone = await cancelBookAppointment({
            ...req.body,
            BookingId: bookingId,
        });
        return res.status(200).json(respone);

    } catch (error) {
        console.log("postCancelBookAppointment error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};
const getPatientProfileAPI = async (req, res) => {
    try {
        if (!isPatientUser(req.user)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        const response = await getPatientProfile(req.user.id);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getPatientProfileAPI error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const updatePatientProfileAPI = async (req, res) => {
    try {
        if (!isPatientUser(req.user)) {
            return res.status(403).json(FORBIDDEN_RESPONSE);
        }

        const response = await updatePatientProfile(req.user.id, req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("updatePatientProfileAPI error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
    postBookAppointment,
    postVerifyBookAppointment,
    getAllPatient,
    getListBookingForPatient,
    postCancelBookAppointment,
    getPatientProfileAPI,
    updatePatientProfileAPI,
};
