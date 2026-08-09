const assert = require("assert");
const {
  fixedRulesOverlap,
  findFixedRuleOverlap,
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

const fixedSlot = {
  id: 10,
  doctorId: 10,
  ruleType: "FIXED",
  isActive: 1,
  weekday: 1,
  appointmentTypeId: "AT1",
  startTime: "09:00",
  endTime: "10:00",
};
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11 }),
  true
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, startTime: "09:30", endTime: "10:30" }),
  true
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, startTime: "10:00", endTime: "11:00" }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, weekday: 2 }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, doctorId: 99 }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, appointmentTypeId: "AT2" }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, isActive: 0 }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, ruleType: "OFF" }),
  false
);
assert.strictEqual(
  fixedRulesOverlap(fixedSlot, { ...fixedSlot, id: 11, ruleType: "FLEXIBLE" }),
  false
);
assert.strictEqual(
  findFixedRuleOverlap(fixedSlot, [fixedSlot], fixedSlot.id),
  null
);
assert.strictEqual(
  findFixedRuleOverlap(fixedSlot, [{ ...fixedSlot, id: 11 }], fixedSlot.id).id,
  11
);

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
