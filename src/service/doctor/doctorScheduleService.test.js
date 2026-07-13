const assert = require("assert");
const {
  buildDesiredSlotsFromRules,
} = require("./doctorScheduleService");

const baseFixed = {
  id: 1,
  doctorId: 10,
  ruleType: "FIXED",
  weekday: 6,
  date: null,
  appointmentTypeId: "AT1",
  startTime: "07:00:00",
  endTime: "09:00:00",
  slotDurationMinutes: 30,
  capacity: 2,
  minBookingNoticeDays: 0,
  maxBookingAheadDays: 30,
  price: 100000,
  discountPercent: 0,
  isActive: 1,
};

const flexible = {
  ...baseFixed,
  id: 2,
  ruleType: "FLEXIBLE",
  date: "2026-07-11",
  startTime: "10:00:00",
  endTime: "11:00:00",
  capacity: 3,
};

const fixedOnly = buildDesiredSlotsFromRules([baseFixed], "2026-07-11");
assert.strictEqual(fixedOnly.size, 4);
assert(fixedOnly.has("AT1|07:00:00|07:30:00"));

const flexibleOverridesFixed = buildDesiredSlotsFromRules([baseFixed, flexible], "2026-07-11");
assert.strictEqual(flexibleOverridesFixed.size, 2);
assert(!flexibleOverridesFixed.has("AT1|07:00:00|07:30:00"));
assert(flexibleOverridesFixed.has("AT1|10:00:00|10:30:00"));

const offAll = {
  id: 3,
  doctorId: 10,
  ruleType: "OFF",
  date: "2026-07-11",
  appointmentTypeId: null,
  startTime: "10:30:00",
  endTime: "11:00:00",
  isActive: 1,
};
const withOff = buildDesiredSlotsFromRules([baseFixed, flexible, offAll], "2026-07-11");
assert.strictEqual(withOff.size, 1);
assert(withOff.has("AT1|10:00:00|10:30:00"));

const secondPass = buildDesiredSlotsFromRules([baseFixed, flexible, offAll], "2026-07-11");
assert.deepStrictEqual([...withOff.keys()], [...secondPass.keys()]);
