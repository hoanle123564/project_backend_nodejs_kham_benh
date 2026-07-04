const moment = require("moment");
const connection = require("../config/data");

const parsePriceToNumber = (priceText) => {
    if (!priceText) return 0;
    const rawNumber = String(priceText).replace(/[^\d]/g, "");
    return Number(rawNumber) || 0;
};

const APPOINTMENT_TYPE = Object.freeze({
    OFFLINE: "AT1",
    ONLINE: "AT2",
});

const OPERATION_STATUS = Object.freeze({
    PENDING_CONFIRMATION: "pendingConfirmation",
    WAITING_EXAM: "waitingExam",
    IN_PROGRESS: "inProgress",
    COMPLETED: "completed",
    CANCELLED: "cancelled",
});

const ensurePriceAtBookingColumn = async () => {
    const [columns] = await connection.promise().query("SHOW COLUMNS FROM booking LIKE 'priceAtBooking'");

    if (columns.length === 0) {
        await connection.promise().query("ALTER TABLE booking ADD COLUMN priceAtBooking INT DEFAULT 0 AFTER token");
    }
};

const normalizePositiveInteger = (value, defaultValue, maxValue) => {
    const parsedValue = Number.parseInt(value, 10);

    if (!Number.isInteger(parsedValue) || parsedValue <= 0) {
        return defaultValue;
    }

    return Math.min(parsedValue, maxValue);
};

const getOperationalStatus = (bookingStatusId, visitStatusId) => {
    if (bookingStatusId === "S4") {
        return OPERATION_STATUS.CANCELLED;
    }

    if (bookingStatusId === "S1") {
        return OPERATION_STATUS.PENDING_CONFIRMATION;
    }

    if (visitStatusId === "VS2") {
        return OPERATION_STATUS.IN_PROGRESS;
    }

    if (visitStatusId === "VS3" || bookingStatusId === "S3") {
        return OPERATION_STATUS.COMPLETED;
    }

    return OPERATION_STATUS.WAITING_EXAM;
};

const getDoctorPriceAtBooking = async (doctorId, appointmentTypeId = APPOINTMENT_TYPE.OFFLINE) => {
    const [rows] = await connection.promise().query(
        `
        SELECT
            offlinePrice.value_vi AS offlinePriceVi,
            onlinePrice.value_vi AS onlinePriceVi
        FROM doctor_info di
        LEFT JOIN lookup offlinePrice
            ON offlinePrice.keyMap = di.priceId
           AND offlinePrice.type = 'PRICE'
        LEFT JOIN lookup onlinePrice
            ON onlinePrice.keyMap = di.onlinePriceId
           AND onlinePrice.type = 'PRICE'
        WHERE di.doctorId = ?
        LIMIT 1
        `,
        [doctorId]
    );

    const priceRow = rows[0] || {};
    const priceText =
        appointmentTypeId === APPOINTMENT_TYPE.ONLINE
            ? priceRow.onlinePriceVi
            : priceRow.offlinePriceVi;

    return parsePriceToNumber(priceText);
};

const getSchedulePriceAtBooking = async (
    scheduleId,
    doctorId,
    appointmentTypeId = APPOINTMENT_TYPE.OFFLINE
) => {
    const [rows] = await connection.promise().query(
        `
        SELECT price
        FROM schedule
        WHERE id = ?
        LIMIT 1
        `,
        [scheduleId]
    );

    const schedulePrice = rows[0]?.price;
    if (schedulePrice !== null && schedulePrice !== undefined && schedulePrice !== "") {
        return Number(schedulePrice) || 0;
    }

    return getDoctorPriceAtBooking(doctorId, appointmentTypeId);
};

const backfillBookingPrices = async () => {
    await ensurePriceAtBookingColumn();

    const [rows] = await connection.promise().query(
        `
        SELECT
            b.id,
            COALESCE(
                s.price,
                CASE
                    WHEN s.appointmentTypeId = ?
                    THEN onlinePrice.value_vi
                    ELSE offlinePrice.value_vi
                END
            ) AS priceVi
        FROM booking b
        LEFT JOIN schedule s
            ON s.id = b.scheduleId
        LEFT JOIN doctor_info di
            ON di.doctorId = s.doctorId
        LEFT JOIN lookup offlinePrice
            ON offlinePrice.keyMap = di.priceId
           AND offlinePrice.type = 'PRICE'
        LEFT JOIN lookup onlinePrice
            ON onlinePrice.keyMap = di.onlinePriceId
           AND onlinePrice.type = 'PRICE'
        WHERE b.priceAtBooking IS NULL
           OR b.priceAtBooking = 0
        `,
        [APPOINTMENT_TYPE.ONLINE]
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
        SELECT ev.examDate AS date, COALESCE(b.priceAtBooking, 0) AS priceAtBooking
        FROM examination_visit ev
        INNER JOIN booking b
            ON b.id = ev.bookingId
        WHERE ev.paymentStatusId = 'PS2'
          AND ev.examDate BETWEEN ? AND ?
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

const getTodayOverview = async () => {
    const today = moment().format("YYYY-MM-DD");

    const [rows] = await connection.promise().query(
        `
        SELECT
            b.statusId AS bookingStatusId,
            ev.statusId AS visitStatusId
        FROM booking b
        LEFT JOIN examination_visit ev
            ON ev.bookingId = b.id
        WHERE b.date = ?
        `,
        [today]
    );

    const overview = {
        date: today,
        total: rows.length,
        pendingConfirmation: 0,
        waitingExam: 0,
        inProgress: 0,
        completed: 0,
        cancelled: 0,
    };

    rows.forEach((row) => {
        const statusKey = getOperationalStatus(row.bookingStatusId, row.visitStatusId);
        overview[statusKey] += 1;
    });

    return overview;
};

const getPaymentOverview = async () => {
    const [rows] = await connection.promise().query(
        `
        SELECT
            COUNT(ev.id) AS totalCount,
            SUM(COALESCE(b.priceAtBooking, 0)) AS totalAmount,
            SUM(CASE WHEN ev.paymentStatusId = 'PS2' THEN 1 ELSE 0 END) AS paidCount,
            SUM(CASE WHEN ev.paymentStatusId = 'PS2' THEN COALESCE(b.priceAtBooking, 0) ELSE 0 END) AS paidAmount,
            SUM(CASE WHEN COALESCE(ev.paymentStatusId, 'PS1') <> 'PS2' THEN 1 ELSE 0 END) AS unpaidCount,
            SUM(CASE WHEN COALESCE(ev.paymentStatusId, 'PS1') <> 'PS2' THEN COALESCE(b.priceAtBooking, 0) ELSE 0 END) AS unpaidAmount
        FROM examination_visit ev
        INNER JOIN booking b
            ON b.id = ev.bookingId
        `
    );

    const result = rows[0] || {};

    return {
        totalCount: Number(result.totalCount) || 0,
        totalAmount: Number(result.totalAmount) || 0,
        paid: {
            count: Number(result.paidCount) || 0,
            amount: Number(result.paidAmount) || 0,
        },
        unpaid: {
            count: Number(result.unpaidCount) || 0,
            amount: Number(result.unpaidAmount) || 0,
        },
    };
};

const getAppointmentTypeStats = async () => {
    const defaultStats = {
        [APPOINTMENT_TYPE.OFFLINE]: {
            appointmentTypeId: APPOINTMENT_TYPE.OFFLINE,
            count: 0,
            revenue: 0,
        },
        [APPOINTMENT_TYPE.ONLINE]: {
            appointmentTypeId: APPOINTMENT_TYPE.ONLINE,
            count: 0,
            revenue: 0,
        },
    };

    const [rows] = await connection.promise().query(
        `
        SELECT
            COALESCE(s.appointmentTypeId, ?) AS appointmentTypeId,
            COUNT(b.id) AS count,
            SUM(COALESCE(b.priceAtBooking, 0)) AS revenue
        FROM booking b
        INNER JOIN schedule s
            ON s.id = b.scheduleId
        GROUP BY COALESCE(s.appointmentTypeId, ?)
        `,
        [APPOINTMENT_TYPE.OFFLINE, APPOINTMENT_TYPE.OFFLINE]
    );

    rows.forEach((row) => {
        const appointmentTypeId = row.appointmentTypeId || APPOINTMENT_TYPE.OFFLINE;
        defaultStats[appointmentTypeId] = {
            appointmentTypeId,
            count: Number(row.count) || 0,
            revenue: Number(row.revenue) || 0,
        };
    });

    return {
        total: Object.values(defaultStats).reduce((sum, item) => sum + item.count, 0),
        items: [
            defaultStats[APPOINTMENT_TYPE.OFFLINE],
            defaultStats[APPOINTMENT_TYPE.ONLINE],
        ],
    };
};

const getRecentBookings = async ({ page, limit }) => {
    const offset = (page - 1) * limit;

    const [countRows, rows] = await Promise.all([
        connection.promise().query("SELECT COUNT(*) AS total FROM booking").then(([result]) => result),
        connection.promise().query(
            `
            SELECT
                b.id AS bookingId,
                b.createdAt,
                b.date AS appointmentDate,
                b.statusId AS bookingStatusId,
                COALESCE(b.priceAtBooking, 0) AS priceAtBooking,
                s.appointmentTypeId,
                lat.value_vi AS appointmentTypeVi,
                lat.value_en AS appointmentTypeEn,
                ev.statusId AS visitStatusId,
                patient.id AS patientId,
                patient.firstName AS patientFirstName,
                patient.lastName AS patientLastName,
                doctor.id AS doctorId,
                doctor.firstName AS doctorFirstName,
                doctor.lastName AS doctorLastName
            FROM booking b
            INNER JOIN schedule s
                ON s.id = b.scheduleId
            INNER JOIN users patient
                ON patient.id = b.patientId
            INNER JOIN users doctor
                ON doctor.id = s.doctorId
            LEFT JOIN examination_visit ev
                ON ev.bookingId = b.id
            LEFT JOIN lookup lat
                ON lat.keyMap = s.appointmentTypeId
               AND lat.type = 'APPOINTMENT_TYPE'
            ORDER BY b.createdAt DESC, b.id DESC
            LIMIT ? OFFSET ?
            `,
            [limit, offset]
        ).then(([result]) => result),
    ]);

    const countRow = countRows[0] || {};
    const total = Number(countRow?.total) || 0;
    const totalPages = Math.max(1, Math.ceil(total / limit));

    return {
        items: rows.map((row) => ({
            bookingId: row.bookingId,
            createdAt: row.createdAt,
            appointmentDate: row.appointmentDate,
            priceAtBooking: Number(row.priceAtBooking) || 0,
            appointmentTypeId: row.appointmentTypeId || APPOINTMENT_TYPE.OFFLINE,
            appointmentTypeVi: row.appointmentTypeVi,
            appointmentTypeEn: row.appointmentTypeEn,
            bookingStatusId: row.bookingStatusId,
            visitStatusId: row.visitStatusId,
            statusKey: getOperationalStatus(row.bookingStatusId, row.visitStatusId),
            patientId: row.patientId,
            patientName: `${row.patientFirstName || ""} ${row.patientLastName || ""}`.trim() || "Unknown patient",
            doctorId: row.doctorId,
            doctorName: `${row.doctorFirstName || ""} ${row.doctorLastName || ""}`.trim() || "Unknown doctor",
        })),
        pagination: {
            page,
            limit,
            total,
            totalPages,
        },
    };
};

const getDashboardStatistics = async ({ revenueType, topDoctorType, recentPage, recentLimit }) => {
    await backfillBookingPrices();

    const page = normalizePositiveInteger(recentPage, 1, Number.MAX_SAFE_INTEGER);
    const limit = normalizePositiveInteger(recentLimit, 5, 5);

    const [
        revenue,
        topDoctors,
        doctorRatio,
        todayOverview,
        paymentOverview,
        appointmentTypeStats,
        recentBookings,
    ] = await Promise.all([
        getRevenueStatistics(revenueType),
        getTopDoctorStatistics(topDoctorType),
        getDoctorRatioStatistics(),
        getTodayOverview(),
        getPaymentOverview(),
        getAppointmentTypeStats(),
        getRecentBookings({ page, limit }),
    ]);

    return {
        errCode: 0,
        errMessage: "OK",
        data: {
            revenue,
            topDoctors,
            doctorRatio,
            todayOverview,
            paymentOverview,
            appointmentTypeStats,
            recentBookings,
        },
    };
};

module.exports = {
    getOperationalStatus,
    parsePriceToNumber,
    ensurePriceAtBookingColumn,
    getDoctorPriceAtBooking,
    getSchedulePriceAtBooking,
    backfillBookingPrices,
    getDashboardStatistics,
};
