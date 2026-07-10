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
const DEFAULT_SESSION_TITLE = "Cuộc trò chuyện mới";
const SESSION_ACCESS_ERROR = "Không tìm thấy cuộc trò chuyện hoặc bạn không có quyền truy cập.";

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

module.exports = {
  STATES,
  ACTIONABLE_INTENTS,
  APPOINTMENT_TYPE,
  DEFAULT_SESSION_TITLE,
  SESSION_ACCESS_ERROR,
  SPECIALTY_CODE_TO_NAMES,
  defaultCollectedInfo,
};
