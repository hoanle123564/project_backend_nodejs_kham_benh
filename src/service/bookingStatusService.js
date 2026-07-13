const { withTransaction } = require("./transactionService");
const {
  LOOKUP_TYPES,
  BOOKING_STATUS,
  VISIT_STATUS,
  assertLookupKey,
} = require("./workflowStatusService");
const {
  APPOINTMENT_TYPE_ONLINE,
  VIDEO_STATUS_CANCELLED,
  VIDEO_STATUS_ENDED,
  VIDEO_STATUS_IN_CALL,
} = require("./videoConsultationService");

const INACTIVE_BOOKING_STATUS_IDS = Object.freeze([
  BOOKING_STATUS.CANCELLED_BY_PATIENT,
  BOOKING_STATUS.CANCELLED_BY_DOCTOR,
  BOOKING_STATUS.REJECTED_BY_DOCTOR,
  BOOKING_STATUS.PATIENT_NO_SHOW,
]);

const TERMINAL_BOOKING_STATUS_IDS = Object.freeze([
  BOOKING_STATUS.COMPLETED,
  ...INACTIVE_BOOKING_STATUS_IDS,
]);

const CAPACITY_EXCLUDED_BOOKING_STATUS_IDS = TERMINAL_BOOKING_STATUS_IDS;

const DOCTOR_TRANSITIONS = Object.freeze({
  [BOOKING_STATUS.CONFIRMED]: [
    BOOKING_STATUS.DOCTOR_CONFIRMED,
    BOOKING_STATUS.REJECTED_BY_DOCTOR,
  ],
  [BOOKING_STATUS.DOCTOR_CONFIRMED]: [BOOKING_STATUS.PATIENT_NO_SHOW],
});

const getAllowedStatusIds = (statusId, roleId) => {
  if (roleId === "R2") return DOCTOR_TRANSITIONS[statusId] || [];
  if (roleId === "R3" && [BOOKING_STATUS.PENDING, BOOKING_STATUS.CONFIRMED].includes(statusId)) {
    return [BOOKING_STATUS.CANCELLED_BY_PATIENT];
  }
  return [];
};

const getReasonColumn = (statusId) => {
  if ([BOOKING_STATUS.CANCELLED_BY_PATIENT, BOOKING_STATUS.CANCELLED_BY_DOCTOR].includes(statusId)) {
    return "cancelReason";
  }
  if (statusId === BOOKING_STATUS.REJECTED_BY_DOCTOR) return "rejectReason";
  if (statusId === BOOKING_STATUS.PATIENT_NO_SHOW) return "noShowNote";
  return null;
};

const canMarkPatientNoShow = (visitStatusId) =>
  !visitStatusId || visitStatusId === VISIT_STATUS.WAITING;

const isBookingActiveForCapacity = (statusId) =>
  Boolean(statusId) && !CAPACITY_EXCLUDED_BOOKING_STATUS_IDS.includes(statusId);

const buildCapacitySummary = (bookedCount, capacity) => {
  const count = Math.max(0, Number(bookedCount) || 0);
  const max = Math.max(1, Number(capacity) || 1);
  return {
    bookedCount: count,
    capacity: max,
    remaining: Math.max(0, max - count),
    hasActiveBooking: count > 0 ? 1 : 0,
    isFull: count >= max ? 1 : 0,
  };
};

const getCapacityExcludedStatusIds = () => [...CAPACITY_EXCLUDED_BOOKING_STATUS_IDS];

const normalizeBookingId = (bookingId) => {
  const normalized = Number(bookingId);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const updateVideoStatusForCancelledBooking = async (db, booking) => {
  if (booking.appointmentTypeId !== APPOINTMENT_TYPE_ONLINE) return;

  await db.query(
    `
      UPDATE video_consultation_session
      SET statusId = ?, endedAt = COALESCE(endedAt, CURRENT_TIMESTAMP)
      WHERE bookingId = ? AND statusId <> ?
    `,
    [VIDEO_STATUS_CANCELLED, booking.id, VIDEO_STATUS_ENDED]
  );
};

const updateBookingStatus = async ({ bookingId, statusId, note, actor }) => {
  const normalizedBookingId = normalizeBookingId(bookingId);
  const normalizedStatusId = String(statusId || "").trim();
  const normalizedNote = String(note || "").trim() || null;

  if (!normalizedBookingId || !normalizedStatusId || !actor?.id || !actor?.roleId) {
    return { errCode: 1, errMessage: "Missing required parameters" };
  }

  try {
    return await withTransaction(async (db) => {
      const targetLookup = await assertLookupKey(LOOKUP_TYPES.BOOKING_STATUS, normalizedStatusId, db);
      const [rows] = await db.query(
        `
          SELECT b.id, b.statusId, b.patientId, s.doctorId, s.appointmentTypeId,
                 ev.statusId AS visitStatusId,
                 vcs.statusId AS videoSessionStatusId
          FROM booking b
          INNER JOIN schedule s ON s.id = b.scheduleId
          LEFT JOIN examination_visit ev ON ev.bookingId = b.id
          LEFT JOIN video_consultation_session vcs ON vcs.bookingId = b.id
          WHERE b.id = ?
          LIMIT 1
          FOR UPDATE
        `,
        [normalizedBookingId]
      );

      const booking = rows[0];
      if (!booking) return { errCode: 2, errMessage: "Booking does not exist" };
      if (actor.roleId === "R2" && Number(booking.doctorId) !== Number(actor.id)) {
        return { errCode: 403, errMessage: "Permission denied" };
      }
      if (actor.roleId === "R3" && Number(booking.patientId) !== Number(actor.id)) {
        return { errCode: 403, errMessage: "Permission denied" };
      }

      await assertLookupKey(LOOKUP_TYPES.BOOKING_STATUS, booking.statusId, db);
      if (TERMINAL_BOOKING_STATUS_IDS.includes(booking.statusId)) {
        return { errCode: 2, errMessage: "Completed or cancelled bookings cannot be changed" };
      }
      const allowedStatusIds = getAllowedStatusIds(booking.statusId, actor.roleId);
      if (actor.roleId !== "R1" && !allowedStatusIds.includes(normalizedStatusId)) {
        return { errCode: 2, errMessage: "Booking status transition is not allowed" };
      }
      if (actor.roleId !== "R1" && booking.statusId === normalizedStatusId) {
        return { errCode: 2, errMessage: "Booking already has this status" };
      }
      if (
        normalizedStatusId === BOOKING_STATUS.PATIENT_NO_SHOW &&
        !canMarkPatientNoShow(booking.visitStatusId)
      ) {
        return { errCode: 2, errMessage: "Patient no-show cannot be set after the visit has started" };
      }
      if (
        booking.videoSessionStatusId === VIDEO_STATUS_IN_CALL &&
        [BOOKING_STATUS.CANCELLED_BY_PATIENT, BOOKING_STATUS.CANCELLED_BY_DOCTOR].includes(normalizedStatusId)
      ) {
        return { errCode: 3, errMessage: "Online appointment cannot be canceled after the video room has started" };
      }

      const reasonColumn = getReasonColumn(normalizedStatusId);
      const updateColumns = ["statusId = ?", "statusUpdatedAt = CURRENT_TIMESTAMP"];
      const params = [normalizedStatusId];
      if (reasonColumn) {
        updateColumns.push(`${reasonColumn} = ?`);
        params.push(normalizedNote);
      }
      params.push(booking.id);

      await db.query(`UPDATE booking SET ${updateColumns.join(", ")} WHERE id = ?`, params);
      if (INACTIVE_BOOKING_STATUS_IDS.includes(normalizedStatusId)) {
        await updateVideoStatusForCancelledBooking(db, booking);
      }

      return {
        errCode: 0,
        errMessage: "Booking status updated successfully",
        data: {
          bookingId: booking.id,
          statusId: normalizedStatusId,
          statusVi: targetLookup.value_vi,
          statusEn: targetLookup.value_en,
          reasonColumn,
          note: normalizedNote,
        },
      };
    });
  } catch (error) {
    return { errCode: error.errCode || 1, errMessage: error.message || "Error from server" };
  }
};

const cancelBookingsByScheduleChangeInCurrentTransaction = async ({ bookingIds, note }, db) => {
  const ids = (bookingIds || [])
    .map((id) => Number(id))
    .filter((id) => Number.isInteger(id) && id > 0);
  const normalizedNote = String(note || "Schedule changed by doctor").trim();

  if (!ids.length) {
    return { affectedRows: 0, bookingIds: [] };
  }

  const placeholders = ids.map(() => "?").join(", ");
  const inactivePlaceholders = CAPACITY_EXCLUDED_BOOKING_STATUS_IDS.map(() => "?").join(", ");
  const [rows] = await db.query(
    `
      SELECT b.id, s.appointmentTypeId
      FROM booking b
      INNER JOIN schedule s ON s.id = b.scheduleId
      WHERE b.id IN (${placeholders})
        AND b.statusId NOT IN (${inactivePlaceholders})
      FOR UPDATE
    `,
    [...ids, ...CAPACITY_EXCLUDED_BOOKING_STATUS_IDS]
  );
  const activeIds = rows.map((row) => row.id);
  if (!activeIds.length) {
    return { affectedRows: 0, bookingIds: [] };
  }

  const activePlaceholders = activeIds.map(() => "?").join(", ");
  await db.query(
    `
      UPDATE booking
      SET statusId = ?, cancelReason = ?, statusUpdatedAt = CURRENT_TIMESTAMP
      WHERE id IN (${activePlaceholders})
    `,
    [BOOKING_STATUS.CANCELLED_BY_DOCTOR, normalizedNote, ...activeIds]
  );

  await db.query(
    `
      UPDATE video_consultation_session
      SET statusId = ?, endedAt = COALESCE(endedAt, CURRENT_TIMESTAMP)
      WHERE bookingId IN (${activePlaceholders})
        AND statusId <> ?
    `,
    [VIDEO_STATUS_CANCELLED, ...activeIds, VIDEO_STATUS_ENDED]
  );

  return { affectedRows: activeIds.length, bookingIds: activeIds };
};

module.exports = {
  CAPACITY_EXCLUDED_BOOKING_STATUS_IDS,
  INACTIVE_BOOKING_STATUS_IDS,
  TERMINAL_BOOKING_STATUS_IDS,
  buildCapacitySummary,
  cancelBookingsByScheduleChangeInCurrentTransaction,
  canMarkPatientNoShow,
  getCapacityExcludedStatusIds,
  getAllowedStatusIds,
  isBookingActiveForCapacity,
  updateBookingStatus,
};
