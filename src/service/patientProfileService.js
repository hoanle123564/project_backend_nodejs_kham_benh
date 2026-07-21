const moment = require("moment");
const { getDb, withTransaction } = require("./transactionService");

const USER_PROFILE_FIELDS = Object.freeze([
  "firstName",
  "lastName",
  "phoneNumber",
  "email",
  "gender",
  "address",
  "provinceCode",
  "districtCode",
  "wardCode",
  "image",
]);

const PATIENT_PROFILE_FIELDS = Object.freeze([
  "dateOfBirth",
  "bloodType",
  "allergies",
  "citizenId",
  "ethnicityId",
  "occupation",
  "healthInsuranceCode",
  "refundBankName",
  "refundAccountName",
  "refundAccountNumber",
]);

// Kiểm tra object có chứa field cần cập nhật hay không.
const hasOwn = (object, key) => Object.prototype.hasOwnProperty.call(object || {}, key);

// Chuẩn hóa id bệnh nhân, trả null nếu giá trị không hợp lệ.
const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

// Chuẩn hóa chuỗi nhập từ form, biến chuỗi rỗng thành null để lưu DB nhất quán.
const normalizeString = (value) => {
  if (value === undefined) return undefined;
  if (value === null) return null;

  const normalized = String(value).trim();
  return normalized === "" ? null : normalized;
};

// Chuẩn hóa ngày sinh về YYYY-MM-DD và báo lỗi nếu định dạng không hợp lệ.
const normalizeDate = (value) => {
  if (value === undefined) return undefined;
  if (value === null || value === "") return null;

  const normalized = moment(value, ["YYYY-MM-DD", "DD/MM/YYYY", moment.ISO_8601], true);
  if (!normalized.isValid()) {
    const error = new Error("Invalid dateOfBirth");
    error.errCode = 3;
    throw error;
  }

  return normalized.format("YYYY-MM-DD");
};

// Chọn hàm chuẩn hóa phù hợp cho từng field hồ sơ bệnh nhân.
const normalizeProfileField = (fieldName, value) => {
  if (fieldName === "dateOfBirth") {
    return normalizeDate(value);
  }

  return normalizeString(value);
};

// Sinh mã bệnh nhân ổn định theo id người dùng.
const buildMedicalCode = (patientId) => `PAT-${String(patientId).padStart(8, "0")}`;

// Tạo danh sách cột và giá trị cần UPDATE từ whitelist field cho trước.
const buildUpdatePayload = (allowedFields, data, normalizer) =>
  allowedFields.reduce(
    (payload, fieldName) => {
      if (!hasOwn(data, fieldName)) {
        return payload;
      }

      const normalizedValue = normalizer(fieldName, data[fieldName]);
      if (normalizedValue === undefined) {
        return payload;
      }

      payload.assignments.push(`${fieldName} = ?`);
      payload.values.push(normalizedValue);
      return payload;
    },
    { assignments: [], values: [] }
  );

// Đảm bảo user tồn tại và là bệnh nhân R3, có thể khóa dòng khi chuẩn bị cập nhật.
const requirePatientUser = async (patientId, db, lock = false) => {
  const normalizedPatientId = normalizePositiveId(patientId);
  if (!normalizedPatientId) {
    const error = new Error("Missing required parameter: patientId");
    error.errCode = 1;
    throw error;
  }

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT id, roleId
      FROM users
      WHERE id = ? AND roleId = 'R3'
      LIMIT 1
      ${lock ? "FOR UPDATE" : ""}
    `,
    [normalizedPatientId]
  );

  if (rows.length === 0) {
    const error = new Error("Patient not found");
    error.errCode = 2;
    throw error;
  }

  return rows[0];
};

// Lấy dữ liệu hồ sơ bệnh nhân bằng cách gộp bảng users và patient_profile.
const getPatientProfileData = async (patientId, db) => {
  const normalizedPatientId = normalizePositiveId(patientId);
  if (!normalizedPatientId) {
    const error = new Error("Missing required parameter: patientId");
    error.errCode = 1;
    throw error;
  }

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        u.id,
        u.email,
        u.firstName,
        u.lastName,
        u.phoneNumber,
        u.gender,
        u.address,
        u.provinceCode,
        u.districtCode,
        u.wardCode,
        u.image,
        p.id AS patientProfileId,
        p.medicalCode,
        p.dateOfBirth,
        p.bloodType,
        p.allergies,
        p.citizenId,
        p.ethnicityId,
        p.occupation,
        p.healthInsuranceCode,
        p.refundBankName,
        p.refundAccountName,
        p.refundAccountNumber
      FROM users u
      LEFT JOIN patient_profile p
        ON p.patientId = u.id
      WHERE u.id = ? AND u.roleId = 'R3'
      LIMIT 1
    `,
    [normalizedPatientId]
  );

  if (rows.length === 0) {
    const error = new Error("Patient not found");
    error.errCode = 2;
    throw error;
  }

  return rows[0];
};

// Tạo dòng patient_profile nếu bệnh nhân chưa có hồ sơ mở rộng.
const ensurePatientProfileRow = async (patientId, db) => {
  const executor = getDb(db);
  const [existingRows] = await executor.query(
    `
      SELECT *
      FROM patient_profile
      WHERE patientId = ?
      LIMIT 1
      FOR UPDATE
    `,
    [patientId]
  );

  if (existingRows.length > 0) {
    return existingRows[0];
  }

  try {
    const medicalCode = buildMedicalCode(patientId);
    await executor.query(
      `
        INSERT INTO patient_profile (patientId, medicalCode)
        VALUES (?, ?)
      `,
      [patientId, medicalCode]
    );
  } catch (error) {
    if (error?.code !== "ER_DUP_ENTRY" && error?.errno !== 1062) {
      throw error;
    }
  }

  const [createdRows] = await executor.query(
    `
      SELECT *
      FROM patient_profile
      WHERE patientId = ?
      LIMIT 1
    `,
    [patientId]
  );

  return createdRows[0] || null;
};

// Cập nhật đồng thời thông tin users và patient_profile trong cùng executor.
const updatePatientProfileData = async (patientId, data, db) => {
  const normalizedPatientId = normalizePositiveId(patientId);
  if (!normalizedPatientId) {
    const error = new Error("Missing required parameter: patientId");
    error.errCode = 1;
    throw error;
  }

  const executor = getDb(db);
  await requirePatientUser(normalizedPatientId, executor, true);

  // Chỉ cập nhật các field thuộc bảng users được phép nhận từ form.
  const userPayload = buildUpdatePayload(
    USER_PROFILE_FIELDS,
    data,
    (_fieldName, value) => normalizeString(value)
  );

  if (userPayload.assignments.length > 0) {
    await executor.query(
      `
        UPDATE users
        SET ${userPayload.assignments.join(", ")}
        WHERE id = ? AND roleId = 'R3'
      `,
      [...userPayload.values, normalizedPatientId]
    );
  }

  await ensurePatientProfileRow(normalizedPatientId, executor);

  // Sau khi chắc chắn có patient_profile, cập nhật các field hồ sơ y tế mở rộng.
  const profilePayload = buildUpdatePayload(
    PATIENT_PROFILE_FIELDS,
    data,
    normalizeProfileField
  );

  if (profilePayload.assignments.length > 0) {
    await executor.query(
      `
        UPDATE patient_profile
        SET ${profilePayload.assignments.join(", ")}
        WHERE patientId = ?
      `,
      [...profilePayload.values, normalizedPatientId]
    );
  }

  return getPatientProfileData(normalizedPatientId, executor);
};

// API service lấy hồ sơ bệnh nhân và trả về format errCode/errMessage chuẩn.
const getPatientProfile = async (patientId) => {
  try {
    const data = await getPatientProfileData(patientId);
    return { errCode: 0, errMessage: "OK", data };
  } catch (error) {
    return {
      errCode: error.errCode || 1,
      errMessage: error.message || "Database error",
      data: {},
    };
  }
};

// API service cập nhật hồ sơ bệnh nhân trong transaction.
const updatePatientProfile = async (patientId, data) => {
  try {
    const profile = await withTransaction((db) =>
      updatePatientProfileData(patientId, data || {}, db)
    );

    return { errCode: 0, errMessage: "Update patient profile successfully", data: profile };
  } catch (error) {
    return {
      errCode: error.errCode || 1,
      errMessage: error.message || "Database error",
      data: {},
    };
  }
};

module.exports = {
  USER_PROFILE_FIELDS,
  PATIENT_PROFILE_FIELDS,
  buildMedicalCode,
  ensurePatientProfileRow,
  getPatientProfileData,
  updatePatientProfileData,
  getPatientProfile,
  updatePatientProfile,
};
