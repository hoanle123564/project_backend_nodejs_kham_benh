const connection = require("../../config/data");
const {
  chatDebug,
  chatWarn,
  normalizeText,
  normalizeSpecialtyNames,
  getSpecialtyNameCandidates,
  getAppointmentTypeId,
  isOnlineConsultation,
  splitTimeRange,
  formatDate,
  parseMoney,
  buildDoctorName,
} = require("./chatUtils");

const getSpecialtyMatchInfo = async (aiSpecialties) => {
  const requested = normalizeSpecialtyNames(aiSpecialties);
  const [rows] = await connection.promise().query(
    `
      SELECT id, name
      FROM specialty
      WHERE isActive = 1
    `
  );

  const specialtyByName = new Map(
    rows.map((row) => [normalizeText(row.name), row])
  );
  const matched = [];
  const unmatched = [];

  requested.forEach((specialty) => {
    const candidates = getSpecialtyNameCandidates(specialty);
    const row = candidates
      .map((candidate) => specialtyByName.get(normalizeText(candidate)))
      .find(Boolean);

    if (row) {
      matched.push(row);
    } else {
      unmatched.push(specialty);
      chatWarn(`no specialty matched for ${specialty}`);
    }
  });

  const uniqueMatched = Array.from(
    new Map(matched.map((row) => [row.id, row])).values()
  );

  chatDebug("ai specialties:", requested);
  chatDebug("mapped specialty names:", uniqueMatched.map((row) => row.name));
  chatDebug("matched specialty ids:", uniqueMatched.map((row) => row.id));

  return {
    requested,
    unmatched,
    ids: uniqueMatched.map((row) => row.id),
    names: uniqueMatched.map((row) => row.name),
  };
};

const buildScheduleDateFilter = (collectedInfo = {}, params = []) => {
  if (collectedInfo.preferred_date) {
    params.push(collectedInfo.preferred_date);
    return "s.date = ?";
  }

  return "s.date >= CURDATE()";
};

const getAvailableSlotsForDoctor = async (doctorId, collectedInfo = {}, debugStats = null) => {
  const appointmentTypeId = getAppointmentTypeId(collectedInfo);
  const params = [doctorId];
  const dateFilter = buildScheduleDateFilter(collectedInfo, params);
  params.push(appointmentTypeId);

  const [rows] = await connection.promise().query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
        s.appointmentTypeId,
        lt.value_vi AS timeVi,
        lt.value_en AS timeEn,
        COALESCE(activeBooking.bookedCount, 0) AS bookedCount,
        CASE WHEN COALESCE(activeBooking.bookedCount, 0) > 0 THEN 1 ELSE 0 END AS hasActiveBooking
      FROM schedule s
      LEFT JOIN (
        SELECT scheduleId, COUNT(*) AS bookedCount
        FROM booking
        WHERE statusId <> 'S4'
        GROUP BY scheduleId
      ) AS activeBooking
        ON activeBooking.scheduleId = s.id
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE s.doctorId = ?
        AND ${dateFilter}
        AND s.appointmentTypeId = ?
      ORDER BY s.date ASC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      LIMIT 10
    `,
    params
  );

  const availableRows = rows.filter((row) => {
    return Number(row.hasActiveBooking) !== 1;
  });

  chatDebug("slot filters:", {
    doctorId,
    consultation_type: collectedInfo.consultation_type,
    appointmentTypeId,
    preferred_date: collectedInfo.preferred_date || null,
    schedules_before_capacity: rows.length,
    schedules_after_capacity: availableRows.length,
    capacity: rows.map((row) => ({
      scheduleId: row.id,
      bookedCount: Number(row.bookedCount) || 0,
      hasActiveBooking: Number(row.hasActiveBooking) ? 1 : 0,
    })),
  });

  if (debugStats) {
    debugStats.schedulesBeforeCapacity += rows.length;
    debugStats.schedulesAfterCapacity += availableRows.length;
  }

  return availableRows.map((row, index) => {
    const timeText = row.timeVi || row.timeEn || row.timeType;
    const { start_time, end_time } = splitTimeRange(timeText);
    const bookedCount = Number(row.bookedCount) || 0;
    const hasActiveBooking = Number(row.hasActiveBooking) ? 1 : 0;

    return {
      index: index + 1,
      id: row.id,
      doctor_id: row.doctorId,
      date: formatDate(row.date),
      start_time,
      end_time,
      time: timeText,
      timeType: row.timeType,
      appointmentTypeId: row.appointmentTypeId,
      bookedCount,
      hasActiveBooking,
      remaining: hasActiveBooking ? 0 : 1,
    };
  });
};

const getNearestAvailableSlotForDoctor = async (doctorId, collectedInfo = {}) => {
  if (!collectedInfo.preferred_date) return null;

  const appointmentTypeId = getAppointmentTypeId(collectedInfo);
  const params = [
    doctorId,
    collectedInfo.preferred_date,
    appointmentTypeId,
  ];

  const [rows] = await connection.promise().query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
        s.appointmentTypeId,
        lt.value_vi AS timeVi,
        lt.value_en AS timeEn,
        COALESCE(activeBooking.bookedCount, 0) AS bookedCount,
        CASE WHEN COALESCE(activeBooking.bookedCount, 0) > 0 THEN 1 ELSE 0 END AS hasActiveBooking
      FROM schedule s
      LEFT JOIN (
        SELECT scheduleId, COUNT(*) AS bookedCount
        FROM booking
        WHERE statusId <> 'S4'
        GROUP BY scheduleId
      ) AS activeBooking
        ON activeBooking.scheduleId = s.id
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE s.doctorId = ?
        AND s.date > ?
        AND s.appointmentTypeId = ?
        AND COALESCE(activeBooking.bookedCount, 0) = 0
      ORDER BY s.date ASC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      LIMIT 1
    `,
    params
  );

  if (!rows[0]) return null;

  const timeText = rows[0].timeVi || rows[0].timeEn || rows[0].timeType;
  const { start_time, end_time } = splitTimeRange(timeText);

  return {
    id: rows[0].id,
    doctor_id: rows[0].doctorId,
    date: formatDate(rows[0].date),
    start_time,
    end_time,
    time: timeText,
    timeType: rows[0].timeType,
    appointmentTypeId: rows[0].appointmentTypeId,
    bookedCount: Number(rows[0].bookedCount) || 0,
    hasActiveBooking: Number(rows[0].hasActiveBooking) ? 1 : 0,
    remaining: Number(rows[0].hasActiveBooking) ? 0 : 1,
  };
};

const findDoctorsFromCollectedInfo = async (collectedInfo = {}, debugStats = null) => {
  const specialtyMatch = await getSpecialtyMatchInfo(collectedInfo.specialties);
  if (specialtyMatch.requested.length === 0) {
    if (debugStats) debugStats.reason = "AI_NO_SPECIALTY";
    return [];
  }

  if (specialtyMatch.ids.length === 0) {
    if (debugStats) debugStats.reason = "NO_SPECIALTY_MATCH";
    return [];
  }

  const location = String(collectedInfo.location || "").trim();
  const whereClauses = [
    "u.roleId = 'R2'",
    "di.isActive = 1",
    "sp.isActive = 1",
    "(c.id IS NULL OR c.isActive = 1)",
  ];
  const params = [];

  whereClauses.push(`di.specialtyId IN (${specialtyMatch.ids.map(() => "?").join(", ")})`);
  params.push(...specialtyMatch.ids);

  if (location && !isOnlineConsultation(collectedInfo)) {
    whereClauses.push(
      "(c.provinceCode = ? OR lp.value_vi LIKE ? OR lp.value_en LIKE ? OR c.address LIKE ?)"
    );
    params.push(location, `%${location}%`, `%${location}%`, `%${location}%`);
  }

  if (isOnlineConsultation(collectedInfo)) {
    chatDebug("location filter skipped because consultation_type is online");
  }

  const [rows] = await connection.promise().query(
    `
      SELECT
        u.id,
        u.firstName,
        u.lastName,
        p.value_vi AS positionVi,
        sp.name AS specialty,
        c.provinceCode,
        c.address AS clinicAddress,
        COALESCE(lp.value_vi, c.provinceCode) AS city,
        di.onlinePriceId,
        offlinePrice.value_vi AS offlinePrice,
        onlinePrice.value_vi AS onlinePrice
      FROM users u
      INNER JOIN doctor_info di
        ON di.doctorId = u.id
      INNER JOIN specialty sp
        ON sp.id = di.specialtyId
      LEFT JOIN clinic c
        ON c.id = di.clinicId
      LEFT JOIN lookup lp
        ON lp.keyMap = c.provinceCode AND lp.type = 'PROVINCE'
      LEFT JOIN lookup p
        ON p.keyMap = u.positionId AND p.type = 'POSITION'
      LEFT JOIN lookup offlinePrice
        ON offlinePrice.keyMap = di.priceId AND offlinePrice.type = 'PRICE'
      LEFT JOIN lookup onlinePrice
        ON onlinePrice.keyMap = di.onlinePriceId AND onlinePrice.type = 'PRICE'
      WHERE ${whereClauses.join(" AND ")}
      ORDER BY di.displayOrder ASC, u.createdAt DESC
      LIMIT 20
    `,
    params
  );

  const candidateRows = isOnlineConsultation(collectedInfo)
    ? rows.filter((row) => row.onlinePriceId)
    : rows;

  if (debugStats) {
    debugStats.specialtyMatch = specialtyMatch;
    debugStats.doctorsBeforeOnlineFilter = rows.length;
    debugStats.doctorsBeforeSlotFilter = candidateRows.length;
  }

  if (rows.length === 0) {
    if (debugStats) debugStats.reason = "NO_DOCTOR_FOR_SPECIALTY";
    return [];
  }

  if (candidateRows.length === 0) {
    if (debugStats) debugStats.reason = "NO_ONLINE_DOCTOR";
    return [];
  }

  const doctors = [];
  for (const row of candidateRows) {
    const slots = await getAvailableSlotsForDoctor(row.id, collectedInfo, debugStats);
    if (slots.length === 0 && debugStats) {
      const nearestSlot = await getNearestAvailableSlotForDoctor(row.id, collectedInfo);
      if (
        nearestSlot &&
        (!debugStats.nearestAvailableSlot ||
          nearestSlot.date < debugStats.nearestAvailableSlot.date)
      ) {
        debugStats.nearestAvailableSlot = nearestSlot;
      }
    }
    if (slots.length === 0) continue;
    const online = isOnlineConsultation(collectedInfo);

    doctors.push({
      index: doctors.length + 1,
      id: row.id,
      name: buildDoctorName(row),
      specialty: row.specialty,
      city: row.city || row.provinceCode || row.clinicAddress || "",
      supports_online: Boolean(row.onlinePriceId),
      price: parseMoney(online ? row.onlinePrice : row.offlinePrice),
      available_slots: slots,
    });

    if (doctors.length >= 5) break;
  }

  if (debugStats) {
    debugStats.doctorsAfterSlotFilter = doctors.length;
    if (doctors.length === 0) {
      debugStats.reason = debugStats.schedulesBeforeCapacity > 0
        ? "SCHEDULE_FULL_CAPACITY"
        : "NO_SCHEDULE_FOR_DATE";
    }
  }

  return doctors;
};

module.exports = {
  getSpecialtyMatchInfo,
  buildScheduleDateFilter,
  getAvailableSlotsForDoctor,
  getNearestAvailableSlotForDoctor,
  findDoctorsFromCollectedInfo,
};
