const doctorProfileService = require("./doctor/doctorProfileService");
const doctorScheduleService = require("./doctor/doctorScheduleService");
const doctorBookingService = require("./doctor/doctorBookingService");

module.exports = {
  getTopDoctorHome: doctorProfileService.getTopDoctorHome,
  getDetailDoctorById: doctorProfileService.getDetailDoctorById,
  getAllDoctorHome: doctorProfileService.getAllDoctorHome,
  saveDetailInfoDoctor: doctorProfileService.saveDetailInfoDoctor,
  PostScheduleDoctor: doctorScheduleService.PostScheduleDoctor,
  GetcheScheduleDoctorByDate: doctorScheduleService.GetcheScheduleDoctorByDate,
  updateScheduleDoctor: doctorScheduleService.updateScheduleDoctor,
  GetListPatientForDoctor: doctorBookingService.GetListPatientForDoctor,
  sendRemedy: doctorBookingService.sendRemedy,
  deleteScheduleDoctor: doctorScheduleService.deleteScheduleDoctor,
  GetListAppointment: doctorBookingService.GetListAppointment,
  ListBooking: doctorBookingService.ListBooking,
  getRelatedDoctorsById: doctorProfileService.getRelatedDoctorsById,
  updateDoctorInfoOrder: doctorProfileService.updateDoctorInfoOrder,
  changeStatusDoctorInfo: doctorProfileService.changeStatusDoctorInfo,
};
