const assert = require("node:assert/strict");
const test = require("node:test");
const {
  PAYOS_TERMINAL_FAILURES,
  classifyProviderOutcome,
  validatePatientRefundRequest,
} = require("./refundService");

const validRequest = {
  bookingId: 123,
  bankBin: "970415",
  bankName: "VCB",
  bankAccountNumber: "0123456789",
  bankAccountName: "NGUYEN VAN A",
  reason: "Patient cancellation",
};

const refund = {
  referenceId: "REFUND_123",
  amount: 100000,
  receiverBankBin: "970415",
  receiverAccountNumber: "0123456789",
};

const payout = (state, overrides = {}) => ({
  id: "po_123",
  referenceId: "REFUND_123",
  amount: 100000,
  toBin: "970415",
  toAccountNumber: "0123456789",
  transactions: [{ id: "tx_123", state }],
  ...overrides,
});

test("patient refund validation accepts only the public allow-list", () => {
  const validation = validatePatientRefundRequest(validRequest);
  assert.equal(validation.valid, true);
  assert.equal(validation.value.bookingId, 123);
  assert.equal(validation.value.reason, "Patient cancellation");
});

test("patient refund validation rejects protected and unknown fields", () => {
  const validation = validatePatientRefundRequest({ ...validRequest, amount: 1, refundMode: "MANUAL", patientId: 9, statusId: "RFS3" });
  assert.equal(validation.valid, false);
  assert.match(validation.errors.join(" "), /amount/);
  assert.match(validation.errors.join(" "), /refundMode/);
  assert.match(validation.errors.join(" "), /patientId/);
  assert.match(validation.errors.join(" "), /statusId/);
});

test("patient refund validation enforces BIN and snapshot lengths", () => {
  assert.equal(validatePatientRefundRequest({ ...validRequest, bankBin: "12345" }).valid, false);
  assert.equal(validatePatientRefundRequest({ ...validRequest, bankName: "x".repeat(101) }).valid, false);
  assert.equal(validatePatientRefundRequest({ ...validRequest, bankAccountNumber: "x".repeat(65) }).valid, false);
  assert.equal(validatePatientRefundRequest({ ...validRequest, bankAccountName: "x".repeat(121) }).valid, false);
  assert.equal(validatePatientRefundRequest({ ...validRequest, reason: "x".repeat(501) }).valid, false);
  assert.equal(validatePatientRefundRequest({ ...validRequest, reason: 123 }).valid, false);
});

test("provider state mapper distinguishes success, processing, terminal failure and unknown data", () => {
  assert.equal(classifyProviderOutcome(refund, payout("SUCCEEDED")).kind, "SUCCEEDED");
  assert.equal(classifyProviderOutcome(refund, payout("PROCESSING")).kind, "PROCESSING");
  for (const state of PAYOS_TERMINAL_FAILURES) assert.equal(classifyProviderOutcome(refund, payout(state)).kind, "FAILED");
  assert.equal(classifyProviderOutcome(refund, payout("SOMETHING_NEW")).kind, "UNKNOWN");
  assert.equal(classifyProviderOutcome(refund, { ...payout("SUCCEEDED"), transactions: [] }).kind, "UNKNOWN");
  assert.equal(classifyProviderOutcome(refund, payout("SUCCEEDED", { amount: 999 })).kind, "UNKNOWN");
  assert.equal(classifyProviderOutcome(refund, payout("SUCCEEDED", { toBin: "970436" })).kind, "UNKNOWN");
  assert.equal(classifyProviderOutcome(refund, payout("SUCCEEDED", { referenceId: "OTHER" })).kind, "UNKNOWN");
  assert.equal(classifyProviderOutcome(refund, {
    id: "po_123",
    referenceId: "REFUND_123",
    transactions: { 0: { id: "tx_123", state: "SUCCEEDED", amount: 100000, toBin: "970415", toAccountNumber: "0123456789" } },
  }).kind, "SUCCEEDED");
});
