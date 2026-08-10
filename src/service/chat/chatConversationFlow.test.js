const assert = require("assert");
const { STATES, defaultCollectedInfo } = require("./chatState");
const {
  formatConfirmReply,
  formatPaymentPendingReply,
  getPaymentFromBookingResponse,
  completePaidPayment,
} = require("./chatConversationFlow");

const session = {
  sessionId: "test-session",
  state: STATES.CONFIRM_BOOKING,
  bookingId: null,
  collectedInfo: {
    ...defaultCollectedInfo(),
    consultation_type: "online",
    patientName: "Test Patient",
    patientPhone: "0900000000",
    patientEmail: "test@example.com",
    selectedDoctor: { name: "Doctor Test", specialty: "General" },
    selectedSlot: {
      date: "2026-08-10",
      start_time: "08:00",
      end_time: "08:30",
      effectivePrice: 100000,
    },
  },
};

assert.match(formatConfirmReply(session), /100\.000đ/);
assert.match(
  formatPaymentPendingReply({ amount: 100000, paymentCode: "APMTEST" }),
  /100\.000đ/
);
assert.strictEqual(
  getPaymentFromBookingResponse({ errCode: 0, data: { payment: { paymentId: 9 } } }).paymentId,
  9
);
assert.strictEqual(getPaymentFromBookingResponse({ errCode: 0, data: { id: 9 } }), null);

const paidResponse = completePaidPayment(session, {
  paymentId: 9,
  bookingId: 101,
  status: "PAID",
});
assert.strictEqual(session.state, STATES.BOOKING_CREATED);
assert.strictEqual(session.bookingId, 101);
assert.strictEqual(paidResponse.data.booking.id, 101);
console.log("chatConversationFlow test passed");
