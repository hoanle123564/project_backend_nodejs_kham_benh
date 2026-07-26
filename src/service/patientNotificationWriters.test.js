const assert = require("assert");
const fs = require("fs");
const path = require("path");

const serviceRoot = __dirname;
const writers = [
  "PatientService.js",
  "paymentService.js",
  "bookingStatusService.js",
  path.join("doctor", "doctorBookingService.js"),
  "examinationWorkflowService.js",
];

for (const writer of writers) {
  const source = fs.readFileSync(path.join(serviceRoot, writer), "utf8");
  assert(source.includes("createPatientBookingStatusNotification"), `${writer} must create a patient status notification`);
  assert(source.includes("notificationService"), `${writer} must use the shared notification service`);
}

const chatSource = fs.readFileSync(path.join(serviceRoot, "chatRoomService.js"), "utf8");
assert(chatSource.includes("NOTIFICATION_TYPE.NEW_MESSAGE"));
assert(chatSource.includes("notificationService"));

const reminderSource = fs.readFileSync(path.join(serviceRoot, "appointmentReminderService.js"), "utf8");
assert(reminderSource.includes("NOTIFICATION_TYPE.APPOINTMENT_REMINDER"));
assert(reminderSource.includes("notificationService"));
