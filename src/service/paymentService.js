const crypto = require("crypto");
const connection = require("../config/data");
const { withTransaction } = require("./transactionService");
const { getSchedulePriceAtBooking } = require("./adminDashboardService");
const { createDoctorNotification } = require("./doctorNotificationService");
const { isScheduleStarted, normalizeDate } = require("./doctor/doctorSchedulePolicy");
const { assignBookingQueueNumberInCurrentTransaction } = require("./bookingQueueService");

const PAYMENT_STATUS = Object.freeze({
  PENDING: "PPS1",
  PAID_PENDING_DOCTOR: "PPS2",
  COMPLETED: "PPS3",
  EXPIRED: "PPS4",
  MANUAL_REVIEW: "PPS5",
  REFUND_PENDING: "PPS6",
  REFUNDED: "PPS7",
  REFUND_FAILED: "PPS8",
});
const REFUND_STATUS = Object.freeze({ PENDING: "RFS1", PROCESSING: "RFS2", REFUNDED: "RFS3", FAILED: "RFS4" });
const PROVIDER = "SEPAY";
const PAYMENT_METHOD = "PAY2";
const PAYMENT_CURRENCY = "VND";
const CAPACITY_EXCLUDED_STATUS_IDS = Object.freeze(["S3", "S4", "S5", "S6", "S7"]);
const PUBLIC_PAYMENT_STATUS = Object.freeze({
  [PAYMENT_STATUS.PENDING]: "PENDING",
  [PAYMENT_STATUS.PAID_PENDING_DOCTOR]: "PAID",
  [PAYMENT_STATUS.COMPLETED]: "PAID",
  [PAYMENT_STATUS.EXPIRED]: "EXPIRED",
  [PAYMENT_STATUS.REFUNDED]: "REFUNDED",
  [PAYMENT_STATUS.REFUND_PENDING]: "REFUNDED",
  [PAYMENT_STATUS.MANUAL_REVIEW]: "FAILED",
  [PAYMENT_STATUS.REFUND_FAILED]: "FAILED",
});

const getPublicPaymentStatus = (statusId) => PUBLIC_PAYMENT_STATUS[statusId] || "FAILED";
const isPaidPaymentStatus = (statusId) => [PAYMENT_STATUS.PAID_PENDING_DOCTOR, PAYMENT_STATUS.COMPLETED].includes(statusId);

const shouldAssignOnlineBookingQueue = ({ booking, payment }) =>
  booking?.appointmentTypeId === "AT2" && booking?.statusId === "S8" && isPaidPaymentStatus(payment?.statusId);

const ensureOnlineBookingQueue = async ({ booking, payment }, db) => {
  if (!shouldAssignOnlineBookingQueue({ booking, payment })) return null;
  return assignBookingQueueNumberInCurrentTransaction(
    { bookingId: booking.id, doctorId: booking.doctorId, appointmentDate: booking.date },
    db
  );
};

const getPaymentConfig = () => ({
  enabled: String(process.env.SEPAY_ENABLED).toLowerCase() === "true",
  accountNumber: String(process.env.SEPAY_BANK_ACCOUNT || "").trim(),
  bankName: String(process.env.SEPAY_BANK_NAME || "").trim(),
  accountHolder: String(process.env.SEPAY_ACCOUNT_HOLDER || "").trim(),
  prefix: String(process.env.SEPAY_PAYMENT_PREFIX || "APM").trim(),
  expiresMinutes: Math.max(1, Number(process.env.SEPAY_PAYMENT_EXPIRE_MINUTES || 15)),
  webhookSecret: String(process.env.SEPAY_WEBHOOK_SECRET || ""),
  authType: String(process.env.SEPAY_WEBHOOK_AUTH_TYPE || "HMAC").toUpperCase(),
  refundMode: String(process.env.SEPAY_REFUND_MODE || "MANUAL").toUpperCase(),
});

const validatePaymentConfig = () => {
  const config = getPaymentConfig();
  if (!config.enabled) return config;
  const missing = ["accountNumber", "bankName", "accountHolder", "prefix", "webhookSecret"].filter((key) => !config[key]);
  if (config.authType !== "HMAC" || missing.length) {
    throw new Error(`Invalid SePay configuration: ${missing.join(", ") || "SEPAY_WEBHOOK_AUTH_TYPE must be HMAC"}`);
  }
  return config;
};

const buildPaymentCode = (bookingId, prefix) => `${prefix}${bookingId}${crypto.randomBytes(4).toString("hex").toUpperCase()}`;
const escapeRegExp = (value) => String(value).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
const normalizePaymentCode = (value) => String(value || "").trim().toUpperCase();
const getPaymentCodePattern = (prefix = getPaymentConfig().prefix) => new RegExp(`^${escapeRegExp(normalizePaymentCode(prefix))}\\d+[A-F0-9]{8}$`);
const extractPaymentCode = (payload = {}, config = getPaymentConfig()) => {
  const pattern = getPaymentCodePattern(config.prefix);
  const directCode = normalizePaymentCode(payload.code);
  if (pattern.test(directCode)) return directCode;

  const embedded = new RegExp(`(?:^|[^A-Z0-9])(${escapeRegExp(normalizePaymentCode(config.prefix))}\\d+[A-F0-9]{8})(?![A-Z0-9])`);
  for (const value of [payload.content, payload.description]) {
    const match = normalizePaymentCode(value).match(embedded);
    if (match && pattern.test(match[1])) return match[1];
  }
  return null;
};
const buildQrCodeUrl = ({ accountNumber, bankName, amount, paymentCode }) =>
  `https://vietqr.app/img?${new URLSearchParams({ acc: accountNumber, bank: bankName, amount: String(amount), des: paymentCode, template: "compact" })}`;
const getPaymentExpiryAt = (payment, config = getPaymentConfig()) => {
  const createdAt = new Date(payment?.createdAt);
  return new Date(createdAt.getTime() + config.expiresMinutes * 60 * 1000);
};
const isPaymentExpired = (payment, config = getPaymentConfig(), now = Date.now()) =>
  getPaymentExpiryAt(payment, config).getTime() <= now;
const activeStatusPlaceholders = () => CAPACITY_EXCLUDED_STATUS_IDS.map(() => "?").join(", ");
const buildCapacitySummary = (bookedCount, capacity) => {
  const count = Math.max(0, Number(bookedCount) || 0);
  const max = Math.max(1, Number(capacity) || 1);
  return { bookedCount: count, capacity: max, remaining: Math.max(0, max - count) };
};

const getScheduleForPayment = async (scheduleId, db) => {
  const [scheduleRows] = await db.query(
    `SELECT id, doctorId, date, appointmentTypeId, COALESCE(capacity, 1) AS capacity, COALESCE(isActive, 1) AS isActive
       FROM schedule WHERE id = ? LIMIT 1 FOR UPDATE`,
    [scheduleId]
  );
  const schedule = scheduleRows[0];
  if (!schedule) return null;
  const excluded = CAPACITY_EXCLUDED_STATUS_IDS;
  const [bookings] = await db.query(
    `SELECT COUNT(*) AS bookedCount FROM booking WHERE scheduleId = ? AND statusId NOT IN (${activeStatusPlaceholders()})`,
    [scheduleId, ...excluded]
  );
  return { ...schedule, ...buildCapacitySummary(bookings[0]?.bookedCount, schedule.capacity) };
};

const getPublicPayment = (payment, config = getPaymentConfig()) => ({
  id: payment.id,
  paymentId: payment.id,
  bookingId: payment.bookingId,
  paymentCode: payment.paymentCode,
  amount: Number(payment.amount),
  currency: PAYMENT_CURRENCY,
  statusId: payment.statusId,
  status: getPublicPaymentStatus(payment.statusId),
  paidAt: payment.paidAt,
  expiresAt: getPaymentExpiryAt(payment, config).toISOString(),
  bankName: config.bankName,
  accountNumber: config.accountNumber,
  accountHolder: config.accountHolder,
  qrCodeUrl: payment.statusId === PAYMENT_STATUS.PENDING
    ? buildQrCodeUrl({ ...config, amount: Number(payment.amount), paymentCode: payment.paymentCode })
    : null,
});

const createOnlineBookingPayment = async ({ scheduleId, reason, patientId }) => {
  let config;
  try {
    config = validatePaymentConfig();
  } catch (error) {
    return { errCode: 5, errMessage: error.message };
  }
  if (!config.enabled) return { errCode: 5, errMessage: "Online payment is not enabled." };
  const normalizedScheduleId = Number(scheduleId);
  if (!Number.isInteger(normalizedScheduleId) || normalizedScheduleId <= 0 || !Number(patientId)) {
    return { errCode: 1, errMessage: "Missing required parameters" };
  }

  try {
    const data = await withTransaction(async (db) => {
      const schedule = await getScheduleForPayment(normalizedScheduleId, db);
      if (!schedule) return { error: "Selected schedule does not exist" };
      if (schedule.appointmentTypeId !== "AT2") return { error: "Selected schedule is not an online appointment" };
      if (Number(schedule.isActive) !== 1 || schedule.remaining <= 0 || isScheduleStarted(schedule)) {
        return { error: "Selected schedule is unavailable" };
      }
      const [patients] = await db.query("SELECT id FROM users WHERE id = ? AND roleId = 'R3' LIMIT 1 FOR UPDATE", [patientId]);
      if (!patients[0]) return { error: "Patient profile was not found" };
      const [existing] = await db.query(
        `SELECT id FROM booking WHERE scheduleId = ? AND patientId = ? AND statusId NOT IN (${activeStatusPlaceholders()}) LIMIT 1 FOR UPDATE`,
        [normalizedScheduleId, patientId, ...CAPACITY_EXCLUDED_STATUS_IDS]
      );
      if (existing[0]) return { error: "You already have an active booking for this schedule." };
      const amount = await getSchedulePriceAtBooking(normalizedScheduleId, db);
      if (!Number.isInteger(Number(amount)) || Number(amount) <= 0) return { error: "Consultation price is unavailable." };
      const [booking] = await db.query(
        `INSERT INTO booking (statusId, scheduleId, patientId, date, reason, priceAtBooking, paymentMethodId)
         VALUES ('S1', ?, ?, ?, ?, ?, ?)`,
        [normalizedScheduleId, patientId, normalizeDate(schedule.date), String(reason || "").trim() || null, amount, PAYMENT_METHOD]
      );
      const paymentCode = buildPaymentCode(booking.insertId, config.prefix);
      const createdAt = new Date();
      const [payment] = await db.query(
        `INSERT INTO appointment_payments (bookingId, patientId, paymentCode, amount, statusId)
         VALUES (?, ?, ?, ?, ?)`,
        [booking.insertId, patientId, paymentCode, amount, PAYMENT_STATUS.PENDING]
      );
      return { bookingId: booking.insertId, payment: { id: payment.insertId, bookingId: booking.insertId, paymentCode, amount, statusId: PAYMENT_STATUS.PENDING, createdAt } };
    });
    if (data.error) return { errCode: 4, errMessage: data.error };
    return { errCode: 0, errMessage: "Payment created", data: { bookingId: data.bookingId, payment: getPublicPayment(data.payment, config) } };
  } catch (error) {
    return { errCode: 1, errMessage: error.message || "Unable to create payment" };
  }
};

const verifySePaySignature = ({ rawBody, signature, timestamp }) => {
  const config = getPaymentConfig();
  const value = String(timestamp || "");
  const seconds = Number(value);
  if (config.authType !== "HMAC" || !config.webhookSecret || !Number.isInteger(seconds) || Math.abs(Math.floor(Date.now() / 1000) - seconds) > 300) return false;
  const expected = `sha256=${crypto.createHmac("sha256", config.webhookSecret).update(`${value}.${rawBody}`).digest("hex")}`;
  const actual = String(signature || "");
  return actual.length === expected.length && crypto.timingSafeEqual(Buffer.from(actual), Buffer.from(expected));
};

const markEvent = (db, eventId, processingStatus, errorMessage = null) =>
  db.query("UPDATE payment_webhook_events SET processingStatus = ?, errorMessage = ?, processedAt = CURRENT_TIMESTAMP WHERE id = ?", [processingStatus, errorMessage, eventId]);

const getSePayTransactionId = (payload) => String(payload?.id ?? "").trim();
const logSePay = (message, details = {}) => console.info("[SePay]", message, details);
const processSePayWebhook = async ({ payload, rawBody }) => {
  const transactionId = getSePayTransactionId(payload);
  if (!transactionId) return { errCode: 1, errMessage: "Missing SePay transaction id" };
  const payloadHash = crypto.createHash("sha256").update(rawBody).digest("hex");
  const config = getPaymentConfig();
  try {
    const result = await withTransaction(async (db) => {
      const [event] = await db.query(
        `INSERT IGNORE INTO payment_webhook_events (provider, providerTransactionId, payloadHash, processingStatus)
         VALUES (?, ?, ?, 'RECEIVED')`,
        [PROVIDER, transactionId, payloadHash]
      );
      if (event.affectedRows === 0) return { matched: true, duplicate: true };
      const eventId = event.insertId;
      const paymentCode = extractPaymentCode(payload, config);
      logSePay("received", { transactionId, payloadCode: normalizePaymentCode(payload.code) || null, paymentCode });
      if (!paymentCode) {
        await markEvent(db, eventId, "UNMATCHED", "PAYMENT_CODE_NOT_FOUND");
        return { matched: false, reason: "PAYMENT_CODE_NOT_FOUND" };
      }
      const [paymentReferences] = await db.query("SELECT id, bookingId FROM appointment_payments WHERE paymentCode = ? LIMIT 1", [paymentCode]);
      const paymentReference = paymentReferences[0];
      if (!paymentReference) {
        await markEvent(db, eventId, "UNMATCHED", "PAYMENT_NOT_FOUND");
        return { matched: false, reason: "PAYMENT_NOT_FOUND", paymentCode };
      }
      const [bookings] = await db.query(
        `SELECT b.id, b.statusId, b.date, s.doctorId, s.appointmentTypeId
           FROM booking b INNER JOIN schedule s ON s.id = b.scheduleId
          WHERE b.id = ? LIMIT 1 FOR UPDATE`,
        [paymentReference.bookingId]
      );
      const booking = bookings[0];
      if (!booking) {
        await markEvent(db, eventId, "UNMATCHED", "BOOKING_NOT_FOUND");
        return { matched: false, reason: "BOOKING_NOT_FOUND", paymentId: paymentReference.id };
      }
      const [payments] = await db.query("SELECT * FROM appointment_payments WHERE id = ? LIMIT 1 FOR UPDATE", [paymentReference.id]);
      const payment = payments[0];
      if (!payment || payment.paymentCode !== paymentCode) {
        await markEvent(db, eventId, "UNMATCHED", "PAYMENT_NOT_FOUND");
        return { matched: false, reason: "PAYMENT_NOT_FOUND", paymentCode };
      }
      if (payload.transferType !== "in") {
        await markEvent(db, eventId, "MANUAL_REVIEW", "INVALID_TRANSFER_TYPE");
        return { matched: false, reason: "INVALID_TRANSFER_TYPE", paymentId: payment.id };
      }
      if (String(payload.accountNumber || "").trim() !== config.accountNumber || Number(payload.transferAmount) !== Number(payment.amount)) {
        await markEvent(db, eventId, "MANUAL_REVIEW", "PAYMENT_MISMATCH");
        if (payment.statusId === PAYMENT_STATUS.PENDING) await db.query("UPDATE appointment_payments SET statusId = ? WHERE id = ?", [PAYMENT_STATUS.MANUAL_REVIEW, payment.id]);
        return { matched: false, reason: "PAYMENT_MISMATCH", paymentId: payment.id };
      }
      if (payment.statusId !== PAYMENT_STATUS.PENDING || isPaymentExpired(payment, config)) {
        const reason = payment.statusId !== PAYMENT_STATUS.PENDING ? "PAYMENT_NOT_PENDING" : "PAID_AFTER_EXPIRED";
        await markEvent(db, eventId, "MANUAL_REVIEW", reason);
        if (payment.statusId === PAYMENT_STATUS.PENDING) await db.query("UPDATE appointment_payments SET statusId = ? WHERE id = ?", [PAYMENT_STATUS.EXPIRED, payment.id]);
        return { matched: false, reason, paymentId: payment.id };
      }
      if (["S3", "S4", "S5", "S6", "S7"].includes(booking.statusId)) {
        await markEvent(db, eventId, "MANUAL_REVIEW", "BOOKING_NOT_PAYABLE");
        return { matched: false, reason: "BOOKING_NOT_PAYABLE", paymentId: payment.id, bookingId: booking.id };
      }
      const paymentStatusId = booking.statusId === "S8" ? PAYMENT_STATUS.COMPLETED : PAYMENT_STATUS.PAID_PENDING_DOCTOR;
      await db.query(
        `UPDATE appointment_payments
            SET statusId = ?, paidAt = CURRENT_TIMESTAMP
          WHERE id = ?`,
        [paymentStatusId, payment.id]
      );
      await db.query("UPDATE booking SET statusId = 'S2' WHERE id = ? AND statusId = 'S1'", [payment.bookingId]);
      await db.query("UPDATE examination_visit SET paymentStatusId = 'PS2' WHERE bookingId = ?", [payment.bookingId]);
      const updatedBooking = { ...booking, statusId: booking.statusId === "S1" ? "S2" : booking.statusId };
      const updatedPayment = { ...payment, statusId: paymentStatusId };
      const queue = await ensureOnlineBookingQueue({ booking: updatedBooking, payment: updatedPayment }, db);
      await markEvent(db, eventId, "PROCESSED");
      if (updatedBooking.statusId === "S2") {
        await createDoctorNotification({ doctorId: updatedBooking.doctorId, bookingId: payment.bookingId, type: "NEW_PAID_ONLINE_BOOKING", content: "Online booking has been paid and is awaiting confirmation." }, db);
      }
      return { matched: true, processed: true, paymentStatus: getPublicPaymentStatus(paymentStatusId), paymentId: payment.id, bookingId: payment.bookingId, doctorId: updatedBooking.doctorId, queueNumber: queue?.data?.queueNumber || null };
    });
    logSePay("response", { transactionId, matched: result.matched, duplicate: Boolean(result.duplicate), paymentId: result.paymentId || null, reason: result.reason || null });
    return result.processed || result.duplicate
      ? { errCode: 0, errMessage: "OK", data: result }
      : { errCode: 2, errMessage: result.reason || "Webhook could not be applied", httpStatus: 422, data: result };
  } catch (error) {
    return { errCode: 1, errMessage: error.message || "Webhook processing failed" };
  }
};

const getBookingPayment = async (bookingId, user) => {
  const [rows] = await connection.promise().query(
    `SELECT p.* FROM appointment_payments p INNER JOIN booking b ON b.id = p.bookingId
      WHERE p.bookingId = ? AND (? = 'R1' OR (? = 'R3' AND b.patientId = ?) OR (? = 'R2' AND EXISTS (SELECT 1 FROM schedule s WHERE s.id = b.scheduleId AND s.doctorId = ?))) LIMIT 1`,
    [bookingId, user?.roleId, user?.roleId, user?.id, user?.roleId, user?.id]
  );
  return rows[0] ? { errCode: 0, errMessage: "OK", data: getPublicPayment(rows[0]) } : { errCode: 404, errMessage: "Payment not found" };
};

const applyDoctorPaymentDecision = async ({ bookingId, statusId, reason, actor }, db) => {
  if (!["S8", "S6"].includes(statusId)) return;
  const [payments] = await db.query("SELECT * FROM appointment_payments WHERE bookingId = ? LIMIT 1 FOR UPDATE", [bookingId]);
  const payment = payments[0];
  if (!payment) return null;
  if (statusId === "S8") {
    if (payment.statusId === PAYMENT_STATUS.PENDING || payment.statusId === PAYMENT_STATUS.COMPLETED) return payment;
    if (payment.statusId !== PAYMENT_STATUS.PAID_PENDING_DOCTOR) {
      const error = new Error("Online booking payment cannot be confirmed"); error.errCode = 2; throw error;
    }
    await db.query("UPDATE appointment_payments SET statusId = ? WHERE id = ?", [PAYMENT_STATUS.COMPLETED, payment.id]);
    return { ...payment, statusId: PAYMENT_STATUS.COMPLETED };
  }
  if (payment.statusId === PAYMENT_STATUS.PENDING) return payment;
  if (![PAYMENT_STATUS.PAID_PENDING_DOCTOR, PAYMENT_STATUS.COMPLETED].includes(payment.statusId)) {
    const error = new Error("Online booking payment cannot be refunded"); error.errCode = 2; throw error;
  }
  const [profiles] = await db.query("SELECT refundBankName, refundAccountName, refundAccountNumber FROM patient_profile WHERE patientId = ? LIMIT 1", [payment.patientId]);
  const profile = profiles[0] || {};
  await db.query("UPDATE appointment_payments SET statusId = ? WHERE id = ?", [PAYMENT_STATUS.REFUND_PENDING, payment.id]);
  await db.query(
    `INSERT INTO payment_refunds (paymentId, bookingId, amount, statusId, reason, refundMode, receiverBank, receiverAccountName, receiverAccountNumber)
     VALUES (?, ?, ?, ?, ?, 'MANUAL', ?, ?, ?)`,
    [payment.id, bookingId, payment.amount, REFUND_STATUS.PENDING, reason || null, profile.refundBankName || null, profile.refundAccountName || null, profile.refundAccountNumber || null]
  );
  return { ...payment, statusId: PAYMENT_STATUS.REFUND_PENDING };
};

const listRefunds = async () => {
  const [rows] = await connection.promise().query(
    `SELECT r.*, p.paymentCode, u.firstName, u.lastName, u.email FROM payment_refunds r
       INNER JOIN appointment_payments p ON p.id = r.paymentId INNER JOIN users u ON u.id = p.patientId ORDER BY r.requestedAt DESC`
  );
  return { errCode: 0, errMessage: "OK", data: rows };
};

const confirmManualRefund = async ({ refundId, refundTransactionId, actor }) => {
  const transactionId = String(refundTransactionId || "").trim();
  if (!transactionId) return { errCode: 1, errMessage: "Refund transaction id is required" };
  try {
    const data = await withTransaction(async (db) => {
      const [refunds] = await db.query("SELECT * FROM payment_refunds WHERE id = ? LIMIT 1 FOR UPDATE", [refundId]);
      const refund = refunds[0];
      if (!refund) return null;
      if (refund.statusId !== REFUND_STATUS.PENDING) { const error = new Error("Refund is already processed"); error.errCode = 2; throw error; }
      if (!refund.receiverBank || !refund.receiverAccountName || !refund.receiverAccountNumber) { const error = new Error("Patient refund account is incomplete"); error.errCode = 2; throw error; }
      await db.query("UPDATE payment_refunds SET statusId = ?, refundTransactionId = ?, processedBy = ?, refundedAt = CURRENT_TIMESTAMP WHERE id = ?", [REFUND_STATUS.REFUNDED, transactionId, actor.id, refund.id]);
      await db.query("UPDATE appointment_payments SET statusId = ? WHERE id = ?", [PAYMENT_STATUS.REFUNDED, refund.paymentId]);
      return { id: refund.id };
    });
    return data ? { errCode: 0, errMessage: "Refund confirmed", data } : { errCode: 404, errMessage: "Refund not found" };
  } catch (error) { return { errCode: error.errCode || 1, errMessage: error.message }; }
};

const expirePendingPayments = async () => withTransaction(async (db) => {
  const config = getPaymentConfig();
  const expiredBefore = new Date(Date.now() - config.expiresMinutes * 60 * 1000);
  const [payments] = await db.query("SELECT id, bookingId FROM appointment_payments WHERE statusId = ? AND createdAt <= ? FOR UPDATE", [PAYMENT_STATUS.PENDING, expiredBefore]);
  if (!payments.length) return 0;
  const paymentIds = payments.map((payment) => payment.id);
  const bookingIds = payments.map((payment) => payment.bookingId);
  await db.query(`DELETE FROM appointment_payments WHERE id IN (${paymentIds.map(() => "?").join(",")})`, paymentIds);
  await db.query(`DELETE FROM booking WHERE id IN (${bookingIds.map(() => "?").join(",")})`, bookingIds);
  return payments.length;
});

const startPaymentExpiryScheduler = () => {
  const run = () => expirePendingPayments().catch((error) => console.error("payment expiry error:", error.message));
  run();
  return setInterval(run, 60 * 1000);
};

module.exports = { PAYMENT_STATUS, REFUND_STATUS, applyDoctorPaymentDecision, buildPaymentCode, buildQrCodeUrl, confirmManualRefund, createOnlineBookingPayment, ensureOnlineBookingQueue, expirePendingPayments, extractPaymentCode, getBookingPayment, getPaymentCodePattern, getPaymentExpiryAt, getPublicPaymentStatus, getSePayTransactionId, isPaidPaymentStatus, isPaymentExpired, listRefunds, normalizePaymentCode, processSePayWebhook, shouldAssignOnlineBookingQueue, startPaymentExpiryScheduler, validatePaymentConfig, verifySePaySignature };
