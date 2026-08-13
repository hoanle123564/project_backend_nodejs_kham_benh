const assert = require("assert");
const {
  normalizeOptionalReason,
  isValidBookingPrice,
  normalizePatientAppointmentFilters,
  buildPatientAppointmentWhereClause,
} = require("./PatientService");

assert.strictEqual(normalizeOptionalReason("   "), null);
assert.strictEqual(normalizeOptionalReason(null), null);
assert.strictEqual(normalizeOptionalReason("  Đau đầu  "), "Đau đầu");
assert.strictEqual(isValidBookingPrice(200000), true);
assert.strictEqual(isValidBookingPrice(0), false);
assert.strictEqual(isValidBookingPrice("invalid"), false);

const validFilters = normalizePatientAppointmentFilters({
  startDate: "2026-06-01",
  endDate: "2026-06-30",
  statusId: "S8",
  appointmentTypeId: "AT2",
  search: "  Nguyen Van A  ",
});
assert.strictEqual(validFilters.errMessage, "");
assert.deepStrictEqual(validFilters.filters, {
  startDate: "2026-06-01",
  endDate: "2026-06-30",
  statusId: "S8",
  appointmentTypeId: "AT2",
  search: "Nguyen Van A",
});

assert.strictEqual(
  normalizePatientAppointmentFilters({ startDate: "2026-06-01" }).errMessage,
  "Start date and end date are required together."
);
assert.strictEqual(
  normalizePatientAppointmentFilters({ startDate: "2026-06-31", endDate: "2026-07-01" }).errMessage,
  "Invalid appointment date range."
);
assert.strictEqual(
  normalizePatientAppointmentFilters({ startDate: "2026-07-02", endDate: "2026-07-01" }).errMessage,
  "Start date must not be after end date."
);
assert.strictEqual(normalizePatientAppointmentFilters({ statusId: "S9" }).errMessage, "Invalid booking status.");
assert.strictEqual(normalizePatientAppointmentFilters({ appointmentTypeId: "AT3" }).errMessage, "Invalid appointment type.");

const whereClause = buildPatientAppointmentWhereClause(42, validFilters.filters);
assert.deepStrictEqual(whereClause.conditions, [
  "b.patientId = ?",
  "b.date BETWEEN ? AND ?",
  "b.statusId = ?",
  "s.appointmentTypeId = ?",
  "(CAST(b.id AS CHAR) LIKE ? OR CONCAT_WS(' ', u.firstName, u.lastName) LIKE ?)",
]);
assert.deepStrictEqual(whereClause.params, [
  42,
  "2026-06-01",
  "2026-06-30",
  "S8",
  "AT2",
  "%Nguyen Van A%",
  "%Nguyen Van A%",
]);
