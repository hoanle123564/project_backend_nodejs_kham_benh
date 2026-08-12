const assert = require("node:assert/strict");
const test = require("node:test");

const validBody = {
  bankBin: "970415",
  bankName: "VCB",
  bankAccountNumber: "0123456789",
  bankAccountName: "NGUYEN VAN A",
  reason: "Bác sĩ từ chối khám",
};

const loadRefundService = (state) => {
  const calls = [];
  const db = {
    query: async (sql, params = []) => {
      calls.push({ sql, params });
      if (sql.includes("FROM booking b")) {
        return state.booking && Number(params[1]) === Number(state.booking.patientId) ? [[state.booking]] : [[]];
      }
      if (sql.includes("FROM appointment_payments")) return [[state.payment]];
      if (sql.includes("FROM payment_refunds")) return [[state.refund]];
      if (sql.includes("UPDATE payment_refunds")) {
        const [bankBin, bankName, bankAccountNumber, bankAccountName, reason] = params;
        state.refund = {
          ...state.refund,
          receiverBankBin: bankBin,
          receiverBank: bankName,
          receiverAccountNumber: bankAccountNumber,
          receiverAccountName: bankAccountName,
          reason,
        };
        return [{ affectedRows: 1 }];
      }
      return [[]];
    },
  };
  const mocks = {
    "../config/data": { promise: () => db },
    "./transactionService": { withTransaction: async (callback) => callback(db) },
    "./paymentService": {
      PAYMENT_STATUS: { REFUND_PENDING: "PPS6" },
      REFUND_STATUS: { PENDING: "RFS1" },
    },
    "./payosPayoutService": {
      createPayout: async () => ({}),
      createPayosIdempotencyKey: () => "refund-key",
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

const buildState = (overrides = {}) => ({
  booking: { id: 12, patientId: 7, statusId: "S6", appointmentTypeId: "AT2" },
  payment: { id: 22, bookingId: 12, statusId: "PPS6" },
  refund: { id: 32, paymentId: 22, bookingId: 12, statusId: "RFS1", refundMode: "MANUAL" },
  ...overrides,
});

test("manual S6 refund update saves bank details without creating a second refund", { concurrency: false }, async () => {
  const state = buildState();
  const loaded = loadRefundService(state);
  try {
    const response = await loaded.service.updatePatientManualRefund({
      user: { id: 7, roleId: "R3" },
      bookingId: "12",
      body: validBody,
    });

    assert.equal(response.errCode, 0);
    assert.equal(response.data.id, 32);
    assert.equal(state.refund.receiverBankBin, "970415");
    assert.equal(state.refund.receiverBank, "VCB");
    assert.equal(state.refund.reason, "Bác sĩ từ chối khám");
    assert.equal(state.payment.statusId, "PPS6");
    assert.equal(state.refund.statusId, "RFS1");
    assert.equal(loaded.calls.some(({ sql }) => /INSERT/i.test(sql)), false);
  } finally {
    loaded.restore();
  }
});

test("manual S6 refund update rejects a booking outside the doctor-rejected state", { concurrency: false }, async () => {
  const state = buildState({ booking: { id: 12, patientId: 7, statusId: "S4", appointmentTypeId: "AT2" } });
  const loaded = loadRefundService(state);
  try {
    const response = await loaded.service.updatePatientManualRefund({
      user: { id: 7, roleId: "R3" },
      bookingId: 12,
      body: validBody,
    });

    assert.equal(response.errCode, 2);
    assert.equal(response.httpStatus, 409);
    assert.equal(loaded.calls.some(({ sql }) => /UPDATE payment_refunds/i.test(sql)), false);
  } finally {
    loaded.restore();
  }
});

test("manual S6 refund update rejects a different patient", { concurrency: false }, async () => {
  const loaded = loadRefundService(buildState());
  try {
    const response = await loaded.service.updatePatientManualRefund({
      user: { id: 99, roleId: "R3" },
      bookingId: 12,
      body: validBody,
    });

    assert.equal(response.errCode, 404);
    assert.equal(response.httpStatus, 404);
    assert.equal(loaded.calls.some(({ sql }) => /UPDATE payment_refunds/i.test(sql)), false);
  } finally {
    loaded.restore();
  }
});

test("manual S6 refund update rejects a non-manual or processed refund", { concurrency: false }, async () => {
  for (const refundOverride of [{ refundMode: "PAYOS" }, { statusId: "RFS3" }]) {
    const loaded = loadRefundService(buildState({ refund: { ...buildState().refund, ...refundOverride } }));
    try {
      const response = await loaded.service.updatePatientManualRefund({
        user: { id: 7, roleId: "R3" },
        bookingId: 12,
        body: validBody,
      });

      assert.equal(response.errCode, 2);
      assert.equal(response.httpStatus, 409);
      assert.equal(loaded.calls.some(({ sql }) => /UPDATE payment_refunds/i.test(sql)), false);
    } finally {
      loaded.restore();
    }
  }
});

test("manual refund update validation keeps reason optional", { concurrency: false }, () => {
  const loaded = loadRefundService(buildState());
  try {
    const validation = loaded.service.validatePatientManualRefundUpdateRequest({ ...validBody, reason: "   " });
    assert.equal(validation.valid, true);
    assert.equal(validation.value.reason, null);
  } finally {
    loaded.restore();
  }
});
