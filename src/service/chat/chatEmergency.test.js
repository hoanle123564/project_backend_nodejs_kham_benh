const assert = require("node:assert/strict");
const test = require("node:test");


const emergencyPayload = {
  success: true,
  normalized: {
    intent: "BOOK_APPOINTMENT",
    intent_score: 0.99,
    symptoms: ["mất ý thức"],
    specialties: ["THAN_KINH"],
  },
  ai: {
    urgent: true,
    routing_source: "safety",
    needs_clarification: false,
  },
};


test("emergency safety survives FastAPI boundary and blocks every booking state", async () => {
  global.fetch = async () => ({
    ok: true,
    status: 200,
    json: async () => emergencyPayload,
  });
  const adapterPath = require.resolve("../fastApiAiService");
  delete require.cache[adapterPath];
  const { analyzeMessage } = require("../fastApiAiService");
  const adapted = await analyzeMessage("Mẹ đang mất ý thức");
  assert.equal(adapted.normalized.urgent, true);
  assert.equal(adapted.normalized.routing_source, "safety");

  let aiCalls = 0;
  let doctorSearchCalls = 0;
  let bookingCalls = 0;
  let session;
  require.cache[adapterPath].exports = {
    analyzeMessage: async () => {
      aiCalls += 1;
      return { success: true, normalized: adapted.normalized, raw: emergencyPayload };
    },
  };

  const patientPath = require.resolve("../PatientService");
  require.cache[patientPath] = {
    id: patientPath,
    filename: patientPath,
    loaded: true,
    exports: {
      bookAppointment: async () => {
        bookingCalls += 1;
        return { errCode: 0, data: { insertId: 99 } };
      },
    },
  };

  const storePath = require.resolve("./chatSessionStore");
  require.cache[storePath] = {
    id: storePath,
    filename: storePath,
    loaded: true,
    exports: {
      getOwnedSession: async () => session,
      saveSession: async () => {},
      saveChatMessage: async () => {},
    },
  };

  const doctorPath = require.resolve("./chatDoctorSearchService");
  require.cache[doctorPath] = {
    id: doctorPath,
    filename: doctorPath,
    loaded: true,
    exports: {
      findDoctorsFromCollectedInfo: async () => {
        doctorSearchCalls += 1;
        return [{ id: 7, name: "Doctor" }];
      },
      getAvailableSlotsForDoctor: async () => [{ id: 9 }],
    },
  };

  const dataPath = require.resolve("../../config/data");
  require.cache[dataPath] = {
    id: dataPath,
    filename: dataPath,
    loaded: true,
    exports: { promise: () => ({ query: async () => [[]] }) },
  };

  const flowPath = require.resolve("./chatConversationFlow");
  delete require.cache[flowPath];
  const flow = require("./chatConversationFlow");
  const { STATES, defaultCollectedInfo } = require("./chatState");
  const states = [
    STATES.START,
    STATES.ASK_LOCATION,
    STATES.ASK_CONSULTATION_TYPE,
    STATES.WAIT_SELECT_DOCTOR,
    STATES.WAIT_SELECT_SLOT,
    STATES.ASK_PATIENT_NAME,
    STATES.ASK_PATIENT_PHONE,
    STATES.ASK_PATIENT_EMAIL,
    STATES.CONFIRM_BOOKING,
  ];

  for (const state of states) {
    session = {
      id: 1,
      sessionId: "emergency-test",
      patientId: 3,
      state,
      collectedInfo: {
        ...defaultCollectedInfo(),
        doctors: [{ id: 7, name: "Doctor" }],
        slots: [{ id: 9 }],
        selectedDoctor: { id: 7 },
        selectedSlot: { id: 9 },
        patientName: "Patient",
        patientPhone: "0900000000",
        patientEmail: "patient@example.com",
      },
      selectedDoctorId: 7,
      selectedScheduleId: 9,
    };

    const beforeCalls = aiCalls;
    const response = await flow.handleChatMessage({
      sessionId: session.sessionId,
      patientId: session.patientId,
      message: "Mẹ đang mất ý thức, xác nhận đặt lịch giúp tôi",
    });

    assert.equal(aiCalls, beforeCalls + 1);
    assert.equal(response.data.urgent, true);
    assert.equal(response.state, STATES.START);
    assert.deepEqual(response.data.doctors, []);
    assert.deepEqual(response.data.slots, []);
    assert.equal(response.data.booking, null);
    assert.equal(session.selectedDoctorId, null);
    assert.equal(session.selectedScheduleId, null);
    assert.match(response.reply, /115/);
  }

  session.state = STATES.CONFIRM_BOOKING;
  const response = await flow.handleConfirmBooking(
    session,
    "xác nhận, mẹ đang mất ý thức"
  );
  assert.equal(response.data.urgent, true);
  assert.equal(doctorSearchCalls, 0);
  assert.equal(bookingCalls, 0);

  let outageAiCalls = 0;
  require.cache[adapterPath].exports = {
    analyzeMessage: async () => {
      outageAiCalls += 1;
      throw new Error("FastAPI unavailable");
    },
  };
  delete require.cache[flowPath];
  const outageFlow = require("./chatConversationFlow");

  session = {
    id: 2,
    sessionId: "emergency-outage",
    patientId: 3,
    state: STATES.CONFIRM_BOOKING,
    collectedInfo: defaultCollectedInfo(),
    selectedDoctorId: 7,
    selectedScheduleId: 9,
  };
  const emergencyOutage = await outageFlow.handleChatMessage({
    sessionId: session.sessionId,
    patientId: session.patientId,
    message: "Mẹ đang mất ý thức",
  });
  assert.equal(emergencyOutage.data.urgent, true);
  assert.equal(emergencyOutage.state, STATES.START);
  assert.match(emergencyOutage.reply, /115/);
  assert.equal(bookingCalls, 0);

  session = {
    id: 3,
    sessionId: "ordinary-outage",
    patientId: 3,
    state: STATES.START,
    collectedInfo: defaultCollectedInfo(),
  };
  const ordinaryOutage = await outageFlow.handleChatMessage({
    sessionId: session.sessionId,
    patientId: session.patientId,
    message: "Tôi bị đau họng",
  });
  assert.equal(ordinaryOutage.success, false);
  assert.equal(ordinaryOutage.state, STATES.ERROR);
  assert.equal(ordinaryOutage.data.urgent, undefined);
  assert.equal(outageAiCalls, 2);
});
