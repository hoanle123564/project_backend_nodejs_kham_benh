const assert = require("assert");
const Module = require("module");

const originalLoad = Module._load;
const cancelCalls = [];
const paymentCancelCalls = [];
let cancelResponse = { errCode: 0, data: { bookingId: 101, statusId: "S4" } };
let paymentIntentResponse = {
  errCode: 0,
  data: { paymentId: 9, status: "PENDING", bookingId: null },
};
let paymentCancelResponse = {
  errCode: 0,
  data: { paymentId: 9, status: "EXPIRED", bookingId: null },
};

Module._load = function load(request, parent, isMain) {
  if (request === "../PatientService" && parent?.filename?.endsWith("chatConversationFlow.js")) {
    return {
      bookAppointment: async () => ({ errCode: 0 }),
      cancelBookAppointment: async (args) => {
        cancelCalls.push(args);
        return cancelResponse;
      },
    };
  }

  if (request === "../paymentService" && parent?.filename?.endsWith("chatConversationFlow.js")) {
    return {
      cancelPaymentIntent: async (args) => {
        paymentCancelCalls.push(args);
        return paymentCancelResponse;
      },
      getPaymentIntent: async () => paymentIntentResponse,
    };
  }

  return originalLoad.call(this, request, parent, isMain);
};

const { STATES, defaultCollectedInfo } = require("./chatState");
const {
  handleAskBookingId,
  handleCancelRequest,
  handleCancellationMessage,
  handleWaitPayment,
  parseBookingId,
} = require("./chatConversationFlow");
Module._load = originalLoad;

const createSession = ({
  state = STATES.BOOKING_CREATED,
  bookingId = 101,
  payment = null,
  booking = bookingId ? { id: bookingId } : null,
} = {}) => ({
  sessionId: "cancel-test",
  patientId: 42,
  state,
  bookingId,
  collectedInfo: {
    ...defaultCollectedInfo(),
    booking,
    payment,
  },
});

(async () => {
  assert.strictEqual(parseBookingId("hủy lịch 123"), 123);
  assert.strictEqual(parseBookingId("hủy ngày 12/08"), null);

  cancelCalls.length = 0;
  cancelResponse = { errCode: 0, data: { bookingId: 101, statusId: "S4" } };
  const knownBooking = createSession();
  const knownResponse = await handleCancellationMessage(knownBooking, "hủy");
  assert.strictEqual(cancelCalls[0].BookingId, 101);
  assert.strictEqual(cancelCalls[0].patientId, 42);
  assert.strictEqual(knownResponse.success, true);
  assert.strictEqual(knownResponse.data.cancellation.statusId, "S4");
  assert.strictEqual(knownBooking.state, STATES.CANCELLED);
  assert.strictEqual(knownBooking.bookingId, null);

  const ambiguous = createSession({ bookingId: null });
  const ambiguousResponse = await handleCancelRequest(ambiguous, "hủy lịch");
  assert.strictEqual(ambiguous.state, STATES.ASK_BOOKING_ID);
  assert.match(ambiguousResponse.reply, /booking/i);

  const selectedById = createSession({ bookingId: null });
  await handleAskBookingId(selectedById, "202");
  assert.strictEqual(cancelCalls.at(-1).BookingId, 202);
  assert.strictEqual(selectedById.state, STATES.CANCELLED);

  cancelResponse = { errCode: 2, errMessage: "Booking status transition is not allowed" };
  const failed = createSession();
  const failedResponse = await handleCancelRequest(failed, "hủy");
  assert.strictEqual(failedResponse.success, false);
  assert.strictEqual(failed.state, STATES.BOOKING_CREATED);
  assert.strictEqual(failed.bookingId, 101);

  cancelResponse = { errCode: 0, data: { bookingId: 303, statusId: "S4" } };
  paymentIntentResponse = {
    errCode: 0,
    data: { paymentId: 9, status: "PAID", bookingId: 303 },
  };
  const paidOnline = createSession({
    state: STATES.WAIT_PAYMENT,
    bookingId: null,
    payment: { paymentId: 9, status: "PENDING", bookingId: null },
  });
  await handleWaitPayment(paidOnline, "hủy");
  assert.strictEqual(cancelCalls.at(-1).BookingId, 303);
  assert.strictEqual(paidOnline.state, STATES.CANCELLED);

  paymentIntentResponse = {
    errCode: 0,
    data: { paymentId: 9, status: "PENDING", bookingId: null },
  };
  paymentCancelResponse = {
    errCode: 0,
    data: { paymentId: 9, status: "EXPIRED", bookingId: null },
  };
  const pendingOnline = createSession({
    state: STATES.WAIT_PAYMENT,
    bookingId: null,
    payment: { paymentId: 9, status: "PENDING", bookingId: null },
  });
  await handleWaitPayment(pendingOnline, "hủy");
  assert.strictEqual(paymentCancelCalls.at(-1).paymentId, 9);
  assert.strictEqual(pendingOnline.state, STATES.CANCELLED);

  console.log("chatCancellationFlow test passed");
})().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
