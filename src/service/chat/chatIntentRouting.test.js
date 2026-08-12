const assert = require("node:assert/strict");
const test = require("node:test");

const faqPath = require.resolve("./chatFaqService");
require.cache[faqPath] = {
  id: faqPath,
  filename: faqPath,
  loaded: true,
  exports: {
    isPriceQuestion: (text) => /gia|phi/.test(String(text || "")),
    resolveChatFaq: async (message) =>
      /gia/.test(String(message || ""))
        ? { reply: "Giá khám của bác sĩ", source: "schedule.price" }
        : null,
  },
};

const doctorSearchPath = require.resolve("./chatDoctorSearchService");
require.cache[doctorSearchPath] = {
  id: doctorSearchPath,
  filename: doctorSearchPath,
  loaded: true,
  exports: {
    findDoctorsFromCollectedInfo: async () => [
      {
        id: 7,
        name: "BS. Ngô Hải Yến",
        specialty: "Tim mạch",
        city: "Gò Vấp",
        available_slots: [
          {
            id: 91,
            index: 1,
            date: "2026-08-12",
            start_time: "08:00",
            end_time: "08:30",
            appointmentTypeId: "AT2",
            effectivePrice: 200000,
            isActive: 1,
            isBookable: 1,
            remaining: 1,
          },
          ...Array.from({ length: 9 }, (_, index) => ({
            id: 92 + index,
            index: index + 2,
            date: "2026-08-12",
            start_time: "09:00",
            end_time: "09:30",
            appointmentTypeId: "AT2",
            effectivePrice: 200000,
            isActive: 1,
            isBookable: 1,
            remaining: 1,
          })),
        ],
        has_more_slots: true,
      },
    ],
    getAvailableSlotsForDoctor: async () => [],
    getAvailableSlotPageForDoctor: async (_doctorId, _info, options = {}) => ({
      slots: options.offset === 10
        ? [{
            id: 101,
            index: 11,
            date: "2026-08-12",
            start_time: "14:00",
            end_time: "14:30",
            appointmentTypeId: "AT2",
            effectivePrice: 200000,
            isActive: 1,
            isBookable: 1,
            remaining: 1,
          }]
        : [],
      hasMore: false,
    }),
  },
};

const flowPath = require.resolve("./chatConversationFlow");
delete require.cache[flowPath];
const flow = require("./chatConversationFlow");
const { STATES, defaultCollectedInfo } = require("./chatState");

const resultFor = (intent, extra = {}) => ({
  normalized: { intent, ...extra },
  raw: { normalized: { intent, ...extra } },
});

const newSession = () => ({
  sessionId: "intent-routing-test",
  patientId: 3,
  state: STATES.START,
  collectedInfo: defaultCollectedInfo(),
  selectedDoctorId: null,
  selectedScheduleId: null,
  bookingId: null,
});

test("all nine intents avoid the old generic fallback at START", async () => {
  const intents = [
    "GREETING",
    "FIND_DOCTOR",
    "ASK_AVAILABLE_SLOT",
    "BOOK_APPOINTMENT",
    "CONFIRM_BOOKING",
    "CANCEL_BOOKING",
    "PROVIDE_INFO",
    "OUT_OF_SCOPE",
    "EMERGENCY",
  ];

  for (const intent of intents) {
    const response = await flow.handleStart(
      newSession(),
      "test message",
      resultFor(intent)
    );
    assert.notEqual(
      response.reply,
      "Tôi có thể hỗ trợ bạn tìm bác sĩ và đặt lịch khám. Bạn vui lòng mô tả triệu chứng hoặc nhu cầu khám."
    );
  }
});

test("availability by doctor name returns read-only slots without booking state", async () => {
  const session = newSession();
  const response = await flow.handleStart(
    session,
    "Bác sĩ Ngô Hải Yến còn lịch sáng mai không?",
    resultFor("ASK_AVAILABLE_SLOT", {
      doctor_name: "Ngô Hải Yến",
      preferred_date: "2026-08-12",
      preferred_time: null,
      consultation_type: "offline",
    })
  );

  assert.equal(response.state, STATES.SHOW_AVAILABLE_SLOTS);
  assert.equal(response.data.readOnly, true);
  assert.equal(response.data.slots[0].id, 91);
  assert.equal(session.collectedInfo.preferred_time, "sang");
  assert.equal(session.selectedDoctorId, null);
  assert.equal(session.selectedScheduleId, null);
  assert.equal(session.bookingId, null);
});

test("FIND_DOCTOR phrasing that asks for a schedule uses read-only availability", async () => {
  const session = newSession();
  const response = await flow.handleStart(
    session,
    "cho toi biet lich online cua bac si Ngo Hai Yen hom nay",
    resultFor("FIND_DOCTOR", {
      doctor_name: "Ngo Hai Yen",
      preferred_date: "2026-08-11",
      consultation_type: "online",
    })
  );

  assert.equal(response.state, STATES.SHOW_AVAILABLE_SLOTS);
  assert.equal(response.data.readOnly, true);
  assert.equal(response.data.slots.length, 10);
  assert.equal(response.data.slots[0].appointmentTypeId, "AT2");
  assert.equal(response.data.hasMoreSlots, true);
  assert.equal(session.selectedDoctorId, null);
  assert.equal(session.selectedScheduleId, null);
  assert.equal(session.bookingId, null);
});

test("read-only availability loads the next page without creating booking state", async () => {
  const session = newSession();
  await flow.handleStart(
    session,
    "cho toi biet lich online cua bac si Ngo Hai Yen hom nay",
    resultFor("FIND_DOCTOR", {
      doctor_name: "Ngo Hai Yen",
      preferred_date: "2026-08-11",
      consultation_type: "online",
    })
  );

  const response = await flow.dispatchByState(
    session,
    "xem them",
    resultFor("PROVIDE_INFO")
  );

  assert.equal(response.state, STATES.SHOW_AVAILABLE_SLOTS);
  assert.equal(response.data.slots[0].id, 101);
  assert.equal(response.data.slots[0].index, 11);
  assert.equal(response.data.hasMoreSlots, false);
  assert.equal(session.collectedInfo.readOnlyAvailability.offset, 11);
  assert.equal(session.selectedDoctorId, null);
  assert.equal(session.selectedScheduleId, null);
  assert.equal(session.bookingId, null);
});

test("explicit doctor price wording uses the price FAQ even when AI says FIND_DOCTOR", async () => {
  const session = newSession();
  const response = await flow.handleStart(
    session,
    "gia kham cua bac si Ngo Hai Yen",
    resultFor("FIND_DOCTOR", { doctor_name: "Ngo Hai Yen" })
  );

  assert.equal(response.state, STATES.START);
  assert.equal(response.data.source, "schedule.price");
  assert.match(response.reply, /Giá khám/);
});

test("explicit booking wording is not rerouted to read-only availability", async () => {
  const session = newSession();
  const response = await flow.handleStart(
    session,
    "dat lich voi bac si Ngo Hai Yen",
    resultFor("FIND_DOCTOR", {
      doctor_name: "Ngo Hai Yen",
      consultation_type: "online",
    })
  );

  assert.notEqual(response.state, STATES.SHOW_AVAILABLE_SLOTS);
});

test("a booking request after read-only availability re-enters normal booking flow", async () => {
  const session = newSession();
  session.state = STATES.SHOW_AVAILABLE_SLOTS;
  session.collectedInfo.doctor_name = "Ngô Hải Yến";

  const response = await flow.dispatchByState(
    session,
    "đặt lịch",
    resultFor("BOOK_APPOINTMENT", { doctor_name: "Ngô Hải Yến" })
  );

  assert.notEqual(response.state, STATES.SHOW_AVAILABLE_SLOTS);
  assert.match(response.reply, /online|phòng khám|triệu chứng|chuyên khoa/i);
});

test("confirming after read-only availability reports that no booking draft exists", async () => {
  const session = newSession();
  session.state = STATES.SHOW_AVAILABLE_SLOTS;

  const response = await flow.dispatchByState(
    session,
    "xác nhận",
    resultFor("CONFIRM_BOOKING")
  );

  assert.equal(response.state, STATES.START);
  assert.match(response.reply, /chưa có cuộc hẹn|chưa có.*xác nhận/i);
});
