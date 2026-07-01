const { FORBIDDEN_RESPONSE } = require("../service/clinicAccessService");
const {
  getDoctorDashboardStatistics,
} = require("../service/doctorDashboardService");

const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const getDoctorDashboardStatisticsApi = async (req, res) => {
  try {
    if (req.user?.roleId !== "R2") {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const doctorId = normalizePositiveId(req.user?.id);
    if (!doctorId) {
      return res.status(403).json(FORBIDDEN_RESPONSE);
    }

    const response = await getDoctorDashboardStatistics({
      doctorId,
      range: req.query?.range,
    });

    return res.status(200).json(response);
  } catch (error) {
    console.error("getDoctorDashboardStatisticsApi error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
    });
  }
};

module.exports = {
  getDoctorDashboardStatisticsApi,
};
