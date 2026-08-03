const bcrypt = require("bcrypt");
const connection = require("../config/data");
const { withTransaction } = require("./transactionService");
const { updatePatientProfileData } = require("./patientProfileService");
const { VISIT_STATUS } = require("./workflowStatusService");

const PATIENT_BOOKING_STATUS_IDS = ["S1", "S2", "S8", "S3"];
const ACTIVE_VISIT_STATUS_IDS = [VISIT_STATUS.IN_PROGRESS, VISIT_STATUS.COMPLETED];
const PATIENT_FIELDS = [
  "firstName",
  "lastName",
  "phoneNumber",
  "gender",
  "address",
  "dateOfBirth",
  "citizenId",
  "ethnicityId",
  "occupation",
  "healthInsuranceCode",
];
const DOCTOR_FIELDS = [
  "firstName",
  "lastName",
  "phoneNumber",
  "gender",
  "address",
  "provinceCode",
  "districtCode",
  "wardCode",
  "positionId",
  "image",
];

const normalizeId = (value) => {
  const id = Number(value);
  return Number.isInteger(id) && id > 0 ? id : null;
};

const pagination = (query = {}) => {
  const page = Math.max(Number(query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(query.limit) || 20, 1), 100);
  return { page, limit, offset: (page - 1) * limit };
};

const responseError = (error, data = []) => ({
  errCode: error.errCode || 1,
  errMessage: error.message || "Database error",
  data,
});

const patientScope = async (clinicId, patientId, db = connection.promise()) => {
  const [rows] = await db.query(
    `
      SELECT u.id
      FROM users u
      INNER JOIN booking b ON b.patientId = u.id
      INNER JOIN schedule s ON s.id = b.scheduleId
      INNER JOIN doctor_info di ON di.doctorId = s.doctorId
      WHERE u.id = ?
        AND u.roleId = 'R3'
        AND di.clinicId = ?
        AND b.statusId IN (${PATIENT_BOOKING_STATUS_IDS.map(() => "?").join(", ")})
      LIMIT 1
    `,
    [patientId, clinicId, ...PATIENT_BOOKING_STATUS_IDS]
  );

  if (!rows[0]) {
    const error = new Error("Permission denied");
    error.errCode = 403;
    throw error;
  }
};

const getClinicPatients = async (clinicId, query = {}) => {
  try {
    const normalizedClinicId = normalizeId(clinicId);
    if (!normalizedClinicId) throw new Error("Missing required parameter: clinicId");

    const { page, limit, offset } = pagination(query);
    const sortColumns = {
      patientName: "patientName",
      firstBookingCreatedAt: "firstBookingCreatedAt",
      latestExamDate: "latestExamDate",
      bookingCount: "bookingCount",
    };
    const sortBy = sortColumns[query.sortBy] || "latestExamDate";
    const sortDir = String(query.sortDir || "").toUpperCase() === "ASC" ? "ASC" : "DESC";
    const visitFilter = String(query.visitFilter || "").trim();
    const havingClause = visitFilter === "examined"
      ? "HAVING COUNT(DISTINCT ev.id) > 0"
      : visitFilter === "not_examined"
        ? "HAVING COUNT(DISTINCT ev.id) = 0"
        : "";
    const params = [
      ...ACTIVE_VISIT_STATUS_IDS,
      normalizedClinicId,
      ...PATIENT_BOOKING_STATUS_IDS,
    ];
    const filters = [];
    const search = String(query.search || "").trim();
    const statusId = String(query.statusId || "").trim();

    if (search) {
      const keyword = `%${search}%`;
      filters.push("AND (CONCAT_WS(' ', u.firstName, u.lastName) LIKE ? OR u.email LIKE ? OR u.phoneNumber LIKE ? OR pp.medicalCode LIKE ?)");
      params.push(keyword, keyword, keyword, keyword);
    }
    if (statusId) {
      filters.push("AND b.statusId = ?");
      params.push(statusId);
    }

    const baseFrom = `
      FROM booking b
      INNER JOIN schedule s ON s.id = b.scheduleId
      INNER JOIN doctor_info di ON di.doctorId = s.doctorId
      INNER JOIN users u ON u.id = b.patientId AND u.roleId = 'R3'
      LEFT JOIN patient_profile pp ON pp.patientId = u.id
      LEFT JOIN examination_visit ev
        ON ev.bookingId = b.id
       AND ev.statusId IN (${ACTIVE_VISIT_STATUS_IDS.map(() => "?").join(", ")})
      WHERE di.clinicId = ?
        AND b.statusId IN (${PATIENT_BOOKING_STATUS_IDS.map(() => "?").join(", ")})
        ${filters.join(" ")}
      GROUP BY u.id, u.email, u.firstName, u.lastName, u.phoneNumber, u.gender, u.address,
        pp.medicalCode, pp.dateOfBirth, pp.citizenId, pp.healthInsuranceCode
      ${havingClause}
    `;
    const [rows] = await connection.promise().query(
      `
        SELECT u.id AS patientId, u.email, u.firstName, u.lastName,
          CONCAT_WS(' ', u.firstName, u.lastName) AS patientName,
          u.phoneNumber, u.gender, u.address, pp.medicalCode, pp.dateOfBirth,
          pp.citizenId, pp.healthInsuranceCode, MIN(b.createdAt) AS firstBookingCreatedAt,
          MIN(b.date) AS firstAppointmentDate, MAX(ev.examDate) AS latestExamDate,
          MAX(COALESCE(ev.completedAt, ev.startedAt, ev.createdAt)) AS latestVisitAt,
          COUNT(DISTINCT b.id) AS bookingCount, COUNT(DISTINCT ev.id) AS visitCount
        ${baseFrom}
        ORDER BY ${sortBy} ${sortDir}, u.id DESC
        LIMIT ? OFFSET ?
      `,
      [...params, limit, offset]
    );
    const [countRows] = await connection.promise().query(
      `SELECT COUNT(*) AS total FROM (SELECT u.id ${baseFrom}) scoped_patients`,
      params
    );

    return {
      errCode: 0,
      errMessage: "OK",
      data: rows || [],
      pagination: { page, limit, total: Number(countRows[0]?.total) || 0 },
    };
  } catch (error) {
    return responseError(error);
  }
};

const getClinicPatient = async (clinicId, patientId) => {
  try {
    const normalizedClinicId = normalizeId(clinicId);
    const normalizedPatientId = normalizeId(patientId);
    if (!normalizedClinicId || !normalizedPatientId) throw new Error("Missing required parameters");
    await patientScope(normalizedClinicId, normalizedPatientId);

    const [rows] = await connection.promise().query(
      `
        SELECT u.id AS patientId, u.email, u.firstName, u.lastName,
          CONCAT_WS(' ', u.firstName, u.lastName) AS patientName,
          u.phoneNumber, u.gender, u.address, pp.medicalCode, pp.dateOfBirth,
          pp.citizenId, pp.ethnicityId, pp.occupation, pp.healthInsuranceCode,
          COUNT(DISTINCT b.id) AS bookingCount, COUNT(DISTINCT ev.id) AS visitCount,
          MIN(b.createdAt) AS firstBookingCreatedAt, MIN(b.date) AS firstAppointmentDate,
          MAX(ev.examDate) AS latestExamDate,
          MAX(COALESCE(ev.completedAt, ev.startedAt, ev.createdAt)) AS latestVisitAt
        FROM users u
        INNER JOIN booking b ON b.patientId = u.id
        INNER JOIN schedule s ON s.id = b.scheduleId
        INNER JOIN doctor_info di ON di.doctorId = s.doctorId
        LEFT JOIN patient_profile pp ON pp.patientId = u.id
        LEFT JOIN examination_visit ev
          ON ev.bookingId = b.id
         AND ev.statusId IN (${ACTIVE_VISIT_STATUS_IDS.map(() => "?").join(", ")})
        WHERE u.id = ? AND u.roleId = 'R3' AND di.clinicId = ?
          AND b.statusId IN (${PATIENT_BOOKING_STATUS_IDS.map(() => "?").join(", ")})
        GROUP BY u.id, u.email, u.firstName, u.lastName, u.phoneNumber, u.gender, u.address,
          pp.medicalCode, pp.dateOfBirth, pp.citizenId, pp.ethnicityId, pp.occupation, pp.healthInsuranceCode
        LIMIT 1
      `,
      [
        ...ACTIVE_VISIT_STATUS_IDS,
        normalizedPatientId,
        normalizedClinicId,
        ...PATIENT_BOOKING_STATUS_IDS,
      ]
    );

    return { errCode: 0, errMessage: "OK", data: rows[0] || {} };
  } catch (error) {
    return responseError(error, {});
  }
};

const updateClinicPatient = async (clinicId, patientId, data) => {
  try {
    const normalizedClinicId = normalizeId(clinicId);
    const normalizedPatientId = normalizeId(patientId);
    if (!normalizedClinicId || !normalizedPatientId) throw new Error("Missing required parameters");
    const payload = PATIENT_FIELDS.reduce((result, field) => {
      if (Object.prototype.hasOwnProperty.call(data || {}, field)) result[field] = data[field];
      return result;
    }, {});

    await withTransaction(async (db) => {
      await patientScope(normalizedClinicId, normalizedPatientId, db);
      await updatePatientProfileData(normalizedPatientId, payload, db);
    });
    return getClinicPatient(normalizedClinicId, normalizedPatientId);
  } catch (error) {
    return responseError(error, {});
  }
};

const createClinicDoctor = async (clinicId, data) => {
  try {
    const normalizedClinicId = normalizeId(clinicId);
    const email = String(data?.email || "").trim();
    const password = String(data?.password || "");
    const firstName = String(data?.firstName || "").trim();
    const lastName = String(data?.lastName || "").trim();
    if (!normalizedClinicId || !email || !password || !firstName || !lastName) {
      return { errCode: 1, errMessage: "Missing required parameters" };
    }

    const doctorId = await withTransaction(async (db) => {
      const [existingRows] = await db.query("SELECT id FROM users WHERE email = ? LIMIT 1 FOR UPDATE", [email]);
      if (existingRows[0]) {
        const error = new Error("Email already exists");
        error.errCode = 2;
        throw error;
      }
      const passwordHash = await bcrypt.hash(password, 10);
      const [userResult] = await db.query(
        `
          INSERT INTO users (email, password, firstName, lastName, address, provinceCode, districtCode, wardCode,
            gender, roleId, phoneNumber, positionId, image)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'R2', ?, ?, ?)
        `,
        [
          email, passwordHash, firstName, lastName, data?.address || null, data?.provinceCode || null,
          data?.districtCode || null, data?.wardCode || null, data?.gender || null, data?.phoneNumber || null,
          data?.positionId || null, data?.image || null,
        ]
      );
      await db.query(
        "INSERT INTO doctor_info (doctorId, clinicId, isActive) VALUES (?, ?, 1)",
        [userResult.insertId, normalizedClinicId]
      );
      return userResult.insertId;
    });

    return { errCode: 0, errMessage: "Doctor created successfully", data: { doctorId } };
  } catch (error) {
    return responseError(error, {});
  }
};

const updateClinicDoctor = async (clinicId, doctorId, data) => {
  try {
    const normalizedClinicId = normalizeId(clinicId);
    const normalizedDoctorId = normalizeId(doctorId);
    if (!normalizedClinicId || !normalizedDoctorId) throw new Error("Missing required parameters");
    const payload = DOCTOR_FIELDS.reduce((result, field) => {
      if (Object.prototype.hasOwnProperty.call(data || {}, field)) result[field] = data[field];
      return result;
    }, {});
    const assignments = Object.keys(payload).map((field) => `${field} = ?`);
    if (!assignments.length) return { errCode: 0, errMessage: "OK", data: {} };

    await withTransaction(async (db) => {
      const [rows] = await db.query(
        `
          SELECT u.id
          FROM users u
          INNER JOIN doctor_info di ON di.doctorId = u.id
          WHERE u.id = ? AND u.roleId = 'R2' AND di.clinicId = ?
          LIMIT 1
          FOR UPDATE
        `,
        [normalizedDoctorId, normalizedClinicId]
      );
      if (!rows[0]) {
        const error = new Error("Permission denied");
        error.errCode = 403;
        throw error;
      }
      await db.query(`UPDATE users SET ${assignments.join(", ")} WHERE id = ?`, [
        ...Object.values(payload),
        normalizedDoctorId,
      ]);
    });

    return { errCode: 0, errMessage: "Doctor updated successfully", data: { doctorId: normalizedDoctorId } };
  } catch (error) {
    return responseError(error, {});
  }
};

module.exports = {
  createClinicDoctor,
  getClinicPatient,
  getClinicPatients,
  updateClinicDoctor,
  updateClinicPatient,
};
