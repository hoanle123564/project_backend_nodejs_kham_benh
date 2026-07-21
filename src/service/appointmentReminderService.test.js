const assert = require("assert");
const { EventEmitter } = require("events");
const https = require("https");
const { BOOKING_STATUS } = require("./workflowStatusService");
const {
  getReminderDecision,
  hasPendingReminderChannel,
} = require("./appointmentReminderService");
const { normalizePhoneForSpeedSms, sendAppointmentReminderSms } = require("./smsService");

const booking = {
  date: "2026-07-14",
  startTime: "08:00:00",
  statusId: BOOKING_STATUS.DOCTOR_CONFIRMED,
};

assert.strictEqual(
  getReminderDecision(booking, "2026-07-14T07:29:00+07:00").due,
  false
);
assert.strictEqual(
  getReminderDecision(booking, "2026-07-14T07:30:00+07:00").due,
  true
);
assert.strictEqual(
  getReminderDecision(booking, "2026-07-14T07:40:00+07:00").due,
  true
);
assert.strictEqual(
  getReminderDecision({
    ...booking,
    emailSentAt: "2026-07-14T07:30:01+07:00",
    smsSentAt: "2026-07-14T07:30:01+07:00",
  }, "2026-07-14T07:40:00+07:00").reason,
  "ALREADY_SENT"
);

for (const statusId of ["S3", "S4", "S5", "S6", "S7"]) {
  assert.strictEqual(
    getReminderDecision({ ...booking, statusId }, "2026-07-14T07:40:00+07:00").due,
    false
  );
}

assert.strictEqual(
  getReminderDecision(booking, "2026-07-14T08:00:00+07:00").reason,
  "APPOINTMENT_STARTED"
);
assert.strictEqual(hasPendingReminderChannel({ emailSentAt: 1, smsSentAt: 1 }), false);
assert.strictEqual(normalizePhoneForSpeedSms("0912 345 678"), "0912345678");
assert.strictEqual(normalizePhoneForSpeedSms("+84912345678"), "+84912345678");
assert.strictEqual(normalizePhoneForSpeedSms("not-a-phone"), null);

const originalRequest = https.request;
let requestOptions;
let requestBody;
https.request = (options, callback) => {
  requestOptions = options;
  const request = new EventEmitter();
  request.write = (body) => {
    requestBody = body;
  };
  request.end = () => {
    const response = new EventEmitter();
    response.statusCode = 200;
    callback(response);
    process.nextTick(() => {
      response.emit("data", Buffer.from('{"status":"success","code":"00","data":{"tranId":"test-id","invalidPhone":[]}}'));
      response.emit("end");
    });
  };
  return request;
};

process.env.SPEEDSMS_ACCESS_TOKEN = "test-token";
process.env.SPEEDSMS_SMS_TYPE = "2";
process.env.SPEEDSMS_SENDER = "";
sendAppointmentReminderSms({ toPhone: "0912 345 678", message: "Reminder" })
  .then((result) => {
    assert.deepStrictEqual(result, { sent: true, id: "test-id" });
    assert.strictEqual(requestOptions.hostname, "api.speedsms.vn");
    assert.deepStrictEqual(JSON.parse(requestBody), { to: ["0912345678"], content: "Reminder", sms_type: 2 });
  })
  .finally(() => {
    https.request = originalRequest;
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
