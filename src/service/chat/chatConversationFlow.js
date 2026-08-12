const connection = require("../../config/data");
const { analyzeMessage } = require("../fastApiAiService");
const { bookAppointment, cancelBookAppointment } = require("../PatientService");
const { cancelPaymentIntent, getPaymentIntent } = require("../paymentService");
const {
  STATES,
  SUPPORTED_INTENTS,
  DEFAULT_SESSION_TITLE,
  defaultCollectedInfo,
} = require("./chatState");
const {
  chatDebug,
  normalizeText,
  normalizeConsultationType,
  normalizeSpecialtyNames,
  ensureArray,
  parsePreferredDate,
  parsePreferredTime,
  isOnlineConsultation,
  parseSelectionNumber,
  normalizePhone,
  isValidPhone,
  normalizeEmail,
  isValidEmail,
  formatMoney,
  isCancelMessage,
  isConfirmMessage,
  splitPatientName,
  buildSessionTitle,
} = require("./chatUtils");
const {
  getOwnedSession,
  saveSession,
  saveChatMessage,
} = require("./chatSessionStore");
const {
  findDoctorsFromCollectedInfo,
  getAvailableSlotPageForDoctor,
  getAvailableSlotsForDoctor,
} = require("./chatDoctorSearchService");
const { isPriceQuestion, resolveChatFaq } = require("./chatFaqService");

const EMERGENCY_REPLY =
  "Đây có thể là tình trạng cấp cứu. Hãy gọi 115 hoặc đến cơ sở cấp cứu gần nhất ngay. " +
  "Tôi sẽ không tiếp tục gợi ý bác sĩ, lịch khám hoặc đặt lịch khám thường.";
const EMERGENCY_PHRASES = [
  "dau nguc du doi",
  "dau nguc kem kho tho",
  "kho tho dot ngot",
  "ngat xiu",
  "co giat",
  "mat y thuc",
  "chay mau nhieu",
  "meo mieng",
  "yeu nua nguoi",
  "soc phan ve",
  "sung moi kho tho",
];
const COMPOSITE_EMERGENCY_CHEST_PHRASES = [
  "dau nguc bop nghet",
  "dau nguc nghen",
  "dau nguc chat",
];
const COMPOSITE_EMERGENCY_ASSOCIATED_PHRASES = [
  "mo hoi lanh",
  "tai mat",
  "lanh nguoi",
  "goi nguoi ho tro",
  "rat gap",
];
const DRAFT_CANCELLATION_STATES = new Set([
  STATES.ASK_LOCATION,
  STATES.ASK_CONSULTATION_TYPE,
  STATES.ASK_AVAILABLE_DOCTOR,
  STATES.WAIT_SELECT_DOCTOR,
  STATES.WAIT_SELECT_SLOT,
  STATES.SHOW_AVAILABLE_SLOTS,
  STATES.ASK_PATIENT_NAME,
  STATES.ASK_PATIENT_PHONE,
  STATES.ASK_PATIENT_EMAIL,
  STATES.CONFIRM_BOOKING,
]);
const BOOKING_ID_REPLY =
  "Bạn muốn hủy lịch khám nào? Vui lòng gửi mã booking, ví dụ: 123.";

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

const isEmergencyResult = (aiResult = {}) => {
  const normalized = aiResult.normalized || {};
  const rawAi = aiResult.raw?.ai || {};
  return Boolean(
    normalized.urgent ||
      rawAi.urgent ||
      aiResult.raw?.urgent ||
      normalized.intent === "EMERGENCY"
  );
};

const hasEmergencyPhrase = (message) => {
  const normalizedMessage = normalizeText(message);
  if (EMERGENCY_PHRASES.some((phrase) => normalizedMessage.includes(phrase))) {
    return true;
  }

  const hasCompositeChestPain = COMPOSITE_EMERGENCY_CHEST_PHRASES.some((phrase) =>
    normalizedMessage.includes(phrase)
  );
  const hasAssociatedSign = COMPOSITE_EMERGENCY_ASSOCIATED_PHRASES.some((phrase) =>
    normalizedMessage.includes(phrase)
  );
  const isNegatedChest = /\b(?:khong|chua)\b[^.!?]*\bdau nguc (?:bop nghet|nghen|chat)\b/.test(
    normalizedMessage
  );
  const isNegatedAssociated = /\b(?:khong|chua)\s+(?:va\s+)?(?:mo hoi lanh|tai mat|lanh nguoi|goi nguoi ho tro)\b/.test(
    normalizedMessage
  );
  const hasHistoryMarker = /\b(?:tung|tien su|truoc day|tuan truoc|thang truoc|hom qua|nam ngoai)\b/.test(
    normalizedMessage
  );
  const hasCurrentChestEvent = /\b(?:dang|hien dang|luc nay|bay gio|vua)\b[^.!?]*\bdau nguc (?:bop nghet|nghen|chat)\b/.test(
    normalizedMessage
  );
  const isResolvedHistory =
    hasHistoryMarker &&
    /\b(?:hien da on|hien da tinh|da on|da het|khoe roi|khong con)\b/.test(
      normalizedMessage
    );
  const isHistoricalOnly = hasHistoryMarker && !hasCurrentChestEvent;
  const isEducationalContext =
    /bai viet|giao trinh|la gi|co nguy hiem khong|chi muon hoi|dang hoi|tim hieu|the nao|\bneu\b|\bgia su\b/.test(
      normalizedMessage
    ) && !hasCurrentChestEvent;

  return (
    hasCompositeChestPain &&
    hasAssociatedSign &&
    !isNegatedChest &&
    !isNegatedAssociated &&
    !isResolvedHistory &&
    !isHistoricalOnly &&
    !isEducationalContext
  );
};

const normalizeBookingId = (value) => {
  const bookingId = Number(value);
  return Number.isInteger(bookingId) && bookingId > 0 ? bookingId : null;
};

const parseBookingId = (message) => {
  const matches = String(message || "").match(/\b\d+\b/g) || [];
  return matches.length === 1 ? normalizeBookingId(matches[0]) : null;
};

const getSessionBookingId = (session) =>
  [
    session.bookingId,
    session.collectedInfo?.booking?.id,
    session.collectedInfo?.payment?.bookingId,
  ]
    .map(normalizeBookingId)
    .find(Boolean) || null;

const hasEmergencyDecision = (aiResult) =>
  typeof aiResult?.normalized?.urgent === "boolean" ||
  typeof aiResult?.raw?.ai?.urgent === "boolean" ||
  typeof aiResult?.raw?.urgent === "boolean";

const shouldBlockEmergency = (message, aiResult = null) =>
  isEmergencyResult(aiResult || {}) ||
  (!hasEmergencyDecision(aiResult) && hasEmergencyPhrase(message));

const emergencyResponse = (session, aiResult = {}) => {
  aiResult = aiResult || {};
  const normalized = aiResult.normalized || {};
  const rawAi = aiResult.raw?.ai || {};
  session.state = STATES.START;
  session.collectedInfo = {
    ...defaultCollectedInfo(),
    urgent: true,
    routing_source: normalized.routing_source || rawAi.routing_source || "safety",
  };
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;
  session.bookingId = null;
  return responseForSession(session, EMERGENCY_REPLY, true, {
    urgent: true,
    routing_source: session.collectedInfo.routing_source,
  });
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
  const preferredTime = normalized.preferred_time || parsePreferredTime(message);

  nextInfo.intent = normalized.intent || nextInfo.intent;
  nextInfo.intent_score = normalized.intent_score ?? nextInfo.intent_score;
  nextInfo.symptoms = symptoms.length ? symptoms : nextInfo.symptoms;
  nextInfo.duration = normalized.duration || nextInfo.duration;
  nextInfo.consultation_type = consultationType || nextInfo.consultation_type;
  nextInfo.location = normalized.location || nextInfo.location;
  nextInfo.specialties = specialties.length ? specialties : nextInfo.specialties;
  nextInfo.doctor_name = normalized.doctor_name || nextInfo.doctor_name;
  nextInfo.preferred_date = preferredDate || normalized.preferred_date || nextInfo.preferred_date;
  nextInfo.preferred_time = preferredTime || nextInfo.preferred_time;
  nextInfo.debugReason = null;
  nextInfo.reason =
    symptoms.length || normalized.duration
      ? [symptoms.join(", "), normalized.duration].filter(Boolean).join(" ")
      : nextInfo.reason || message;

  return nextInfo;
};

const getMissingRequiredInfo = (collectedInfo = {}) => {
  const missing = [];
  const hasDoctorName = Boolean(String(collectedInfo.doctor_name || "").trim());

  if (!hasDoctorName && normalizeSpecialtyNames(collectedInfo.specialties).length === 0) {
    missing.push("specialties");
  }
  if (
    !hasDoctorName &&
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

const formatDoctorsReply = (doctors) => {
  const lines = [`Tôi tìm thấy ${doctors.length} bác sĩ phù hợp:`];

  doctors.forEach((doctor) => {
    lines.push(
      "",
      `${doctor.index}. ${doctor.name}`,
      `   Chuyên khoa: ${doctor.specialty || "Chưa rõ"}`,
      `   Thành phố: ${doctor.city || "Chưa rõ"}`,
      `   Hình thức: ${doctor.supports_online ? "Có hỗ trợ online" : "Tại phòng khám"}`,
      `   Giá khám: ${formatMoney(doctor.price)}`
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

const hasExplicitBookingPhrase = (message) => {
  const text = normalizeText(message);
  return /\b(?:dat lich|dat hen|book|booking|muon dat)\b/.test(text);
};

const isLoadMoreAvailabilityRequest = (message) => {
  const text = normalizeText(message);
  return (
    /\bxem them\b|\bxem tiep\b|\bthem lich\b|\blich tiep theo\b/.test(text) ||
    /\bcon lich\b/.test(text)
  );
};

const isReadOnlyAvailabilityRequest = (message, normalized = {}, collectedInfo = {}) => {
  const text = normalizeText(message);
  const doctorName = normalized.doctor_name || collectedInfo.doctor_name;
  return Boolean(
    normalized.intent === "FIND_DOCTOR" &&
      doctorName &&
      !hasExplicitBookingPhrase(message) &&
      (/\blich\b/.test(text) ||
        /\bkhung gio\b|\bgio kham\b|\bthoi gian kham\b/.test(text))
  );
};

const resetReadOnlyAvailability = (collectedInfo) => {
  collectedInfo.readOnlyAvailability = {
    doctorId: null,
    doctor: null,
    offset: 0,
    hasMore: false,
  };
};

const formatReadOnlySlotsReply = (slots, doctor, hasMore = false) => {
  const lines = [`Lịch trống tham khảo của bác sĩ ${doctor?.name || ""}:`];
  slots.forEach((slot) => {
    lines.push(`${slot.index}. ${slot.date}, ${slot.start_time} - ${slot.end_time}`);
  });
  if (!slots.length) {
    lines.push("Hiện chưa có lịch trống phù hợp vào thời gian này.");
  } else {
    lines.push("Đây là thông tin xem lịch, chưa tạo cuộc hẹn. Nếu muốn đặt, bạn hãy nói 'đặt lịch'.");
  }
  if (hasMore) {
    lines.push("", "Gõ \"xem thêm\" để xem các khung giờ tiếp theo.");
  }
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
    `Giá khám: ${formatMoney(slot.effectivePrice || slot.price || doctor.price)}`,
    `Tên bệnh nhân: ${info.patientName || ""}`,
    `Số điện thoại: ${info.patientPhone || ""}`,
    `Email: ${info.patientEmail || ""}`,
    `Lý do khám: ${info.reason || ""}`,
    "Bạn xác nhận đặt lịch này không? Vui lòng trả lời có hoặc không.",
  ].join("\n");
};

const formatPaymentPendingReply = (payment) =>
  [
    "Bạn đã chọn lịch khám online.",
    `Số tiền cần thanh toán: ${formatMoney(payment?.amount)}`,
    `Nội dung chuyển khoản: ${payment?.paymentCode || ""}`,
    "Vui lòng quét mã QR bên dưới để thanh toán.",
    "Lịch hẹn chỉ được xác nhận sau khi hệ thống nhận thanh toán thành công.",
  ].join("\n");

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
  resetReadOnlyAvailability(session.collectedInfo);
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
        : "Hiện tại chưa tìm thấy bác sĩ/lịch phù hợp với thông tin của bạn.";
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

const handleNonBookingIntent = async (session, message, intent) => {
  if (intent === "GREETING") {
    session.state = STATES.START;
    return responseForSession(
      session,
      "Xin chào! Tôi có thể giúp tìm bác sĩ, xem lịch trống, đặt hoặc hủy lịch khám. Bạn muốn thực hiện việc nào ạ?",
      true,
      { intent }
    );
  }

  if (intent === "PROVIDE_INFO" || intent === "OUT_OF_SCOPE") {
    const faq = await resolveChatFaq(message, session.collectedInfo);
    if (faq) {
      session.state = STATES.START;
      return responseForSession(session, faq.reply, true, {
        intent,
        source: faq.source,
      });
    }

    session.state = STATES.START;
    return responseForSession(
      session,
      intent === "OUT_OF_SCOPE"
        ? "Tôi chỉ hỗ trợ tìm bác sĩ, xem lịch, đặt/hủy lịch và thông tin phòng khám có trong hệ thống. Tôi không thể tư vấn thuốc hoặc chẩn đoán bệnh."
        : "Tôi có thể cung cấp thông tin có sẵn về bác sĩ, lịch trống, giá khám và phòng khám. Bạn muốn hỏi thông tin nào ạ?",
      true,
      { intent, source: "supported_clinic_data" }
    );
  }

  if (intent === "CONFIRM_BOOKING") {
    if (session.collectedInfo?.selectedSlot) {
      session.state = STATES.CONFIRM_BOOKING;
      return responseForSession(session, formatConfirmReply(session), true, { intent });
    }
    session.state = STATES.START;
    return responseForSession(
      session,
      "Hiện chưa có cuộc hẹn nào đang chờ xác nhận. Bạn hãy tìm bác sĩ hoặc bắt đầu đặt lịch trước nhé.",
      true,
      { intent }
    );
  }

  if (intent === "CANCEL_BOOKING") {
    return handleCancellationMessage(session, message);
  }

  session.state = STATES.START;
  return responseForSession(
    session,
    "Tôi chưa xác định được yêu cầu. Bạn có thể nói rõ muốn tìm bác sĩ, xem lịch hay đặt lịch không ạ?",
    true,
    { intent: intent || "UNKNOWN" }
  );
};

const mergeAvailabilityInfo = (session, normalized, message) => {
  const nextInfo = mergeAiResult(session.collectedInfo, normalized, message);
  if (!nextInfo.doctor_name && session.state === STATES.ASK_AVAILABLE_DOCTOR) {
    nextInfo.doctor_name = String(message || "").trim();
  }
  session.collectedInfo = nextInfo;
  return nextInfo;
};

const handleAvailableSlotRequest = async (session, message, normalized = {}) => {
  const info = mergeAvailabilityInfo(session, normalized, message);
  if (!String(info.doctor_name || "").trim()) {
    session.state = STATES.ASK_AVAILABLE_DOCTOR;
    session.collectedInfo.slots = [];
    resetReadOnlyAvailability(session.collectedInfo);
    session.selectedDoctorId = null;
    session.selectedScheduleId = null;
    return responseForSession(
      session,
      "Bạn vui lòng cho biết tên bác sĩ muốn xem lịch. Tôi sẽ chỉ hiển thị lịch, chưa tạo cuộc hẹn.",
      true,
      { readOnly: true, read_only: true }
    );
  }

  const debugStats = {
    reason: null,
    schedulesBeforeCapacity: 0,
    schedulesAfterCapacity: 0,
  };
  const doctors = await findDoctorsFromCollectedInfo(info, debugStats);
  const doctor = doctors[0] || null;
  const slots = doctor?.available_slots || [];
  const hasMoreSlots = Boolean(doctor?.has_more_slots);
  session.collectedInfo.doctors = [];
  session.collectedInfo.slots = slots;
  session.collectedInfo.selectedDoctor = null;
  session.collectedInfo.selectedSlot = null;
  session.collectedInfo.readOnlyAvailability = doctor
    ? {
        doctorId: doctor.id,
        doctor: {
          id: doctor.id,
          name: doctor.name,
          specialty: doctor.specialty,
          city: doctor.city,
          supports_online: doctor.supports_online,
        },
        offset: slots.length,
        hasMore: hasMoreSlots,
      }
    : {
        doctorId: null,
        doctor: null,
        offset: 0,
        hasMore: false,
      };
  session.collectedInfo.debugReason = debugStats.reason;
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;
  session.state = STATES.SHOW_AVAILABLE_SLOTS;

  if (!doctor) {
    return responseForSession(
      session,
      "Không tìm thấy bác sĩ hoặc lịch trống phù hợp với thông tin bạn vừa gửi.",
      true,
      {
        readOnly: true,
        read_only: true,
        doctor: null,
        slots: [],
        hasMoreSlots: false,
        debugReason: debugStats.reason || "NO_DOCTOR_FOR_NAME",
      }
    );
  }

  return responseForSession(
    session,
    formatReadOnlySlotsReply(slots, doctor, hasMoreSlots),
    true,
    {
      readOnly: true,
      read_only: true,
      doctor,
      slots,
      hasMoreSlots,
      preferredDate: info.preferred_date || null,
    }
  );
};

const handleAskAvailableDoctor = async (session, message, aiResult = null) => {
  const normalized = aiResult?.normalized || {};
  if (["FIND_DOCTOR", "BOOK_APPOINTMENT"].includes(normalized.intent)) {
    return handleStart(session, message, aiResult);
  }
  if (normalized.intent && ["GREETING", "PROVIDE_INFO", "OUT_OF_SCOPE", "CONFIRM_BOOKING", "CANCEL_BOOKING"].includes(normalized.intent)) {
    return handleNonBookingIntent(session, message, normalized.intent);
  }
  return handleAvailableSlotRequest(session, message, normalized);
};

const handleLoadMoreAvailability = async (session) => {
  const info = session.collectedInfo || defaultCollectedInfo();
  const context = info.readOnlyAvailability || {};
  const doctor = context.doctor || null;

  if (!context.doctorId || !doctor) {
    return responseForSession(
      session,
      "Hiện chưa có danh sách lịch để xem thêm.",
      true,
      { readOnly: true, read_only: true, hasMoreSlots: false }
    );
  }

  if (!context.hasMore) {
    return responseForSession(
      session,
      "Đã hiển thị hết lịch trống phù hợp.",
      true,
      { readOnly: true, read_only: true, doctor, slots: [], hasMoreSlots: false }
    );
  }

  const page = await getAvailableSlotPageForDoctor(
    context.doctorId,
    info,
    { offset: context.offset || 0, limit: 10 }
  );
  const slots = page?.slots || [];
  const nextOffset = (context.offset || 0) + slots.length;
  const hasMoreSlots = Boolean(page?.hasMore && slots.length);

  info.slots = slots;
  info.readOnlyAvailability = {
    ...context,
    offset: nextOffset,
    hasMore: hasMoreSlots,
  };
  session.collectedInfo = info;
  session.state = STATES.SHOW_AVAILABLE_SLOTS;

  return responseForSession(
    session,
    formatReadOnlySlotsReply(slots, doctor, hasMoreSlots),
    true,
    {
      readOnly: true,
      read_only: true,
      doctor,
      slots,
      hasMoreSlots,
      preferredDate: info.preferred_date || null,
    }
  );
};

const handleShowAvailableSlots = async (session, message, aiResult = null) => {
  if (isLoadMoreAvailabilityRequest(message)) {
    return handleLoadMoreAvailability(session);
  }

  const intent = aiResult?.normalized?.intent;
  if (["FIND_DOCTOR", "BOOK_APPOINTMENT"].includes(intent)) {
    return handleStart(session, message, aiResult);
  }
  if (intent === "ASK_AVAILABLE_SLOT") {
    return handleAvailableSlotRequest(session, message, aiResult.normalized);
  }
  if (["GREETING", "PROVIDE_INFO", "OUT_OF_SCOPE", "CONFIRM_BOOKING", "CANCEL_BOOKING"].includes(intent)) {
    return handleNonBookingIntent(session, message, intent);
  }
  return responseForSession(
    session,
    "Danh sách trên chỉ để xem lịch. Nếu muốn đặt lịch, bạn hãy nói 'đặt lịch' và tôi sẽ bắt đầu quy trình đặt hẹn.",
    true,
    { readOnly: true, read_only: true }
  );
};

const handleStart = async (session, message, existingAiResult = null) => {
  const aiResult = existingAiResult || (await analyzeMessage(message));
  const normalized = aiResult.normalized || {};
  session.lastAiResult = aiResult.raw;
  if (shouldBlockEmergency(message, aiResult)) {
    return emergencyResponse(session, aiResult);
  }
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

  session.collectedInfo = mergeAiResult(session.collectedInfo, normalized, message);

  if (!hasExplicitBookingPhrase(message) && isPriceQuestion(normalizeText(message))) {
    return handleNonBookingIntent(session, message, "PROVIDE_INFO");
  }

  if (isReadOnlyAvailabilityRequest(message, normalized, session.collectedInfo)) {
    return handleAvailableSlotRequest(session, message, normalized);
  }

  if (normalized.intent === "ASK_AVAILABLE_SLOT") {
    return handleAvailableSlotRequest(session, message, normalized);
  }

  if (["GREETING", "PROVIDE_INFO", "OUT_OF_SCOPE", "CONFIRM_BOOKING", "CANCEL_BOOKING"].includes(normalized.intent)) {
    return handleNonBookingIntent(session, message, normalized.intent);
  }

  if (!SUPPORTED_INTENTS.has(normalized.intent)) {
    session.state = STATES.START;
    return responseForSession(
      session,
      "Tôi chưa xác định được yêu cầu. Bạn có thể nói rõ muốn tìm bác sĩ, xem lịch hay đặt lịch không ạ?",
      true,
      { intent: normalized.intent || "UNKNOWN" }
    );
  }

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

const handleAskPatientEmail = async (session, message) => {
  const email = normalizeEmail(message);

  if (!isValidEmail(email)) {
    session.state = STATES.ASK_PATIENT_EMAIL;
    return responseForSession(session, "Email chưa hợp lệ, bạn vui lòng nhập lại ạ.");
  }

  session.collectedInfo.patientEmail = email;
  return advanceToPatientInfoOrConfirm(session);
};

const cancelSession = (
  session,
  reply = "Lịch đặt đã được hủy. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi.",
  extraData = {}
) => {
  session.state = STATES.CANCELLED;
  session.collectedInfo.doctors = [];
  session.collectedInfo.slots = [];
  session.collectedInfo.selectedDoctor = null;
  session.collectedInfo.selectedSlot = null;
  resetReadOnlyAvailability(session.collectedInfo);
  session.selectedDoctorId = null;
  session.selectedScheduleId = null;
  session.bookingId = null;
  session.collectedInfo.payment = null;
  session.collectedInfo.booking = null;

  return responseForSession(session, reply, true, extraData);
};

const cancelBookingFromSession = async (session, bookingId) => {
  const normalizedBookingId = normalizeBookingId(bookingId);
  if (!normalizedBookingId) {
    session.state = STATES.ASK_BOOKING_ID;
    return responseForSession(session, BOOKING_ID_REPLY);
  }

  const response = await cancelBookAppointment({
    BookingId: normalizedBookingId,
    patientId: session.patientId,
  });

  if (response.errCode !== 0) {
    return responseForSession(
      session,
      response.errMessage || "Không thể hủy lịch hẹn này.",
      false,
      { cancellation: { bookingId: normalizedBookingId, ...(response.data || {}) } }
    );
  }

  const cancelledBooking = {
    id: response.data?.bookingId || normalizedBookingId,
    statusId: response.data?.statusId || "S4",
    statusVi: response.data?.statusVi || null,
    statusEn: response.data?.statusEn || null,
  };
  return cancelSession(
    session,
    `Lịch hẹn ${cancelledBooking.id} đã được hủy thành công. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi.`,
    { booking: cancelledBooking, cancellation: response.data || cancelledBooking }
  );
};

const handleCancelRequest = async (session, message) => {
  const bookingId = parseBookingId(message) || getSessionBookingId(session);
  if (!bookingId) {
    session.state = STATES.ASK_BOOKING_ID;
    return responseForSession(session, BOOKING_ID_REPLY);
  }

  return cancelBookingFromSession(session, bookingId);
};

const handleAskBookingId = async (session, message) => {
  const bookingId = parseBookingId(message);
  if (!bookingId) {
    session.state = STATES.ASK_BOOKING_ID;
    return responseForSession(session, BOOKING_ID_REPLY);
  }

  return cancelBookingFromSession(session, bookingId);
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
  }, session.patientId);

  if (response.errCode !== 0) {
    return {
      success: false,
      message: response.errMessage || "Booking failed",
      raw: response,
    };
  }

  const payment = getPaymentFromBookingResponse(response);
  if (payment) {
    return {
      success: false,
      paymentRequired: true,
      payment,
      raw: response,
    };
  }

  const bookingId = response.data?.insertId || response.data?.id || null;
  if (!bookingId) {
    return {
      success: false,
      message: "Online payment is required before the booking can be confirmed.",
      raw: response,
    };
  }
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

const getPaymentFromBookingResponse = (response) =>
  response?.errCode === 0 && response.data?.payment?.paymentId
    ? response.data.payment
    : null;

const completePaidPayment = (session, payment) => {
  const bookingId = payment?.bookingId || null;
  session.bookingId = bookingId;
  session.collectedInfo.payment = payment;
  session.collectedInfo.booking = bookingId ? { id: bookingId } : null;
  session.state = STATES.BOOKING_CREATED;
  return responseForSession(
    session,
    `Thanh toán thành công. Mã lịch hẹn của bạn là ${bookingId}.`,
    true,
    { booking: session.collectedInfo.booking, payment }
  );
};

const handleWaitPayment = async (session, message) => {
  const paymentId = session.collectedInfo?.payment?.paymentId;
  if (!paymentId) {
    if (isCancelMessage(message)) {
      return handleCancelRequest(session, message);
    }
    session.state = STATES.CONFIRM_BOOKING;
    return responseForSession(session, formatConfirmReply(session));
  }

  const user = { id: session.patientId, roleId: "R3" };
  if (isCancelMessage(message)) {
    const requestedBookingId = parseBookingId(message) || getSessionBookingId(session);
    if (requestedBookingId) {
      return cancelBookingFromSession(session, requestedBookingId);
    }

    const current = await getPaymentIntent(paymentId, user);
    if (current.errCode === 0) {
      session.collectedInfo.payment = current.data;
      if (current.data?.bookingId) {
        return cancelBookingFromSession(session, current.data.bookingId);
      }
    }

    const cancelled = await cancelPaymentIntent({ paymentId, user });
    if (cancelled.errCode !== 0) {
      if (cancelled.data?.bookingId) {
        return cancelBookingFromSession(session, cancelled.data.bookingId);
      }
      return responseForSession(
        session,
        cancelled.errMessage || "Không thể hủy yêu cầu thanh toán.",
        false,
        { payment: cancelled.data || session.collectedInfo.payment }
      );
    }
    return cancelSession(
      session,
      "Yêu cầu thanh toán đã được hủy. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi."
    );
  }

  const current = await getPaymentIntent(paymentId, user);
  if (current.errCode !== 0) {
    return responseForSession(session, current.errMessage || "Không thể kiểm tra thanh toán.", false);
  }

  const payment = current.data;
  session.collectedInfo.payment = payment;
  if (payment.status === "PAID" && payment.bookingId) {
    return completePaidPayment(session, payment);
  }

  if (["EXPIRED", "FAILED", "REFUNDED"].includes(payment.status)) {
    session.state = STATES.CONFIRM_BOOKING;
    return responseForSession(
      session,
      "Mã thanh toán đã hết hiệu lực. Bạn có muốn tạo lại yêu cầu thanh toán không?",
      true,
      { payment }
    );
  }

  return responseForSession(
    session,
    "Tôi chưa nhận được thanh toán. Vui lòng quét mã QR và thử kiểm tra lại sau ít phút.",
    true,
    { payment }
  );
};

const handleCancellationMessage = async (session, message) => {
  if (session.state === STATES.WAIT_PAYMENT) {
    return handleWaitPayment(session, message);
  }

  if (DRAFT_CANCELLATION_STATES.has(session.state) && !getSessionBookingId(session)) {
    return cancelSession(
      session,
      "Yêu cầu đặt lịch đã được hủy. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi."
    );
  }

  return handleCancelRequest(session, message);
};

const handleConfirmBooking = async (session, message, aiResult = null) => {
  if (shouldBlockEmergency(message, aiResult)) {
    return emergencyResponse(session, aiResult);
  }

  if (isCancelMessage(message)) {
    return cancelSession(
      session,
      "Yêu cầu đặt lịch đã được hủy. Khi cần đặt lịch mới, bạn có thể gửi triệu chứng cho tôi."
    );
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

  if (result.paymentRequired) {
    session.bookingId = null;
    session.collectedInfo.booking = null;
    session.collectedInfo.payment = result.payment;
    session.state = STATES.WAIT_PAYMENT;
    return responseForSession(
      session,
      formatPaymentPendingReply(result.payment),
      true,
      { payment: result.payment, payment_required: true }
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

const dispatchByState = async (session, message, aiResult = null) => {
  if (shouldBlockEmergency(message, aiResult)) {
    return emergencyResponse(session, aiResult);
  }

  if ([STATES.BOOKING_CREATED, STATES.CANCELLED, STATES.ERROR].includes(session.state)) {
    session.state = STATES.START;
    session.collectedInfo = defaultCollectedInfo();
    session.selectedDoctorId = null;
    session.selectedScheduleId = null;
    session.bookingId = null;
  }

  switch (session.state) {
    case STATES.START:
      return handleStart(session, message, aiResult);
    case STATES.ASK_LOCATION:
      return handleAskLocation(session, message);
    case STATES.ASK_CONSULTATION_TYPE:
      return handleAskConsultationType(session, message);
    case STATES.ASK_AVAILABLE_DOCTOR:
      return handleAskAvailableDoctor(session, message, aiResult);
    case STATES.WAIT_SELECT_DOCTOR:
      return handleWaitSelectDoctor(session, message);
    case STATES.WAIT_SELECT_SLOT:
      return handleWaitSelectSlot(session, message);
    case STATES.SHOW_AVAILABLE_SLOTS:
      return handleShowAvailableSlots(session, message, aiResult);
    case STATES.ASK_PATIENT_NAME:
      return handleAskPatientName(session, message);
    case STATES.ASK_PATIENT_PHONE:
      return handleAskPatientPhone(session, message);
    case STATES.ASK_PATIENT_EMAIL:
      return handleAskPatientEmail(session, message);
    case STATES.ASK_BOOKING_ID:
      return handleAskBookingId(session, message);
    case STATES.CONFIRM_BOOKING:
      return handleConfirmBooking(session, message, aiResult);
    case STATES.WAIT_PAYMENT:
      return handleWaitPayment(session, message);
    default:
      session.state = STATES.START;
      return handleStart(session, message, aiResult);
  }
};

const handleChatMessage = async ({ sessionId, message, patientId, patientEmail }) => {
  const trimmedMessage = String(message || "").trim();
  const session = await getOwnedSession(sessionId, patientId);
  await hydratePatientInfo(session, patientEmail);

  if (!trimmedMessage) {
    return responseForSession(
      session,
      "Bạn vui lòng nhập nội dung tin nhắn.",
      false
    );
  }

  try {
    if (!session.title || session.title === DEFAULT_SESSION_TITLE) {
      session.title = buildSessionTitle(trimmedMessage);
    }
    await saveChatMessage(session, "user", trimmedMessage);

    const aiResult =
      session.state === STATES.WAIT_PAYMENT ||
      session.state === STATES.ASK_BOOKING_ID ||
      isCancelMessage(trimmedMessage)
        ? null
        : await analyzeMessage(trimmedMessage);
    if (aiResult) session.lastAiResult = aiResult.raw;
    const response = shouldBlockEmergency(trimmedMessage, aiResult)
      ? emergencyResponse(session, aiResult)
      : isCancelMessage(trimmedMessage)
        ? await handleCancellationMessage(session, trimmedMessage)
        : aiResult?.normalized?.intent === "CANCEL_BOOKING"
          ? await handleNonBookingIntent(session, trimmedMessage, "CANCEL_BOOKING")
        : await dispatchByState(session, trimmedMessage, aiResult);

    await saveSession(session);
    await saveChatMessage(session, "bot", response.reply, response.state, response.data);
    return response;
  } catch (error) {
    console.error("chatService.handleChatMessage error:", error);
    // ponytail: phrase-only fallback is limited to AI transport outages; FastAPI owns full context.
    if (hasEmergencyPhrase(trimmedMessage)) {
      const response = emergencyResponse(session);
      await saveSession(session);
      await saveChatMessage(session, "bot", response.reply, response.state, response.data);
      return response;
    }
    session.state = STATES.ERROR;
    const response = responseForSession(
      session,
      "Hiện tại tôi chưa kết nối được dịch vụ AI. Bạn vui lòng thử lại sau.",
      false
    );
    await saveSession(session);
    await saveChatMessage(session, "bot", response.reply, response.state, response.data);
    return response;
  }
};

module.exports = {
  responseForSession,
  isEmergencyResult,
  emergencyResponse,
  getPatientInfo,
  hydratePatientInfo,
  mergeAiResult,
  getMissingRequiredInfo,
  askForMissingInfo,
  formatDoctorsReply,
  formatSlotsReply,
  formatReadOnlySlotsReply,
  isReadOnlyAvailabilityRequest,
  isLoadMoreAvailabilityRequest,
  formatConfirmReply,
  formatPaymentPendingReply,
  parseBookingId,
  getSessionBookingId,
  getPaymentFromBookingResponse,
  completePaidPayment,
  handleWaitPayment,
  cancelBookingFromSession,
  handleCancelRequest,
  handleAskBookingId,
  handleCancellationMessage,
  findDoctorsAndReply,
  continueAfterRequiredInfo,
  handleStart,
  handleLoadMoreAvailability,
  handleAskLocation,
  handleAskConsultationType,
  handleWaitSelectDoctor,
  advanceToPatientInfoOrConfirm,
  handleWaitSelectSlot,
  handleAskPatientName,
  handleAskPatientPhone,
  handleAskPatientEmail,
  cancelSession,
  createBookingFromSession,
  handleConfirmBooking,
  dispatchByState,
  handleChatMessage,
};
