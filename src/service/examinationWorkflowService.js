const { getDb, withTransaction } = require("./transactionService");
const { sendRemedy } = require("./DoctorService");
const {
  ensureVideoSessionForOnlineBookingInCurrentTransaction,
  markVideoSessionEndedForBookingInCurrentTransaction,
} = require("./videoConsultationService");
const {
  BOOKING_STATUS,
  LOOKUP_TYPES,
  VISIT_STATUS,
  PAYMENT_STATUS,
  MEDICAL_RECORD_STATUS,
  assertLookupKey,
  isClosedMedicalRecordStatus,
} = require("./workflowStatusService");

// Chuẩn hóa id bắt buộc và báo lỗi nếu thiếu hoặc không hợp lệ.
const normalizePositiveId = (value, fieldName) => {
  const normalized = Number(value);
  if (Number.isInteger(normalized) && normalized > 0) {
    return normalized;
  }

  const error = new Error(`Missing required parameter: ${fieldName}`);
  error.errCode = 1;
  throw error;
};

// Chuẩn hóa chuỗi tùy chọn, giữ undefined để phân biệt field không gửi lên.
const normalizeOptionalString = (value) => {
  if (value === undefined) return undefined;
  if (value === null) return null;

  const normalized = String(value).trim();
  return normalized === "" ? null : normalized;
};

// Chuẩn hóa số thập phân tùy chọn cho các chỉ số sinh hiệu.
const normalizeOptionalDecimal = (value, fieldName) => {
  if (value === undefined) return undefined;
  if (value === null || String(value).trim() === "") return null;

  const normalized = Number(value);
  if (!Number.isFinite(normalized)) {
    const error = new Error(`Invalid numeric value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return normalized;
};

// Chuẩn hóa số nguyên tùy chọn cho các chỉ số cần là số nguyên.
const normalizeOptionalInteger = (value, fieldName) => {
  if (value === undefined) return undefined;
  if (value === null || String(value).trim() === "") return null;

  const normalized = Number(value);
  if (!Number.isInteger(normalized)) {
    const error = new Error(`Invalid integer value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return normalized;
};

// Chuẩn hóa số thập phân không âm cho số lượng thuốc/tiền.
const normalizeNonNegativeOptionalDecimal = (value, fieldName) => {
  const normalized = normalizeOptionalDecimal(value, fieldName);
  if (normalized !== undefined && normalized !== null && normalized < 0) {
    const error = new Error(`Invalid non-negative numeric value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return normalized;
};

// Chuẩn hóa số nguyên không âm cho số ngày dùng thuốc.
const normalizeNonNegativeOptionalInteger = (value, fieldName) => {
  const normalized = normalizeOptionalInteger(value, fieldName);
  if (normalized !== undefined && normalized !== null && normalized < 0) {
    const error = new Error(`Invalid non-negative integer value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return normalized;
};

// Đổi giá trị rỗng thành 0 khi tính tổng số lượng thuốc.
const toQuantityNumber = (value) => (value === undefined || value === null ? 0 : Number(value));

// Chuẩn hóa số tiền tùy chọn và làm tròn về đơn vị tiền lưu DB.
const normalizeOptionalMoney = (value, fieldName) => {
  if (value === undefined) return undefined;
  if (value === null || String(value).trim() === "") return null;

  const normalized = Number(value);
  if (!Number.isFinite(normalized) || normalized < 0) {
    const error = new Error(`Invalid money value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return Math.round(normalized);
};

// Chuẩn hóa ngày tùy chọn theo định dạng YYYY-MM-DD.
const normalizeOptionalDate = (value, fieldName) => {
  if (value === undefined) return undefined;
  if (value === null || String(value).trim() === "") return null;

  const normalized = String(value).trim();
  if (!/^\d{4}-\d{2}-\d{2}$/.test(normalized)) {
    const error = new Error(`Invalid date value: ${fieldName}`);
    error.errCode = 1;
    throw error;
  }

  return normalized;
};

// Kiểm tra payload có thật sự gửi field đó lên hay không.
const hasOwn = (source, fieldName) =>
  Object.prototype.hasOwnProperty.call(source || {}, fieldName);

// Nhận diện lỗi trùng khóa để xử lý các thao tác tạo dữ liệu idempotent.
const isDuplicateEntryError = (error) => error && error.code === "ER_DUP_ENTRY";

// Sinh mã toa thuốc ổn định theo id hồ sơ bệnh án.
const buildPrescriptionCode = (medicalRecordId) =>
  `RX-${String(medicalRecordId).padStart(8, "0")}`;

const MEDICAL_RECORD_TEXT_FIELDS = Object.freeze([
  "bloodPressure",
  "symptoms",
  "preliminaryDiagnosis",
  "doctorConclusion",
  "generalNote",
]);

const MEDICAL_RECORD_DECIMAL_FIELDS = Object.freeze([
  "heightCm",
  "weightKg",
  "bmi",
]);

const MEDICAL_RECORD_INTEGER_FIELDS = Object.freeze([
  "pulsePerMinute",
  "respiratoryRate",
]);

const MEDICAL_RECORD_DATE_FIELDS = Object.freeze(["followUpDate"]);

// Lấy ngữ cảnh booking để tạo lượt khám: bệnh nhân, bác sĩ, ngày khám và STT.
const getBookingVisitContext = async (bookingId, db, options = {}) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        b.id AS bookingId,
        b.patientId,
        b.scheduleId,
        b.date AS examDate,
        b.statusId AS bookingStatusId,
        b.priceAtBooking,
        s.doctorId,
        bq.id AS bookingQueueId,
        bq.queueNumber
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      LEFT JOIN booking_queue bq
        ON bq.bookingId = b.id
      WHERE b.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

// Lấy lượt khám theo bookingId, có thể khóa dòng để cập nhật an toàn trong transaction.
const getExaminationVisitByBookingId = async (bookingId, db, options = {}) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM examination_visit
      WHERE bookingId = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

// Lấy lượt khám theo examinationVisitId, có thể khóa dòng khi cần cập nhật trạng thái.
const getExaminationVisitById = async (examinationVisitId, db, options = {}) => {
  const normalizedVisitId = normalizePositiveId(examinationVisitId, "examinationVisitId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM examination_visit
      WHERE id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedVisitId]
  );

  return rows[0] || null;
};

// Kiểm tra booking đủ điều kiện tạo lượt khám: đã xác nhận và đã có STT.
const requireBookingVisitContext = async (bookingId, db) => {
  const context = await getBookingVisitContext(bookingId, db, { forUpdate: true });

  if (!context) {
    const error = new Error("Booking not found");
    error.errCode = 2;
    throw error;
  }

  if (context.bookingStatusId !== BOOKING_STATUS.CONFIRMED) {
    const error = new Error("Booking is not confirmed");
    error.errCode = 3;
    throw error;
  }

  if (!context.bookingQueueId || !context.queueNumber) {
    const error = new Error("Booking queue number has not been assigned");
    error.errCode = 4;
    throw error;
  }

  return context;
};

// Tạo lượt khám cho booking trong transaction hiện tại nếu chưa có.
const ensureExaminationVisitForBookingInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const bookingId = normalizePositiveId(data?.bookingId, "bookingId");
  const context = await requireBookingVisitContext(bookingId, executor);

  if (data?.doctorId && Number(data.doctorId) !== Number(context.doctorId)) {
    const error = new Error("Booking does not belong to this doctor");
    error.errCode = 403;
    throw error;
  }

  const existingVisit = await getExaminationVisitByBookingId(bookingId, executor, {
    forUpdate: true,
  });

  if (existingVisit) {
    return { created: false, data: existingVisit };
  }

  try {
    // Tạo lượt khám ở trạng thái chờ, kế thừa ngày khám và STT từ booking_queue.
    const [insertResult] = await executor.query(
      `
        INSERT INTO examination_visit
          (bookingId, patientId, doctorId, examDate, queueNumber, statusId, paymentStatusId)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        context.bookingId,
        context.patientId,
        context.doctorId,
        context.examDate,
        context.queueNumber,
        VISIT_STATUS.WAITING,
        PAYMENT_STATUS.UNPAID,
      ]
    );

    const visit = await getExaminationVisitById(insertResult.insertId, executor, {
      forUpdate: true,
    });

    return { created: true, data: visit };
  } catch (error) {
    if (!isDuplicateEntryError(error)) {
      throw error;
    }

    // Nếu transaction khác vừa tạo visit, đọc lại để đảm bảo thao tác idempotent.
    const visit = await getExaminationVisitByBookingId(bookingId, executor, {
      forUpdate: true,
    });

    if (visit) {
      return { created: false, data: visit };
    }

    throw error;
  }
};

// Tạo lượt khám cho booking, tự mở transaction nếu caller chưa truyền transaction.
const ensureExaminationVisitForBooking = async (data, db) => {
  if (db) {
    return ensureExaminationVisitForBookingInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    ensureExaminationVisitForBookingInCurrentTransaction(data, transactionDb)
  );
};

// Bắt đầu lượt khám từ booking và đảm bảo hồ sơ bệnh án nháp đã sẵn sàng.
const startExaminationVisitForBookingInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const result = await ensureExaminationVisitForBookingInCurrentTransaction(data, executor);
  const visit = result.data;

  if (!visit) {
    return { ...result, started: false };
  }

  let currentVisit = visit;
  let started = false;

  // Chỉ chuyển VS1 -> VS2 một lần; lượt đã bắt đầu thì giữ nguyên trạng thái hiện tại.
  if (visit.statusId === VISIT_STATUS.WAITING) {
    await executor.query(
      `
        UPDATE examination_visit
        SET statusId = ?, startedAt = COALESCE(startedAt, CURRENT_TIMESTAMP)
        WHERE id = ? AND statusId = ?
      `,
      [VISIT_STATUS.IN_PROGRESS, visit.id, VISIT_STATUS.WAITING]
    );

    currentVisit = await getExaminationVisitById(visit.id, executor, {
      forUpdate: true,
    });
    started = true;
  }

  // Sau khi lượt khám bắt đầu, tạo medical_record nháp nếu chưa có.
  const recordResult = await ensureMedicalRecordForVisitInCurrentTransaction(
    {
      examinationVisitId: currentVisit.id,
      doctorId: data?.doctorId,
    },
    executor
  );
  const record = recordResult.data || {};
  const videoSession = await ensureVideoSessionForOnlineBookingInCurrentTransaction(
    currentVisit.bookingId,
    executor
  );

  return {
    created: result.created,
    started,
    recordCreated: recordResult.created,
    videoSessionCreated: Boolean(videoSession?.sessionId),
    data: {
      ...currentVisit,
      medicalRecordId: record.id || null,
      medicalRecordStatusId: record.statusId || null,
      videoSessionId: videoSession?.sessionId || null,
      videoRoomId: videoSession?.roomId || null,
      videoSessionStatusId: videoSession?.videoSessionStatusId || null,
    },
  };
};

// Bắt đầu lượt khám, tự mở transaction nếu caller chưa truyền transaction.
const startExaminationVisitForBooking = async (data, db) => {
  if (db) {
    return startExaminationVisitForBookingInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    startExaminationVisitForBookingInCurrentTransaction(data, transactionDb)
  );
};

// Lấy hồ sơ bệnh án theo examinationVisitId.
const getMedicalRecordByVisitId = async (examinationVisitId, db, options = {}) => {
  const normalizedVisitId = normalizePositiveId(examinationVisitId, "examinationVisitId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM medical_record
      WHERE examinationVisitId = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedVisitId]
  );

  return rows[0] || null;
};

// Lấy hồ sơ bệnh án theo bookingId.
const getMedicalRecordByBookingId = async (bookingId, db, options = {}) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM medical_record
      WHERE bookingId = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

// Lấy hồ sơ bệnh án theo medicalRecordId.
const getMedicalRecordById = async (medicalRecordId, db, options = {}) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM medical_record
      WHERE id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedRecordId]
  );

  return rows[0] || null;
};

// Lấy ngữ cảnh lượt khám và bệnh nhân để tạo hoặc kiểm tra hồ sơ bệnh án.
const getVisitRecordContext = async (examinationVisitId, db, options = {}) => {
  const normalizedVisitId = normalizePositiveId(examinationVisitId, "examinationVisitId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        ev.id AS examinationVisitId,
        ev.bookingId,
        ev.patientId,
        ev.doctorId,
        ev.examDate,
        ev.queueNumber,
        ev.statusId AS visitStatusId,
        u.firstName,
        u.lastName,
        u.gender,
        u.phoneNumber,
        u.address
      FROM examination_visit ev
      INNER JOIN users u
        ON u.id = ev.patientId
      WHERE ev.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedVisitId]
  );

  return rows[0] || null;
};

// Tạo hồ sơ bệnh án nháp cho lượt khám trong transaction hiện tại nếu chưa có.
const ensureMedicalRecordForVisitInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const examinationVisitId = normalizePositiveId(data?.examinationVisitId, "examinationVisitId");
  const context = await getVisitRecordContext(examinationVisitId, executor, {
    forUpdate: true,
  });

  if (!context) {
    const error = new Error("Examination visit not found");
    error.errCode = 2;
    throw error;
  }

  if (data?.doctorId && Number(data.doctorId) !== Number(context.doctorId)) {
    const error = new Error("Visit does not belong to this doctor");
    error.errCode = 403;
    throw error;
  }

  if (context.visitStatusId === VISIT_STATUS.WAITING) {
    const error = new Error("Visit must be started before creating medical record");
    error.errCode = 409;
    throw error;
  }

  const existingByVisit = await getMedicalRecordByVisitId(examinationVisitId, executor, {
    forUpdate: true,
  });

  if (existingByVisit) {
    return { created: false, data: existingByVisit };
  }

  // Chống dữ liệu cũ: nếu booking đã có medical_record thì tái sử dụng thay vì tạo trùng.
  const existingByBooking = await getMedicalRecordByBookingId(context.bookingId, executor, {
    forUpdate: true,
  });

  if (existingByBooking) {
    return { created: false, data: existingByBooking };
  }

  try {
    // Tạo record nháp MR1 gắn với booking, lượt khám, bệnh nhân và bác sĩ.
    const [insertResult] = await executor.query(
      `
        INSERT INTO medical_record
          (
            bookingId,
            examinationVisitId,
            patientId,
            doctorId,
            statusId
          )
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        context.bookingId,
        context.examinationVisitId,
        context.patientId,
        context.doctorId,
        MEDICAL_RECORD_STATUS.DRAFT,
      ]
    );

    const [rows] = await executor.query(
      `
        SELECT *
        FROM medical_record
        WHERE id = ?
        LIMIT 1
        FOR UPDATE
      `,
      [insertResult.insertId]
    );

    return { created: true, data: rows[0] || null };
  } catch (error) {
    if (!isDuplicateEntryError(error)) {
      throw error;
    }

    // Nếu bị trùng khóa do race-condition, đọc lại record vừa được tạo.
    const record = await getMedicalRecordByVisitId(examinationVisitId, executor, {
      forUpdate: true,
    });

    if (record) {
      return { created: false, data: record };
    }

    throw error;
  }
};

// Tạo hồ sơ bệnh án cho lượt khám, tự mở transaction nếu cần.
const ensureMedicalRecordForVisit = async (data, db) => {
  if (db) {
    return ensureMedicalRecordForVisitInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    ensureMedicalRecordForVisitInCurrentTransaction(data, transactionDb)
  );
};

// Khóa và kiểm tra hồ sơ bệnh án còn được phép chỉnh sửa hay không.
const assertMedicalRecordEditable = async (medicalRecordId, db) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT id, bookingId, patientId, doctorId, statusId
      FROM medical_record
      WHERE id = ?
      LIMIT 1
      FOR UPDATE
    `,
    [normalizedRecordId]
  );

  if (rows.length === 0) {
    const error = new Error("Medical record not found");
    error.errCode = 2;
    throw error;
  }

  if (isClosedMedicalRecordStatus(rows[0].statusId)) {
    const error = new Error("Medical record is closed");
    error.errCode = 409;
    throw error;
  }

  return rows[0];
};

// Lấy source draft từ data.draft nếu FE gửi dạng bọc, ngược lại dùng trực tiếp data.
const getMedicalRecordDraftSource = (data = {}) =>
  data?.draft && typeof data.draft === "object" ? data.draft : data;

// Tạo object các field medical_record cần cập nhật từ payload nháp.
const buildMedicalRecordDraftUpdates = (data = {}) => {
  const source = getMedicalRecordDraftSource(data);
  const updates = {};

  MEDICAL_RECORD_TEXT_FIELDS.forEach((fieldName) => {
    if (hasOwn(source, fieldName)) {
      updates[fieldName] = normalizeOptionalString(source[fieldName]);
    }
  });

  MEDICAL_RECORD_DECIMAL_FIELDS.forEach((fieldName) => {
    if (hasOwn(source, fieldName)) {
      updates[fieldName] = normalizeOptionalDecimal(source[fieldName], fieldName);
    }
  });

  MEDICAL_RECORD_INTEGER_FIELDS.forEach((fieldName) => {
    if (hasOwn(source, fieldName)) {
      updates[fieldName] = normalizeOptionalInteger(source[fieldName], fieldName);
    }
  });

  MEDICAL_RECORD_DATE_FIELDS.forEach((fieldName) => {
    if (hasOwn(source, fieldName)) {
      updates[fieldName] = normalizeOptionalDate(source[fieldName], fieldName);
    }
  });

  return updates;
};

// Kiểm tra payload có ít nhất một field nháp hợp lệ để cập nhật hay không.
const hasMedicalRecordDraftUpdates = (data = {}) =>
  Object.keys(buildMedicalRecordDraftUpdates(data)).length > 0;

// Cập nhật nháp hồ sơ bệnh án trong transaction hiện tại.
const updateMedicalRecordDraftInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");
  await assertMedicalRecordEditable(medicalRecordId, executor);

  const updates = buildMedicalRecordDraftUpdates(data);
  const fieldNames = Object.keys(updates);
  if (fieldNames.length === 0) {
    return getMedicalRecordById(medicalRecordId, executor, { forUpdate: true });
  }

  // Chỉ SET những field FE thật sự gửi lên để tránh ghi đè dữ liệu không liên quan.
  const setClause = fieldNames.map((fieldName) => `${fieldName} = ?`).join(", ");
  await executor.query(
    `
      UPDATE medical_record
      SET ${setClause}, updatedAt = CURRENT_TIMESTAMP
      WHERE id = ?
    `,
    [...fieldNames.map((fieldName) => updates[fieldName]), medicalRecordId]
  );

  return getMedicalRecordById(medicalRecordId, executor, { forUpdate: true });
};

// Cập nhật nháp hồ sơ bệnh án, tự mở transaction nếu cần.
const updateMedicalRecordDraft = async (data, db) => {
  if (db) {
    return updateMedicalRecordDraftInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    updateMedicalRecordDraftInCurrentTransaction(data, transactionDb)
  );
};

// Lấy hoặc tạo header toa thuốc cho hồ sơ bệnh án trong transaction hiện tại.
const getOrCreatePrescriptionForRecordInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");
  const record = await assertMedicalRecordEditable(medicalRecordId, executor);

  const [existingRows] = await executor.query(
    `
      SELECT *
      FROM prescription
      WHERE medicalRecordId = ?
      LIMIT 1
      FOR UPDATE
    `,
    [medicalRecordId]
  );

  if (existingRows.length > 0) {
    return { created: false, data: existingRows[0] };
  }

  const prescriptionCode = buildPrescriptionCode(medicalRecordId);
  const [insertResult] = await executor.query(
    `
      INSERT INTO prescription
        (medicalRecordId, patientId, doctorId, prescriptionCode, note)
      VALUES (?, ?, ?, ?, ?)
    `,
    [
      medicalRecordId,
      record.patientId,
      record.doctorId,
      prescriptionCode,
      normalizeOptionalString(data?.note) || null,
    ]
  );

  const [rows] = await executor.query(
    `
      SELECT *
      FROM prescription
      WHERE id = ?
      LIMIT 1
    `,
    [insertResult.insertId]
  );

  return { created: true, data: rows[0] || null };
};

// Lấy hoặc tạo header toa thuốc, tự mở transaction nếu cần.
const getOrCreatePrescriptionForRecord = async (data, db) => {
  if (db) {
    return getOrCreatePrescriptionForRecordInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    getOrCreatePrescriptionForRecordInCurrentTransaction(data, transactionDb)
  );
};

// Kiểm tra một dòng thuốc có dữ liệu đáng lưu hay chỉ là dòng rỗng trên UI.
const hasAnyPrescriptionItemValue = (item = {}) =>
  [
    "medicineName",
    "dosageForm",
    "usageDays",
    "morningQty",
    "noonQty",
    "afternoonQty",
    "eveningQty",
    "totalQuantity",
    "instruction",
  ].some((fieldName) => {
    const normalized = normalizeOptionalString(item[fieldName]);
    return normalized !== undefined && normalized !== null;
  });

// Chuẩn hóa một dòng thuốc và tính tổng số lượng theo số ngày x các cữ dùng.
const normalizePrescriptionItem = (item = {}) => {
  if (!hasAnyPrescriptionItemValue(item)) {
    return null;
  }

  const medicineName = normalizeOptionalString(item.medicineName);
  if (!medicineName) {
    const error = new Error("Missing required parameter: medicineName");
    error.errCode = 1;
    throw error;
  }

  const usageDays = normalizeNonNegativeOptionalInteger(item.usageDays, "usageDays");
  const morningQty = normalizeNonNegativeOptionalDecimal(item.morningQty, "morningQty");
  const noonQty = normalizeNonNegativeOptionalDecimal(item.noonQty, "noonQty");
  const afternoonQty = normalizeNonNegativeOptionalDecimal(item.afternoonQty, "afternoonQty");
  const eveningQty = normalizeNonNegativeOptionalDecimal(item.eveningQty, "eveningQty");
  const normalizedUsageDays = toQuantityNumber(usageDays);
  const normalizedMorningQty = toQuantityNumber(morningQty);
  const normalizedNoonQty = toQuantityNumber(noonQty);
  const normalizedAfternoonQty = toQuantityNumber(afternoonQty);
  const normalizedEveningQty = toQuantityNumber(eveningQty);
  const totalQuantity =
    normalizedUsageDays *
    (normalizedMorningQty + normalizedNoonQty + normalizedAfternoonQty + normalizedEveningQty);

  // Payload trả về đã sạch dữ liệu rỗng và sẵn sàng insert vào prescription_item.
  return {
    medicineName,
    dosageForm: normalizeOptionalString(item.dosageForm) || null,
    usageDays: normalizedUsageDays,
    morningQty: normalizedMorningQty,
    noonQty: normalizedNoonQty,
    afternoonQty: normalizedAfternoonQty,
    eveningQty: normalizedEveningQty,
    totalQuantity,
    instruction: normalizeOptionalString(item.instruction) || null,
  };
};

// Chuẩn hóa danh sách thuốc, bỏ các dòng hoàn toàn rỗng.
const normalizePrescriptionItems = (items = []) => {
  if (!Array.isArray(items)) {
    const error = new Error("Invalid prescription items");
    error.errCode = 1;
    throw error;
  }

  return items.map(normalizePrescriptionItem).filter(Boolean);
};

// Kiểm tra payload toa thuốc có note hoặc ít nhất một dòng thuốc có dữ liệu.
const hasPrescriptionPayloadData = (data = {}) => {
  const note = normalizeOptionalString(data?.note);
  if (note !== undefined && note !== null) {
    return true;
  }

  return Array.isArray(data?.items) && data.items.some(hasAnyPrescriptionItemValue);
};

// Lấy toa thuốc kèm toàn bộ dòng thuốc theo prescriptionId.
const getPrescriptionWithItems = async (prescriptionId, db) => {
  const normalizedPrescriptionId = normalizePositiveId(prescriptionId, "prescriptionId");
  const executor = getDb(db);
  const [prescriptionRows] = await executor.query(
    `
      SELECT *
      FROM prescription
      WHERE id = ?
      LIMIT 1
    `,
    [normalizedPrescriptionId]
  );

  if (prescriptionRows.length === 0) {
    return null;
  }

  const [itemRows] = await executor.query(
    `
      SELECT *
      FROM prescription_item
      WHERE prescriptionId = ?
      ORDER BY id ASC
    `,
    [normalizedPrescriptionId]
  );

  return {
    ...prescriptionRows[0],
    items: itemRows || [],
  };
};

// Lưu toa thuốc cho hồ sơ: cập nhật note, xóa dòng cũ và insert lại danh sách mới.
const savePrescriptionForRecordInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");
  await assertMedicalRecordEditable(medicalRecordId, executor);

  const result = await getOrCreatePrescriptionForRecordInCurrentTransaction(data, executor);
  const prescription = result.data;
  const items = normalizePrescriptionItems(data?.items || []);

  // Header toa thuốc được giữ lại, chỉ cập nhật note và thời điểm chỉnh sửa.
  await executor.query(
    `
      UPDATE prescription
      SET note = ?, updatedAt = CURRENT_TIMESTAMP
      WHERE id = ?
    `,
    [normalizeOptionalString(data?.note) || null, prescription.id]
  );

  await executor.query("DELETE FROM prescription_item WHERE prescriptionId = ?", [
    prescription.id,
  ]);

  // Danh sách thuốc được thay thế toàn bộ để đồng bộ đúng payload hiện tại từ UI.
  for (const item of items) {
    await executor.query(
      `
        INSERT INTO prescription_item
          (
            prescriptionId,
            medicineName,
            dosageForm,
            usageDays,
            morningQty,
            noonQty,
            afternoonQty,
            eveningQty,
            totalQuantity,
            instruction
          )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        prescription.id,
        item.medicineName,
        item.dosageForm,
        item.usageDays,
        item.morningQty,
        item.noonQty,
        item.afternoonQty,
        item.eveningQty,
        item.totalQuantity,
        item.instruction,
      ]
    );
  }

  return getPrescriptionWithItems(prescription.id, executor);
};

// Lưu toa thuốc, tự mở transaction nếu cần.
const savePrescriptionForRecord = async (data, db) => {
  if (db) {
    return savePrescriptionForRecordInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    savePrescriptionForRecordInCurrentTransaction(data, transactionDb)
  );
};

// Tạo một kết quả cận lâm sàng cho hồ sơ trong transaction hiện tại.
const createParaclinicalResultInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");
  await assertMedicalRecordEditable(medicalRecordId, executor);

  const name = normalizeOptionalString(data?.name);
  if (!name) {
    const error = new Error("Missing required parameter: name");
    error.errCode = 1;
    throw error;
  }

  const [insertResult] = await executor.query(
    `
      INSERT INTO paraclinical_result
        (medicalRecordId, type, name, resultSummary, note)
      VALUES (?, ?, ?, ?, ?)
    `,
    [
      medicalRecordId,
      normalizeOptionalString(data?.type) || null,
      name,
      normalizeOptionalString(data?.resultSummary) || null,
      normalizeOptionalString(data?.note) || null,
    ]
  );

  const [rows] = await executor.query(
    `
      SELECT *
      FROM paraclinical_result
      WHERE id = ?
      LIMIT 1
    `,
    [insertResult.insertId]
  );

  return rows[0] || null;
};

// Tạo một kết quả cận lâm sàng, tự mở transaction nếu cần.
const createParaclinicalResult = async (data, db) => {
  if (db) {
    return createParaclinicalResultInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    createParaclinicalResultInCurrentTransaction(data, transactionDb)
  );
};

// Kiểm tra một dòng cận lâm sàng có dữ liệu đáng lưu hay không.
const hasAnyParaclinicalValue = (item = {}) =>
  ["type", "name", "resultSummary", "note"].some((fieldName) => {
    const normalized = normalizeOptionalString(item[fieldName]);
    return normalized !== undefined && normalized !== null;
  });

// Chuẩn hóa một dòng cận lâm sàng và bắt buộc có tên chỉ định/kết quả.
const normalizeParaclinicalItem = (item = {}) => {
  if (!hasAnyParaclinicalValue(item)) {
    return null;
  }

  const name = normalizeOptionalString(item.name);
  if (!name) {
    const error = new Error("Missing required parameter: name");
    error.errCode = 1;
    throw error;
  }

  return {
    type: normalizeOptionalString(item.type) || null,
    name,
    resultSummary: normalizeOptionalString(item.resultSummary) || null,
    note: normalizeOptionalString(item.note) || null,
  };
};

// Chuẩn hóa danh sách cận lâm sàng, bỏ các dòng trống.
const normalizeParaclinicalItems = (items = []) => {
  if (!Array.isArray(items)) {
    const error = new Error("Invalid paraclinical results");
    error.errCode = 1;
    throw error;
  }

  return items.map(normalizeParaclinicalItem).filter(Boolean);
};

// Lấy danh sách kết quả cận lâm sàng của hồ sơ theo thứ tự tạo.
const getParaclinicalResultsForRecord = async (medicalRecordId, db) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM paraclinical_result
      WHERE medicalRecordId = ?
      ORDER BY createdAt ASC, id ASC
    `,
    [normalizedRecordId]
  );

  return rows || [];
};

// Lưu lại toàn bộ danh sách cận lâm sàng cho hồ sơ trong transaction hiện tại.
const saveParaclinicalResultsForRecordInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");
  await assertMedicalRecordEditable(medicalRecordId, executor);

  const items = normalizeParaclinicalItems(data?.items || data?.paraclinicalResults || []);

  // Thay thế toàn bộ danh sách để dữ liệu DB khớp đúng payload hiện tại từ UI.
  await executor.query("DELETE FROM paraclinical_result WHERE medicalRecordId = ?", [
    medicalRecordId,
  ]);

  for (const item of items) {
    await executor.query(
      `
        INSERT INTO paraclinical_result
          (medicalRecordId, type, name, resultSummary, note)
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        medicalRecordId,
        item.type,
        item.name,
        item.resultSummary,
        item.note,
      ]
    );
  }

  return getParaclinicalResultsForRecord(medicalRecordId, executor);
};

// Lưu danh sách cận lâm sàng, tự mở transaction nếu cần.
const saveParaclinicalResultsForRecord = async (data, db) => {
  if (db) {
    return saveParaclinicalResultsForRecordInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    saveParaclinicalResultsForRecordInCurrentTransaction(data, transactionDb)
  );
};

// Lấy ngữ cảnh hồ sơ và lượt khám để kiểm tra điều kiện hoàn tất/đóng hồ sơ.
const getMedicalRecordVisitContext = async (medicalRecordId, db, options = {}) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        mr.*,
        ev.statusId AS visitStatusId,
        ev.paymentStatusId,
        ev.completedAt AS visitCompletedAt
      FROM medical_record mr
      INNER JOIN examination_visit ev
        ON ev.id = mr.examinationVisitId
      WHERE mr.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedRecordId]
  );

  return rows[0] || null;
};

// Lấy lượt khám liên kết với một hồ sơ bệnh án.
const getExaminationVisitForRecord = async (medicalRecordId, db) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT ev.*
      FROM examination_visit ev
      INNER JOIN medical_record mr
        ON mr.examinationVisitId = ev.id
      WHERE mr.id = ?
      LIMIT 1
    `,
    [normalizedRecordId]
  );

  return rows[0] || null;
};

// Đánh dấu booking hoàn tất khi lượt khám tương ứng đã hoàn tất.
const markBookingCompletedForVisitInCurrentTransaction = async (context, db) => {
  if (!context?.bookingId) return;

  await db.query(
    `
      UPDATE booking
      SET statusId = ?
      WHERE id = ? AND statusId = ?
    `,
    [BOOKING_STATUS.COMPLETED, context.bookingId, BOOKING_STATUS.CONFIRMED]
  );
  await markVideoSessionEndedForBookingInCurrentTransaction(context.bookingId, db);
};

// Định dạng ngày gửi trong email kết quả khám.
const formatEmailDate = (value) => {
  if (!value) return "";
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return value.toISOString().slice(0, 10);
  }

  return String(value).slice(0, 10);
};

// Ghép ngày khám và khung giờ thành chuỗi hiển thị trong email kết quả.
const buildResultEmailTime = (context = {}) =>
  [formatEmailDate(context.examDate), context.timeTypeVi || context.timeTypeEn || context.timeType]
    .filter(Boolean)
    .join(" - ");

// Chuẩn bị payload email kết quả khám sau khi lượt khám hoàn tất.
const getCompletedVisitResultEmailPayload = async (medicalRecordId) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId, "medicalRecordId");
  const executor = getDb();
  const [rows] = await executor.query(
    `
      SELECT
        mr.id AS medicalRecordId,
        mr.bookingId,
        mr.doctorConclusion,
        mr.followUpDate,
        b.reason,
        b.date AS examDate,
        s.timeType,
        lt.value_vi AS timeTypeVi,
        lt.value_en AS timeTypeEn,
        patient.email AS patientEmail,
        patient.firstName AS patientFirstName,
        patient.lastName AS patientLastName
      FROM medical_record mr
      INNER JOIN booking b
        ON b.id = mr.bookingId
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      INNER JOIN users patient
        ON patient.id = mr.patientId
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE mr.id = ?
      LIMIT 1
    `,
    [normalizedRecordId]
  );

  const context = rows[0];
  if (!context || !context.patientEmail) {
    return null;
  }

  // Nạp toa thuốc và kết quả cận lâm sàng để email có đủ nội dung điều trị.
  const [prescriptionItems] = await executor.query(
    `
      SELECT
        pi.medicineName,
        pi.morningQty,
        pi.noonQty,
        pi.afternoonQty,
        pi.eveningQty,
        pi.dosageForm,
        pi.instruction
      FROM prescription p
      INNER JOIN prescription_item pi
        ON pi.prescriptionId = p.id
      WHERE p.medicalRecordId = ?
      ORDER BY pi.id ASC
    `,
    [normalizedRecordId]
  );

  const [paraclinicalResults] = await executor.query(
    `
      SELECT
        type,
        name,
        resultSummary
      FROM paraclinical_result
      WHERE medicalRecordId = ?
      ORDER BY id ASC
    `,
    [normalizedRecordId]
  );

  return {
    email: context.patientEmail,
    bookingId: context.bookingId,
    patientName: `${context.patientFirstName || ""} ${context.patientLastName || ""}`.trim(),
    time: buildResultEmailTime(context),
    reason: context.reason,
    doctorConclusion: context.doctorConclusion,
    followUpDate: context.followUpDate,
    prescriptionItems,
    paraclinicalResults,
    skipBookingStatusUpdate: true,
  };
};

// Gửi email kết quả khám cho bệnh nhân sau khi transaction hoàn tất.
const sendCompletedVisitResultEmail = async (medicalRecordId) => {
  const payload = await getCompletedVisitResultEmailPayload(medicalRecordId);
  if (!payload) {
    return {
      sent: false,
      skipped: true,
      errMessage: "Missing patient email for completed visit result",
    };
  }

  const response = await sendRemedy(payload);
  return {
    sent: response?.errCode === 0,
    errCode: response?.errCode,
    errMessage: response?.errMessage,
  };
};

// Hoàn tất lượt khám từ hồ sơ bệnh án trong transaction hiện tại.
const completeVisitForMedicalRecordInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");

  // Nếu payload có nháp hồ sơ thì lưu trước, ngược lại chỉ cần kiểm tra hồ sơ còn mở.
  if (hasMedicalRecordDraftUpdates(data)) {
    await updateMedicalRecordDraftInCurrentTransaction(data, executor);
  } else {
    await assertMedicalRecordEditable(medicalRecordId, executor);
  }

  // Nếu gửi kèm toa thuốc thì lưu toa trước khi hoàn tất lượt khám.
  if (
    data?.prescription &&
    typeof data.prescription === "object" &&
    hasPrescriptionPayloadData(data.prescription)
  ) {
    await savePrescriptionForRecordInCurrentTransaction(
      {
        ...data.prescription,
        medicalRecordId,
      },
      executor
    );
  }

  // Nếu gửi kèm cận lâm sàng thì thay thế danh sách hiện có trước khi hoàn tất.
  if (Array.isArray(data?.paraclinicalResults)) {
    await saveParaclinicalResultsForRecordInCurrentTransaction(
      {
        medicalRecordId,
        items: data.paraclinicalResults,
      },
      executor
    );
  }

  const context = await getMedicalRecordVisitContext(medicalRecordId, executor, {
    forUpdate: true,
  });

  if (!context) {
    const error = new Error("Medical record not found");
    error.errCode = 2;
    throw error;
  }

  if (isClosedMedicalRecordStatus(context.statusId)) {
    const error = new Error("Medical record is closed");
    error.errCode = 409;
    throw error;
  }

  if (!normalizeOptionalString(context.symptoms)) {
    const error = new Error("symptoms is required before completing visit");
    error.errCode = 1;
    throw error;
  }

  // Nếu visit đã hoàn tất từ trước, chỉ đồng bộ lại trạng thái booking và trả kết quả hiện tại.
  if (context.visitStatusId === VISIT_STATUS.COMPLETED) {
    await markBookingCompletedForVisitInCurrentTransaction(context, executor);

    return {
      completedNow: false,
      data: {
        record: context,
        visit: await getExaminationVisitForRecord(medicalRecordId, executor),
      },
    };
  }

  if (context.visitStatusId !== VISIT_STATUS.IN_PROGRESS) {
    const error = new Error("Visit must be in progress before completion");
    error.errCode = 409;
    throw error;
  }

  // Chuyển visit VS2 -> VS3 và ghi thời điểm hoàn tất.
  await executor.query(
    `
      UPDATE examination_visit
      SET statusId = ?, completedAt = COALESCE(completedAt, CURRENT_TIMESTAMP)
      WHERE id = ? AND statusId = ?
    `,
    [
      VISIT_STATUS.COMPLETED,
      context.examinationVisitId,
      VISIT_STATUS.IN_PROGRESS,
    ]
  );
  await markBookingCompletedForVisitInCurrentTransaction(context, executor);

  return {
    completedNow: true,
    data: {
      record: await getMedicalRecordById(medicalRecordId, executor, { forUpdate: true }),
      visit: await getExaminationVisitForRecord(medicalRecordId, executor),
    },
  };
};

// Hoàn tất lượt khám và gửi email kết quả sau khi transaction commit thành công.
const completeVisitForMedicalRecord = async (data, db) => {
  if (db) {
    return completeVisitForMedicalRecordInCurrentTransaction(data, db);
  }

  const result = await withTransaction((transactionDb) =>
    completeVisitForMedicalRecordInCurrentTransaction(data, transactionDb)
  );

  if (!result.completedNow) {
    return result;
  }

  try {
    // Email nằm ngoài transaction để lỗi SMTP không rollback dữ liệu khám đã hoàn tất.
    const resultEmail = await sendCompletedVisitResultEmail(data?.medicalRecordId);
    return {
      ...result,
      resultEmail,
    };
  } catch (error) {
    console.error("sendCompletedVisitResultEmail error:", error);
    return {
      ...result,
      resultEmail: {
        sent: false,
        errMessage: error.message || "Failed to send result email",
      },
    };
  }
};

// Lấy tổng quan thanh toán của lượt khám, gồm số tiền phải thu và phương thức thanh toán.
const getVisitPaymentSummary = async (examinationVisitId, db, options = {}) => {
  const normalizedVisitId = normalizePositiveId(examinationVisitId, "examinationVisitId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        ev.id AS examinationVisitId,
        ev.bookingId,
        ev.patientId,
        ev.doctorId,
        ev.paymentStatusId,
        ev.paymentMethodId,
        lpm.value_vi AS paymentMethodVi,
        lpm.value_en AS paymentMethodEn,
        COALESCE(b.priceAtBooking, 0) AS amountDue
      FROM examination_visit ev
      INNER JOIN booking b
        ON b.id = ev.bookingId
      LEFT JOIN lookup lpm
        ON lpm.keyMap = ev.paymentMethodId AND lpm.type = 'PAYMENT'
      WHERE ev.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedVisitId]
  );

  return rows[0] || null;
};

// Thu tiền lượt khám trong transaction hiện tại.
const collectVisitPaymentInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const examinationVisitId = normalizePositiveId(data?.examinationVisitId, "examinationVisitId");
  const paymentMethodId = normalizeOptionalString(data?.paymentMethodId);
  const amountReceived = normalizeOptionalMoney(data?.amountReceived, "amountReceived");
  const summary = await getVisitPaymentSummary(examinationVisitId, executor, {
    forUpdate: true,
  });

  if (!summary) {
    const error = new Error("Examination visit not found");
    error.errCode = 2;
    throw error;
  }

  if (summary.paymentStatusId === PAYMENT_STATUS.PAID) {
    return { paidNow: false, data: summary };
  }

  const amountDue = Number(summary.amountDue) || 0;

  // Nếu FE gửi số tiền đã nhận thì không cho xác nhận thiếu so với giá booking.
  if (amountReceived !== undefined && amountReceived !== null && amountReceived < amountDue) {
    const error = new Error("Received amount is less than amount due");
    error.errCode = 1;
    throw error;
  }

  if (paymentMethodId) {
    // Chỉ nhận phương thức thanh toán tồn tại trong bảng lookup.
    await assertLookupKey(LOOKUP_TYPES.PAYMENT_METHOD, paymentMethodId, executor);
  }

  const [updateResult] = await executor.query(
    `
      UPDATE examination_visit
      SET paymentStatusId = ?, paymentMethodId = ?
      WHERE id = ? AND paymentStatusId <> ?
    `,
    [
      PAYMENT_STATUS.PAID,
      paymentMethodId,
      examinationVisitId,
      PAYMENT_STATUS.PAID,
    ]
  );

  const paidSummary = await getVisitPaymentSummary(examinationVisitId, executor, {
    forUpdate: true,
  });

  return {
    paidNow: Number(updateResult?.affectedRows) > 0,
    data: paidSummary,
  };
};

// Thu tiền lượt khám, tự mở transaction nếu cần.
const collectVisitPayment = async (data, db) => {
  if (db) {
    return collectVisitPaymentInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    collectVisitPaymentInCurrentTransaction(data, transactionDb)
  );
};

module.exports = {
  buildPrescriptionCode,
  getBookingVisitContext,
  getExaminationVisitByBookingId,
  getExaminationVisitById,
  ensureExaminationVisitForBookingInCurrentTransaction,
  ensureExaminationVisitForBooking,
  startExaminationVisitForBookingInCurrentTransaction,
  startExaminationVisitForBooking,
  getMedicalRecordByVisitId,
  getMedicalRecordByBookingId,
  getMedicalRecordById,
  ensureMedicalRecordForVisitInCurrentTransaction,
  ensureMedicalRecordForVisit,
  assertMedicalRecordEditable,
  updateMedicalRecordDraftInCurrentTransaction,
  updateMedicalRecordDraft,
  getOrCreatePrescriptionForRecordInCurrentTransaction,
  getOrCreatePrescriptionForRecord,
  savePrescriptionForRecordInCurrentTransaction,
  savePrescriptionForRecord,
  createParaclinicalResultInCurrentTransaction,
  createParaclinicalResult,
  saveParaclinicalResultsForRecordInCurrentTransaction,
  saveParaclinicalResultsForRecord,
  completeVisitForMedicalRecordInCurrentTransaction,
  completeVisitForMedicalRecord,
  getVisitPaymentSummary,
  collectVisitPaymentInCurrentTransaction,
  collectVisitPayment,
};
