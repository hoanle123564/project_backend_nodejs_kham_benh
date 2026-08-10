const assert = require("assert");
const { mapScheduleRowToChatSlot } = require("./chatDoctorSearchService");

const slot = mapScheduleRowToChatSlot(
  {
    id: 42,
    doctorId: 7,
    date: "2026-08-10",
    startTime: "08:00:00",
    endTime: "08:30:00",
    appointmentTypeId: "AT2",
    price: 100000,
    bookedCount: 0,
    capacity: 1,
    remaining: 1,
    isActive: 1,
    isBookable: 1,
  },
  0
);

assert.strictEqual(slot.price, 100000);
assert.strictEqual(slot.effectivePrice, 100000);
assert.strictEqual(slot.isBookable, 1);
assert.strictEqual(slot.index, 1);
console.log("chatDoctorSearchService test passed");
