const assert = require("assert");

const Module = require("module");
const originalLoad = Module._load;
let bookingArgs = null;

Module._load = function load(request, parent, isMain) {
  if (request === "../PatientService" && parent?.filename?.endsWith("chatConversationFlow.js")) {
    return {
      bookAppointment: async (...args) => {
        bookingArgs = args;
        return { errCode: 0, data: { payment: { paymentId: 17 } } };
      },
    };
  }
  return originalLoad.call(this, request, parent, isMain);
};

const { createBookingFromSession } = require("./chatConversationFlow");
Module._load = originalLoad;

(async () => {
  const result = await createBookingFromSession({
    patientId: 42,
    collectedInfo: {
      patientName: "Test Patient",
      patientEmail: "test@example.com",
      patientPhone: "0900000000",
      selectedSlot: {
        id: 99,
        date: "2026-08-10",
        start_time: "08:00",
        end_time: "08:30",
      },
    },
  });

  assert.strictEqual(bookingArgs[0].patientId, 42);
  assert.strictEqual(bookingArgs[1], 42);
  assert.strictEqual(result.paymentRequired, true);
  assert.strictEqual(result.payment.paymentId, 17);
  console.log("chatBookingFlow test passed");
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
