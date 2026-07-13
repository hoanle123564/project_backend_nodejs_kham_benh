const { ListBooking } = require("../service/DoctorService");
const {
  TERMINAL_BOOKING_STATUS_IDS,
  getAllowedStatusIds,
  updateBookingStatus,
} = require("../service/bookingStatusService");
const { FORBIDDEN_RESPONSE } = require("../service/clinicAccessService");

const listBookings = async (req, res, roleId) => {
  if (req.user?.roleId !== roleId) return res.status(403).json(FORBIDDEN_RESPONSE);

  const response = await ListBooking(req.user);
  if (response.errCode !== 0) return res.status(200).json(response);

  return res.status(200).json({
    ...response,
    data: response.data.map((booking) => ({
      ...booking,
      allowedStatusIds:
        roleId === "R1"
          ? (TERMINAL_BOOKING_STATUS_IDS.includes(booking.statusId) ? [] : null)
          : getAllowedStatusIds(booking.statusId, roleId),
    })),
  });
};

const getAdminBookings = (req, res) => listBookings(req, res, "R1");
const getDoctorBookings = (req, res) => listBookings(req, res, "R2");

const patchBookingStatus = async (req, res, roleId) => {
  if (req.user?.roleId !== roleId) return res.status(403).json(FORBIDDEN_RESPONSE);

  const response = await updateBookingStatus({
    bookingId: req.params.bookingId,
    statusId: req.body?.statusId,
    note: req.body?.note,
    actor: req.user,
  });
  return res.status(response.errCode === 403 ? 403 : 200).json(response);
};

const patchAdminBookingStatus = (req, res) => patchBookingStatus(req, res, "R1");
const patchDoctorBookingStatus = (req, res) => patchBookingStatus(req, res, "R2");

module.exports = {
  getAdminBookings,
  getDoctorBookings,
  patchAdminBookingStatus,
  patchDoctorBookingStatus,
};
