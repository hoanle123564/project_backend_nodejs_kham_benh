const connection = require("../../config/data");
const { GetcheScheduleDoctorByDate } = require("../doctor/doctorScheduleService");
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

const mapScheduleRowToChatSlot = (row, index) => {
  const timeText = row.value_vi || row.value_en || row.timeVi || row.timeEn || row.timeType;
  const startEnd = row.startTime && row.endTime
    ? { start_time: row.startTime.slice(0, 5), end_time: row.endTime.slice(0, 5) }
    : splitTimeRange(timeText);

  return {
    index: index + 1,
    id: row.id,
    doctor_id: row.doctorId,
    date: formatDate(row.date),
    start_time: startEnd.start_time,
    end_time: startEnd.end_time,
    time: timeText,
    timeType: row.timeType,
    appointmentTypeId: row.appointmentTypeId,
    bookedCount: Number(row.bookedCount) || 0,
    hasActiveBooking: Number(row.hasActiveBooking) ? 1 : 0,
    remaining: Number(row.remaining) || 0,
    isFull: Number(row.isFull) ? 1 : 0,
  };
};

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
  const dates = collectedInfo.preferred_date
    ? [collectedInfo.preferred_date]
    : Array.from({ length: 30 }, (_, index) =>
        new Date(Date.now() + index * 24 * 60 * 60 * 1000).toISOString().slice(0, 10)
      );
  const availableRows = [];

  for (const date of dates) {
    const response = await GetcheScheduleDoctorByDate(doctorId, date);
    const rows = response?.errCode === 0 ? response.data || [] : [];
    rows
      .filter((row) => row.appointmentTypeId === appointmentTypeId)
      .forEach((row) => availableRows.push(row));
    if (availableRows.length >= 10) break;
  }

  chatDebug("slot filters:", {
    doctorId,
    consultation_type: collectedInfo.consultation_type,
    appointmentTypeId,
    preferred_date: collectedInfo.preferred_date || null,
    schedules_before_capacity: availableRows.length,
    schedules_after_capacity: availableRows.length,
    capacity: availableRows.map((row) => ({
      scheduleId: row.id,
      bookedCount: Number(row.bookedCount) || 0,
      hasActiveBooking: Number(row.hasActiveBooking) ? 1 : 0,
    })),
  });

  if (debugStats) {
    debugStats.schedulesBeforeCapacity += availableRows.length;
    debugStats.schedulesAfterCapacity += availableRows.length;
  }

  return availableRows.slice(0, 10).map(mapScheduleRowToChatSlot);
};

const getNearestAvailableSlotForDoctor = async (doctorId, collectedInfo = {}) => {
  if (!collectedInfo.preferred_date) return null;

  const appointmentTypeId = getAppointmentTypeId(collectedInfo);
  const startDate = new Date(collectedInfo.preferred_date);
  for (let index = 1; index <= 30; index += 1) {
    const date = new Date(startDate.getTime() + index * 24 * 60 * 60 * 1000)
      .toISOString()
      .slice(0, 10);
    const response = await GetcheScheduleDoctorByDate(doctorId, date);
    const row = (response?.data || []).find((item) => item.appointmentTypeId === appointmentTypeId);
    if (row) {
      return mapScheduleRowToChatSlot(row, 0);
    }
  }

  return null;
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
