const assert = require("assert");
const { normalizeOptionalReason, isValidBookingPrice } = require("./PatientService");

assert.strictEqual(normalizeOptionalReason("   "), null);
assert.strictEqual(normalizeOptionalReason(null), null);
assert.strictEqual(normalizeOptionalReason("  Đau đầu  "), "Đau đầu");
assert.strictEqual(isValidBookingPrice(200000), true);
assert.strictEqual(isValidBookingPrice(0), false);
assert.strictEqual(isValidBookingPrice("invalid"), false);
