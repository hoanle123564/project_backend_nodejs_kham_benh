const assert = require("node:assert/strict");
const test = require("node:test");

const loadPaymentService = (payment) => {
  const calls = [];
  const db = {
    query: async (sql, params = []) => {
      calls.push({ sql, params });
      if (sql.includes("FROM appointment_payments")) return [[payment]];
      if (sql.includes("FROM patient_profile")) return [[{
        refundBankName: "VCB",
        refundAccountName: "NGUYEN VAN A",
        refundAccountNumber: "0123456789",
      }]];
      if (sql.includes("INSERT IGNORE INTO payment_refunds")) return [{ affectedRows: 1, insertId: 42 }];
      return [{ affectedRows: 1 }];
    },
  };
  const mocks = {
    "../config/data": { promise: () => db },
    "./transactionService": { withTransaction: async (callback) => callback(db) },
    "./adminDashboardService": { getSchedulePriceAtBooking: async () => 100000 },
    "./notificationService": {
      createDoctorNotification: async () => {},
      createPatientBookingStatusNotification: async () => {},
    },
    "./doctor/doctorSchedulePolicy": { isScheduleStarted: () => false, normalizeDate: (value) => value },
    "./bookingQueueService": { assignBookingQueueNumberInCurrentTransaction: async () => null },
    "./payosPayoutService": { createPayosIdempotencyKey: () => "00000000-0000-4000-8000-000000000042" },
  };
  const originals = Object.entries(mocks).map(([modulePath, exports]) => {
    const resolvedPath = require.resolve(modulePath);
    const original = require.cache[resolvedPath];
    require.cache[resolvedPath] = { id: resolvedPath, filename: resolvedPath, loaded: true, exports };
    return [resolvedPath, original];
  });
  const servicePath = require.resolve("./paymentService");
  delete require.cache[servicePath];
  const service = require("./paymentService");
  return {
    calls,
    service,
    db,
    restore: () => {
      originals.forEach(([resolvedPath, original]) => {
        if (original) require.cache[resolvedPath] = original;
        else delete require.cache[resolvedPath];
      });
      delete require.cache[servicePath];
    },
  };
};

test("doctor rejection creates one PAYOS refund with stable provider identifiers", { concurrency: false }, async () => {
  const payment = { id: 10, bookingId: 20, patientId: 7, amount: 100000, statusId: "PPS2", appointmentTypeId: "AT2" };
  const loaded = loadPaymentService(payment);
  try {
    const result = await loaded.service.applyDoctorPaymentDecision({ bookingId: 20, statusId: "S6", reason: "Doctor unavailable" }, loaded.db);
    assert.equal(result.statusId, "PPS6");
    const insert = loaded.calls.find(({ sql }) => sql.includes("INSERT IGNORE INTO payment_refunds"));
    assert.equal(insert.params[5], "PAYOS");
    const identifiers = loaded.calls.find(({ sql }) => sql.includes("SET referenceId = ?, idempotencyKey = ?"));
    assert.deepEqual(identifiers.params, ["REFUND_42", "00000000-0000-4000-8000-000000000042", 42]);
  } finally {
    loaded.restore();
  }
});

test("non-online doctor rejection keeps the legacy MANUAL refund path", { concurrency: false }, async () => {
  const payment = { id: 11, bookingId: 21, patientId: 7, amount: 100000, statusId: "PPS2", appointmentTypeId: "AT1" };
  const loaded = loadPaymentService(payment);
  try {
    await loaded.service.applyDoctorPaymentDecision({ bookingId: 21, statusId: "S6" }, loaded.db);
    const insert = loaded.calls.find(({ sql }) => sql.includes("INSERT IGNORE INTO payment_refunds"));
    assert.match(insert.sql, /'MANUAL'/);
    assert.equal(loaded.calls.some(({ sql }) => sql.includes("SET referenceId = ?, idempotencyKey = ?")), false);
  } finally {
    loaded.restore();
  }
});
