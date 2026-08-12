const STATES = Object.freeze({
  START: "START",
  ASK_LOCATION: "ASK_LOCATION",
  ASK_CONSULTATION_TYPE: "ASK_CONSULTATION_TYPE",
  ASK_AVAILABLE_DOCTOR: "ASK_AVAILABLE_DOCTOR",
  WAIT_SELECT_DOCTOR: "WAIT_SELECT_DOCTOR",
  WAIT_SELECT_SLOT: "WAIT_SELECT_SLOT",
  SHOW_AVAILABLE_SLOTS: "SHOW_AVAILABLE_SLOTS",
  ASK_PATIENT_NAME: "ASK_PATIENT_NAME",
  ASK_PATIENT_PHONE: "ASK_PATIENT_PHONE",
  ASK_PATIENT_EMAIL: "ASK_PATIENT_EMAIL",
  ASK_BOOKING_ID: "ASK_BOOKING_ID",
  CONFIRM_BOOKING: "CONFIRM_BOOKING",
  BOOKING_CREATED: "BOOKING_CREATED",
  CANCELLED: "CANCELLED",
  ERROR: "ERROR",
});

const SUPPORTED_INTENTS = new Set([
  "GREETING",
  "FIND_DOCTOR",
  "ASK_AVAILABLE_SLOT",
  "BOOK_APPOINTMENT",
  "CONFIRM_BOOKING",
  "CANCEL_BOOKING",
  "PROVIDE_INFO",
  "OUT_OF_SCOPE",
  "EMERGENCY",
]);
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
  doctor_name: null,
  preferred_date: null,
  preferred_time: null,
  debugReason: null,
  reason: null,
  doctors: [],
  slots: [],
  readOnlyAvailability: {
    doctorId: null,
    doctor: null,
    offset: 0,
    hasMore: false,
  },
  selectedDoctor: null,
  selectedSlot: null,
  patientName: null,
  patientPhone: null,
  patientEmail: null,
  booking: null,
});

module.exports = {
  STATES,
  SUPPORTED_INTENTS,
  ACTIONABLE_INTENTS,
  APPOINTMENT_TYPE,
  DEFAULT_SESSION_TITLE,
  SESSION_ACCESS_ERROR,
  SPECIALTY_CODE_TO_NAMES,
  defaultCollectedInfo,
};
