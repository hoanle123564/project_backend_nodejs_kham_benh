const assert = require("assert");
const {
  calculateFinalPrice,
  generateSlots,
  isDateInBookingWindow,
  rangesOverlap,
  validateRulePayload,
} = require("./doctorSchedulePolicy");

assert.deepStrictEqual(generateSlots("07:00", "08:10", 30), [
  { startTime: "07:00:00", endTime: "07:30:00" },
  { startTime: "07:30:00", endTime: "08:00:00" },
]);

assert.strictEqual(rangesOverlap("07:00", "07:30", "07:30", "08:00"), false);
assert.strictEqual(rangesOverlap("07:00", "07:31", "07:30", "08:00"), true);

assert.strictEqual(
  isDateInBookingWindow("2026-07-13", 1, 3, new Date("2026-07-11T10:00:00+07:00")),
  true
);
assert.strictEqual(
  isDateInBookingWindow("2026-07-11", 1, 3, new Date("2026-07-11T10:00:00+07:00")),
  false
);
assert.strictEqual(
  isDateInBookingWindow("2026-07-15", 1, 3, new Date("2026-07-11T10:00:00+07:00")),
  false
);

assert.strictEqual(calculateFinalPrice(100000, 10), 90000);
assert.strictEqual(calculateFinalPrice(100000, 100), 0);

const fixed = validateRulePayload({
  ruleType: "FIXED",
  weekday: 1,
  appointmentTypeId: "AT1",
  startTime: "07:00",
  endTime: "11:00",
  slotDurationMinutes: 30,
  capacity: 3,
  minBookingNoticeDays: 0,
  maxBookingAheadDays: 30,
  price: 100000,
  discountPercent: 5,
});
assert.strictEqual(fixed.ok, true);

const invalid = validateRulePayload({
  ruleType: "FLEXIBLE",
  date: "2026-07-11",
  appointmentTypeId: "AT1",
  startTime: "11:00",
  endTime: "07:00",
  slotDurationMinutes: 0,
  capacity: 0,
  minBookingNoticeDays: 5,
  maxBookingAheadDays: 3,
});
assert.strictEqual(invalid.ok, false);
