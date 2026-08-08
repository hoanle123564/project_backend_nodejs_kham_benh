const assert = require("node:assert/strict");
const test = require("node:test");

const loadDashboardService = (queryCalls) => {
  const dataPath = require.resolve("../config/data");
  const transactionPath = require.resolve("./transactionService");
  const servicePath = require.resolve("./adminDashboardService");
  const originals = [
    [dataPath, require.cache[dataPath]],
    [transactionPath, require.cache[transactionPath]],
  ];
  const connection = {
    promise: () => ({
      query: async (sql, params = []) => {
        queryCalls.push({ sql, params });
        if (sql.includes("COUNT(DISTINCT b.patientId)")) return [[{ total: 0 }]];
        if (sql.includes("FROM doctor_info WHERE clinicId")) return [[{ total: 0 }]];
        if (sql.includes("FROM clinic_department")) return [[{ total: 0 }]];
        if (sql.includes("COUNT(ev.id)")) return [[{}]];
        if (sql.includes("SELECT COUNT(*) AS total")) return [[{ total: 0 }]];
        return [[]];
      },
    }),
  };
  require.cache[dataPath] = { id: dataPath, filename: dataPath, loaded: true, exports: connection };
  require.cache[transactionPath] = {
    id: transactionPath,
    filename: transactionPath,
    loaded: true,
    exports: { getDb: (db) => db || connection.promise() },
  };
  delete require.cache[servicePath];
  const service = require("./adminDashboardService");

  return {
    service,
    restore: () => {
      originals.forEach(([modulePath, original]) => {
        if (original) require.cache[modulePath] = original;
        else delete require.cache[modulePath];
      });
      delete require.cache[servicePath];
    },
  };
};

test("clinic-scoped dashboard applies the resolved clinic to every booking aggregate", { concurrency: false }, async () => {
  const queryCalls = [];
  const { service, restore } = loadDashboardService(queryCalls);

  try {
    const response = await service.getDashboardStatistics({
      clinicId: 42,
      revenueType: "month",
      topDoctorType: "month",
      recentPage: 1,
      recentLimit: 5,
    });

    const bookingQueries = queryCalls.filter(({ sql }) => sql.includes("doctor_info di"));
    assert.equal(bookingQueries.length, 9);
    bookingQueries.forEach(({ params }) => assert.ok(params.includes(42)));
    assert.deepEqual(response.data.summary, { patients: 0, doctors: 0, departments: 0 });
    assert.equal(response.data.doctorRatio, undefined);
  } finally {
    restore();
  }
});

test("global dashboard keeps its existing unscoped response shape", { concurrency: false }, async () => {
  const queryCalls = [];
  const { service, restore } = loadDashboardService(queryCalls);

  try {
    const response = await service.getDashboardStatistics({
      revenueType: "month",
      topDoctorType: "month",
      recentPage: 1,
      recentLimit: 5,
    });

    assert.deepEqual(response.data.doctorRatio, { newDoctors: 0, oldDoctors: 0, totalDoctors: 0 });
    assert.equal(queryCalls.some(({ sql }) => sql.includes("doctor_info di")), false);
    assert.equal(response.data.summary, undefined);
  } finally {
    restore();
  }
});
