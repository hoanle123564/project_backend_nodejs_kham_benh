const assert = require("assert");
const {
  generateSlots,
  rangesOverlap,
  validateRulePayload,
} = require("./doctorSchedulePolicy");

assert.deepStrictEqual(generateSlots("07:00", "08:10", 30), [
  { startTime: "07:00:00", endTime: "07:30:00" },
  { startTime: "07:30:00", endTime: "08:00:00" },
]);

assert.strictEqual(rangesOverlap("07:00", "07:30", "07:30", "08:00"), false);
assert.strictEqual(rangesOverlap("07:00", "07:31", "07:30", "08:00"), true);

const fixed = validateRulePayload({
  ruleType: "FIXED",
  weekday: 1,
  appointmentTypeId: "AT1",
  startTime: "07:00",
  endTime: "11:00",
  slotDurationMinutes: 30,
  capacity: 3,
  price: 100000,
});
assert.strictEqual(fixed.ok, true);

const offAllDay = validateRulePayload({
  ruleType: "OFF",
  date: "2026-07-11",
  startTime: "00:00",
  endTime: "23:59",
});
assert.strictEqual(offAllDay.ok, true);

const invalid = validateRulePayload({
  ruleType: "FLEXIBLE",
  date: "2026-07-11",
  appointmentTypeId: "AT1",
  startTime: "11:00",
  endTime: "07:00",
  slotDurationMinutes: 0,
  capacity: 0,
  price: 0,
});
assert.strictEqual(invalid.ok, false);
