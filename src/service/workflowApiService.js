const moment = require("moment");
const connection = require("../config/data");
const { withTransaction } = require("./transactionService");
const {
  BOOKING_STATUS,
  VISIT_STATUS,
  PAYMENT_STATUS,
  MEDICAL_RECORD_STATUS,
} = require("./workflowStatusService");
const {
  startExaminationVisitForBooking,
  ensureMedicalRecordForVisit,
  updateMedicalRecordDraft,
  getOrCreatePrescriptionForRecord,
  savePrescriptionForRecord,
  createParaclinicalResult,
  saveParaclinicalResultsForRecord,
  completeVisitForMedicalRecord,
  getVisitPaymentSummary,
  collectVisitPayment,
} = require("./examinationWorkflowService");
const { canDoctorOpenVideoBooking } = require("./videoConsultationService");

const VALID_DOCTOR_PATIENT_BOOKING_STATUSES = Object.freeze([
  BOOKING_STATUS.PENDING,
  BOOKING_STATUS.CONFIRMED,
  BOOKING_STATUS.COMPLETED,
]);

const ACTIVE_QUEUE_BOOKING_STATUSES = Object.freeze([
  BOOKING_STATUS.PENDING,
  BOOKING_STATUS.CONFIRMED,
  BOOKING_STATUS.COMPLETED,
]);

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

// Chuẩn hóa chuỗi tùy chọn từ query/body, trả null cho giá trị rỗng.
const normalizeOptionalString = (value) => {
  if (value === undefined || value === null) return null;
  const normalized = String(value).trim();
  return normalized === "" ? null : normalized;
};

// Chuẩn hóa ngày query, mặc định là ngày hiện tại theo múi giờ Việt Nam.
const normalizeDate = (value) => {
  const source = value || moment().utcOffset(7).format("YYYY-MM-DD");
  const normalized = moment(source, ["YYYY-MM-DD", "DD/MM/YYYY", moment.ISO_8601], true);
  if (!normalized.isValid()) {
    const error = new Error("Invalid date");
    error.errCode = 1;
    throw error;
  }

  return normalized.format("YYYY-MM-DD");
};

// Chuẩn hóa page/limit và giới hạn limit tối đa để tránh query quá lớn.
const normalizePagination = (query = {}) => {
  const page = Math.max(Number(query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(query.limit) || 20, 1), 100);
  return {
    page,
    limit,
    offset: (page - 1) * limit,
  };
};

// Chuẩn hóa hướng sort, mặc định DESC nếu không truyền ASC.
const normalizeSortDirection = (value) =>
  String(value || "").toUpperCase() === "ASC" ? "ASC" : "DESC";

// Đóng gói response thành công theo format service hiện có.
const ok = (data, extra = {}) => ({
  errCode: 0,
  errMessage: "OK",
  data,
  ...extra,
});

// Đóng gói response lỗi theo format errCode/errMessage hiện có.
const errorResponse = (error, data = []) => ({
  errCode: error.errCode || 1,
  errMessage: error.message || "Database error",
  data,
});

// Tạo điều kiện tìm kiếm bệnh nhân theo tên, email, số điện thoại hoặc mã bệnh nhân.
const buildSearchClause = (search, params) => {
  const normalizedSearch = normalizeOptionalString(search);
  if (!normalizedSearch) {
    return "";
  }

  const keyword = `%${normalizedSearch}%`;
  params.push(keyword, keyword, keyword, keyword);
  return `
    AND (
      CONCAT_WS(' ', u.firstName, u.lastName) LIKE ?
      OR u.email LIKE ?
      OR u.phoneNumber LIKE ?
      OR pp.medicalCode LIKE ?
    )
  `;
};

// Đảm bảo bệnh nhân thuộc phạm vi khám của bác sĩ trước khi xem chi tiết/lịch sử.
const assertDoctorPatientRelationship = async (doctorId, patientId) => {
  const normalizedDoctorId = normalizePositiveId(doctorId, "doctorId");
  const normalizedPatientId = normalizePositiveId(patientId, "patientId");

  const [rows] = await connection.promise().query(
    `
      SELECT COUNT(DISTINCT b.id) AS bookingCount
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      WHERE s.doctorId = ?
        AND b.patientId = ?
        AND b.statusId IN (?, ?, ?)
    `,
    [
      normalizedDoctorId,
      normalizedPatientId,
      ...VALID_DOCTOR_PATIENT_BOOKING_STATUSES,
    ]
  );

  if (!rows[0] || Number(rows[0].bookingCount) === 0) {
    const error = new Error("Patient does not belong to this doctor");
    error.errCode = 403;
    throw error;
  }
};

// Lấy danh sách bệnh nhân từng đặt lịch với bác sĩ, kèm thống kê booking/lượt khám.
const getDoctorPatientList = async (query) => {
  try {
    const doctorId = normalizePositiveId(query?.doctorId, "doctorId");
    const pagination = normalizePagination(query);
    const patientSortColumns = {
      patientName: "patientName",
      firstBookingCreatedAt: "firstBookingCreatedAt",
      latestExamDate: "latestExamDate",
      medicalCode: "pp.medicalCode",
    };
    const sortBy = patientSortColumns[query?.sortBy] || "latestExamDate";
    const sortDirection = normalizeSortDirection(query?.sortDir);
    const visitFilter = normalizeOptionalString(query?.visitFilter);
    const havingClause =
      visitFilter === "examined"
        ? "HAVING COUNT(DISTINCT ev.id) > 0"
        : visitFilter === "not_examined"
          ? "HAVING COUNT(DISTINCT ev.id) = 0"
          : "";
    const params = [
      VISIT_STATUS.IN_PROGRESS,
      VISIT_STATUS.COMPLETED,
      doctorId,
      ...VALID_DOCTOR_PATIENT_BOOKING_STATUSES,
    ];
    const searchClause = buildSearchClause(query?.search, params);
    // baseFrom được dùng lại cho cả query dữ liệu và query đếm để hai kết quả cùng bộ lọc.
    const baseFrom = `
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      INNER JOIN users u
        ON u.id = b.patientId
      LEFT JOIN patient_profile pp
        ON pp.patientId = u.id
      LEFT JOIN examination_visit ev
        ON ev.bookingId = b.id
       AND ev.statusId IN (?, ?)
      WHERE s.doctorId = ?
        AND b.statusId IN (?, ?, ?)
        ${searchClause}
      GROUP BY
        u.id,
        u.email,
        u.firstName,
        u.lastName,
        u.phoneNumber,
        u.gender,
        u.address,
        pp.medicalCode,
        pp.dateOfBirth,
        pp.citizenId,
        pp.healthInsuranceCode
      ${havingClause}
    `;

    const [rows] = await connection.promise().query(
      `
        SELECT
          u.id AS patientId,
          u.email,
          u.firstName,
          u.lastName,
          CONCAT_WS(' ', u.firstName, u.lastName) AS patientName,
          u.phoneNumber,
          u.gender,
          u.address,
          pp.medicalCode,
          pp.dateOfBirth,
          pp.citizenId,
          pp.healthInsuranceCode,
          MIN(b.createdAt) AS firstBookingCreatedAt,
          MIN(b.date) AS firstAppointmentDate,
          MAX(ev.examDate) AS latestExamDate,
          MAX(COALESCE(ev.completedAt, ev.startedAt, ev.createdAt)) AS latestVisitAt,
          COUNT(DISTINCT b.id) AS bookingCount,
          COUNT(DISTINCT ev.id) AS visitCount
        ${baseFrom}
        ORDER BY ${sortBy} ${sortDirection}, u.id DESC
        LIMIT ? OFFSET ?
      `,
      [...params, pagination.limit, pagination.offset]
    );

    const [countRows] = await connection.promise().query(
      `
        SELECT COUNT(*) AS total
        FROM (
          SELECT u.id
          ${baseFrom}
        ) counted
      `,
      params
    );

    return ok(rows || [], {
      pagination: {
        page: pagination.page,
        limit: pagination.limit,
        total: Number(countRows[0]?.total) || 0,
      },
    });
  } catch (error) {
    return errorResponse(error, []);
  }
};

// Lấy thông tin tổng quan của một bệnh nhân trong phạm vi bác sĩ đang xem.
const getDoctorPatientDetail = async (query) => {
  try {
    const doctorId = normalizePositiveId(query?.doctorId, "doctorId");
    const patientId = normalizePositiveId(query?.patientId, "patientId");
    await assertDoctorPatientRelationship(doctorId, patientId);

    const [rows] = await connection.promise().query(
      `
        SELECT
          u.id AS patientId,
          u.email,
          u.firstName,
          u.lastName,
          CONCAT_WS(' ', u.firstName, u.lastName) AS patientName,
          u.phoneNumber,
          u.gender,
          u.address,
          u.provinceCode,
          u.districtCode,
          u.wardCode,
          u.image,
          pp.id AS patientProfileId,
          pp.medicalCode,
          pp.dateOfBirth,
          pp.bloodType,
          pp.allergies,
          pp.citizenId,
          pp.ethnicityId,
          pp.occupation,
          pp.healthInsuranceCode,
          COUNT(DISTINCT b.id) AS bookingCount,
          COUNT(DISTINCT ev.id) AS visitCount,
          MIN(b.createdAt) AS firstBookingCreatedAt,
          MAX(ev.examDate) AS latestExamDate,
          MAX(COALESCE(ev.completedAt, ev.startedAt, ev.createdAt)) AS latestVisitAt
        FROM users u
        LEFT JOIN patient_profile pp
          ON pp.patientId = u.id
        INNER JOIN booking b
          ON b.patientId = u.id
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        LEFT JOIN examination_visit ev
          ON ev.bookingId = b.id
         AND ev.statusId IN (?, ?)
        WHERE u.id = ?
          AND u.roleId = 'R3'
          AND s.doctorId = ?
          AND b.statusId IN (?, ?, ?)
        GROUP BY
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
          pp.id,
          pp.medicalCode,
          pp.dateOfBirth,
          pp.bloodType,
          pp.allergies,
          pp.citizenId,
          pp.ethnicityId,
          pp.occupation,
          pp.healthInsuranceCode
        LIMIT 1
      `,
      [
        VISIT_STATUS.IN_PROGRESS,
        VISIT_STATUS.COMPLETED,
        patientId,
        doctorId,
        ...VALID_DOCTOR_PATIENT_BOOKING_STATUSES,
      ]
    );

    if (rows.length === 0) {
      return {
        errCode: 2,
        errMessage: "Patient not found",
        data: {},
      };
    }

    return ok(rows[0]);
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lấy lịch sử booking/lượt khám/hồ sơ của một bệnh nhân với bác sĩ.
const getDoctorPatientHistory = async (query) => {
  try {
    const doctorId = normalizePositiveId(query?.doctorId, "doctorId");
    const patientId = normalizePositiveId(query?.patientId, "patientId");
    await assertDoctorPatientRelationship(doctorId, patientId);

    const [rows] = await connection.promise().query(
      `
        SELECT
          b.id AS bookingId,
          b.date AS appointmentDate,
          b.reason,
          b.statusId AS bookingStatusId,
          b.priceAtBooking,
          s.timeType,
          s.appointmentTypeId,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          lat.value_vi AS appointmentTypeVi,
          lat.value_en AS appointmentTypeEn,
          bq.queueNumber,
          ev.id AS examinationVisitId,
          ev.statusId AS visitStatusId,
          ev.paymentStatusId,
          ev.startedAt,
          ev.completedAt,
          mr.id AS medicalRecordId,
          mr.statusId AS medicalRecordStatusId,
          mr.followUpDate,
          p.id AS prescriptionId,
          COUNT(DISTINCT pr.id) AS paraclinicalCount
        FROM booking b
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        LEFT JOIN lookup lt
          ON lt.keyMap = s.timeType AND lt.type = 'TIME'
        LEFT JOIN lookup lat
          ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
        LEFT JOIN booking_queue bq
          ON bq.bookingId = b.id
        LEFT JOIN examination_visit ev
          ON ev.bookingId = b.id
        LEFT JOIN medical_record mr
          ON mr.bookingId = b.id
        LEFT JOIN prescription p
          ON p.medicalRecordId = mr.id
        LEFT JOIN paraclinical_result pr
          ON pr.medicalRecordId = mr.id
        WHERE s.doctorId = ?
          AND b.patientId = ?
          AND b.statusId IN (?, ?, ?)
        GROUP BY
          b.id,
          b.date,
          b.reason,
          b.statusId,
          b.priceAtBooking,
          s.timeType,
          s.appointmentTypeId,
          lt.value_vi,
          lt.value_en,
          lat.value_vi,
          lat.value_en,
          bq.queueNumber,
          ev.id,
          ev.statusId,
          ev.paymentStatusId,
          ev.startedAt,
          ev.completedAt,
          mr.id,
          mr.statusId,
          mr.followUpDate,
          p.id
        ORDER BY b.date DESC, COALESCE(bq.queueNumber, 999999) ASC, b.id DESC
      `,
      [doctorId, patientId, ...VALID_DOCTOR_PATIENT_BOOKING_STATUSES]
    );

    return ok(rows || []);
  } catch (error) {
    return errorResponse(error, []);
  }
};

// Lấy hàng đợi khám trong ngày của bác sĩ, dựa trên booking_queue đã được cấp STT.
const getDoctorQueue = async (query) => {
  try {
    const doctorId = normalizePositiveId(query?.doctorId, "doctorId");
    const appointmentDate = normalizeDate(query?.date || query?.appointmentDate);
    const visitStatusId = normalizeOptionalString(query?.visitStatusId || query?.statusId);
    const paymentStatusId = normalizeOptionalString(query?.paymentStatusId);
    const search = normalizeOptionalString(query?.search);
    const params = [
      VISIT_STATUS.WAITING,
      PAYMENT_STATUS.UNPAID,
      doctorId,
      appointmentDate,
      ...ACTIVE_QUEUE_BOOKING_STATUSES,
    ];
    const filters = [];

    // Các filter trạng thái/tìm kiếm được ghép động nhưng vẫn dùng parameterized query.
    if (visitStatusId) {
      filters.push("COALESCE(ev.statusId, ?) = ?");
      params.push(VISIT_STATUS.WAITING, visitStatusId);
    }

    if (paymentStatusId) {
      filters.push("COALESCE(ev.paymentStatusId, ?) = ?");
      params.push(PAYMENT_STATUS.UNPAID, paymentStatusId);
    }

    if (search) {
      const keyword = `%${search}%`;
      filters.push(
        "(CONCAT_WS(' ', patient.firstName, patient.lastName) LIKE ? OR CONCAT(patient.firstName, patient.lastName) LIKE ? OR patient.phoneNumber LIKE ?)"
      );
      params.push(keyword, keyword, keyword);
    }

    // Query này INNER JOIN booking_queue để chỉ hiển thị booking đã có STT hợp lệ.
    const [rows] = await connection.promise().query(
      `
        SELECT
          b.id AS bookingId,
          b.date AS appointmentDate,
          b.reason,
          b.statusId AS bookingStatusId,
          b.priceAtBooking,
          s.timeType,
          s.appointmentTypeId,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          lat.value_vi AS appointmentTypeVi,
          lat.value_en AS appointmentTypeEn,
          bq.queueNumber,
          bq.id AS bookingQueueId,
          ev.id AS examinationVisitId,
          COALESCE(ev.statusId, ?) AS visitStatusId,
          COALESCE(ev.paymentStatusId, ?) AS paymentStatusId,
          ev.startedAt,
          ev.completedAt,
          mr.id AS medicalRecordId,
          mr.statusId AS medicalRecordStatusId,
          patient.id AS patientId,
          patient.email AS patientEmail,
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.phoneNumber AS patientPhoneNumber,
          patient.gender AS patientGender,
          patient.address AS patientAddress,
          pp.medicalCode,
          pp.dateOfBirth,
          lvs.value_vi AS visitStatusVi,
          lvs.value_en AS visitStatusEn,
          lps.value_vi AS paymentStatusVi,
          lps.value_en AS paymentStatusEn,
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt
        FROM booking b
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        INNER JOIN booking_queue bq
          ON bq.bookingId = b.id
        INNER JOIN users patient
          ON patient.id = b.patientId
        LEFT JOIN patient_profile pp
          ON pp.patientId = patient.id
        LEFT JOIN lookup lt
          ON lt.keyMap = s.timeType AND lt.type = 'TIME'
        LEFT JOIN lookup lat
          ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
        LEFT JOIN examination_visit ev
          ON ev.bookingId = b.id
        LEFT JOIN medical_record mr
          ON mr.bookingId = b.id
        LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id
        LEFT JOIN lookup lvs
          ON lvs.keyMap = COALESCE(ev.statusId, 'VS1') AND lvs.type = 'VISIT_STATUS'
        LEFT JOIN lookup lps
          ON lps.keyMap = COALESCE(ev.paymentStatusId, 'PS1') AND lps.type = 'PAYMENT_STATUS'
        WHERE s.doctorId = ?
          AND b.date = ?
          AND b.statusId IN (?, ?, ?)
          ${filters.length > 0 ? `AND ${filters.join(" AND ")}` : ""}
        ORDER BY bq.queueNumber ASC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      params
    );

    return ok(
      (rows || []).map((row) => ({
        ...row,
        canJoinVideo: canDoctorOpenVideoBooking(row),
      })),
      { appointmentDate }
    );
  } catch (error) {
    return errorResponse(error, []);
  }
};

// Lấy chi tiết một lịch hẹn cho màn bác sĩ, kèm queue, visit và medical record nếu có.
const getDoctorAppointmentDetail = async (query) => {
  try {
    const bookingId = normalizePositiveId(query?.bookingId || query?.id, "bookingId");

    const [rows] = await connection.promise().query(
      `
        SELECT
          b.id AS bookingId,
          b.date AS appointmentDate,
          b.reason,
          b.statusId AS bookingStatusId,
          b.priceAtBooking,
          s.timeType,
          s.appointmentTypeId,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          lat.value_vi AS appointmentTypeVi,
          lat.value_en AS appointmentTypeEn,
          bq.queueNumber,
          bq.id AS bookingQueueId,
          ev.id AS examinationVisitId,
          COALESCE(ev.statusId, ?) AS visitStatusId,
          COALESCE(ev.paymentStatusId, ?) AS paymentStatusId,
          ev.paymentMethodId,
          ev.startedAt,
          ev.completedAt,
          mr.id AS medicalRecordId,
          mr.statusId AS medicalRecordStatusId,
          patient.id AS patientId,
          patient.email AS patientEmail,
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.phoneNumber AS patientPhoneNumber,
          patient.gender AS patientGender,
          patient.address AS patientAddress,
          pp.medicalCode,
          pp.dateOfBirth,
          lvs.value_vi AS visitStatusVi,
          lvs.value_en AS visitStatusEn,
          lps.value_vi AS paymentStatusVi,
          lps.value_en AS paymentStatusEn,
          lpm.value_vi AS paymentMethodVi,
          lpm.value_en AS paymentMethodEn,
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt
        FROM booking b
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        LEFT JOIN booking_queue bq
          ON bq.bookingId = b.id
        INNER JOIN users patient
          ON patient.id = b.patientId
        LEFT JOIN patient_profile pp
          ON pp.patientId = patient.id
        LEFT JOIN lookup lt
          ON lt.keyMap = s.timeType AND lt.type = 'TIME'
        LEFT JOIN lookup lat
          ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
        LEFT JOIN examination_visit ev
          ON ev.bookingId = b.id
        LEFT JOIN medical_record mr
          ON mr.bookingId = b.id
        LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id
        LEFT JOIN lookup lvs
          ON lvs.keyMap = COALESCE(ev.statusId, 'VS1') AND lvs.type = 'VISIT_STATUS'
        LEFT JOIN lookup lps
          ON lps.keyMap = COALESCE(ev.paymentStatusId, 'PS1') AND lps.type = 'PAYMENT_STATUS'
        LEFT JOIN lookup lpm
          ON lpm.keyMap = ev.paymentMethodId AND lpm.type = 'PAYMENT'
        WHERE b.id = ?
          AND b.statusId IN (?, ?, ?)
        LIMIT 1
      `,
      [
        VISIT_STATUS.WAITING,
        PAYMENT_STATUS.UNPAID,
        bookingId,
        ...ACTIVE_QUEUE_BOOKING_STATUSES,
      ]
    );

    if (rows.length === 0) {
      return {
        errCode: 2,
        errMessage: "Appointment not found",
        data: {},
      };
    }

    return ok({
      ...rows[0],
      canJoinVideo: canDoctorOpenVideoBooking(rows[0]),
    });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lấy danh sách hồ sơ bệnh án của bác sĩ, hỗ trợ lọc ngày/trạng thái/tìm kiếm/phân trang.
const getDoctorMedicalRecordList = async (query) => {
  try {
    const doctorId = normalizePositiveId(query?.doctorId, "doctorId");
    const appointmentDateValue = normalizeOptionalString(query?.date || query?.appointmentDate);
    const appointmentDate = appointmentDateValue ? normalizeDate(appointmentDateValue) : null;
    const pagination = normalizePagination(query);
    const visitStatusId = normalizeOptionalString(query?.visitStatusId);
    const recordStatusId = normalizeOptionalString(query?.recordStatusId);
    const sortColumns = {
      medicalRecordId: "mr.id",
      appointmentDate: "ev.examDate",
      queueNumber: "ev.queueNumber",
      patientName: "patientName",
      visitStatusId: "ev.statusId",
      recordStatusId: "mr.statusId",
      completedAt: "ev.completedAt",
    };
    const sortBy = sortColumns[query?.sortBy] || "ev.examDate";
    const sortDirection = normalizeSortDirection(query?.sortDir);
    const filters = ["mr.doctorId = ?"];
    const params = [doctorId];

    // Bộ lọc ngày là tùy chọn; không truyền ngày thì trả toàn bộ hồ sơ thuộc bác sĩ.
    if (appointmentDate) {
      filters.push("ev.examDate = ?");
      params.push(appointmentDate);
    }

    if (visitStatusId) {
      filters.push("ev.statusId = ?");
      params.push(visitStatusId);
    }

    if (recordStatusId) {
      filters.push("mr.statusId = ?");
      params.push(recordStatusId);
    }

    const search = normalizeOptionalString(query?.search);
    if (search) {
      const keyword = `%${search}%`;
      filters.push(`
        (
          CONCAT_WS(' ', patient.firstName, patient.lastName) LIKE ?
          OR patient.email LIKE ?
          OR patient.phoneNumber LIKE ?
          OR pp.medicalCode LIKE ?
          OR b.reason LIKE ?
          OR CAST(mr.id AS CHAR) LIKE ?
        )
      `);
      params.push(keyword, keyword, keyword, keyword, keyword, keyword);
    }

    const whereClause = filters.join(" AND ");
    // baseFrom gom toàn bộ JOIN/filter để query dữ liệu và query đếm luôn khớp nhau.
    const baseFrom = `
      FROM medical_record mr
      INNER JOIN examination_visit ev
        ON ev.id = mr.examinationVisitId
      INNER JOIN booking b
        ON b.id = mr.bookingId
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      INNER JOIN users patient
        ON patient.id = mr.patientId
      LEFT JOIN patient_profile pp
        ON pp.patientId = patient.id
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      LEFT JOIN lookup lvs
        ON lvs.keyMap = ev.statusId AND lvs.type = 'VISIT_STATUS'
      LEFT JOIN lookup lps
        ON lps.keyMap = ev.paymentStatusId AND lps.type = 'PAYMENT_STATUS'
      WHERE ${whereClause}
    `;

    const [rows] = await connection.promise().query(
      `
        SELECT
          mr.id AS medicalRecordId,
          mr.statusId AS medicalRecordStatusId,
          mr.followUpDate,
          mr.closedAt,
          mr.createdAt AS recordCreatedAt,
          ev.id AS examinationVisitId,
          ev.bookingId,
          ev.patientId,
          ev.doctorId,
          ev.examDate,
          ev.queueNumber,
          ev.statusId AS visitStatusId,
          ev.paymentStatusId,
          ev.startedAt,
          ev.completedAt,
          b.date AS appointmentDate,
          b.reason,
          b.priceAtBooking,
          s.timeType,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          CONCAT_WS(' ', patient.firstName, patient.lastName) AS patientName,
          patient.email AS patientEmail,
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.phoneNumber AS patientPhoneNumber,
          pp.medicalCode,
          lvs.value_vi AS visitStatusVi,
          lvs.value_en AS visitStatusEn,
          lps.value_vi AS paymentStatusVi,
          lps.value_en AS paymentStatusEn
        ${baseFrom}
        ORDER BY ${sortBy} ${sortDirection}, ev.queueNumber ASC, mr.id DESC
        LIMIT ? OFFSET ?
      `,
      [...params, pagination.limit, pagination.offset]
    );

    const [countRows] = await connection.promise().query(
      `
        SELECT COUNT(*) AS total
        ${baseFrom}
      `,
      params
    );

    return ok(rows || [], {
      pagination: {
        page: pagination.page,
        limit: pagination.limit,
        total: Number(countRows[0]?.total) || 0,
      },
    });
  } catch (error) {
    return errorResponse(error, []);
  }
};

// Bắt đầu lượt khám từ booking và trả về trạng thái tạo visit/medical record.
const startVisitForBooking = async (data) => {
  try {
    const result = await startExaminationVisitForBooking(data);
    return ok(result.data || {}, {
      created: result.created,
      started: result.started,
      recordCreated: result.recordCreated,
      videoSessionCreated: result.videoSessionCreated,
    });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lấy chi tiết một examination_visit kèm booking, bệnh nhân, bác sĩ và nhãn trạng thái.
const getExaminationVisitDetail = async (query) => {
  try {
    const examinationVisitId = normalizePositiveId(
      query?.examinationVisitId || query?.id,
      "examinationVisitId"
    );

    const [rows] = await connection.promise().query(
      `
        SELECT
          ev.*,
          b.reason,
          b.statusId AS bookingStatusId,
          b.priceAtBooking,
          s.timeType,
          s.appointmentTypeId,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          lat.value_vi AS appointmentTypeVi,
          lat.value_en AS appointmentTypeEn,
          patient.email AS patientEmail,
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.phoneNumber AS patientPhoneNumber,
          patient.gender AS patientGender,
          patient.address AS patientAddress,
          pp.medicalCode,
          pp.dateOfBirth,
          doctor.firstName AS doctorFirstName,
          doctor.lastName AS doctorLastName,
          lvs.value_vi AS visitStatusVi,
          lvs.value_en AS visitStatusEn,
          lps.value_vi AS paymentStatusVi,
          lps.value_en AS paymentStatusEn,
          mr.id AS medicalRecordId,
          mr.statusId AS medicalRecordStatusId,
          vcs.statusId AS videoSessionStatusId,
          vcs.startedAt AS videoStartedAt,
          vcs.endedAt AS videoEndedAt
        FROM examination_visit ev
        INNER JOIN booking b
          ON b.id = ev.bookingId
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        INNER JOIN users patient
          ON patient.id = ev.patientId
        INNER JOIN users doctor
          ON doctor.id = ev.doctorId
        LEFT JOIN patient_profile pp
          ON pp.patientId = ev.patientId
        LEFT JOIN lookup lt
          ON lt.keyMap = s.timeType AND lt.type = 'TIME'
        LEFT JOIN lookup lat
          ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
        LEFT JOIN lookup lvs
          ON lvs.keyMap = ev.statusId AND lvs.type = 'VISIT_STATUS'
        LEFT JOIN lookup lps
          ON lps.keyMap = ev.paymentStatusId AND lps.type = 'PAYMENT_STATUS'
        LEFT JOIN medical_record mr
          ON mr.examinationVisitId = ev.id
        LEFT JOIN video_consultation_session vcs
          ON vcs.bookingId = b.id
        WHERE ev.id = ?
        LIMIT 1
      `,
      [examinationVisitId]
    );

    if (rows.length === 0) {
      return {
        errCode: 2,
        errMessage: "Examination visit not found",
        data: {},
      };
    }

    return ok({
      ...rows[0],
      canJoinVideo: canDoctorOpenVideoBooking(rows[0]),
    });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Đảm bảo một lượt khám đã có hồ sơ bệnh án, tạo mới nếu chưa tồn tại.
const ensureRecordForVisit = async (data) => {
  try {
    const result = await ensureMedicalRecordForVisit(data);
    return ok(result.data || {}, { created: result.created });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lấy chi tiết hồ sơ bệnh án, kèm toa thuốc và danh sách kết quả cận lâm sàng.
const getMedicalRecordDetail = async (query) => {
  try {
    const medicalRecordId = normalizePositiveId(
      query?.medicalRecordId || query?.id,
      "medicalRecordId"
    );

    const [recordRows] = await connection.promise().query(
      `
        SELECT
          mr.*,
          ev.examDate,
          ev.queueNumber,
          ev.statusId AS visitStatusId,
          ev.paymentStatusId,
          ev.paymentMethodId,
          ev.startedAt,
          ev.completedAt,
          b.reason,
          b.priceAtBooking,
          s.timeType,
          lt.value_vi AS timeTypeVi,
          lt.value_en AS timeTypeEn,
          patient.email AS patientEmail,
          patient.firstName AS currentPatientFirstName,
          patient.lastName AS currentPatientLastName,
          patient.phoneNumber AS currentPatientPhoneNumber,
          doctor.firstName AS doctorFirstName,
          doctor.lastName AS doctorLastName
        FROM medical_record mr
        INNER JOIN examination_visit ev
          ON ev.id = mr.examinationVisitId
        INNER JOIN booking b
          ON b.id = mr.bookingId
        INNER JOIN schedule s
          ON s.id = b.scheduleId
        INNER JOIN users patient
          ON patient.id = mr.patientId
        INNER JOIN users doctor
          ON doctor.id = mr.doctorId
        LEFT JOIN lookup lt
          ON lt.keyMap = s.timeType AND lt.type = 'TIME'
        WHERE mr.id = ?
        LIMIT 1
      `,
      [medicalRecordId]
    );

    if (recordRows.length === 0) {
      return {
        errCode: 2,
        errMessage: "Medical record not found",
        data: {},
      };
    }

    const [prescriptionRows] = await connection.promise().query(
      `
        SELECT *
        FROM prescription
        WHERE medicalRecordId = ?
        LIMIT 1
      `,
      [medicalRecordId]
    );

    let prescription = prescriptionRows[0] || null;
    if (prescription) {
      // Khi đã có toa, nạp thêm các dòng thuốc để FE hiển thị/chỉnh sửa một payload hoàn chỉnh.
      const [itemRows] = await connection.promise().query(
        `
          SELECT *
          FROM prescription_item
          WHERE prescriptionId = ?
          ORDER BY id ASC
        `,
        [prescription.id]
      );

      prescription = {
        ...prescription,
        items: itemRows || [],
      };
    }

    const [paraclinicalRows] = await connection.promise().query(
      `
        SELECT *
        FROM paraclinical_result
        WHERE medicalRecordId = ?
        ORDER BY createdAt ASC, id ASC
      `,
      [medicalRecordId]
    );

    return ok({
      ...recordRows[0],
      prescription,
      paraclinicalResults: paraclinicalRows || [],
    });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lưu nháp thông tin khám trong medical_record.
const saveMedicalRecordDraft = async (data) => {
  try {
    const result = await updateMedicalRecordDraft(data);
    return ok(result || {});
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Đảm bảo hồ sơ có toa thuốc, tạo header toa nếu chưa tồn tại.
const ensurePrescriptionForRecord = async (data) => {
  try {
    const result = await getOrCreatePrescriptionForRecord(data);
    return ok(result.data || {}, { created: result.created });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lưu danh sách thuốc của một hồ sơ bệnh án.
const savePrescriptionItemsForRecord = async (data) => {
  try {
    const result = await savePrescriptionForRecord(data);
    return ok(result || {});
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Tạo một kết quả cận lâm sàng đơn lẻ cho hồ sơ.
const createParaclinicalForRecord = async (data) => {
  try {
    const result = await createParaclinicalResult(data);
    return ok(result || {});
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lưu lại toàn bộ danh sách kết quả cận lâm sàng của hồ sơ.
const saveParaclinicalListForRecord = async (data) => {
  try {
    const result = await saveParaclinicalResultsForRecord(data);
    return ok(result || []);
  } catch (error) {
    return errorResponse(error, []);
  }
};

// Hoàn tất lượt khám từ hồ sơ bệnh án và trả thêm kết quả gửi email nếu có.
const completeMedicalRecordVisit = async (data) => {
  try {
    const result = await completeVisitForMedicalRecord(data);
    return ok(result.data || {}, {
      completedNow: result.completedNow,
      resultEmail: result.resultEmail,
    });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Lấy thông tin thanh toán của một lượt khám.
const getVisitPaymentSummaryResponse = async (query) => {
  try {
    const examinationVisitId = normalizePositiveId(
      query?.examinationVisitId || query?.id,
      "examinationVisitId"
    );
    const data = await getVisitPaymentSummary(examinationVisitId);

    if (!data) {
      return {
        errCode: 2,
        errMessage: "Examination visit not found",
        data: {},
      };
    }

    return ok(data);
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Thu tiền lượt khám và cập nhật trạng thái thanh toán.
const collectPaymentForVisit = async (data) => {
  try {
    const result = await collectVisitPayment(data);
    return ok(result.data || {}, { paidNow: result.paidNow });
  } catch (error) {
    return errorResponse(error, {});
  }
};

// Đóng hồ sơ bệnh án sau khi lượt khám đã hoàn tất.
const closeMedicalRecord = async (data) => {
  try {
    const medicalRecordId = normalizePositiveId(data?.medicalRecordId, "medicalRecordId");

    const result = await withTransaction(async (db) => {
      // Khóa hồ sơ và lượt khám liên quan để trạng thái đóng không bị cập nhật song song.
      const [rows] = await db.query(
        `
          SELECT
            mr.*,
            ev.statusId AS visitStatusId
          FROM medical_record mr
          INNER JOIN examination_visit ev
            ON ev.id = mr.examinationVisitId
          WHERE mr.id = ?
          LIMIT 1
          FOR UPDATE
        `,
        [medicalRecordId]
      );

      if (rows.length === 0) {
        const error = new Error("Medical record not found");
        error.errCode = 2;
        throw error;
      }

      const record = rows[0];
      if (record.statusId === MEDICAL_RECORD_STATUS.CLOSED) {
        return { closedNow: false, data: record };
      }

      // Chỉ cho đóng hồ sơ khi lượt khám đã ở trạng thái hoàn tất.
      if (record.visitStatusId !== VISIT_STATUS.COMPLETED) {
        const error = new Error("Visit must be completed before closing record");
        error.errCode = 409;
        throw error;
      }

      await db.query(
        `
          UPDATE medical_record
          SET statusId = ?, closedAt = CURRENT_TIMESTAMP
          WHERE id = ? AND statusId <> ?
        `,
        [
          MEDICAL_RECORD_STATUS.CLOSED,
          medicalRecordId,
          MEDICAL_RECORD_STATUS.CLOSED,
        ]
      );

      const [updatedRows] = await db.query(
        `
          SELECT *
          FROM medical_record
          WHERE id = ?
          LIMIT 1
        `,
        [medicalRecordId]
      );

      return { closedNow: true, data: updatedRows[0] || null };
    });

    return ok(result.data || {}, { closedNow: result.closedNow });
  } catch (error) {
    return errorResponse(error, {});
  }
};

module.exports = {
  getDoctorPatientList,
  getDoctorPatientDetail,
  getDoctorPatientHistory,
  getDoctorQueue,
  getDoctorAppointmentDetail,
  getDoctorMedicalRecordList,
  startVisitForBooking,
  getExaminationVisitDetail,
  ensureRecordForVisit,
  getMedicalRecordDetail,
  saveMedicalRecordDraft,
  ensurePrescriptionForRecord,
  savePrescriptionItemsForRecord,
  createParaclinicalForRecord,
  saveParaclinicalListForRecord,
  completeMedicalRecordVisit,
  getVisitPaymentSummaryResponse,
  collectPaymentForVisit,
  closeMedicalRecord,
};
