const connection = require("../config/data");
const { withTransaction } = require("./transactionService");
const { PAYMENT_STATUS, REFUND_STATUS } = require("./paymentService");
const {
  createPayout,
  createPayosIdempotencyKey,
  getPayosPayoutConfig,
  getPayoutById,
  getPayoutId,
  getPayoutReference,
  getPayoutsByReference,
  getProviderState,
  getTransactionId,
  isValidPayosIdempotencyKey,
  validatePayosPayoutConfig,
} = require("./payosPayoutService");

const PAYOS_MODE = "PAYOS";
const PAYOS_TERMINAL_FAILURES = new Set(["FAILED", "REJECTED", "CANCELLED", "DECLINED"]);
const PAYOS_TRANSPORT_ERRORS = new Set(["PAYOS_TIMEOUT", "ECONNRESET", "ETIMEDOUT", "ENOTFOUND", "EAI_AGAIN", "ECONNREFUSED", "EHOSTUNREACH", "ENETUNREACH", "ECONNABORTED", "EPIPE", "EPROTO", "EACCES"]);
const PATIENT_REFUND_FIELDS = new Set(["bookingId", "bankBin", "bankName", "bankAccountNumber", "bankAccountName", "reason"]);

const normalizePositiveId = (value) => {
  if (typeof value === "boolean" || value === null || value === undefined || String(value).trim() === "") return null;
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const result = (errCode, errMessage, data, httpStatus) => ({
  errCode,
  errMessage,
  ...(data === undefined ? {} : { data }),
  ...(httpStatus ? { httpStatus } : {}),
});

const conflict = (message) => {
  const error = new Error(message);
  error.errCode = 2;
  error.httpStatus = 409;
  return error;
};

const normalizeTransportError = (error) => {
  if (!PAYOS_TRANSPORT_ERRORS.has(error?.code)) return null;
  const isTimeout = error.code === "PAYOS_TIMEOUT" || error.code === "ETIMEDOUT";
  return {
    state: isTimeout ? "HTTP_TIMEOUT" : "HTTP_NETWORK_ERROR",
    code: error.code,
    message: isTimeout ? "PayOS payout request timed out" : "PayOS payout request could not be completed",
  };
};

const providerOutcomeMessage = (outcome, fallback) => outcome?.providerMessage
  ? `PayOS: ${outcome.providerMessage}`
  : fallback;

const validatePatientRefundRequest = (body = {}) => {
  const errors = [];
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return { valid: false, errors: ["Request body must be an object"] };
  }

  Object.keys(body).forEach((key) => {
    if (!PATIENT_REFUND_FIELDS.has(key)) errors.push(`Unsupported field: ${key}`);
  });

  const bookingId = normalizePositiveId(body.bookingId);
  if (!bookingId) errors.push("bookingId must be a positive integer");

  const requiredStrings = [
    ["bankBin", /^\d{6,10}$/, "bankBin must contain 6 to 10 digits"],
    ["bankName", null, "bankName is required"],
    ["bankAccountNumber", null, "bankAccountNumber is required"],
    ["bankAccountName", null, "bankAccountName is required"],
  ];
  const values = { bookingId };
  requiredStrings.forEach(([field, pattern, missingMessage]) => {
    const value = typeof body[field] === "string" ? body[field].trim() : "";
    if (!value) errors.push(missingMessage);
    if (pattern && value && !pattern.test(value)) errors.push(missingMessage);
    values[field] = value;
  });
  if (values.bankName.length > 100) errors.push("bankName must be at most 100 characters");
  if (values.bankAccountNumber.length > 64) errors.push("bankAccountNumber must be at most 64 characters");
  if (values.bankAccountName.length > 120) errors.push("bankAccountName must be at most 120 characters");

  if (body.reason !== undefined && body.reason !== null && typeof body.reason !== "string") {
    errors.push("reason must be a string");
  }
  const reason = typeof body.reason === "string" ? body.reason.trim() : null;
  if (reason && reason.length > 500) errors.push("reason must be at most 500 characters");
  values.reason = reason || null;

  return { valid: errors.length === 0, errors, value: values };
};

const REFUND_DETAIL_SELECT = `
  SELECT
    r.*,
    p.paymentCode,
    p.patientId,
    p.statusId AS paymentStatusId,
    b.statusId AS bookingStatusId,
    b.scheduleId,
    s.appointmentTypeId,
    di.clinicId,
    clinic.name AS clinicName,
    u.firstName,
    u.lastName,
    u.email
  FROM payment_refunds r
  INNER JOIN appointment_payments p ON p.id = r.paymentId
  LEFT JOIN booking b ON b.id = r.bookingId
  LEFT JOIN schedule s ON s.id = b.scheduleId
  LEFT JOIN doctor_info di ON di.doctorId = s.doctorId
  LEFT JOIN clinic ON clinic.id = di.clinicId
  INNER JOIN users u ON u.id = p.patientId
`;

const getRefundRow = async (db, refundId, clinicId = null, forUpdate = false) => {
  const normalizedRefundId = normalizePositiveId(refundId);
  if (!normalizedRefundId) return null;
  const suffix = clinicId === null
    ? "WHERE r.id = ?"
    : "WHERE r.id = ? AND di.clinicId = ?";
  const params = clinicId === null ? [normalizedRefundId] : [normalizedRefundId, clinicId];
  const [rows] = await db.query(`${REFUND_DETAIL_SELECT} ${suffix} LIMIT 1${forUpdate ? " FOR UPDATE" : ""}`, params);
  return rows[0] || null;
};

const readRefundRow = async (refundId, clinicId = null) => getRefundRow(connection.promise(), refundId, clinicId);

const createPatientRefund = async ({ user, body }) => {
  if (user?.roleId !== "R3") return result(403, "Permission denied", undefined, 403);
  const validation = validatePatientRefundRequest(body);
  if (!validation.valid) return result(1, validation.errors.join("; "), undefined, 422);

  const { bookingId, bankBin, bankName, bankAccountNumber, bankAccountName, reason } = validation.value;
  try {
    const refundId = await withTransaction(async (db) => {
      const [bookings] = await db.query(
        `SELECT b.id, b.patientId, b.statusId, b.scheduleId, s.appointmentTypeId
         FROM booking b
         INNER JOIN schedule s ON s.id = b.scheduleId
         WHERE b.id = ? AND b.patientId = ?
         LIMIT 1 FOR UPDATE`,
        [bookingId, user.id],
      );
      const booking = bookings[0];
      if (!booking) return { notFound: true };
      if (booking.statusId !== "S4" || booking.appointmentTypeId !== "AT2") {
        return { conflict: "Refund requires a cancelled online booking" };
      }

      const [payments] = await db.query(
        "SELECT * FROM appointment_payments WHERE bookingId = ? LIMIT 1 FOR UPDATE",
        [booking.id],
      );
      const payment = payments[0];
      if (!payment || payment.statusId !== PAYMENT_STATUS.PAID_PENDING_DOCTOR) {
        return { conflict: "Payment is not eligible for a patient refund" };
      }

      const [existingRefunds] = await db.query(
        "SELECT id FROM payment_refunds WHERE paymentId = ? LIMIT 1 FOR UPDATE",
        [payment.id],
      );
      if (existingRefunds[0]) return { conflict: "A refund request already exists for this payment" };

      const [inserted] = await db.query(
        `INSERT INTO payment_refunds
          (paymentId, bookingId, amount, statusId, reason, refundMode,
           receiverBankBin, receiverBank, receiverAccountNumber, receiverAccountName, requestedBy)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [payment.id, booking.id, payment.amount, REFUND_STATUS.PENDING, reason, PAYOS_MODE, bankBin, bankName, bankAccountNumber, bankAccountName, user.id],
      );
      const referenceId = `REFUND_${inserted.insertId}`;
      const idempotencyKey = createPayosIdempotencyKey();
      await db.query(
        "UPDATE payment_refunds SET referenceId = ?, idempotencyKey = ? WHERE id = ?",
        [referenceId, idempotencyKey, inserted.insertId],
      );
      return { id: inserted.insertId };
    });

    if (refundId?.notFound) return result(404, "Booking not found", undefined, 404);
    if (refundId?.conflict) return result(2, refundId.conflict, undefined, 409);
    const data = await readRefundRow(refundId.id);
    return result(0, "Refund request created", data, 201);
  } catch (error) {
    if (error?.code === "ER_DUP_ENTRY") return result(2, "A refund request already exists for this payment", undefined, 409);
    return result(1, error.message || "Unable to create refund request");
  }
};

const listPatientRefunds = async (patientId, refundId = null) => {
  const normalizedPatientId = normalizePositiveId(patientId);
  if (!normalizedPatientId) return result(403, "Permission denied", undefined, 403);
  const params = [normalizedPatientId];
  let where = "WHERE p.patientId = ?";
  if (refundId !== null) {
    const normalizedRefundId = normalizePositiveId(refundId);
    if (!normalizedRefundId) return result(404, "Refund not found", undefined, 404);
    where += " AND r.id = ?";
    params.push(normalizedRefundId);
  }
  try {
    const [rows] = await connection.promise().query(`${REFUND_DETAIL_SELECT} ${where} ORDER BY r.requestedAt DESC`, params);
    if (refundId !== null && !rows[0]) return result(404, "Refund not found", undefined, 404);
    return result(0, "OK", refundId === null ? rows : rows[0]);
  } catch (error) {
    return result(1, error.message || "Unable to load refunds", refundId === null ? [] : undefined);
  }
};

const listManagementRefunds = async (clinicId = null) => {
  try {
    const params = [];
    let where = "";
    if (clinicId !== null) {
      where = "WHERE di.clinicId = ?";
      params.push(clinicId);
    }
    const [rows] = await connection.promise().query(`${REFUND_DETAIL_SELECT} ${where} ORDER BY r.requestedAt DESC`, params);
    return result(0, "OK", rows);
  } catch (error) {
    return result(1, error.message || "Unable to load refunds", []);
  }
};

const ensureScopedPayosRefund = (refund) => {
  if (!refund) {
    const error = new Error("Refund not found in the current clinic scope");
    error.errCode = 404;
    error.httpStatus = 404;
    return error;
  }
  if (refund.refundMode !== PAYOS_MODE) return conflict("PayOS action is only available for PAYOS refunds");
  return null;
};

const getCurrentRefundOr404 = async (refundId, clinicId) => readRefundRow(refundId, clinicId);

const ensurePayosIdempotencyKey = async ({ refundId, clinicId = null }) => {
  let resolvedKey = null;
  await withTransaction(async (db) => {
    const refund = await getRefundRow(db, refundId, clinicId, true);
    if (!refund || refund.refundMode !== PAYOS_MODE) return;
    const currentKey = String(refund.idempotencyKey || "").trim();
    if (isValidPayosIdempotencyKey(currentKey)) {
      resolvedKey = currentKey;
      return;
    }
    resolvedKey = createPayosIdempotencyKey();
    await db.query(
      "UPDATE payment_refunds SET idempotencyKey = ? WHERE id = ?",
      [resolvedKey, refund.id],
    );
  });
  return resolvedKey;
};

const approvePayosRefund = async ({ refundId, actor, clinicId = null }) => {
  const existing = await getCurrentRefundOr404(refundId, clinicId);
  const scopeError = ensureScopedPayosRefund(existing);
  if (scopeError) return result(scopeError.errCode, scopeError.message, undefined, scopeError.httpStatus);
  let config;
  try {
    config = validatePayosPayoutConfig();
  } catch (error) {
    return result(error.errCode || 5, error.message, undefined, error.httpStatus || 503);
  }

  try {
    const approved = await withTransaction(async (db) => {
      const refund = await getRefundRow(db, refundId, clinicId, true);
      const scopeError = ensureScopedPayosRefund(refund);
      if (scopeError) throw scopeError;
      if (refund.statusId !== REFUND_STATUS.PENDING || refund.paymentStatusId !== PAYMENT_STATUS.PAID_PENDING_DOCTOR) {
        throw conflict("Refund is not ready for approval");
      }
      const idempotencyKey = isValidPayosIdempotencyKey(refund.idempotencyKey)
        ? String(refund.idempotencyKey).trim()
        : createPayosIdempotencyKey();
      await db.query(
        `UPDATE payment_refunds
         SET statusId = ?, idempotencyKey = ?, approvedBy = ?, approvedAt = CURRENT_TIMESTAMP
         WHERE id = ? AND statusId = ?`,
        [REFUND_STATUS.APPROVED, idempotencyKey, actor.id, refund.id, REFUND_STATUS.PENDING],
      );
      return { ...refund, statusId: REFUND_STATUS.APPROVED, idempotencyKey, approvedBy: actor.id };
    });

    let providerResponse;
    try {
      providerResponse = await createPayout({
        refundId: approved.id,
        referenceId: approved.referenceId,
        amount: approved.amount,
        description: `Refund booking ${approved.bookingId}`,
        toBin: approved.receiverBankBin,
        toAccountNumber: approved.receiverAccountNumber,
        idempotencyKey: approved.idempotencyKey,
        config,
      });
    } catch (providerError) {
      const transportError = normalizeTransportError(providerError);
      if (transportError) {
        const outcome = await persistProviderOutcome({ refundId: approved.id, payout: null, clinicId, accepted: false, providerError: transportError });
        const current = await getCurrentRefundOr404(approved.id, clinicId);
        return result(0, providerOutcomeMessage(outcome, "PayOS outcome is pending reconciliation"), current, 202);
      }
      throw providerError;
    }
    const outcome = await persistProviderOutcome({ refundId: approved.id, payout: providerResponse.payout, clinicId, accepted: isAcceptedPayout(providerResponse), providerError: providerResponse.providerError });
    const current = await getCurrentRefundOr404(approved.id, clinicId);
    return result(0, outcome.unknown ? providerOutcomeMessage(outcome, "PayOS outcome requires reconciliation") : "Refund approved", current, outcome.unknown ? 202 : 200);
  } catch (error) {
    return result(error.errCode || 1, error.message || "Unable to approve refund", undefined, error.httpStatus || 500);
  }
};

const rejectPayosRefund = async ({ refundId, actor, reason, clinicId = null }) => {
  const rejectionReason = typeof reason === "string" ? reason.trim() : "";
  if (!rejectionReason || rejectionReason.length > 500) return result(1, "A rejection reason of at most 500 characters is required", undefined, 422);
  try {
    const updatedId = await withTransaction(async (db) => {
      const refund = await getRefundRow(db, refundId, clinicId, true);
      const scopeError = ensureScopedPayosRefund(refund);
      if (scopeError) throw scopeError;
      if (refund.statusId !== REFUND_STATUS.PENDING) throw conflict("Refund is not pending approval");
      await db.query(
        `UPDATE payment_refunds
         SET statusId = ?, rejectedBy = ?, rejectedAt = CURRENT_TIMESTAMP, rejectionReason = ?
         WHERE id = ? AND statusId = ?`,
        [REFUND_STATUS.REJECTED, actor.id, rejectionReason, refund.id, REFUND_STATUS.PENDING],
      );
      return refund.id;
    });
    return result(0, "Refund rejected", await getCurrentRefundOr404(updatedId, clinicId));
  } catch (error) {
    return result(error.errCode || 1, error.message || "Unable to reject refund", undefined, error.httpStatus || 409);
  }
};

const getProviderTransaction = (payout) => {
  const transactions = Array.isArray(payout?.transactions)
    ? payout.transactions
    : payout?.transactions && typeof payout.transactions === "object"
      ? Object.values(payout.transactions)
      : [];
  return transactions[0] || null;
};

const getPayoutIdentity = (payout) => {
  const transaction = getProviderTransaction(payout);
  return {
    referenceId: getPayoutReference(payout),
    payoutId: getPayoutId(payout),
    transactionId: getTransactionId(payout),
    providerState: getProviderState(payout),
    amount: payout?.amount ?? transaction?.amount,
    toBin: payout?.toBin ?? transaction?.toBin,
    toAccountNumber: payout?.toAccountNumber ?? transaction?.toAccountNumber,
    hasTransaction: Boolean(transaction),
  };
};

const matchesRefund = (refund, payout) => {
  const identity = getPayoutIdentity(payout);
  return Boolean(
    identity.hasTransaction &&
    identity.referenceId && identity.referenceId === refund.referenceId &&
    identity.amount !== undefined && Number(identity.amount) === Number(refund.amount) &&
    identity.toBin && identity.toBin === refund.receiverBankBin &&
    identity.toAccountNumber && identity.toAccountNumber === refund.receiverAccountNumber,
  );
};

const isAcceptedPayout = (response) => {
  const payout = response?.payout;
  const successfulHttp = !response?.statusCode || (response.statusCode >= 200 && response.statusCode < 300);
  return Boolean(successfulHttp && !response?.providerError && payout && (getPayoutId(payout) || getPayoutReference(payout) || getTransactionId(payout)));
};

const classifyProviderOutcome = (refund, payout) => {
  const identity = getPayoutIdentity(payout);
  if (!identity.providerState || !identity.hasTransaction || !matchesRefund(refund, payout)) {
    return { kind: "UNKNOWN", identity };
  }
  if (identity.providerState === "SUCCEEDED") return { kind: "SUCCEEDED", identity };
  if (PAYOS_TERMINAL_FAILURES.has(identity.providerState)) return { kind: "FAILED", identity };
  if (identity.providerState === "PROCESSING") return { kind: "PROCESSING", identity };
  return { kind: "UNKNOWN", identity };
};

const persistProviderOutcome = async ({ refundId, payout, clinicId = null, accepted = true, providerError = null }) => {
  const identity = getPayoutIdentity(payout);
  let mapped = false;
  let unknown = !accepted || Boolean(providerError);
  const providerState = providerError?.state || identity.providerState;
  await withTransaction(async (db) => {
    let refund = await getRefundRow(db, refundId, clinicId, true);
    if (!refund || refund.refundMode !== PAYOS_MODE) return;
    const providerFields = [identity.payoutId || null, identity.transactionId || null, providerState || null, refund.id];
    if (accepted && refund.statusId === REFUND_STATUS.APPROVED) {
      await db.query(
        `UPDATE payment_refunds
         SET statusId = ?, processingAt = COALESCE(processingAt, CURRENT_TIMESTAMP),
             payosPayoutId = COALESCE(?, payosPayoutId),
             payosTransactionId = COALESCE(?, payosTransactionId),
             payosProviderState = COALESCE(?, payosProviderState)
         WHERE id = ? AND statusId = ?`,
        [REFUND_STATUS.PROCESSING, ...providerFields.slice(0, 3), refund.id, REFUND_STATUS.APPROVED],
      );
      refund = await getRefundRow(db, refundId, clinicId, true);
    } else if (providerState || identity.payoutId || identity.transactionId) {
      await db.query(
        `UPDATE payment_refunds
         SET payosPayoutId = COALESCE(?, payosPayoutId),
             payosTransactionId = COALESCE(?, payosTransactionId),
             payosProviderState = COALESCE(?, payosProviderState)
         WHERE id = ?`,
        providerFields,
      );
      refund = await getRefundRow(db, refundId, clinicId, true);
    }
    if (!refund || ![REFUND_STATUS.PROCESSING, REFUND_STATUS.REFUNDED, REFUND_STATUS.FAILED].includes(refund.statusId)) return;
    const [payments] = await db.query(
      "SELECT id, statusId FROM appointment_payments WHERE id = ? LIMIT 1 FOR UPDATE",
      [refund.paymentId],
    );
    const payment = payments[0];
    if (!payment) {
      unknown = true;
      return;
    }
    const classification = classifyProviderOutcome(refund, payout);
    if (classification.kind === "UNKNOWN") {
      unknown = true;
      return;
    }
    if (classification.kind === "SUCCEEDED") {
      if (refund.statusId === REFUND_STATUS.PROCESSING) {
        await db.query(
          `UPDATE payment_refunds
           SET statusId = ?, refundedAt = COALESCE(refundedAt, CURRENT_TIMESTAMP), payosTransactionId = COALESCE(?, payosTransactionId)
           WHERE id = ? AND statusId = ?`,
          [REFUND_STATUS.REFUNDED, identity.transactionId || null, refund.id, REFUND_STATUS.PROCESSING],
        );
        await db.query(
          "UPDATE appointment_payments SET statusId = ? WHERE id = ? AND statusId = ?",
          [PAYMENT_STATUS.REFUNDED, payment.id, PAYMENT_STATUS.PAID_PENDING_DOCTOR],
        );
        mapped = true;
      }
      return;
    }
    if (classification.kind === "FAILED" && refund.statusId === REFUND_STATUS.PROCESSING) {
      await db.query(
        `UPDATE payment_refunds
         SET statusId = ?, failedAt = COALESCE(failedAt, CURRENT_TIMESTAMP), failureReason = ?
         WHERE id = ? AND statusId = ?`,
        [REFUND_STATUS.FAILED, identity.providerState, refund.id, REFUND_STATUS.PROCESSING],
      );
      mapped = true;
      return;
    }
  });
  return { mapped, unknown, state: providerState, providerMessage: providerError?.message || null };
};

const isConfirmedEmptyPayoutList = (response) => {
  if (!response || response.statusCode < 200 || response.statusCode >= 300) return false;
  const data = response.body?.data;
  return Array.isArray(data) || Array.isArray(data?.items) || (data?.payouts && typeof data.payouts === "object" && Object.keys(data.payouts).length === 0);
};

const applyFoundPayout = async ({ refundId, payout, clinicId }) => {
  const outcome = await persistProviderOutcome({ refundId, payout, clinicId, accepted: true });
  const current = await getCurrentRefundOr404(refundId, clinicId);
  return { outcome, current };
};

const syncPayosRefund = async ({ refundId, clinicId = null }) => {
  const refund = await getCurrentRefundOr404(refundId, clinicId);
  const scopeError = ensureScopedPayosRefund(refund);
  if (scopeError) return result(scopeError.errCode, scopeError.message, undefined, scopeError.httpStatus);
  let config;
  try {
    config = validatePayosPayoutConfig();
  } catch (error) {
    return result(error.errCode || 5, error.message, undefined, error.httpStatus || 503);
  }
  if (![REFUND_STATUS.APPROVED, REFUND_STATUS.PROCESSING].includes(refund.statusId)) return result(2, "Refund is not syncable", undefined, 409);

  try {
    if (refund.statusId === REFUND_STATUS.APPROVED) {
      const byReference = await getPayoutsByReference({ referenceId: refund.referenceId, config });
      if (byReference.providerError) {
        const outcome = await persistProviderOutcome({ refundId: refund.id, payout: null, clinicId, accepted: false, providerError: byReference.providerError });
        return result(0, providerOutcomeMessage(outcome, "PayOS lookup is inconclusive"), await getCurrentRefundOr404(refund.id, clinicId), 202);
      }
      if (byReference.payouts[0]) {
        const applied = await applyFoundPayout({ refundId: refund.id, payout: byReference.payouts[0], clinicId });
        return result(0, applied.outcome.unknown ? providerOutcomeMessage(applied.outcome, "Provider outcome requires review") : "Refund synchronized", applied.current, applied.outcome.unknown ? 202 : 200);
      }
      if (!isConfirmedEmptyPayoutList(byReference)) return result(0, "PayOS lookup is inconclusive", await getCurrentRefundOr404(refund.id, clinicId), 202);
      const idempotencyKey = await ensurePayosIdempotencyKey({ refundId: refund.id, clinicId });
      if (!idempotencyKey) return result(404, "Refund not found", undefined, 404);
      const created = await createPayout({
        refundId: refund.id,
        referenceId: refund.referenceId,
        amount: refund.amount,
        description: `Refund booking ${refund.bookingId}`,
        toBin: refund.receiverBankBin,
        toAccountNumber: refund.receiverAccountNumber,
        idempotencyKey,
        config,
      });
      const outcome = await persistProviderOutcome({ refundId: refund.id, payout: created.payout, clinicId, accepted: isAcceptedPayout(created), providerError: created.providerError });
      return result(0, outcome.unknown ? providerOutcomeMessage(outcome, "PayOS outcome requires review") : "Refund synchronized", await getCurrentRefundOr404(refund.id, clinicId), outcome.unknown ? 202 : 200);
    }

    let payout = null;
    let lookup = null;
    let providerError = null;
    if (refund.payosPayoutId) {
      lookup = await getPayoutById({ payoutId: refund.payosPayoutId, config });
      providerError = lookup.providerError || null;
      if (!providerError && lookup.statusCode >= 200 && lookup.statusCode < 300) payout = lookup.payout;
    }
    if (!payout) {
      const byReference = await getPayoutsByReference({ referenceId: refund.referenceId, config });
      providerError = byReference.providerError || providerError;
      if (!byReference.providerError) payout = byReference.payouts[0] || null;
    }
    if (!payout) {
      const outcome = providerError
        ? await persistProviderOutcome({ refundId: refund.id, payout: null, clinicId, accepted: false, providerError })
        : null;
      return result(0, providerOutcomeMessage(outcome, "PayOS lookup is inconclusive"), await getCurrentRefundOr404(refund.id, clinicId), 202);
    }
    const applied = await applyFoundPayout({ refundId: refund.id, payout, clinicId });
    return result(0, applied.outcome.unknown ? providerOutcomeMessage(applied.outcome, "Provider outcome requires review") : "Refund synchronized", applied.current, applied.outcome.unknown ? 202 : 200);
  } catch (error) {
    const transportError = normalizeTransportError(error);
    if (transportError) {
      const outcome = await persistProviderOutcome({ refundId: refund.id, payout: null, clinicId, accepted: false, providerError: transportError });
      return result(0, providerOutcomeMessage(outcome, "PayOS lookup is inconclusive"), await getCurrentRefundOr404(refund.id, clinicId), 202);
    }
    return result(0, "PayOS lookup is inconclusive", await getCurrentRefundOr404(refund.id, clinicId), 202);
  }
};

const pollPayosRefunds = async () => {
  const config = getPayosPayoutConfig();
  if (!config.enabled) return 0;
  const [rows] = await connection.promise().query(
    `SELECT r.id
     FROM payment_refunds r
     WHERE r.refundMode = ? AND r.statusId = ?
     ORDER BY r.updatedAt ASC`,
    [PAYOS_MODE, REFUND_STATUS.PROCESSING],
  );
  for (const row of rows) await syncPayosRefund({ refundId: row.id });
  return rows.length;
};

let payosSchedulerRunning = false;
const startPayosRefundScheduler = () => {
  const config = getPayosPayoutConfig();
  if (!config.enabled) return null;
  const run = async () => {
    if (payosSchedulerRunning) return;
    payosSchedulerRunning = true;
    try {
      await pollPayosRefunds();
    } catch (error) {
      console.error("PayOS payout reconciliation error:", error.message);
    } finally {
      payosSchedulerRunning = false;
    }
  };
  run();
  return setInterval(run, config.syncIntervalSeconds * 1000);
};

module.exports = {
  PAYOS_MODE,
  PAYOS_TRANSPORT_ERRORS,
  PAYOS_TERMINAL_FAILURES,
  PATIENT_REFUND_FIELDS,
  approvePayosRefund,
  classifyProviderOutcome,
  createPatientRefund,
  ensurePayosIdempotencyKey,
  listManagementRefunds,
  listPatientRefunds,
  matchesRefund,
  persistProviderOutcome,
  pollPayosRefunds,
  rejectPayosRefund,
  startPayosRefundScheduler,
  syncPayosRefund,
  validatePatientRefundRequest,
};
