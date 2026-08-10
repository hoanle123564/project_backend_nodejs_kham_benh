const { getPublicKeyStats: fetchPublicKeyStats } = require("../service/publicStatsService");

const getPublicKeyStats = async (req, res) => {
  try {
    const response = await fetchPublicKeyStats();
    return res.status(200).json(response);
  } catch (error) {
    console.log("getPublicKeyStats error", error);
    return res.status(400).json({
      errCode: -1,
      errMessage: "Error from server",
      data: null,
    });
  }
};

module.exports = {
  getPublicKeyStats,
};
