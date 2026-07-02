const moment = require("moment");
const { v4: uuidv4 } = require("uuid");
const connection = require("../config/data");
const { analyzeMessage } = require("./fastApiAiService");
const { bookAppointment } = require("./PatientService");

const STATES = Object.freeze({
  START: "START",
  ASK_LOCATION: "ASK_LOCATION",
  ASK_CONSULTATION_TYPE: "ASK_CONSULTATION_TYPE",
  WAIT_SELECT_DOCTOR: "WAIT_SELECT_DOCTOR",
  WAIT_SELECT_SLOT: "WAIT_SELECT_SLOT",
  ASK_PATIENT_NAME: "ASK_PATIENT_NAME",
  ASK_PATIENT_PHONE: "ASK_PATIENT_PHONE",
  ASK_PATIENT_EMAIL: "ASK_PATIENT_EMAIL",
  CONFIRM_BOOKING: "CONFIRM_BOOKING",
  BOOKING_CREATED: "BOOKING_CREATED",
  CANCELLED: "CANCELLED",
  ERROR: "ERROR",
});

const ACTIONABLE_INTENTS = new Set(["FIND_DOCTOR", "BOOK_APPOINTMENT"]);
const APPOINTMENT_TYPE = Object.freeze({ OFFLINE: "AT1", ONLINE: "AT2" });
const ACTIVE_BOOKING_STATUSES = ["S1", "S2", "S3"];

const SPECIALTY_CODE_TO_NAMES = Object.freeze({
  CO_XUONG_KHOP: ["Cơ xương khớp", "Co xuong khop", "Cơ Xương Khớp"],
  TAI_MUI_HONG: ["Tai mũi họng", "Tai Mũi Họng", "Tai mui hong"],
  HO_HAP: ["Hô hấp", "Hô Hấp", "Ho hap"],
  NOI_TONG_QUAT: ["Nội tổng quát", "Nội Tổng Quát", "Noi tong quat"],
  DA_LIEU: ["Da liễu", "Da Liễu", "Da lieu"],
  TIEU_HOA: ["Tiêu hóa", "Tiêu Hoá", "Tieu hoa"],
  TIM_MACH: ["Tim mach"],
  THAN_KINH: ["Than kinh"],
  SAN_PHU_KHOA: ["San phu khoa"],
  NHI_KHOA: ["Nhi khoa"],
  RANG_HAM_MAT: ["Răng hàm mặt", "Răng Hàm Mặt", "Rang ham mat"],
  MAT: ["Mat"],
  TAM_LY_TAM_THAN: ["Tam ly tam than"],
  TIET_NIEU: ["Tiet nieu"],
});

const chatDebug = (...args) => console.log("[chat-debug]", ...args);
const chatWarn = (...args) => console.warn("[chat-debug]", ...args);

const defaultCollectedInfo = () => ({
  intent: null,
  intent_score: null,
  symptoms: [],
  duration: null,
  consultation_type: null,
  location: null,
  specialties: [],
  preferred_date: null,
  debugReason: null,
  reason: null,
  doctors: [],
  slots: [],
  selectedDoctor: null,
  selectedSlot: null,
  patientName: null,
  patientPhone: null,
  patientEmail: null,
  booking: null,
});

const parseJson = (value, fallback) => {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (error) {
    return fallback;
  }
};

const normalizeText = (value) =>
  String(value || "")
    .trim()
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\u0111/g, "d")
    .replace(/đ/g, "d");

const ensureArray = (value) => {
  if (!value) return [];
  if (Array.isArray(value)) return value.filter(Boolean);
  return [value].filter(Boolean);
};

const normalizeConsultationType = (message) => {
  const text = normalizeText(message);

  if (
    text.includes("online") ||
    text.includes("truc tuyen") ||
    text.includes("tu van online")
  ) {
    return "online";
  }

  if (
    text.includes("offline") ||
    text.includes("truc tiep") ||
    text.includes("phong kham") ||
    text.includes("benh vien") ||
    text.includes("tai phong kham")
  ) {
    return "offline";
  }

  return null;
};

const normalizeSpecialtyNames = (specialties) =>
  ensureArray(specialties)
    .map((specialty) => {
      const raw = String(specialty || "").trim();
      return raw;
    })
    .filter(Boolean);

const getSpecialtyNameCandidates = (specialty) => {
  const raw = String(specialty || "").trim();
  const code = raw.toUpperCase();
  return [
    ...(SPECIALTY_CODE_TO_NAMES[code] || []),
    raw,
    raw.replace(/_/g, " "),
  ].filter(Boolean);
};

const getVietnamDate = (offsetDays = 0) => {
  const date = new Date(Date.now() + offsetDays * 24 * 60 * 60 * 1000);
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Ho_Chi_Minh",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  })
    .formatToParts(date)
    .reduce((acc, part) => ({ ...acc, [part.type]: part.value }), {});

  return `${parts.year}-${parts.month}-${parts.day}`;
};

const parsePreferredDate = (message) => {
  const text = normalizeText(message);
  if (text.includes("hom nay")) return getVietnamDate(0);
  if (text.includes("ngay mai") || /\bmai\b/.test(text)) return getVietnamDate(1);
  return null;
};

const isOnlineConsultation = (collectedInfo = {}) =>
  normalizeConsultationType(collectedInfo.consultation_type) === "online";

const getAppointmentTypeId = (collectedInfo = {}) =>
  isOnlineConsultation(collectedInfo)
    ? APPOINTMENT_TYPE.ONLINE
    : APPOINTMENT_TYPE.OFFLINE;

const formatDate = (value) => moment(value).format("YYYY-MM-DD");

const splitTimeRange = (value) => {
  const text = String(value || "").trim();
  const parts = text.split("-").map((part) => part.trim());
  return {
    start_time: parts[0] || text,
    end_time: parts[1] || "",
  };
};

const parseMoney = (value) => {
  const digits = String(value || "").replace(/[^\d]/g, "");
  return digits ? Number(digits) : 0;
};

const buildDoctorName = (doctor) => {
  const fullName = `${doctor.firstName || ""} ${doctor.lastName || ""}`.trim();
  const position = String(doctor.positionVi || "").trim();
  return `${position ? `${position} ` : ""}${fullName}`.trim() || "Bác sĩ";
};

const rowToSession = (row) => {
  const collectedInfo = {
    ...defaultCollectedInfo(),
    ...parseJson(row.collectedInfo, {}),
  };

  return {
    id: row.id,
    sessionId: row.sessionId,
    patientId: row.patientId || null,
    state: row.state || STATES.START,
    collectedInfo,
    selectedDoctorId: row.selectedDoctorId || null,
    selectedScheduleId: row.selectedScheduleId || null,
    bookingId: row.bookingId || null,
    lastAiResult: parseJson(row.lastAiResult, null),
    expiresAt: row.expiresAt || null,
  };
};

const createSessionObject = (sessionId, patientId) => ({
  sessionId: sessionId || uuidv4(),
  patientId: patientId || null,
  state: STATES.START,
  collectedInfo: defaultCollectedInfo(),
  selectedDoctorId: null,
  selectedScheduleId: null,
  bookingId: null,
  lastAiResult: null,
  expiresAt: null,
});

const getOrCreateSession = async (sessionId, patientId) => {
  const normalizedSessionId = String(sessionId || "").trim() || uuidv4();
  const [rows] = await connection.promise().query(
    `
      SELECT *
      FROM chat_sessions
      WHERE sessionId = ?
      LIMIT 1
    `,
    [normalizedSessionId]
  );

  if (rows.length > 0) {
    const session = rowToSession(rows[0]);
    if (patientId && !session.patientId) {
      session.patientId = patientId;
    }
    return session;
  }

  const session = createSessionObject(normalizedSessionId, patientId);
  await connection.promise().query(
    `
      INSERT INTO chat_sessions
        (sessionId, patientId, state, collectedInfo)
      VALUES (?, ?, ?, ?)
    `,
    [
      session.sessionId,
      session.patientId,
      session.state,
      JSON.stringify(session.collectedInfo),
    ]
  );

  return session;
};

const saveSession = async (session) => {
  await connection.promise().query(
    `
      UPDATE chat_sessions
      SET patientId = ?,
          state = ?,
          collectedInfo = ?,
          selectedDoctorId = ?,
          selectedScheduleId = ?,
          bookingId = ?,
          lastAiResult = ?,
          expiresAt = ?
      WHERE sessionId = ?
    `,
    [
      session.patientId || null,
      session.state,
      JSON.stringify(session.collectedInfo || defaultCollectedInfo()),
      session.selectedDoctorId || null,
      session.selectedScheduleId || null,
      session.bookingId || null,
      session.lastAiResult ? JSON.stringify(session.lastAiResult) : null,
      session.expiresAt || null,
      session.sessionId,
    ]
  );
};

const resetSession = async (sessionId) => {
  const session = await getOrCreateSession(sessionId);
  session.state = STATES.START;
  session.collectedInfo = defaultCollectedInfo();
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;
  session.bookingId = null;
  session.lastAiResult = null;
  await saveSession(session);
  return session;
};

const responseForSession = (session, reply, success = true, extraData = {}) => {
  const info = session.collectedInfo || defaultCollectedInfo();

  return {
    success,
    session_id: session.sessionId,
    state: session.state,
    reply,
    data: {
      collected_info: info,
      doctors: info.doctors || [],
      slots: info.slots || [],
      booking: info.booking || (session.bookingId ? { id: session.bookingId } : null),
      ...extraData,
    },
  };
};

const getPatientInfo = async (patientId) => {
  if (!patientId) return null;

  const [rows] = await connection.promise().query(
    `
      SELECT id, email, firstName, lastName, phoneNumber, address, gender
      FROM users
      WHERE id = ? AND roleId = 'R3'
      LIMIT 1
    `,
    [patientId]
  );

  return rows[0] || null;
};

const hydratePatientInfo = async (session, patientEmail) => {
  const info = session.collectedInfo || defaultCollectedInfo();
  const patient = await getPatientInfo(session.patientId);

  if (patient) {
    const patientName = `${patient.firstName || ""} ${patient.lastName || ""}`.trim();
    info.patientName = info.patientName || patientName || null;
    info.patientPhone = info.patientPhone || patient.phoneNumber || null;
    info.patientEmail = info.patientEmail || patient.email || null;
    info.patientAddress = info.patientAddress || patient.address || null;
    info.patientGender = info.patientGender || patient.gender || null;
  } else if (patientEmail) {
    info.patientEmail = info.patientEmail || patientEmail;
  }

  session.collectedInfo = info;
};

const mergeAiResult = (currentInfo, normalized, message) => {
  const nextInfo = {
    ...defaultCollectedInfo(),
    ...(currentInfo || {}),
  };

  const consultationType =
    normalizeConsultationType(normalized.consultation_type) ||
    normalizeConsultationType(message);
  const specialties = normalizeSpecialtyNames(normalized.specialties);
  const symptoms = ensureArray(normalized.symptoms);
  const preferredDate = parsePreferredDate(message);

  nextInfo.intent = normalized.intent || nextInfo.intent;
  nextInfo.intent_score = normalized.intent_score ?? nextInfo.intent_score;
  nextInfo.symptoms = symptoms.length ? symptoms : nextInfo.symptoms;
  nextInfo.duration = normalized.duration || nextInfo.duration;
  nextInfo.consultation_type = consultationType || nextInfo.consultation_type;
  nextInfo.location = normalized.location || nextInfo.location;
  nextInfo.specialties = specialties.length ? specialties : nextInfo.specialties;
  nextInfo.preferred_date = preferredDate || normalized.preferred_date || nextInfo.preferred_date;
  nextInfo.debugReason = null;
  nextInfo.reason =
    symptoms.length || normalized.duration
      ? [symptoms.join(", "), normalized.duration].filter(Boolean).join(" ")
      : nextInfo.reason || message;

  return nextInfo;
};

const getMissingRequiredInfo = (collectedInfo = {}) => {
  const missing = [];

  if (normalizeSpecialtyNames(collectedInfo.specialties).length === 0) {
    missing.push("specialties");
  }
  if (
    !isOnlineConsultation(collectedInfo) &&
    !String(collectedInfo.location || "").trim()
  ) {
    missing.push("location");
  }
  if (!normalizeConsultationType(collectedInfo.consultation_type)) {
    missing.push("consultation_type");
  }

  return missing;
};

const askForMissingInfo = (session) => {
  const missing = getMissingRequiredInfo(session.collectedInfo);

  if (missing.includes("specialties")) {
    session.state = STATES.START;
    return responseForSession(
      session,
      "Bạn vui lòng mô tả triệu chứng hoặc chuyên khoa muốn khám."
    );
  }

  if (missing.includes("location")) {
    session.state = STATES.ASK_LOCATION;
    return responseForSession(session, "Bạn muốn khám ở tỉnh/thành phố nào ạ?");
  }

  if (missing.includes("consultation_type")) {
    session.state = STATES.ASK_CONSULTATION_TYPE;
    return responseForSession(session, "Bạn muốn khám online hay tại phòng khám ạ?");
  }

  return null;
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
  const activeStatusSql = ACTIVE_BOOKING_STATUSES.map(() => "?").join(", ");
  const params = [...ACTIVE_BOOKING_STATUSES, doctorId];
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
        COALESCE(s.maxNumber, 1) AS maxNumber,
        lt.value_vi AS timeVi,
        lt.value_en AS timeEn,
        COUNT(b.id) AS bookedCount
      FROM schedule s
      LEFT JOIN booking b
        ON b.scheduleId = s.id
       AND b.statusId IN (${activeStatusSql})
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE s.doctorId = ?
        AND ${dateFilter}
        AND s.appointmentTypeId = ?
      GROUP BY
        s.id, s.doctorId, s.date, s.timeType, s.appointmentTypeId,
        s.maxNumber, lt.value_vi, lt.value_en
      ORDER BY s.date ASC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      LIMIT 10
    `,
    params
  );

  const availableRows = rows.filter((row) => {
    const maxNumber = Number(row.maxNumber) || 1;
    const bookedCount = Number(row.bookedCount) || 0;
    return bookedCount < maxNumber;
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
      maxNumber: Number(row.maxNumber) || 1,
      bookedCount: Number(row.bookedCount) || 0,
    })),
  });

  if (debugStats) {
    debugStats.schedulesBeforeCapacity += rows.length;
    debugStats.schedulesAfterCapacity += availableRows.length;
  }

  return availableRows.map((row, index) => {
    const timeText = row.timeVi || row.timeEn || row.timeType;
    const { start_time, end_time } = splitTimeRange(timeText);
    const maxNumber = Number(row.maxNumber) || 1;
    const bookedCount = Number(row.bookedCount) || 0;

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
      remaining: Math.max(maxNumber - bookedCount, 0),
    };
  });
};

const getNearestAvailableSlotForDoctor = async (doctorId, collectedInfo = {}) => {
  if (!collectedInfo.preferred_date) return null;

  const appointmentTypeId = getAppointmentTypeId(collectedInfo);
  const activeStatusSql = ACTIVE_BOOKING_STATUSES.map(() => "?").join(", ");
  const params = [
    ...ACTIVE_BOOKING_STATUSES,
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
        COALESCE(s.maxNumber, 1) AS maxNumber,
        lt.value_vi AS timeVi,
        lt.value_en AS timeEn,
        COUNT(b.id) AS bookedCount
      FROM schedule s
      LEFT JOIN booking b
        ON b.scheduleId = s.id
       AND b.statusId IN (${activeStatusSql})
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE s.doctorId = ?
        AND s.date > ?
        AND s.appointmentTypeId = ?
      GROUP BY
        s.id, s.doctorId, s.date, s.timeType, s.appointmentTypeId,
        s.maxNumber, lt.value_vi, lt.value_en
      HAVING bookedCount < maxNumber
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

const formatDoctorsReply = (doctors) => {
  const lines = [`Tôi tìm thấy ${doctors.length} bác sĩ phù hợp:`];

  doctors.forEach((doctor) => {
    lines.push(
      "",
      `${doctor.index}. ${doctor.name}`,
      `   Chuyên khoa: ${doctor.specialty || "Chưa rõ"}`,
      `   Thành phố: ${doctor.city || "Chưa rõ"}`,
      `   Hình thức: ${doctor.supports_online ? "Có hỗ trợ online" : "Tại phòng khám"}`,
      `   Giá khám: ${doctor.price || 0}`
    );
  });

  lines.push("", "Bạn muốn chọn bác sĩ số mấy ạ?");
  return lines.join("\n");
};

const formatSlotsReply = (slots, doctor) => {
  const lines = [`Bác sĩ ${doctor?.name || ""} còn các lịch trống:`];

  slots.forEach((slot) => {
    lines.push(`${slot.index}. ${slot.date}, ${slot.start_time} - ${slot.end_time}`);
  });

  lines.push("", "Bạn muốn chọn lịch số mấy ạ?");
  return lines.join("\n");
};

const formatConfirmReply = (session) => {
  const info = session.collectedInfo || defaultCollectedInfo();
  const doctor = info.selectedDoctor || {};
  const slot = info.selectedSlot || {};
  const consultationLabel =
    info.consultation_type === "online" ? "Online" : "Tại phòng khám";

  return [
    "Bạn vui lòng kiểm tra lại thông tin đặt lịch:",
    `Bác sĩ: ${doctor.name || ""}`,
    `Chuyên khoa: ${doctor.specialty || ""}`,
    `Ngày khám: ${slot.date || ""}`,
    `Giờ khám: ${slot.start_time || ""} - ${slot.end_time || ""}`,
    `Hình thức khám: ${consultationLabel}`,
    `Tên bệnh nhân: ${info.patientName || ""}`,
    `Số điện thoại: ${info.patientPhone || ""}`,
    `Email: ${info.patientEmail || ""}`,
    `Lý do khám: ${info.reason || ""}`,
    "Bạn xác nhận đặt lịch này không? Vui lòng trả lời có hoặc không.",
  ].join("\n");
};

const findDoctorsAndReply = async (session) => {
  const debugStats = {
    reason: null,
    specialtyMatch: null,
    doctorsBeforeOnlineFilter: 0,
    doctorsBeforeSlotFilter: 0,
    doctorsAfterSlotFilter: 0,
    schedulesBeforeCapacity: 0,
    schedulesAfterCapacity: 0,
    nearestAvailableSlot: null,
  };
  const doctors = await findDoctorsFromCollectedInfo(session.collectedInfo, debugStats);
  session.collectedInfo.doctors = doctors;
  session.collectedInfo.slots = [];
  session.collectedInfo.selectedDoctor = null;
  session.collectedInfo.selectedSlot = null;
  session.collectedInfo.debugReason = debugStats.reason;
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;

  chatDebug("doctor filters:", {
    specialty_ids: debugStats.specialtyMatch?.ids || [],
    location: session.collectedInfo.location || null,
    consultation_type: session.collectedInfo.consultation_type || null,
    preferred_date: session.collectedInfo.preferred_date || null,
  });
  chatDebug("doctors before slot filter:", debugStats.doctorsBeforeSlotFilter);
  chatDebug("doctors after slot filter:", debugStats.doctorsAfterSlotFilter);

  if (doctors.length === 0) {
    session.state = STATES.START;
    chatDebug("no doctor result reason:", debugStats.reason || "UNKNOWN");
    const noDoctorReply =
      debugStats.reason === "NO_SCHEDULE_FOR_DATE" && session.collectedInfo.preferred_date
        ? debugStats.nearestAvailableSlot
          ? `Hôm nay bác sĩ chưa có lịch trống. Tôi tìm thấy lịch gần nhất vào ${debugStats.nearestAvailableSlot.date}, ${debugStats.nearestAvailableSlot.start_time} - ${debugStats.nearestAvailableSlot.end_time}.`
          : "Hôm nay bác sĩ chưa có lịch trống. Vui lòng thử ngày khác hoặc đợi thêm lịch mới."
        : "Hien tai chua tim thay bac si/lich phu hop voi thong tin cua ban.";
    return responseForSession(
      session,
      noDoctorReply,
      true,
      {
        debugReason: debugStats.reason || "UNKNOWN",
        nearestAvailableSlot: debugStats.nearestAvailableSlot,
      }
    );
  }

  session.state = STATES.WAIT_SELECT_DOCTOR;
  return responseForSession(session, formatDoctorsReply(doctors));
};

const continueAfterRequiredInfo = async (session) => {
  const missingReply = askForMissingInfo(session);
  if (missingReply) return missingReply;
  return findDoctorsAndReply(session);
};

const handleStart = async (session, message) => {
  const aiResult = await analyzeMessage(message);
  const normalized = aiResult.normalized || {};
  session.lastAiResult = aiResult.raw;
  chatDebug("user message:", message);
  chatDebug("ai normalized:", normalized);
  chatDebug("ai fields:", {
    intent: normalized.intent,
    symptoms: normalized.symptoms,
    duration: normalized.duration,
    consultation_type: normalized.consultation_type,
    location: normalized.location,
    specialties: normalized.specialties,
    preferred_date: normalized.preferred_date || null,
  });

  if (!ACTIONABLE_INTENTS.has(normalized.intent)) {
    session.state = STATES.START;
    return responseForSession(
      session,
      "Tôi có thể hỗ trợ bạn tìm bác sĩ và đặt lịch khám. Bạn vui lòng mô tả triệu chứng hoặc nhu cầu khám."
    );
  }

  session.collectedInfo = mergeAiResult(session.collectedInfo, normalized, message);
  chatDebug("preferred_date:", session.collectedInfo.preferred_date || null);
  chatDebug("collectedInfo:", {
    intent: session.collectedInfo.intent,
    symptoms: session.collectedInfo.symptoms,
    duration: session.collectedInfo.duration,
    consultation_type: session.collectedInfo.consultation_type,
    location: session.collectedInfo.location,
    specialties: session.collectedInfo.specialties,
    preferred_date: session.collectedInfo.preferred_date,
  });
  return continueAfterRequiredInfo(session);
};

const handleAskLocation = async (session, message) => {
  session.collectedInfo.location = String(message || "").trim();
  return continueAfterRequiredInfo(session);
};

const handleAskConsultationType = async (session, message) => {
  const consultationType = normalizeConsultationType(message);

  if (!consultationType) {
    session.state = STATES.ASK_CONSULTATION_TYPE;
    return responseForSession(session, "Bạn muốn khám online hay tại phòng khám ạ?");
  }

  session.collectedInfo.consultation_type = consultationType;
  return continueAfterRequiredInfo(session);
};

const parseSelectionNumber = (message) => {
  const match = String(message || "").match(/\d+/);
  return match ? Number(match[0]) : null;
};

const handleWaitSelectDoctor = async (session, message) => {
  const doctors = session.collectedInfo.doctors || [];
  const selectedNumber = parseSelectionNumber(message);

  if (!selectedNumber || selectedNumber < 1 || selectedNumber > doctors.length) {
    session.state = STATES.WAIT_SELECT_DOCTOR;
    return responseForSession(
      session,
      "Bạn vui lòng chọn số trong danh sách bác sĩ tôi vừa gửi ạ."
    );
  }

  const doctor = doctors[selectedNumber - 1];
  const slots = await getAvailableSlotsForDoctor(doctor.id, session.collectedInfo);
  const selectedDoctor = { ...doctor, index: selectedNumber, available_slots: slots };
  session.collectedInfo.selectedDoctor = selectedDoctor;
  session.collectedInfo.slots = slots;
  session.selectedDoctorId = doctor.id;

  if (slots.length === 0) {
    session.state = STATES.WAIT_SELECT_DOCTOR;
    return responseForSession(
      session,
      "Bác sĩ này hiện chưa có lịch trống. Bạn vui lòng chọn bác sĩ khác trong danh sách."
    );
  }

  session.state = STATES.WAIT_SELECT_SLOT;
  return responseForSession(session, formatSlotsReply(slots, selectedDoctor));
};

const advanceToPatientInfoOrConfirm = (session) => {
  const info = session.collectedInfo;

  if (!String(info.patientName || "").trim()) {
    session.state = STATES.ASK_PATIENT_NAME;
    return responseForSession(session, "Bạn vui lòng cho biết họ tên bệnh nhân ạ.");
  }

  if (!isValidPhone(info.patientPhone)) {
    session.state = STATES.ASK_PATIENT_PHONE;
    return responseForSession(session, "Bạn vui lòng cho biết số điện thoại liên hệ ạ.");
  }

  if (!isValidEmail(info.patientEmail)) {
    session.state = STATES.ASK_PATIENT_EMAIL;
    return responseForSession(session, "Bạn vui lòng cho biết email để nhận xác nhận lịch ạ.");
  }

  session.state = STATES.CONFIRM_BOOKING;
  return responseForSession(session, formatConfirmReply(session));
};

const handleWaitSelectSlot = async (session, message) => {
  const slots = session.collectedInfo.slots || [];
  const selectedNumber = parseSelectionNumber(message);

  if (!selectedNumber || selectedNumber < 1 || selectedNumber > slots.length) {
    session.state = STATES.WAIT_SELECT_SLOT;
    return responseForSession(
      session,
      "Bạn vui lòng chọn số trong danh sách lịch trống tôi vừa gửi ạ."
    );
  }

  const slot = slots[selectedNumber - 1];
  session.collectedInfo.selectedSlot = { ...slot, index: selectedNumber };
  session.selectedScheduleId = slot.id;
  return advanceToPatientInfoOrConfirm(session);
};

const handleAskPatientName = async (session, message) => {
  const patientName = String(message || "").trim();

  if (!patientName) {
    session.state = STATES.ASK_PATIENT_NAME;
    return responseForSession(session, "Bạn vui lòng cho biết họ tên bệnh nhân ạ.");
  }

  session.collectedInfo.patientName = patientName;
  return advanceToPatientInfoOrConfirm(session);
};

const normalizePhone = (message) => String(message || "").replace(/[^\d]/g, "");

const isValidPhone = (phone) => /^\d{9,11}$/.test(String(phone || ""));

const handleAskPatientPhone = async (session, message) => {
  const phone = normalizePhone(message);

  if (!isValidPhone(phone)) {
    session.state = STATES.ASK_PATIENT_PHONE;
    return responseForSession(
      session,
      "Số điện thoại chưa hợp lệ, bạn vui lòng nhập lại ạ."
    );
  }

  session.collectedInfo.patientPhone = phone;
  return advanceToPatientInfoOrConfirm(session);
};

const normalizeEmail = (message) => String(message || "").trim().toLowerCase();

const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(email || ""));

const handleAskPatientEmail = async (session, message) => {
  const email = normalizeEmail(message);

  if (!isValidEmail(email)) {
    session.state = STATES.ASK_PATIENT_EMAIL;
    return responseForSession(session, "Email chưa hợp lệ, bạn vui lòng nhập lại ạ.");
  }

  session.collectedInfo.patientEmail = email;
  return advanceToPatientInfoOrConfirm(session);
};

const isCancelMessage = (message) => {
  const text = normalizeText(message);
  return (
    ["khong", "huy", "cancel", "thoi", "khong dat nua"].includes(text) ||
    /\bhuy\b|\bcancel\b|\bkhong dat\b/.test(text)
  );
};

const isConfirmMessage = (message) => {
  const text = normalizeText(message);
  return (
    !isCancelMessage(message) &&
    (["co", "dong y", "xac nhan", "ok", "oke", "dat lich", "yes"].includes(text) ||
      /\bdong y\b|\bxac nhan\b|\bdat lich\b|\bok\b|\boke\b|\byes\b/.test(text))
  );
};

const cancelSession = (session) => {
  session.state = STATES.CANCELLED;
  session.collectedInfo.doctors = [];
  session.collectedInfo.slots = [];
  session.collectedInfo.selectedDoctor = null;
  session.collectedInfo.selectedSlot = null;
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;

  return responseForSession(
    session,
    "Lịch đặt đã được hủy. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi."
  );
};

const splitPatientName = (name) => {
  const parts = String(name || "").trim().split(/\s+/).filter(Boolean);
  if (parts.length <= 1) {
    return { firstName: parts[0] || "", lastName: "" };
  }

  return {
    firstName: parts.slice(0, -1).join(" "),
    lastName: parts.slice(-1).join(""),
  };
};

const createBookingFromSession = async (session) => {
  const info = session.collectedInfo || {};
  const slot = info.selectedSlot || {};
  const { firstName, lastName } = splitPatientName(info.patientName);

  const response = await bookAppointment({
    patientId: session.patientId || null,
    email: info.patientEmail,
    firstName,
    lastName,
    address: info.patientAddress || info.location || null,
    gender: info.patientGender || null,
    phoneNumber: info.patientPhone,
    scheduleId: slot.id,
    date: slot.date,
    reason: info.reason || null,
    timeString: `${slot.start_time || ""} - ${slot.end_time || ""}`.trim(),
  });

  if (response.errCode !== 0) {
    return {
      success: false,
      message: response.errMessage || "Booking failed",
      raw: response,
    };
  }

  const bookingId = response.data?.insertId || response.data?.id || null;
  return {
    success: true,
    booking: {
      id: bookingId,
      queueNumber: response.data?.queueNumber || null,
      queueAppointmentDate: response.data?.queueAppointmentDate || slot.date,
    },
    raw: response,
  };
};

const handleConfirmBooking = async (session, message) => {
  if (isCancelMessage(message)) {
    return cancelSession(session);
  }

  if (!isConfirmMessage(message)) {
    session.state = STATES.CONFIRM_BOOKING;
    return responseForSession(
      session,
      "Bạn xác nhận đặt lịch này không? Vui lòng trả lời có hoặc không."
    );
  }

  const result = await createBookingFromSession(session);
  if (result.success) {
    session.bookingId = result.booking.id;
    session.collectedInfo.booking = result.booking;
    session.state = STATES.BOOKING_CREATED;
    return responseForSession(
      session,
      `Đặt lịch thành công. Mã lịch hẹn của bạn là ${result.booking.id}.`,
      true,
      { booking: result.booking }
    );
  }

  const errorText = normalizeText(result.message);
  if (errorText.includes("full") || errorText.includes("het cho") || result.raw?.errCode === 4) {
    const slots = await getAvailableSlotsForDoctor(
      session.selectedDoctorId,
      session.collectedInfo
    );
    session.collectedInfo.slots = slots;
    session.collectedInfo.selectedSlot = null;
    session.selectedScheduleId = null;
    session.state = STATES.WAIT_SELECT_SLOT;
    return responseForSession(
      session,
      "Rất tiếc, lịch này vừa hết chỗ. Bạn vui lòng chọn lịch khác."
    );
  }

  session.state = STATES.ERROR;
  console.error("chat booking error:", result.raw || result.message);
  return responseForSession(
    session,
    "Có lỗi xảy ra khi tạo lịch hẹn. Bạn vui lòng thử lại sau.",
    false
  );
};

const dispatchByState = async (session, message) => {
  if ([STATES.BOOKING_CREATED, STATES.CANCELLED, STATES.ERROR].includes(session.state)) {
    session.state = STATES.START;
    session.collectedInfo = defaultCollectedInfo();
    session.selectedDoctorId = null;
    session.selectedScheduleId = null;
    session.bookingId = null;
  }

  switch (session.state) {
    case STATES.START:
      return handleStart(session, message);
    case STATES.ASK_LOCATION:
      return handleAskLocation(session, message);
    case STATES.ASK_CONSULTATION_TYPE:
      return handleAskConsultationType(session, message);
    case STATES.WAIT_SELECT_DOCTOR:
      return handleWaitSelectDoctor(session, message);
    case STATES.WAIT_SELECT_SLOT:
      return handleWaitSelectSlot(session, message);
    case STATES.ASK_PATIENT_NAME:
      return handleAskPatientName(session, message);
    case STATES.ASK_PATIENT_PHONE:
      return handleAskPatientPhone(session, message);
    case STATES.ASK_PATIENT_EMAIL:
      return handleAskPatientEmail(session, message);
    case STATES.CONFIRM_BOOKING:
      return handleConfirmBooking(session, message);
    default:
      session.state = STATES.START;
      return handleStart(session, message);
  }
};

const handleChatMessage = async ({ sessionId, message, patientId, patientEmail }) => {
  const trimmedMessage = String(message || "").trim();
  const session = await getOrCreateSession(sessionId, patientId);
  await hydratePatientInfo(session, patientEmail);

  if (!trimmedMessage) {
    return responseForSession(
      session,
      "Bạn vui lòng nhập nội dung tin nhắn.",
      false
    );
  }

  try {
    const response = isCancelMessage(trimmedMessage)
      ? cancelSession(session)
      : await dispatchByState(session, trimmedMessage);

    await saveSession(session);
    return response;
  } catch (error) {
    console.error("chatService.handleChatMessage error:", error);
    session.state = STATES.ERROR;
    await saveSession(session);
    return responseForSession(
      session,
      "Hiện tại tôi chưa kết nối được dịch vụ AI. Bạn vui lòng thử lại sau.",
      false
    );
  }
};

module.exports = {
  STATES,
  getOrCreateSession,
  saveSession,
  resetSession,
  handleChatMessage,
  handleStart,
  handleAskLocation,
  handleAskConsultationType,
  handleWaitSelectDoctor,
  handleWaitSelectSlot,
  handleAskPatientName,
  handleAskPatientPhone,
  handleAskPatientEmail,
  handleConfirmBooking,
  findDoctorsFromCollectedInfo,
  getAvailableSlotsForDoctor,
  createBookingFromSession,
  parseSelectionNumber,
  normalizeText,
  parsePreferredDate,
  isConfirmMessage,
  isCancelMessage,
  normalizePhone,
  isValidPhone,
  normalizeEmail,
  isValidEmail,
  formatDoctorsReply,
  formatSlotsReply,
  formatConfirmReply,
};
