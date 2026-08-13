const assert = require("assert");
const connection = require("../config/data");
const { getListBookingForPatient } = require("./patientController");

const createResponse = () => {
  const response = { statusCode: null, body: null };
  response.status = (statusCode) => {
    response.statusCode = statusCode;
    return response;
  };
  response.json = (body) => {
    response.body = body;
    return response;
  };
  return response;
};

const run = async () => {
  const originalPromise = connection.promise;
  let capturedQuery = null;

  connection.promise = () => ({
    query: async (sql, params) => {
      capturedQuery = { sql, params };
      return [[]];
    },
  });

  try {
    const response = createResponse();
    await getListBookingForPatient({
      user: { id: 42, roleId: "R3" },
      query: {
        patientId: "999",
        startDate: "2026-06-01",
        endDate: "2026-06-30",
        statusId: "S8",
        appointmentTypeId: "AT2",
        search: "Nguyen Van A",
      },
    }, response);

    assert.strictEqual(response.statusCode, 200);
    assert.strictEqual(response.body.errCode, 0);
    assert.deepStrictEqual(response.body.data, []);
    assert.deepStrictEqual(capturedQuery.params, [
      42,
      "2026-06-01",
      "2026-06-30",
      "S8",
      "AT2",
      "%Nguyen Van A%",
      "%Nguyen Van A%",
    ]);
    assert.match(capturedQuery.sql, /WHERE b\.patientId = \?/);
    assert.match(capturedQuery.sql, /ORDER BY b\.createdAt DESC, b\.id DESC/);

    const invalidDateResponse = createResponse();
    await getListBookingForPatient({
      user: { id: 42, roleId: "R3" },
      query: { startDate: "2026-07-02", endDate: "2026-07-01" },
    }, invalidDateResponse);
    assert.strictEqual(invalidDateResponse.statusCode, 400);
    assert.deepStrictEqual(invalidDateResponse.body, {
      errCode: 1,
      errMessage: "Start date must not be after end date.",
      data: [],
    });

    const forbiddenResponse = createResponse();
    await getListBookingForPatient({
      user: { id: 42, roleId: "R2" },
      query: {},
    }, forbiddenResponse);
    assert.strictEqual(forbiddenResponse.statusCode, 403);
  } finally {
    delete connection.promise;
    if (originalPromise !== connection.promise) {
      connection.promise = originalPromise;
    }
  }
};

run().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
