const assert = require("node:assert/strict");
const test = require("node:test");
const { normalizeSessionTitle } = require("./chatSessionStore");

test("normalizeSessionTitle trims and collapses whitespace", () => {
  assert.equal(normalizeSessionTitle("  Khám   đau vai  "), "Khám đau vai");
});

test("normalizeSessionTitle rejects empty and overlong titles", () => {
  assert.throws(() => normalizeSessionTitle("   "), { statusCode: 400 });
  assert.throws(() => normalizeSessionTitle("a".repeat(256)), { statusCode: 400 });
});
