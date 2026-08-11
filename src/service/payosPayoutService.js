const crypto = require("crypto");
const https = require("https");

const DEFAULT_BASE_URL = "https://api-merchant.payos.vn";
const MAX_PROVIDER_MESSAGE_LENGTH = 240;
const PAYOS_IDEMPOTENCY_KEY_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const getPayosPayoutConfig = () => ({
  enabled: String(process.env.PAYOS_PAYOUT_ENABLED || "false").toLowerCase() === "true",
  baseUrl: String(process.env.PAYOS_PAYOUT_BASE_URL || DEFAULT_BASE_URL).trim().replace(/\/$/, ""),
  clientId: String(process.env.PAYOS_PAYOUT_CLIENT_ID || "").trim(),
  apiKey: String(process.env.PAYOS_PAYOUT_API_KEY || "").trim(),
  checksumKey: String(process.env.PAYOS_PAYOUT_CHECKSUM_KEY || "").trim(),
  timeoutMs: Math.max(1000, Number(process.env.PAYOS_PAYOUT_TIMEOUT_MS || 10000)),
  syncIntervalSeconds: Math.max(10, Number(process.env.PAYOS_PAYOUT_SYNC_INTERVAL_SECONDS || 60)),
});

const validatePayosPayoutConfig = (config = getPayosPayoutConfig()) => {
  const missing = ["clientId", "apiKey", "checksumKey"].filter((key) => !config[key]);
  if (!config.enabled || missing.length) {
    const error = new Error(`Invalid PayOS payout configuration: ${!config.enabled ? "PAYOS_PAYOUT_ENABLED must be true" : missing.join(", ")}`);
    error.errCode = 5;
    error.httpStatus = 503;
    throw error;
  }
  return config;
};

const encodeSignatureValue = (value) => encodeURIComponent(String(value ?? ""));
const buildPayoutSignature = (payload = {}, checksumKey) => {
  const canonical = Object.keys(payload)
    .sort()
    .map((key) => `${key}=${encodeSignatureValue(payload[key])}`)
    .join("&");
  return crypto.createHmac("sha256", String(checksumKey || "")).update(canonical).digest("hex");
};

const createPayosIdempotencyKey = () => crypto.randomUUID();
const isValidPayosIdempotencyKey = (value) => PAYOS_IDEMPOTENCY_KEY_PATTERN.test(String(value || "").trim());

const buildPayoutHeaders = ({ payload = {}, idempotencyKey, config = getPayosPayoutConfig() }) => {
  const headers = {
    "content-type": "application/json",
    "x-client-id": config.clientId,
    "x-api-key": config.apiKey,
    "x-signature": buildPayoutSignature(payload, config.checksumKey),
  };
  if (idempotencyKey) headers["x-idempotency-key"] = idempotencyKey;
  return headers;
};

const parseResponseBody = (value) => {
  if (!value) return null;
  try {
    return JSON.parse(value);
  } catch (_error) {
    return null;
  }
};

const normalizeProviderMessage = (value) => String(value || "")
  .replace(/\s+/g, " ")
  .trim()
  .slice(0, MAX_PROVIDER_MESSAGE_LENGTH);

const normalizeProviderCode = (value) => String(value || "")
  .trim()
  .toUpperCase()
  .replace(/[^A-Z0-9_]/g, "_")
  .slice(0, 32);

const getProviderError = (response) => {
  const statusCode = Number(response?.statusCode || 0);
  const providerCode = normalizeProviderCode(response?.body?.code);
  const providerMessage = normalizeProviderMessage(response?.body?.desc || response?.body?.message);
  const failedHttp = statusCode < 200 || statusCode >= 300;
  const failedProvider = providerCode && !["00", "0", "SUCCESS"].includes(providerCode);
  if (!failedHttp && !failedProvider) return null;

  let state = "PROVIDER_ERROR";
  if (statusCode === 403 && /ip|địa chỉ/i.test(providerMessage)) state = "HTTP_403_IP_NOT_ALLOWED";
  else if (statusCode === 401) state = "HTTP_401";
  else if (statusCode === 403) state = "HTTP_403";
  else if (statusCode >= 500) state = "HTTP_5XX";
  else if (statusCode >= 400) state = `HTTP_${statusCode}`;
  else if (providerCode) state = `PROVIDER_${providerCode}`;

  return {
    state,
    code: providerCode || String(statusCode || "UNKNOWN"),
    message: providerMessage || `PayOS request failed (${statusCode || providerCode || "unknown"})`,
    statusCode,
  };
};

const requestPayosHttp = ({ method, path, query = {}, body = null, idempotencyKey, config = getPayosPayoutConfig() }) =>
  new Promise((resolve, reject) => {
    const url = new URL(`${config.baseUrl}${path}`);
    Object.entries(query).forEach(([key, value]) => url.searchParams.set(key, String(value)));
    const bodyText = body ? JSON.stringify(body) : "";
    const request = https.request(url, {
      method,
      headers: buildPayoutHeaders({ payload: body || query, idempotencyKey, config }),
    }, (response) => {
      let responseText = "";
      response.setEncoding("utf8");
      response.on("data", (chunk) => {
        responseText += chunk;
        if (responseText.length > 2 * 1024 * 1024) response.destroy(new Error("PayOS response is too large"));
      });
      response.on("end", () => resolve({
        statusCode: response.statusCode || 0,
        body: parseResponseBody(responseText),
      }));
    });
    request.setTimeout(config.timeoutMs, () => {
      const error = new Error("PayOS payout request timed out");
      error.code = "PAYOS_TIMEOUT";
      request.destroy(error);
    });
    request.on("error", reject);
    if (bodyText) request.write(bodyText);
    request.end();
  });

const getResponseData = (body) => body && Object.prototype.hasOwnProperty.call(body, "data") ? body.data : body || null;
const asList = (value) => {
  if (Array.isArray(value)) return value;
  if (value && typeof value === "object") return Object.values(value);
  return [];
};
const getTransactions = (payout) => asList(payout?.transactions);
const getFirstTransaction = (payout) => getTransactions(payout)[0] || null;
const getPayoutReference = (payout) => String(payout?.referenceId || getFirstTransaction(payout)?.referenceId || "").trim();
const getPayoutId = (payout) => String(payout?.id || payout?.payoutId || "").trim();
const getTransactionId = (payout) => String(getFirstTransaction(payout)?.id || "").trim();
const getProviderState = (payout) => String(getFirstTransaction(payout)?.state || "").trim().toUpperCase() || null;

const getPayoutCandidates = (body) => {
  const data = getResponseData(body);
  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.items)) return data.items;
  if (data?.payouts && typeof data.payouts === "object") return asList(data.payouts);
  if (data && typeof data === "object") return [data];
  return [];
};

const createPayout = async ({ referenceId, amount, description, toBin, toAccountNumber, idempotencyKey, config }) => {
  const resolvedConfig = validatePayosPayoutConfig(config);
  const resolvedIdempotencyKey = String(idempotencyKey || "").trim();
  if (!isValidPayosIdempotencyKey(resolvedIdempotencyKey)) {
    const error = new Error("PayOS payout idempotency key must be a UUID");
    error.code = "PAYOS_INVALID_IDEMPOTENCY_KEY";
    throw error;
  }
  const payload = { referenceId, amount: Number(amount), description, toBin, toAccountNumber };
  const response = await requestPayosHttp({ method: "POST", path: "/v1/payouts", body: payload, idempotencyKey: resolvedIdempotencyKey, config: resolvedConfig });
  const payout = getResponseData(response.body);
  return { ...response, payload, payout, providerError: getProviderError(response), payoutId: getPayoutId(payout), transactionId: getTransactionId(payout), providerState: getProviderState(payout) };
};

const getPayoutsByReference = async ({ referenceId, config }) => {
  const resolvedConfig = validatePayosPayoutConfig(config);
  const response = await requestPayosHttp({ method: "GET", path: "/v1/payouts", query: { referenceId }, config: resolvedConfig });
  const payouts = getPayoutCandidates(response.body).filter((payout) => getPayoutReference(payout) === referenceId);
  return { ...response, payouts, providerError: getProviderError(response) };
};

const getPayoutById = async ({ payoutId, config }) => {
  const resolvedConfig = validatePayosPayoutConfig(config);
  const response = await requestPayosHttp({ method: "GET", path: `/v1/payouts/${encodeURIComponent(payoutId)}`, config: resolvedConfig });
  const payout = getResponseData(response.body);
  return { ...response, payout: payout && typeof payout === "object" && !Array.isArray(payout) ? payout : null, providerError: getProviderError(response) };
};

module.exports = {
  buildPayoutHeaders,
  buildPayoutSignature,
  createPayout,
  createPayosIdempotencyKey,
  getPayosPayoutConfig,
  getPayoutById,
  getPayoutCandidates,
  getPayoutId,
  getPayoutReference,
  getPayoutsByReference,
  getProviderError,
  getProviderState,
  getTransactionId,
  isValidPayosIdempotencyKey,
  requestPayosHttp,
  validatePayosPayoutConfig,
};
