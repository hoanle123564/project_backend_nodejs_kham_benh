const assert = require("node:assert/strict");
const test = require("node:test");
const { REVIEW_STATUS } = require("./workflowStatusService");

const loadService = (rows, queryError = null) => {
  const dataPath = require.resolve("../config/data");
  const servicePath = require.resolve("./publicStatsService");
  const originalData = require.cache[dataPath];
  const originalService = require.cache[servicePath];
  const calls = [];

  const connection = {
    promise: () => ({
      query: async (sql, params) => {
        calls.push({ sql, params });
        if (queryError) throw queryError;
        return [rows];
      },
    }),
  };

  require.cache[dataPath] = {
    id: dataPath,
    filename: dataPath,
    loaded: true,
    exports: connection,
  };
  delete require.cache[servicePath];

  return {
    calls,
    service: require("./publicStatsService"),
    restore: () => {
      if (originalData) require.cache[dataPath] = originalData;
      else delete require.cache[dataPath];

      if (originalService) require.cache[servicePath] = originalService;
      else delete require.cache[servicePath];
    },
  };
};

test("public key stats use all R3 patients, active doctor profiles, active clinics, and visible positive reviews", { concurrency: false }, async () => {
  const { service, calls, restore } = loadService([
    {
      patients: "13",
      doctors: "7",
      clinics: "3",
      satisfactionRate: "86",
    },
  ]);

  try {
    const response = await service.getPublicKeyStats();

    assert.deepEqual(response, {
      errCode: 0,
      errMessage: "OK",
      data: {
        patients: 13,
        doctors: 7,
        clinics: 3,
        satisfactionRate: 86,
      },
    });
    assert.equal(calls.length, 1);
    assert.match(calls[0].sql, /COUNT\(\*\)\s+FROM users u\s+WHERE u\.roleId = 'R3'/);
    assert.match(calls[0].sql, /dr\.rating >= \?/);
    assert.deepEqual(calls[0].params, [1, 1, 4, REVIEW_STATUS.VISIBLE]);
  } finally {
    restore();
  }
});

test("public key stats normalize empty review aggregates to zero", { concurrency: false }, async () => {
  const { service, restore } = loadService([
    {
      patients: 0,
      doctors: 0,
      clinics: 0,
      satisfactionRate: null,
    },
  ]);

  try {
    const response = await service.getPublicKeyStats();
    assert.deepEqual(response.data, {
      patients: 0,
      doctors: 0,
      clinics: 0,
      satisfactionRate: 0,
    });
  } finally {
    restore();
  }
});

test("public key stats return an error envelope when MySQL fails", { concurrency: false }, async () => {
  const { service, restore } = loadService([], new Error("database unavailable"));

  try {
    assert.deepEqual(await service.getPublicKeyStats(), {
      errCode: 1,
      errMessage: "Error from server",
      data: null,
    });
  } finally {
    restore();
  }
});
