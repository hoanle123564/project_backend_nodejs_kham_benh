const moment = require("moment");
const connection = require("../config/data");
const { getDb } = require("./transactionService");

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
const CLINIC_PATIENT_BOOKING_STATUS_IDS = ["S1", "S2", "S8", "S3"];

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

const getDashboardScope = (clinicId) => {
    if (clinicId === undefined || clinicId === null) {
        return { clinicId: null, scheduleJoin: "", params: [] };
    }

    const normalizedClinicId = Number(clinicId);
    if (!Number.isInteger(normalizedClinicId) || normalizedClinicId <= 0) {
        throw new Error("Invalid clinic scope");
    }

    return {
        clinicId: normalizedClinicId,
        scheduleJoin: "INNER JOIN doctor_info di ON di.doctorId = s.doctorId AND di.clinicId = ?",
        params: [normalizedClinicId],
    };
};

const getOperationalStatus = (bookingStatusId, visitStatusId) => {
    if (["S4", "S5", "S6", "S7"].includes(bookingStatusId)) {
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

const getSchedulePriceAtBooking = async (scheduleId, db) => {
    const executor = getDb(db);
    const [rows] = await executor.query(
        `
        SELECT price
        FROM schedule
        WHERE id = ?
        LIMIT 1
        `,
        [scheduleId]
    );

    const schedulePrice = Number(rows[0]?.price);
    return Number.isInteger(schedulePrice) && schedulePrice > 0 ? schedulePrice : 0;
};

const backfillBookingPrices = async () => {
    await ensurePriceAtBookingColumn();

    const [rows] = await connection.promise().query(
        `
        SELECT
            b.id,
            s.price
        FROM booking b
        LEFT JOIN schedule s
            ON s.id = b.scheduleId
        WHERE b.priceAtBooking IS NULL
           OR b.priceAtBooking = 0
        `
    );

    for (const row of rows) {
        const price = Number(row.price) || 0;
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

const getRevenueStatistics = async (revenueType, clinicId) => {
    const range = getRevenueRange(revenueType);
    const scope = getDashboardScope(clinicId);
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
        INNER JOIN schedule s
            ON s.id = b.scheduleId
        ${scope.scheduleJoin}
        WHERE ev.paymentStatusId = 'PS2'
          AND ev.examDate BETWEEN ? AND ?
        `,
        [...scope.params, range.startDate.format("YYYY-MM-DD"), range.endDate.format("YYYY-MM-DD")]
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

const getTopDoctorStatistics = async (topDoctorType, clinicId) => {
    const range = getTopDoctorRange(topDoctorType);
    const scope = getDashboardScope(clinicId);

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
        ${scope.scheduleJoin}
        JOIN users u
            ON u.id = s.doctorId
        WHERE b.statusId = 'S3'
          AND b.date BETWEEN ? AND ?
        GROUP BY u.id, u.firstName, u.lastName
        ORDER BY examinationCount DESC
        LIMIT 5
        `,
        [...scope.params, range.startDate.format("YYYY-MM-DD"), range.endDate.format("YYYY-MM-DD")]
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

const getTodayOverview = async (clinicId) => {
    const today = moment().format("YYYY-MM-DD");
    const scope = getDashboardScope(clinicId);

    const [rows] = await connection.promise().query(
        `
        SELECT
            b.statusId AS bookingStatusId,
            ev.statusId AS visitStatusId
        FROM booking b
        INNER JOIN schedule s
            ON s.id = b.scheduleId
        ${scope.scheduleJoin}
        LEFT JOIN examination_visit ev
            ON ev.bookingId = b.id
        WHERE b.date = ?
        `,
        [...scope.params, today]
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

const getPaymentOverview = async (clinicId) => {
    const scope = getDashboardScope(clinicId);
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
        INNER JOIN schedule s
            ON s.id = b.scheduleId
        ${scope.scheduleJoin}
        `,
        scope.params
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

const getAppointmentTypeStats = async (clinicId) => {
    const scope = getDashboardScope(clinicId);
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
        ${scope.scheduleJoin}
        GROUP BY COALESCE(s.appointmentTypeId, ?)
        `,
        [APPOINTMENT_TYPE.OFFLINE, ...scope.params, APPOINTMENT_TYPE.OFFLINE]
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

const getRecentBookings = async ({ page, limit, clinicId }) => {
    const offset = (page - 1) * limit;
    const scope = getDashboardScope(clinicId);

    const [countRows, rows] = await Promise.all([
        connection.promise().query(
            `
            SELECT COUNT(*) AS total
            FROM booking b
            INNER JOIN schedule s
                ON s.id = b.scheduleId
            ${scope.scheduleJoin}
            `,
            scope.params
        ).then(([result]) => result),
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
            ${scope.scheduleJoin}
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
            [...scope.params, limit, offset]
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

const getClinicSummary = async (clinicId) => {
    const scope = getDashboardScope(clinicId);
    const statusPlaceholders = CLINIC_PATIENT_BOOKING_STATUS_IDS.map(() => "?").join(", ");
    const [patientRows, doctorRows, departmentRows] = await Promise.all([
        connection.promise().query(
            `
            SELECT COUNT(DISTINCT b.patientId) AS total
            FROM booking b
            INNER JOIN schedule s
                ON s.id = b.scheduleId
            ${scope.scheduleJoin}
            WHERE b.statusId IN (${statusPlaceholders})
            `,
            [...scope.params, ...CLINIC_PATIENT_BOOKING_STATUS_IDS]
        ).then(([rows]) => rows),
        connection.promise().query(
            "SELECT COUNT(*) AS total FROM doctor_info WHERE clinicId = ?",
            [scope.clinicId]
        ).then(([rows]) => rows),
        connection.promise().query(
            "SELECT COUNT(*) AS total FROM clinic_department WHERE clinicId = ? AND isActive = 1",
            [scope.clinicId]
        ).then(([rows]) => rows),
    ]);

    return {
        patients: Number(patientRows[0]?.total) || 0,
        doctors: Number(doctorRows[0]?.total) || 0,
        departments: Number(departmentRows[0]?.total) || 0,
    };
};

const getBookingStatusOverview = async (clinicId) => {
    const scope = getDashboardScope(clinicId);
    const [rows] = await connection.promise().query(
        `
        SELECT b.statusId AS bookingStatusId, ev.statusId AS visitStatusId
        FROM booking b
        INNER JOIN schedule s
            ON s.id = b.scheduleId
        ${scope.scheduleJoin}
        LEFT JOIN examination_visit ev
            ON ev.bookingId = b.id
        `,
        scope.params
    );
    const overview = {
        pendingConfirmation: 0,
        waitingExam: 0,
        inProgress: 0,
        completed: 0,
        cancelled: 0,
    };

    rows.forEach((row) => {
        overview[getOperationalStatus(row.bookingStatusId, row.visitStatusId)] += 1;
    });

    return overview;
};

const getDashboardStatistics = async ({ revenueType, topDoctorType, recentPage, recentLimit, clinicId }) => {

    const page = normalizePositiveInteger(recentPage, 1, Number.MAX_SAFE_INTEGER);
    const limit = normalizePositiveInteger(recentLimit, 5, 5);
    const isClinicScoped = clinicId !== undefined && clinicId !== null;

    const [
        revenue,
        topDoctors,
        doctorRatio,
        todayOverview,
        paymentOverview,
        appointmentTypeStats,
        recentBookings,
        summary,
        bookingStatusOverview,
    ] = await Promise.all([
        getRevenueStatistics(revenueType, clinicId),
        getTopDoctorStatistics(topDoctorType, clinicId),
        isClinicScoped ? Promise.resolve(null) : getDoctorRatioStatistics(),
        getTodayOverview(clinicId),
        getPaymentOverview(clinicId),
        getAppointmentTypeStats(clinicId),
        getRecentBookings({ page, limit, clinicId }),
        isClinicScoped ? getClinicSummary(clinicId) : Promise.resolve(null),
        isClinicScoped ? getBookingStatusOverview(clinicId) : Promise.resolve(null),
    ]);

    return {
        errCode: 0,
        errMessage: "OK",
        data: {
            revenue,
            topDoctors,
            todayOverview,
            paymentOverview,
            appointmentTypeStats,
            recentBookings,
            ...(isClinicScoped
                ? { summary, bookingStatusOverview }
                : { doctorRatio }),
        },
    };
};

module.exports = {
    getOperationalStatus,
    ensurePriceAtBookingColumn,
    getSchedulePriceAtBooking,
    backfillBookingPrices,
    getDashboardStatistics,
};
