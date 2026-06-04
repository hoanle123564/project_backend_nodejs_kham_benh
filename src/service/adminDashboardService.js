const moment = require("moment");
const connection = require("../config/data");

const parsePriceToNumber = (priceText) => {
    if (!priceText) return 0;
    const rawNumber = String(priceText).replace(/[^\d]/g, "");
    return Number(rawNumber) || 0;
};

const ensurePriceAtBookingColumn = async () => {
    const [columns] = await connection.promise().query("SHOW COLUMNS FROM booking LIKE 'priceAtBooking'");

    if (columns.length === 0) {
        await connection.promise().query("ALTER TABLE booking ADD COLUMN priceAtBooking INT DEFAULT 0 AFTER token");
    }
};

const getDoctorPriceAtBooking = async (doctorId) => {
    const [rows] = await connection.promise().query(
        `
        SELECT l.value_vi AS priceVi
        FROM doctor_info di
        LEFT JOIN lookup l
            ON l.keyMap = di.priceId
           AND l.type = 'PRICE'
        WHERE di.doctorId = ?
        LIMIT 1
        `,
        [doctorId]
    );

    return parsePriceToNumber(rows[0]?.priceVi);
};

const backfillBookingPrices = async () => {
    await ensurePriceAtBookingColumn();

    const [rows] = await connection.promise().query(
        `
        SELECT b.id, l.value_vi AS priceVi
        FROM booking b
        LEFT JOIN schedule s
            ON s.id = b.scheduleId
        LEFT JOIN doctor_info di
            ON di.doctorId = s.doctorId
        LEFT JOIN lookup l
            ON l.keyMap = di.priceId
           AND l.type = 'PRICE'
        WHERE b.priceAtBooking IS NULL
           OR b.priceAtBooking = 0
        `
    );

    for (const row of rows) {
        const price = parsePriceToNumber(row.priceVi);
        await connection
            .promise()
            .query("UPDATE booking SET priceAtBooking = ? WHERE id = ?", [price, row.id]);
    }
};

const getRevenueRange = (type) => {
    const today = moment().startOf("day");
    const revenueType = ["week", "month", "year"].includes(type) ? type : "month";

    if (revenueType === "week") {
        return {
            type: revenueType,
            startDate: today.clone().subtract(6, "days"),
            endDate: today.clone(),
            unit: "day",
        };
    }

    if (revenueType === "year") {
        return {
            type: revenueType,
            startDate: today.clone().startOf("year"),
            endDate: today.clone().endOf("year"),
            unit: "month",
        };
    }

    return {
        type: revenueType,
        startDate: today.clone().startOf("month"),
        endDate: today.clone().endOf("month"),
        unit: "day",
    };
};

const getTopDoctorRange = (type) => {
    const today = moment().startOf("day");
    const topDoctorType = ["month", "quarter", "year"].includes(type) ? type : "month";

    if (topDoctorType === "quarter") {
        return {
            type: topDoctorType,
            startDate: today.clone().startOf("quarter"),
            endDate: today.clone().endOf("quarter"),
        };
    }

    if (topDoctorType === "year") {
        return {
            type: topDoctorType,
            startDate: today.clone().startOf("year"),
            endDate: today.clone().endOf("year"),
        };
    }

    return {
        type: topDoctorType,
        startDate: today.clone().startOf("month"),
        endDate: today.clone().endOf("month"),
    };
};

const buildEmptyRevenueData = (range) => {
    const items = [];
    const cursor = range.startDate.clone();

    while (cursor.isSameOrBefore(range.endDate, range.unit)) {
        const key = range.unit === "month" ? cursor.format("YYYY-MM") : cursor.format("YYYY-MM-DD");
        const label = range.unit === "month" ? cursor.format("MM/YYYY") : cursor.format("DD/MM");

        items.push({
            key,
            label,
            revenue: 0,
        });

        cursor.add(1, range.unit);
    }

    return items;
};

const getRevenueStatistics = async (revenueType) => {
    const range = getRevenueRange(revenueType);
    const chartData = buildEmptyRevenueData(range);
    const chartDataByKey = chartData.reduce((acc, item) => {
        acc[item.key] = item;
        return acc;
    }, {});

    const [rows] = await connection.promise().query(
        `
        SELECT b.date, COALESCE(b.priceAtBooking, 0) AS priceAtBooking
        FROM booking b
        WHERE b.statusId = 'S3'
          AND b.date BETWEEN ? AND ?
        `,
        [range.startDate.format("YYYY-MM-DD"), range.endDate.format("YYYY-MM-DD")]
    );

    rows.forEach((row) => {
        const dateKey = range.unit === "month"
            ? moment(row.date).format("YYYY-MM")
            : moment(row.date).format("YYYY-MM-DD");

        if (chartDataByKey[dateKey]) {
            chartDataByKey[dateKey].revenue += Number(row.priceAtBooking) || 0;
        }
    });

    return {
        type: range.type,
        total: chartData.reduce((sum, item) => sum + item.revenue, 0),
        chartData,
    };
};

const getTopDoctorStatistics = async (topDoctorType) => {
    const range = getTopDoctorRange(topDoctorType);

    const [rows] = await connection.promise().query(
        `
        SELECT
            u.id AS doctorId,
            u.firstName,
            u.lastName,
            COUNT(b.id) AS examinationCount
        FROM booking b
        JOIN schedule s
            ON s.id = b.scheduleId
        JOIN users u
            ON u.id = s.doctorId
        WHERE b.statusId = 'S3'
          AND b.date BETWEEN ? AND ?
        GROUP BY u.id, u.firstName, u.lastName
        ORDER BY examinationCount DESC
        LIMIT 5
        `,
        [range.startDate.format("YYYY-MM-DD"), range.endDate.format("YYYY-MM-DD")]
    );

    return rows.map((row) => ({
        doctorId: row.doctorId,
        doctorName: `${row.firstName || ""} ${row.lastName || ""}`.trim() || "Unknown doctor",
        examinationCount: Number(row.examinationCount) || 0,
    }));
};

const getDoctorRatioStatistics = async () => {
    const sevenDaysAgo = moment().subtract(7, "days").format("YYYY-MM-DD HH:mm:ss");

    const [rows] = await connection.promise().query(
        `
        SELECT
            SUM(CASE WHEN createdAt >= ? THEN 1 ELSE 0 END) AS newDoctors,
            SUM(CASE WHEN createdAt < ? THEN 1 ELSE 0 END) AS oldDoctors,
            COUNT(*) AS totalDoctors
        FROM users
        WHERE roleId = 'R2'
        `,
        [sevenDaysAgo, sevenDaysAgo]
    );

    const result = rows[0] || {};

    return {
        newDoctors: Number(result.newDoctors) || 0,
        oldDoctors: Number(result.oldDoctors) || 0,
        totalDoctors: Number(result.totalDoctors) || 0,
    };
};

const getDashboardStatistics = async ({ revenueType, topDoctorType }) => {
    await backfillBookingPrices();

    const [revenue, topDoctors, doctorRatio] = await Promise.all([
        getRevenueStatistics(revenueType),
        getTopDoctorStatistics(topDoctorType),
        getDoctorRatioStatistics(),
    ]);

    return {
        errCode: 0,
        errMessage: "OK",
        data: {
            revenue,
            topDoctors,
            doctorRatio,
        },
    };
};

module.exports = {
    parsePriceToNumber,
    ensurePriceAtBookingColumn,
    getDoctorPriceAtBooking,
    backfillBookingPrices,
    getDashboardStatistics,
};
