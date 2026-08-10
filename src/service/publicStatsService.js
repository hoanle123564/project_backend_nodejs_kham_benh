const connection = require("../config/data");
const { REVIEW_STATUS } = require("./workflowStatusService");

const PUBLIC_KEY_STATS_SQL = `
  SELECT
    (
      SELECT COUNT(*)
      FROM users u
      WHERE u.roleId = 'R3'
    ) AS patients,
    (
      SELECT COUNT(DISTINCT di.doctorId)
      FROM doctor_info di
      INNER JOIN users u ON u.id = di.doctorId
      WHERE u.roleId = 'R2' AND di.isActive = ?
    ) AS doctors,
    (
      SELECT COUNT(*)
      FROM clinic c
      WHERE c.isActive = ?
    ) AS clinics,
    COALESCE(
      (
        SELECT ROUND(
          100 * SUM(CASE WHEN dr.rating >= ? THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0)
        )
        FROM doctor_reviews dr
        WHERE dr.statusId = ?
      ),
      0
    ) AS satisfactionRate
`;

const normalizeCount = (value) => {
  const number = Number(value);
  return Number.isFinite(number) && number >= 0 ? Math.round(number) : 0;
};

const getPublicKeyStats = async () => {
  try {
    const [rows] = await connection.promise().query(PUBLIC_KEY_STATS_SQL, [
      1,
      1,
      4,
      REVIEW_STATUS.VISIBLE,
    ]);
    const row = rows?.[0] || {};

    return {
      errCode: 0,
      errMessage: "OK",
      data: {
        patients: normalizeCount(row.patients),
        doctors: normalizeCount(row.doctors),
        clinics: normalizeCount(row.clinics),
        satisfactionRate: Math.min(normalizeCount(row.satisfactionRate), 100),
      },
    };
  } catch (error) {
    console.log("getPublicKeyStats error:", error);
    return {
      errCode: 1,
      errMessage: "Error from server",
      data: null,
    };
  }
};

module.exports = {
  PUBLIC_KEY_STATS_SQL,
  getPublicKeyStats,
  normalizeCount,
};
