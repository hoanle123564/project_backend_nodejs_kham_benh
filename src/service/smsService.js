const https = require("https");

const SPEEDSMS_SMS_TYPES = new Set([2, 3, 4, 5, 6]);

const normalizePhoneForSpeedSms = (phone) => {
  const value = String(phone || "").trim().replace(/[\s().-]/g, "");
  if (/^0\d{8,10}$/.test(value) || /^84\d{8,10}$/.test(value) || /^\+[1-9]\d{7,14}$/.test(value)) return value;
  return null;
};

const getSpeedSmsConfig = () => ({
  accessToken: process.env.SPEEDSMS_ACCESS_TOKEN,
  smsType: Number(process.env.SPEEDSMS_SMS_TYPE || 2),
  sender: String(process.env.SPEEDSMS_SENDER || "").trim(),
});

const postSpeedSmsMessage = ({ accessToken, toPhone, message, smsType, sender }) => {
  const body = JSON.stringify({
    to: [toPhone],
    content: message,
    sms_type: smsType,
    ...(sender ? { sender } : {}),
  });
  const options = {
    hostname: "api.speedsms.vn",
    method: "POST",
    path: "/index.php/sms/send",
    headers: {
      Authorization: `Basic ${Buffer.from(`${accessToken}:x`).toString("base64")}`,
      "Content-Type": "application/json",
      "Content-Length": Buffer.byteLength(body),
    },
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let responseBody = "";
      res.on("data", (chunk) => {
        responseBody += chunk;
      });
      res.on("end", () => {
        let response;
        try {
          response = JSON.parse(responseBody);
        } catch (error) {
          reject(new Error(`SpeedSMS returned invalid JSON with status ${res.statusCode}`));
          return;
        }

        if (res.statusCode < 200 || res.statusCode >= 300 || response.status !== "success" || response.code !== "00") {
          reject(new Error(`SpeedSMS failed${response.code ? ` (${response.code})` : ""}: ${response.message || "Unknown error"}`));
          return;
        }

        if (response.data?.invalidPhone?.length) {
          reject(new Error("SpeedSMS rejected the recipient phone number"));
          return;
        }

        resolve(response.data || {});
      });
    });

    req.on("error", reject);
    req.write(body);
    req.end();
  });
};

const sendAppointmentReminderSms = async (data = {}) => {
  const { accessToken, smsType, sender } = getSpeedSmsConfig();
  const toPhone = normalizePhoneForSpeedSms(data.toPhone);

  if (!accessToken || !SPEEDSMS_SMS_TYPES.has(smsType) || ([3, 5].includes(smsType) && !sender)) {
    return { skipped: true, reason: "Missing or invalid SpeedSMS configuration" };
  }

  if (!toPhone) {
    return { skipped: true, reason: "Invalid patient phone number" };
  }

  const message = data.message || `LifeCare reminder: appointment at ${data.appointmentTime || ""} ${data.appointmentDate || ""}.`;
  const response = await postSpeedSmsMessage({ accessToken, toPhone, message, smsType, sender });
  return { sent: true, id: response.tranId || null };
};

module.exports = {
  normalizePhoneForSpeedSms,
  sendAppointmentReminderSms,
};
