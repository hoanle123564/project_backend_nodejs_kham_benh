const assert = require("node:assert/strict");
const test = require("node:test");
const {
  createPatientReviewModerationNotification,
  NOTIFICATION_TYPE,
} = require("./notificationService");

test("review moderation notification keeps reviewId null for repeatable events", async () => {
  let params;
  await createPatientReviewModerationNotification(
    {
      patientId: 7,
      bookingId: 22,
      type: NOTIFICATION_TYPE.REVIEW_HIDDEN,
    },
    {
      query: async (sql, queryParams) => {
        params = queryParams;
        return [{ insertId: 1 }];
      },
    }
  );

  assert.deepEqual(params, [7, "R3", 22, null, null, null, null, null, "REVIEW_HIDDEN", null]);
});

const loadReviewService = ({ initialStatus, notificationError = null }) => {
  let statusId = initialStatus;
  const calls = [];
  const notifications = [];
  const db = {
    query: async (sql, params = []) => {
      calls.push({ sql, params });
      if (sql.includes("SELECT id, bookingId, patientId, statusId")) {
        return [[{ id: 5, bookingId: 22, patientId: 7, statusId }]];
      }
      if (sql.includes("UPDATE doctor_reviews SET statusId")) {
        statusId = params[0];
        return [{ affectedRows: 1 }];
      }
      if (sql.includes("FROM doctor_reviews dr")) {
        return [[{ id: 5, bookingId: 22, patientId: 7, doctorId: 9, rating: 4, comment: "ok", statusId }]];
      }
      return [[]];
    },
  };
  const mocks = {
    "../config/data": { promise: () => db },
    "./transactionService": {
      getDb: (transactionDb) => transactionDb || db,
      withTransaction: async (callback) => callback(db),
    },
    "./notificationService": {
      NOTIFICATION_TYPE,
      createDoctorNotification: async () => {},
      createPatientReviewModerationNotification: async (data) => {
        notifications.push(data);
        if (notificationError) throw notificationError;
      },
    },
    "./workflowStatusService": {
      BOOKING_STATUS: {},
      LOOKUP_TYPES: { REVIEW_STATUS: "REVIEW_STATUS" },
      REVIEW_STATUS: { VISIBLE: "RV1", HIDDEN: "RV2" },
      assertLookupKey: async () => {},
    },
  };
  const originals = Object.entries(mocks).map(([modulePath, exports]) => {
    const resolvedPath = require.resolve(modulePath);
    const original = require.cache[resolvedPath];
    require.cache[resolvedPath] = { id: resolvedPath, filename: resolvedPath, loaded: true, exports };
    return [resolvedPath, original];
  });
  const servicePath = require.resolve("./doctorReviewService");
  const originalService = require.cache[servicePath];
  delete require.cache[servicePath];

  return {
    calls,
    notifications,
    service: require("./doctorReviewService"),
    restore: () => {
      if (originalService) require.cache[servicePath] = originalService;
      else delete require.cache[servicePath];
      originals.forEach(([resolvedPath, original]) => {
        if (original) require.cache[resolvedPath] = original;
        else delete require.cache[resolvedPath];
      });
    },
  };
};

const updateVisibility = (loaded, hidden) =>
  loaded.service.updateReviewVisibility({ id: 1, roleId: "R1" }, 5, { hidden });

test("hiding a visible review notifies its patient", async () => {
  const loaded = loadReviewService({ initialStatus: "RV1" });
  try {
    const response = await updateVisibility(loaded, true);
    assert.equal(response.errCode, 0);
    assert.deepEqual(loaded.notifications, [
      { patientId: 7, bookingId: 22, type: NOTIFICATION_TYPE.REVIEW_HIDDEN },
    ]);
  } finally {
    loaded.restore();
  }
});

test("restoring a hidden review notifies its patient", async () => {
  const loaded = loadReviewService({ initialStatus: "RV2" });
  try {
    const response = await updateVisibility(loaded, false);
    assert.equal(response.errCode, 0);
    assert.deepEqual(loaded.notifications, [
      { patientId: 7, bookingId: 22, type: NOTIFICATION_TYPE.REVIEW_RESTORED },
    ]);
  } finally {
    loaded.restore();
  }
});

test("repeating the current visibility does not notify the patient", async () => {
  const loaded = loadReviewService({ initialStatus: "RV1" });
  try {
    const response = await updateVisibility(loaded, false);
    assert.equal(response.errCode, 0);
    assert.equal(loaded.notifications.length, 0);
    assert.equal(loaded.calls.filter(({ sql }) => sql.includes("UPDATE doctor_reviews SET statusId")).length, 0);
  } finally {
    loaded.restore();
  }
});

test("notification failure does not fail the committed moderation", async () => {
  const loaded = loadReviewService({
    initialStatus: "RV1",
    notificationError: new Error("notification unavailable"),
  });
  try {
    const response = await updateVisibility(loaded, true);
    assert.equal(response.errCode, 0);
    assert.equal(loaded.notifications.length, 1);
    assert.equal(loaded.calls.filter(({ sql }) => sql.includes("UPDATE doctor_reviews SET statusId")).length, 1);
  } finally {
    loaded.restore();
  }
});
