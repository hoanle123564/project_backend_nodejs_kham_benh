const assert = require("node:assert/strict");
const test = require("node:test");

const loadRefundService = ({ existingRefund = null, notificationError = null } = {}) => {
  const calls = [];
  const notifications = [];
  const db = {
    query: async (sql, params = []) => {
      calls.push({ sql, params });
      if (sql.includes("FROM booking b")) return [[{ id: 12, patientId: 7, statusId: "S4", scheduleId: 3, appointmentTypeId: "AT2" }]];
      if (sql.includes("FROM appointment_payments")) return [[{ id: 22, bookingId: 12, amount: 100000, statusId: "PPS2" }]];
      if (sql.includes("SELECT id FROM payment_refunds")) return [existingRefund ? [{ id: existingRefund }] : []];
      if (sql.includes("INSERT INTO payment_refunds")) return [{ insertId: 42 }];
      if (sql.includes("FROM payment_refunds r")) return [[{ id: 42, bookingId: 12, refundMode: "PAYOS", statusId: "RFS1" }]];
      return [{ affectedRows: 1 }];
    },
  };
  const mocks = {
    "../config/data": { promise: () => db },
    "./transactionService": { withTransaction: async (callback) => callback(db) },
    "./paymentService": {
      PAYMENT_STATUS: { PAID_PENDING_DOCTOR: "PPS2" },
      REFUND_STATUS: { PENDING: "RFS1" },
    },
    "./payosPayoutService": {
      createPayosIdempotencyKey: () => "00000000-0000-4000-8000-000000000042",
      createPayout: async () => ({}),
      getPayosPayoutConfig: () => ({}),
      getPayoutById: async () => null,
      getPayoutId: () => null,
      getPayoutReference: () => null,
      getPayoutsByReference: async () => ({}),
      getProviderState: () => null,
      getTransactionId: () => null,
      isValidPayosIdempotencyKey: () => false,
      validatePayosPayoutConfig: () => ({}),
    },
    "./notificationService": {
      createAdminRefundNotifications: async (data) => {
        notifications.push(data);
        if (notificationError) throw notificationError;
      },
    },
  };
  const originals = Object.entries(mocks).map(([modulePath, exports]) => {
    const resolvedPath = require.resolve(modulePath);
    const original = require.cache[resolvedPath];
    require.cache[resolvedPath] = { id: resolvedPath, filename: resolvedPath, loaded: true, exports };
    return [resolvedPath, original];
  });
  const servicePath = require.resolve("./refundService");
  delete require.cache[servicePath];
  const service = require("./refundService");
  return {
    calls,
    notifications,
    service,
    restore: () => {
      originals.forEach(([resolvedPath, original]) => {
        if (original) require.cache[resolvedPath] = original;
        else delete require.cache[resolvedPath];
      });
      delete require.cache[servicePath];
    },
  };
};

const validBody = {
  bookingId: 12,
  bankBin: "970415",
  bankName: "VCB",
  bankAccountNumber: "0123456789",
  bankAccountName: "NGUYEN VAN A",
  reason: "Patient cancellation",
};

test("S4 patient refund emits one admin notification after commit", { concurrency: false }, async () => {
  const loaded = loadRefundService();
  try {
    const response = await loaded.service.createPatientRefund({ user: { id: 7, roleId: "R3" }, body: validBody });
    assert.equal(response.errCode, 0);
    assert.deepEqual(loaded.notifications, [{ bookingId: 12 }]);
  } finally {
    loaded.restore();
  }
});

test("refund notification failure does not fail the committed request", { concurrency: false }, async () => {
  const loaded = loadRefundService({ notificationError: new Error("notification unavailable") });
  try {
    const response = await loaded.service.createPatientRefund({ user: { id: 7, roleId: "R3" }, body: validBody });
    assert.equal(response.errCode, 0);
    assert.equal(loaded.notifications.length, 1);
  } finally {
    loaded.restore();
  }
});

test("duplicate refund request does not emit another admin notification", { concurrency: false }, async () => {
  const loaded = loadRefundService({ existingRefund: 32 });
  try {
    const response = await loaded.service.createPatientRefund({ user: { id: 7, roleId: "R3" }, body: validBody });
    assert.equal(response.errCode, 2);
    assert.equal(loaded.notifications.length, 0);
  } finally {
    loaded.restore();
  }
});
