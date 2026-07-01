const moment = require("moment");
const connection = require("../config/data");

const APPOINTMENT_TYPE = Object.freeze({
  OFFLINE: "AT1",
  ONLINE: "AT2",
});

const VISIT_STATUS = Object.freeze({
  COMPLETED: "VS3",
});

const PAYMENT_STATUS = Object.freeze({
  PAID: "PS2",
});

const VALID_RANGES = new Set(["week", "month", "year"]);

const normalizeRange = (range) => (VALID_RANGES.has(range) ? range : "month");

const getRangeMeta = (rangeValue) => {
  const range = normalizeRange(rangeValue);
  const today = moment().startOf("day");

  if (range === "week") {
    return {
      range,
      startDate: today.clone().subtract(6, "days"),
      endDate: today.clone(),
      unit: "day",
    };
  }

  if (range === "year") {
    return {
      range,
      startDate: today.clone().subtract(364, "days"),
      endDate: today.clone(),
      unit: "month",
    };
  }

  return {
    range,
    startDate: today.clone().subtract(29, "days"),
    endDate: today.clone(),
    unit: "day",
  };
};

const formatBucketKey = (value, unit) =>
  unit === "month" ? moment(value).format("YYYY-MM") : moment(value).format("YYYY-MM-DD");

const formatBucketLabel = (value, unit) =>
  unit === "month" ? moment(value).format("MM/YYYY") : moment(value).format("DD/MM");

const buildEmptyBuckets = (rangeMeta) => {
  const buckets = [];
  const cursor = rangeMeta.startDate.clone().startOf(rangeMeta.unit);
  const endCursor = rangeMeta.endDate.clone().startOf(rangeMeta.unit);

  while (cursor.isSameOrBefore(endCursor, rangeMeta.unit)) {
    buckets.push({
      key: formatBucketKey(cursor, rangeMeta.unit),
      label: formatBucketLabel(cursor, rangeMeta.unit),
      totalVisits: 0,
      newPatients: 0,
      oldPatients: 0,
    });

    cursor.add(1, rangeMeta.unit);
  }

  return buckets;
};

const isWithinRange = (examDate, rangeMeta) => {
  const date = moment(examDate).startOf("day");
  return date.isBetween(rangeMeta.startDate, rangeMeta.endDate, "day", "[]");
};

const getDoctorCompletedVisits = async ({ doctorId, endDate }) => {
  const [rows] = await connection.promise().query(
    `
      SELECT
        ev.id AS examinationVisitId,
        ev.patientId,
        ev.examDate,
        ev.paymentStatusId,
        COALESCE(b.priceAtBooking, 0) AS priceAtBooking,
        COALESCE(s.appointmentTypeId, ?) AS appointmentTypeId
      FROM examination_visit ev
      INNER JOIN booking b
        ON b.id = ev.bookingId
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      WHERE ev.doctorId = ?
        AND ev.statusId = ?
        AND ev.examDate <= ?
      ORDER BY ev.patientId ASC, ev.examDate ASC, ev.id ASC
    `,
    [
      APPOINTMENT_TYPE.OFFLINE,
      doctorId,
      VISIT_STATUS.COMPLETED,
      endDate.format("YYYY-MM-DD"),
    ]
  );

  return rows || [];
};

const buildDashboardData = (visits, rangeMeta) => {
  const buckets = buildEmptyBuckets(rangeMeta);
  const bucketByKey = buckets.reduce((acc, bucket) => {
    acc[bucket.key] = bucket;
    return acc;
  }, {});

  const firstVisitByPatient = new Map();
  const revenueSummary = {
    totalRevenue: 0,
    clinicRevenue: 0,
    onlineRevenue: 0,
  };

  let totalNewPatients = 0;
  let totalOldPatients = 0;

  visits.forEach((visit) => {
    if (!firstVisitByPatient.has(visit.patientId)) {
      firstVisitByPatient.set(visit.patientId, visit.examinationVisitId);
    }

    if (!isWithinRange(visit.examDate, rangeMeta)) {
      return;
    }

    const bucketKey = formatBucketKey(visit.examDate, rangeMeta.unit);
    const bucket = bucketByKey[bucketKey];
    if (!bucket) {
      return;
    }

    const isNewPatient = firstVisitByPatient.get(visit.patientId) === visit.examinationVisitId;

    bucket.totalVisits += 1;
    bucket.newPatients += isNewPatient ? 1 : 0;
    bucket.oldPatients += isNewPatient ? 0 : 1;

    totalNewPatients += isNewPatient ? 1 : 0;
    totalOldPatients += isNewPatient ? 0 : 1;

    if (visit.paymentStatusId === PAYMENT_STATUS.PAID) {
      const price = Number(visit.priceAtBooking) || 0;
      revenueSummary.totalRevenue += price;

      if (visit.appointmentTypeId === APPOINTMENT_TYPE.ONLINE) {
        revenueSummary.onlineRevenue += price;
      } else {
        revenueSummary.clinicRevenue += price;
      }
    }
  });

  return {
    revenueSummary,
    visitTrend: {
      items: buckets,
    },
    patientTypeDonut: {
      newPatients: totalNewPatients,
      oldPatients: totalOldPatients,
      total: totalNewPatients + totalOldPatients,
    },
    patientLineChart: {
      items: buckets.map((bucket) => ({ ...bucket })),
    },
    rangeMeta: {
      range: rangeMeta.range,
      startDate: rangeMeta.startDate.format("YYYY-MM-DD"),
      endDate: rangeMeta.endDate.format("YYYY-MM-DD"),
      unit: rangeMeta.unit,
    },
  };
};

const getDoctorDashboardStatistics = async ({ doctorId, range }) => {
  const rangeMeta = getRangeMeta(range);
  const visits = await getDoctorCompletedVisits({
    doctorId,
    endDate: rangeMeta.endDate,
  });

  return {
    errCode: 0,
    errMessage: "OK",
    data: buildDashboardData(visits, rangeMeta),
  };
};

module.exports = {
  getDoctorDashboardStatistics,
};
