const { getDashboardStatistics } = require("../service/adminDashboardService");

const getAdminDashboardStatistics = async (req, res) => {
    try {
        const response = await getDashboardStatistics({
            revenueType: req.query.revenueType,
            topDoctorType: req.query.topDoctorType,
        });

        return res.status(200).json(response);
    } catch (error) {
        console.log("getAdminDashboardStatistics error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
            data: null,
        });
    }
};

module.exports = {
    getAdminDashboardStatistics,
};
