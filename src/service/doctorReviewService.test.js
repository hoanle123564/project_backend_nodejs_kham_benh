const assert = require("assert");
const { BOOKING_STATUS } = require("./workflowStatusService");
const {
  buildRatingSummary,
  getReviewEligibilityFromBooking,
  normalizeLimitedText,
  normalizeRating,
  validateDateRange,
} = require("./doctorReviewService");

const formatDateOffset = (offsetDays) => {
  const date = new Date();
  date.setDate(date.getDate() + offsetDays);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};

assert.deepStrictEqual(normalizeRating(5), { ok: true, value: 5 });
assert.deepStrictEqual(normalizeRating("5"), { ok: true, value: 5 });
assert.strictEqual(normalizeRating(0).ok, false);
assert.strictEqual(normalizeRating(6).ok, false);
assert.strictEqual(normalizeRating(4.5).ok, false);
assert.strictEqual(normalizeRating("4.5").ok, false);
assert.strictEqual(normalizeRating("five").ok, false);

assert.deepStrictEqual(normalizeLimitedText("  ok  ", "Comment"), { ok: true, value: "ok" });
assert.strictEqual(normalizeLimitedText("   ", "Comment").ok, false);
assert.strictEqual(normalizeLimitedText("x".repeat(1001), "Comment").ok, false);

assert.deepStrictEqual(
  buildRatingSummary([
    { rating: 5, count: 3 },
    { rating: 4, count: 1 },
    { rating: 1, count: 1 },
  ]),
  {
    averageRating: 4,
    totalReviews: 5,
    ratingCounts: { 5: 3, 4: 1, 3: 0, 2: 0, 1: 1 },
    ratingPercentages: { 5: 60, 4: 20, 3: 0, 2: 0, 1: 20 },
  }
);

assert.deepStrictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.COMPLETED }), {
  eligible: true,
  reviewed: false,
  reason: null,
});
assert.deepStrictEqual(getReviewEligibilityFromBooking({ reviewId: 10, statusId: BOOKING_STATUS.COMPLETED }), {
  eligible: false,
  reviewed: true,
  reason: "ALREADY_REVIEWED",
});
assert.strictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.CONFIRMED }).reason, "BOOKING_NOT_COMPLETED");
assert.strictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.CANCELLED_BY_PATIENT }).reason, "BOOKING_CANCELLED");
assert.strictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.CANCELLED_BY_DOCTOR }).reason, "BOOKING_CANCELLED");
assert.strictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.REJECTED_BY_DOCTOR }).reason, "DOCTOR_REJECTED");
assert.strictEqual(getReviewEligibilityFromBooking({ statusId: BOOKING_STATUS.PATIENT_NO_SHOW }).reason, "PATIENT_NO_SHOW");

assert.strictEqual(validateDateRange({ dateFrom: formatDateOffset(-35), dateTo: formatDateOffset(-6) }).ok, true);
assert.strictEqual(validateDateRange({ dateFrom: formatDateOffset(-40), dateTo: formatDateOffset(-9) }).ok, false);
assert.strictEqual(validateDateRange({ dateFrom: formatDateOffset(-5), dateTo: formatDateOffset(-10) }).ok, false);
assert.strictEqual(validateDateRange({ dateFrom: "2026-02-31", dateTo: "2026-03-01" }).ok, false);
