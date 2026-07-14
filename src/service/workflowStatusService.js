const { getDb } = require("./transactionService");

const LOOKUP_TYPES = Object.freeze({
  BOOKING_STATUS: "STATUS",
  VISIT_STATUS: "VISIT_STATUS",
  PAYMENT_METHOD: "PAYMENT",
  PAYMENT_STATUS: "PAYMENT_STATUS",
  MEDICAL_RECORD_STATUS: "MEDICAL_RECORD_STATUS",
  REVIEW_STATUS: "REVIEW_STATUS",
});

const BOOKING_STATUS = Object.freeze({
  PENDING: "S1",
  CONFIRMED: "S2",
  DOCTOR_CONFIRMED: "S8",
  COMPLETED: "S3",
  CANCELLED: "S4",
  CANCELLED_BY_PATIENT: "S4",
  CANCELLED_BY_DOCTOR: "S5",
  REJECTED_BY_DOCTOR: "S6",
  PATIENT_NO_SHOW: "S7",
});

const VISIT_STATUS = Object.freeze({
  WAITING: "VS1",
  IN_PROGRESS: "VS2",
  COMPLETED: "VS3",
});

const PAYMENT_STATUS = Object.freeze({
  UNPAID: "PS1",
  PAID: "PS2",
});

const MEDICAL_RECORD_STATUS = Object.freeze({
  DRAFT: "MR1",
  CLOSED: "MR2",
});

const REVIEW_STATUS = Object.freeze({
  VISIBLE: "RV1",
  HIDDEN: "RV2",
});

// Tìm một bản ghi lookup theo type và keyMap để lấy nhãn/trạng thái hợp lệ.
const getLookupByKey = async (type, keyMap, db) => {
  if (!type || !keyMap) {
    return null;
  }

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT keyMap, type, value_vi, value_en
      FROM lookup
      WHERE type = ? AND keyMap = ?
      LIMIT 1
    `,
    [type, keyMap]
  );

  return rows[0] || null;
};

// Đảm bảo key lookup tồn tại trước khi lưu vào workflow.
const assertLookupKey = async (type, keyMap, db) => {
  const lookup = await getLookupByKey(type, keyMap, db);

  if (!lookup) {
    const error = new Error(`Lookup ${type}:${keyMap} does not exist`);
    error.errCode = 2;
    throw error;
  }

  return lookup;
};

// Kiểm tra hồ sơ bệnh án đã ở trạng thái đóng hay chưa.
const isClosedMedicalRecordStatus = (statusId) =>
  statusId === MEDICAL_RECORD_STATUS.CLOSED;

module.exports = {
  LOOKUP_TYPES,
  BOOKING_STATUS,
  VISIT_STATUS,
  PAYMENT_STATUS,
  MEDICAL_RECORD_STATUS,
  REVIEW_STATUS,
  getLookupByKey,
  assertLookupKey,
  isClosedMedicalRecordStatus,
};
