const connection = require("../config/data");

const FORBIDDEN_RESPONSE = {
  errCode: 403,
  errMessage: "Permission denied",
};

const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const isAdmin = (user) => user?.roleId === "R1";

const isClinicManagerRole = (user) => ["R4", "R2"].includes(user?.roleId);

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

const canSaveDoctorInfo = async (user, doctorId, targetClinicId) => {
  if (isAdmin(user)) {
    return true;
  }

  const normalizedDoctorId = normalizePositiveId(doctorId);
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

const canViewBookingList = (user) => ["R1", "R2", "R4"].includes(user?.roleId);

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
      whereClause: "WHERE (s.doctorId = ? OR c.managerUserId = ?)",
      params: [userId, userId],
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
  canViewBookingList,
  getBookingListScope,
};
