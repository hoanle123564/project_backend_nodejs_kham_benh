const assert = require("node:assert/strict");
const crypto = require("node:crypto");
const test = require("node:test");
const {
  buildPayoutHeaders,
  buildPayoutSignature,
  createPayosIdempotencyKey,
  getPayoutCandidates,
  getProviderError,
  isValidPayosIdempotencyKey,
} = require("./payosPayoutService");

const payload = {
  referenceId: "REFUND_123",
  amount: 100000,
  description: "Refund booking 456",
  toBin: "970415",
  toAccountNumber: "0123456789",
};

test("PayOS payout signature sorts and URI-encodes the exact payout payload", () => {
  const checksumKey = "payout-checksum";
  const canonical = "amount=100000&description=Refund%20booking%20456&referenceId=REFUND_123&toAccountNumber=0123456789&toBin=970415";
  const expected = crypto.createHmac("sha256", checksumKey).update(canonical).digest("hex");
  assert.equal(buildPayoutSignature(payload, checksumKey), expected);
});

test("PayOS payout headers contain separate credentials and no category", () => {
  const headers = buildPayoutHeaders({
    payload,
    idempotencyKey: "00000000-0000-4000-8000-000000000123",
    config: { clientId: "client", apiKey: "api", checksumKey: "checksum" },
  });
  assert.equal(headers["x-client-id"], "client");
  assert.equal(headers["x-api-key"], "api");
  assert.equal(headers["x-idempotency-key"], "00000000-0000-4000-8000-000000000123");
  assert.equal(typeof headers["x-signature"], "string");
  assert.equal(Object.prototype.hasOwnProperty.call(payload, "category"), false);
});

test("PayOS payout idempotency keys are provider-compatible UUIDs", () => {
  const key = createPayosIdempotencyKey();
  assert.equal(isValidPayosIdempotencyKey(key), true);
  assert.equal(isValidPayosIdempotencyKey("refund:123"), false);
  assert.equal(Object.prototype.hasOwnProperty.call(buildPayoutHeaders({ payload, config: { clientId: "client", apiKey: "api", checksumKey: "checksum" } }), "x-idempotency-key"), false);
});

test("PayOS list response candidates support array and items envelopes", () => {
  assert.deepEqual(getPayoutCandidates({ data: [{ id: "one" }] }), [{ id: "one" }]);
  assert.deepEqual(getPayoutCandidates({ data: { items: [{ id: "two" }] } }), [{ id: "two" }]);
  assert.deepEqual(getPayoutCandidates({ data: { payouts: { 0: { id: "three" } } } }), [{ id: "three" }]);
  assert.deepEqual(getPayoutCandidates({ data: null }), []);
});

test("PayOS IP rejection is normalized without retaining the raw response", () => {
  const error = getProviderError({
    statusCode: 403,
    body: { code: "403", desc: "Địa chỉ IP không được phép truy cập hệ thống", sensitive: "should-not-be-used" },
  });
  assert.deepEqual(error, {
    state: "HTTP_403_IP_NOT_ALLOWED",
    code: "403",
    message: "Địa chỉ IP không được phép truy cập hệ thống",
    statusCode: 403,
  });
  assert.equal(Object.prototype.hasOwnProperty.call(error, "sensitive"), false);
});

test("Successful PayOS responses do not produce a provider error", () => {
  assert.equal(getProviderError({ statusCode: 200, body: { code: "00", desc: "success" } }), null);
});
