const connection = require("../../config/data");
const { analyzeMessage } = require("../fastApiAiService");
const { bookAppointment } = require("../PatientService");
const {
  STATES,
  ACTIONABLE_INTENTS,
  DEFAULT_SESSION_TITLE,
  defaultCollectedInfo,
} = require("./chatState");
const {
  chatDebug,
  normalizeConsultationType,
  normalizeSpecialtyNames,
  ensureArray,
  parsePreferredDate,
  isOnlineConsultation,
  parseSelectionNumber,
  normalizePhone,
  isValidPhone,
  normalizeEmail,
  isValidEmail,
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
  getAvailableSlotsForDoctor,
} = require("./chatDoctorSearchService");

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

    const response = isCancelMessage(trimmedMessage)
      ? cancelSession(session)
      : await dispatchByState(session, trimmedMessage);

    await saveSession(session);
    await saveChatMessage(session, "bot", response.reply, response.state, response.data);
    return response;
  } catch (error) {
    console.error("chatService.handleChatMessage error:", error);
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
  getPatientInfo,
  hydratePatientInfo,
  mergeAiResult,
  getMissingRequiredInfo,
  askForMissingInfo,
  formatDoctorsReply,
  formatSlotsReply,
  formatConfirmReply,
  findDoctorsAndReply,
  continueAfterRequiredInfo,
  handleStart,
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
