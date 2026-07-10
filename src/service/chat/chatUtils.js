const moment = require("moment");
const {
  APPOINTMENT_TYPE,
  DEFAULT_SESSION_TITLE,
  SESSION_ACCESS_ERROR,
  SPECIALTY_CODE_TO_NAMES,
} = require("./chatState");

const chatDebug = (...args) => console.log("[chat-debug]", ...args);
const chatWarn = (...args) => console.warn("[chat-debug]", ...args);

const parseJson = (value, fallback) => {
  if (!value) return fallback;
  if (typeof value === "object") return value;

  try {
    return JSON.parse(value);
  } catch (error) {
    return fallback;
  }
};

const createChatError = (statusCode, message) =>
  Object.assign(new Error(message), { statusCode });

const requirePatientId = (patientId) => {
  if (!patientId) {
    throw createChatError(401, "Vui lòng đăng nhập tài khoản bệnh nhân để dùng chatbot.");
  }
};

const buildSessionTitle = (message) => {
  const title = String(message || "").replace(/\s+/g, " ").trim();
  if (!title) return DEFAULT_SESSION_TITLE;
  return title.length > 60 ? `${title.slice(0, 57)}...` : title;
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

const parseSelectionNumber = (message) => {
  const match = String(message || "").match(/\d+/);
  return match ? Number(match[0]) : null;
};

const normalizePhone = (message) => String(message || "").replace(/[^\d]/g, "");

const isValidPhone = (phone) => /^\d{9,11}$/.test(String(phone || ""));

const normalizeEmail = (message) => String(message || "").trim().toLowerCase();

const isValidEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(email || ""));

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

module.exports = {
  chatDebug,
  chatWarn,
  parseJson,
  createChatError,
  requirePatientId,
  buildSessionTitle,
  normalizeText,
  ensureArray,
  normalizeConsultationType,
  normalizeSpecialtyNames,
  getSpecialtyNameCandidates,
  getVietnamDate,
  parsePreferredDate,
  isOnlineConsultation,
  getAppointmentTypeId,
  formatDate,
  splitTimeRange,
  parseMoney,
  buildDoctorName,
  parseSelectionNumber,
  normalizePhone,
  isValidPhone,
  normalizeEmail,
  isValidEmail,
  isCancelMessage,
  isConfirmMessage,
  splitPatientName,
};
