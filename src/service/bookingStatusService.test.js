const assert = require("assert");
const { BOOKING_STATUS } = require("./workflowStatusService");
const {
  TERMINAL_BOOKING_STATUS_IDS,
  buildCapacitySummary,
  canMarkPatientNoShow,
  getCapacityExcludedStatusIds,
  getAllowedStatusIds,
  isBookingActiveForCapacity,
} = require("./bookingStatusService");

assert.deepStrictEqual(getAllowedStatusIds(BOOKING_STATUS.CONFIRMED, "R2"), [
  BOOKING_STATUS.DOCTOR_CONFIRMED,
  BOOKING_STATUS.REJECTED_BY_DOCTOR,
]);
assert.deepStrictEqual(getAllowedStatusIds(BOOKING_STATUS.DOCTOR_CONFIRMED, "R2"), [
  BOOKING_STATUS.PATIENT_NO_SHOW,
]);
assert.deepStrictEqual(getAllowedStatusIds(BOOKING_STATUS.CONFIRMED, "R3"), [
  BOOKING_STATUS.CANCELLED_BY_PATIENT,
]);
assert.deepStrictEqual(getAllowedStatusIds(BOOKING_STATUS.COMPLETED, "R2"), []);
for (const statusId of ["S3", "S4", "S5", "S6", "S7"]) {
  assert.deepStrictEqual(getAllowedStatusIds(statusId, "R2"), []);
  assert(TERMINAL_BOOKING_STATUS_IDS.includes(statusId));
}
assert.strictEqual(canMarkPatientNoShow(null), true);
assert.strictEqual(canMarkPatientNoShow("VS1"), true);
assert.strictEqual(canMarkPatientNoShow("VS2"), false);
assert.strictEqual(canMarkPatientNoShow("VS3"), false);
assert.deepStrictEqual(buildCapacitySummary(2, 3), {
  bookedCount: 2,
  capacity: 3,
  remaining: 1,
  hasActiveBooking: 1,
  isFull: 0,
});
assert.deepStrictEqual(buildCapacitySummary(3, 3), {
  bookedCount: 3,
  capacity: 3,
  remaining: 0,
  hasActiveBooking: 1,
  isFull: 1,
});
assert.strictEqual(isBookingActiveForCapacity(BOOKING_STATUS.CONFIRMED), true);
assert.strictEqual(isBookingActiveForCapacity(BOOKING_STATUS.CANCELLED_BY_DOCTOR), false);
assert(getCapacityExcludedStatusIds().includes(BOOKING_STATUS.CANCELLED_BY_DOCTOR));
