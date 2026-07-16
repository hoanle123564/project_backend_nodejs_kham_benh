const connection = require("../config/data");

const FORBIDDEN_RESPONSE = {
  errCode: 403,
  errMessage: "Permission denied",
};

// Chuẩn hóa id về số nguyên dương, trả null nếu dữ liệu không hợp lệ.
const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

// Kiểm tra user có phải admin hệ thống hay không.
const isAdmin = (user) => user?.roleId === "R1";

// Kiểm tra user có phải bệnh nhân hay không.
const isPatient = (user) => user?.roleId === "R3";

// Kiểm tra user thuộc nhóm có quyền quản lý phòng khám/bác sĩ.
const isClinicManagerRole = (user) => ["R4", "R2"].includes(user?.roleId);

// Kiểm tra user có quyền quản lý một phòng khám cụ thể hay không.
const canManageClinic = async (user, clinicId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedClinicId = normalizePositiveId(clinicId);
  const userId = normalizePositiveId(user?.id);
  if (!normalizedClinicId || !userId || !isClinicManagerRole(user)) {
    return false;
  }

  const [rows] = await connection.promise().query(
    `SELECT id FROM clinic WHERE id = ? AND managerUserId = ? LIMIT 1`,
    [normalizedClinicId, userId]
  );

  return rows.length > 0;
};

// Lấy clinicId hiện tại của bác sĩ từ doctor_info.
const getDoctorClinicId = async (doctorId) => {
  const normalizedDoctorId = normalizePositiveId(doctorId);
  if (!normalizedDoctorId) {
    return null;
  }

  const [rows] = await connection.promise().query(
    `SELECT clinicId FROM doctor_info WHERE doctorId = ? LIMIT 1`,
    [normalizedDoctorId]
  );

  return rows?.[0]?.clinicId || null;
};

// Lấy clinicId của chuyên khoa/phòng ban để kiểm tra quyền theo phòng khám.
const getDepartmentClinicId = async (departmentId) => {
  const normalizedDepartmentId = normalizePositiveId(departmentId);
  if (!normalizedDepartmentId) {
    return null;
  }

  const [rows] = await connection.promise().query(
    `SELECT clinicId FROM clinic_department WHERE id = ? LIMIT 1`,
    [normalizedDepartmentId]
  );

  return rows?.[0]?.clinicId || null;
};

// Kiểm tra user có quyền quản lý lịch của bác sĩ hay không.
const canManageDoctorSchedule = async (user, doctorId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedDoctorId = normalizePositiveId(doctorId);
  const userId = normalizePositiveId(user?.id);
  if (!normalizedDoctorId || !userId) {
    return false;
  }

  if (user?.roleId === "R2" && normalizedDoctorId === userId) {
    return true;
  }

  if (!isClinicManagerRole(user)) {
    return false;
  }

  const [rows] = await connection.promise().query(
    `
      SELECT di.doctorId
      FROM doctor_info di
      INNER JOIN clinic c
        ON c.id = di.clinicId
      WHERE di.doctorId = ? AND c.managerUserId = ?
      LIMIT 1
    `,
    [normalizedDoctorId, userId]
  );

  return rows.length > 0;
};

// Kiểm tra quyền lưu thông tin bác sĩ, bao gồm phòng khám đích và phòng khám hiện tại.
const canSaveDoctorInfo = async (user, doctorId, targetClinicId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedDoctorId = normalizePositiveId(doctorId);
  const userId = normalizePositiveId(user?.id);
  if (user?.roleId === "R2") {
    return Boolean(normalizedDoctorId && userId && normalizedDoctorId === userId);
  }

  const normalizedTargetClinicId = normalizePositiveId(targetClinicId);
  if (!normalizedDoctorId || !normalizedTargetClinicId || !isClinicManagerRole(user)) {
    return false;
  }

  const canManageTargetClinic = await canManageClinic(user, normalizedTargetClinicId);
  if (!canManageTargetClinic) {
    return false;
  }

  const currentClinicId = await getDoctorClinicId(normalizedDoctorId);
  if (!currentClinicId) {
    return true;
  }

  return canManageClinic(user, currentClinicId);
};

// Kiểm tra quyền quản lý một lịch khám dựa trên scheduleId.
const canManageSchedule = async (user, scheduleId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedScheduleId = normalizePositiveId(scheduleId);
  if (!normalizedScheduleId) {
    return false;
  }

  const [rows] = await connection.promise().query(
    `SELECT doctorId FROM schedule WHERE id = ? LIMIT 1`,
    [normalizedScheduleId]
  );

  if (rows.length === 0) {
    return false;
  }

  return canManageDoctorSchedule(user, rows[0].doctorId);
};

// Kiểm tra quyền quản lý chuyên khoa/phòng ban theo clinicId liên kết.
const canManageDepartment = async (user, departmentId) => {
  if (isAdmin(user)) {
    return true;
  }

  const clinicId = await getDepartmentClinicId(departmentId);
  if (!clinicId) {
    return false;
  }

  return canManageClinic(user, clinicId);
};

// Kiểm tra quyền quản lý booking dựa trên bác sĩ sở hữu lịch của booking đó.
const canManageBooking = async (user, bookingId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedBookingId = normalizePositiveId(bookingId);
  if (!normalizedBookingId) {
    return false;
  }

  const [rows] = await connection.promise().query(
    `
      SELECT s.doctorId
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      WHERE b.id = ?
      LIMIT 1
    `,
    [normalizedBookingId]
  );

  if (rows.length === 0) {
    return false;
  }

  return canManageDoctorSchedule(user, rows[0].doctorId);
};

// Kiểm tra bệnh nhân hiện tại có phải chủ sở hữu booking hay không.
const isPatientOwnerOfBooking = async (user, bookingId) => {
  const normalizedBookingId = normalizePositiveId(bookingId);
  const userId = normalizePositiveId(user?.id);
  if (!normalizedBookingId || !userId || !isPatient(user)) {
    return false;
  }

  const [rows] = await connection.promise().query(
    `
      SELECT id
      FROM booking
      WHERE id = ? AND patientId = ?
      LIMIT 1
    `,
    [normalizedBookingId, userId]
  );

  return rows.length > 0;
};

// Kiểm tra quyền xem booking: bệnh nhân chủ booking hoặc người có quyền quản lý booking.
const canViewBooking = async (user, bookingId) => {
  if (await isPatientOwnerOfBooking(user, bookingId)) {
    return true;
  }

  return canManageBooking(user, bookingId);
};

// Lấy thông tin chủ sở hữu của lượt khám để tái sử dụng cho kiểm tra quyền.
const getVisitOwnerContext = async (examinationVisitId) => {
  const normalizedVisitId = normalizePositiveId(examinationVisitId);
  if (!normalizedVisitId) {
    return null;
  }

  const [rows] = await connection.promise().query(
    `
      SELECT id, bookingId, patientId, doctorId
      FROM examination_visit
      WHERE id = ?
      LIMIT 1
    `,
    [normalizedVisitId]
  );

  return rows[0] || null;
};

// Kiểm tra quyền thao tác lượt khám theo bác sĩ sở hữu lượt khám.
const canManageVisit = async (user, examinationVisitId) => {
  if (isAdmin(user)) {
    return true;
  }

  const context = await getVisitOwnerContext(examinationVisitId);
  if (!context) {
    return false;
  }

  return canManageDoctorSchedule(user, context.doctorId);
};

// Kiểm tra quyền xem lượt khám cho bệnh nhân chủ sở hữu hoặc phía quản lý/bác sĩ.
const canViewVisit = async (user, examinationVisitId) => {
  const context = await getVisitOwnerContext(examinationVisitId);
  if (!context) {
    return false;
  }

  const userId = normalizePositiveId(user?.id);
  if (isPatient(user) && userId === Number(context.patientId)) {
    return true;
  }

  return canManageDoctorSchedule(user, context.doctorId);
};

// Lấy thông tin chủ sở hữu hồ sơ bệnh án để tái sử dụng cho kiểm tra quyền.
const getMedicalRecordOwnerContext = async (medicalRecordId) => {
  const normalizedRecordId = normalizePositiveId(medicalRecordId);
  if (!normalizedRecordId) {
    return null;
  }

  const [rows] = await connection.promise().query(
    `
      SELECT id, bookingId, examinationVisitId, patientId, doctorId, statusId
      FROM medical_record
      WHERE id = ?
      LIMIT 1
    `,
    [normalizedRecordId]
  );

  return rows[0] || null;
};

// Kiểm tra quyền thao tác hồ sơ bệnh án theo bác sĩ sở hữu hồ sơ.
const canManageMedicalRecord = async (user, medicalRecordId) => {
  if (isAdmin(user)) {
    return true;
  }

  const context = await getMedicalRecordOwnerContext(medicalRecordId);
  if (!context) {
    return false;
  }

  return canManageDoctorSchedule(user, context.doctorId);
};

// Kiểm tra quyền xem hồ sơ bệnh án cho bệnh nhân chủ sở hữu hoặc phía quản lý/bác sĩ.
const canViewMedicalRecord = async (user, medicalRecordId) => {
  const context = await getMedicalRecordOwnerContext(medicalRecordId);
  if (!context) {
    return false;
  }

  const userId = normalizePositiveId(user?.id);
  if (isPatient(user) && userId === Number(context.patientId)) {
    return true;
  }

  return canManageDoctorSchedule(user, context.doctorId);
};

// Kiểm tra user có được xem danh sách booking ở màn quản trị/doctor/clinic hay không.
const canViewBookingList = (user) => ["R1", "R2", "R4"].includes(user?.roleId);

// Tạo điều kiện WHERE và params giới hạn danh sách booking theo role hiện tại.
const getBookingListScope = (user) => {
  const userId = normalizePositiveId(user?.id);

  if (isAdmin(user)) {
    return { allowed: true, whereClause: "", params: [] };
  }

  if (!userId || user?.roleId === "R3") {
    return { allowed: false, whereClause: "", params: [] };
  }

  if (user?.roleId === "R4") {
    return {
      allowed: true,
      whereClause: "WHERE c.managerUserId = ?",
      params: [userId],
    };
  }

  if (user?.roleId === "R2") {
    return {
      allowed: true,
      whereClause: "WHERE s.doctorId = ?",
      params: [userId],
    };
  }

  return { allowed: false, whereClause: "", params: [] };
};

module.exports = {
  FORBIDDEN_RESPONSE,
  canManageClinic,
  canManageDepartment,
  canSaveDoctorInfo,
  canManageDoctorSchedule,
  canManageSchedule,
  canManageBooking,
  isPatientOwnerOfBooking,
  canViewBooking,
  canManageVisit,
  canViewVisit,
  canManageMedicalRecord,
  canViewMedicalRecord,
  canViewBookingList,
  getBookingListScope,
};
