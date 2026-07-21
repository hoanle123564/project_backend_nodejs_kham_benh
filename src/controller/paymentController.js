const {
  createOnlineBookingPayment,
  getBookingPayment,
  processSePayWebhook,
  verifySePaySignature,
  listRefunds,
  confirmManualRefund,
} = require("../service/paymentService");
const { FORBIDDEN_RESPONSE } = require("../service/clinicAccessService");

const postOnlinePayment = async (req, res) => {
  if (req.user?.roleId !== "R3")
    return res.status(403).json(FORBIDDEN_RESPONSE);
  return res
    .status(200)
    .json(
      await createOnlineBookingPayment({ ...req.body, patientId: req.user.id }),
    );
};
const getPayment = async (req, res) =>
  res.status(200).json(await getBookingPayment(req.params.bookingId, req.user));
const postSePayWebhook = async (req, res) => {
  const rawBody = Buffer.isBuffer(req.body) ? req.body.toString("utf8") : "";
  if (
    !verifySePaySignature({
      rawBody,
      signature: req.get("X-SePay-Signature"),
      timestamp: req.get("X-SePay-Timestamp"),
    })
  )
    return res.status(401).json({ success: false });
  let payload;
  try {
    payload = JSON.parse(rawBody);
  } catch (_error) {
    return res.status(400).json({ success: false });
  }
  const result = await processSePayWebhook({ payload, rawBody });
  return res
    .status(result.httpStatus || (result.errCode === 0 ? 200 : 500))
    .json({ success: result.errCode === 0, ...(result.data || {}) });
};
const getAdminRefunds = async (_req, res) =>
  res.status(200).json(await listRefunds());
const postConfirmRefund = async (req, res) =>
  res
    .status(200)
    .json(
      await confirmManualRefund({
        refundId: req.params.refundId,
        refundTransactionId: req.body?.refundTransactionId,
        actor: req.user,
      }),
    );

module.exports = {
  getAdminRefunds,
  getPayment,
  postConfirmRefund,
  postOnlinePayment,
  postSePayWebhook,
};
