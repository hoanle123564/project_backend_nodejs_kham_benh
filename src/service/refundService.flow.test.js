const assert = require("node:assert/strict");
const test = require("node:test");

const loadRefundService = (state, provider) => {
  const db = {
    query: async (sql, params = []) => {
      if (sql.includes("FROM payment_refunds")) return [[{ ...state.refund }]];
      if (sql.includes("approvedBy")) {
        state.committed = false;
        state.refund.statusId = "RFS5";
        if (sql.includes("idempotencyKey")) state.refund.idempotencyKey = params[1];
        state.refund.approvedBy = 99;
        return [{ affectedRows: 1 }];
      }
      if (sql.includes("SET idempotencyKey = ? WHERE id = ?")) {
        state.refund.idempotencyKey = params[0];
        return [{ affectedRows: 1 }];
      }
      if (sql.includes("payosProviderState")) {
        state.refund.payosProviderState = params[2] || state.refund.payosProviderState;
        return [{ affectedRows: 1 }];
      }
      return [[{ id: state.refund.paymentId, statusId: "PPS2" }]];
    },
  };
  const connection = { promise: () => db };
  const transactionService = {
    withTransaction: async (callback) => {
      const value = await callback(db);
      state.committed = true;
      return value;
    },
  };
  const paymentService = { PAYMENT_STATUS: { PAID_PENDING_DOCTOR: "PPS2", REFUNDED: "PPS7" }, REFUND_STATUS: { PENDING: "RFS1", PROCESSING: "RFS2", REFUNDED: "RFS3", FAILED: "RFS4", APPROVED: "RFS5", REJECTED: "RFS6" } };
  const payosService = {
    createPayout: provider.createPayout,
    createPayosIdempotencyKey: () => "00000000-0000-4000-8000-000000000999",
    getPayosPayoutConfig: () => ({}),
    getPayoutById: async () => ({ statusCode: 404, payout: null }),
    getPayoutId: () => "",
    getPayoutReference: () => "",
    getPayoutsByReference: provider.getPayoutsByReference || (async () => ({ statusCode: 200, body: { data: { payouts: {} } }, payouts: [] })),
    getProviderState: () => null,
    getTransactionId: () => "",
    validatePayosPayoutConfig: () => ({}),
    isValidPayosIdempotencyKey: (value) => /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(String(value || "")),
  };
  const mocks = {
    "../config/data": connection,
    "./transactionService": transactionService,
    "./paymentService": paymentService,
    "./payosPayoutService": payosService,
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
  return { service, restore: () => {
    originals.forEach(([resolvedPath, original]) => {
      if (original) require.cache[resolvedPath] = original;
      else delete require.cache[resolvedPath];
    });
    delete require.cache[servicePath];
  } };
};

test("approve commits RFS5 before PayOS HTTP and preserves an inconclusive outcome", { concurrency: false }, async () => {
  const state = { committed: false, refund: { id: 7, paymentId: 10, bookingId: 20, amount: 100000, statusId: "RFS1", refundMode: "PAYOS", paymentStatusId: "PPS2", referenceId: "REFUND_7", idempotencyKey: "refund:7", receiverBankBin: "970415", receiverAccountNumber: "0123456789" } };
  const calls = [];
  const loaded = loadRefundService(state, {
    createPayout: async (options) => {
      calls.push(state.committed);
      assert.equal(state.refund.statusId, "RFS5");
      assert.match(options.idempotencyKey, /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i);
      return { payout: null };
    },
  });
  try {
    const response = await loaded.service.approvePayosRefund({ refundId: 7, actor: { id: 99, roleId: "R1" } });
    assert.deepEqual(calls, [true]);
    assert.equal(response.httpStatus, 202);
    assert.equal(response.data.statusId, "RFS5");
  } finally {
    loaded.restore();
  }
});

test("RFS5 sync looks up by reference before retrying with the same idempotency key", { concurrency: false }, async () => {
  const state = { committed: false, refund: { id: 8, paymentId: 11, bookingId: 21, amount: 100000, statusId: "RFS5", refundMode: "PAYOS", paymentStatusId: "PPS2", referenceId: "REFUND_8", idempotencyKey: "refund:8", receiverBankBin: "970415", receiverAccountNumber: "0123456789" } };
  const calls = [];
  const loaded = loadRefundService(state, {
    getPayoutsByReference: async (options) => {
      calls.push(["lookup", options.referenceId, options.idempotencyKey]);
      return { statusCode: 200, body: { data: { payouts: {} } }, payouts: [] };
    },
    createPayout: async (options) => {
      calls.push(["create", options.idempotencyKey]);
      return { payout: null };
    },
  });
  try {
    const response = await loaded.service.syncPayosRefund({ refundId: 8 });
    assert.deepEqual(calls[0], ["lookup", "REFUND_8", undefined]);
    assert.equal(calls[1][0], "create");
    assert.match(calls[1][1], /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i);
    assert.equal(state.refund.idempotencyKey, calls[1][1]);
    assert.equal(response.httpStatus, 202);
  } finally {
    loaded.restore();
  }
});

test("HTTP 403 IP rejection is persisted while RFS5 and PPS2 remain unchanged", { concurrency: false }, async () => {
  const state = { committed: false, refund: { id: 9, paymentId: 12, bookingId: 22, amount: 10000, statusId: "RFS1", refundMode: "PAYOS", paymentStatusId: "PPS2", referenceId: "REFUND_9", idempotencyKey: "refund:9", receiverBankBin: "970418", receiverAccountNumber: "0123456789" } };
  const loaded = loadRefundService(state, {
    createPayout: async () => ({
      statusCode: 403,
      payout: null,
      providerError: {
        state: "HTTP_403_IP_NOT_ALLOWED",
        code: "403",
        message: "Địa chỉ IP không được phép truy cập hệ thống",
        statusCode: 403,
      },
    }),
  });
  try {
    const response = await loaded.service.approvePayosRefund({ refundId: 9, actor: { id: 99, roleId: "R1" } });
    assert.equal(response.httpStatus, 202);
    assert.equal(response.data.statusId, "RFS5");
    assert.equal(response.data.paymentStatusId, "PPS2");
    assert.equal(response.data.payosProviderState, "HTTP_403_IP_NOT_ALLOWED");
    assert.match(response.errMessage, /Địa chỉ IP/);
  } finally {
    loaded.restore();
  }
});

test("RFS5 HTTP 403 sync never retries POST before the IP issue is resolved", { concurrency: false }, async () => {
  const state = { committed: false, refund: { id: 10, paymentId: 32, bookingId: 158, amount: 10000, statusId: "RFS5", refundMode: "PAYOS", paymentStatusId: "PPS2", referenceId: "REFUND_10", idempotencyKey: "refund:10", receiverBankBin: "970418", receiverAccountNumber: "0123456789" } };
  const calls = [];
  const loaded = loadRefundService(state, {
    getPayoutsByReference: async () => {
      calls.push("lookup");
      return {
        statusCode: 403,
        body: { code: "403", desc: "Địa chỉ IP không được phép truy cập hệ thống" },
        payouts: [],
        providerError: {
          state: "HTTP_403_IP_NOT_ALLOWED",
          code: "403",
          message: "Địa chỉ IP không được phép truy cập hệ thống",
          statusCode: 403,
        },
      };
    },
    createPayout: async () => {
      calls.push("create");
      return { payout: null };
    },
  });
  try {
    const response = await loaded.service.syncPayosRefund({ refundId: 10 });
    assert.deepEqual(calls, ["lookup"]);
    assert.equal(response.httpStatus, 202);
    assert.equal(response.data.statusId, "RFS5");
    assert.equal(response.data.paymentStatusId, "PPS2");
    assert.equal(response.data.payosProviderState, "HTTP_403_IP_NOT_ALLOWED");
  } finally {
    loaded.restore();
  }
});
