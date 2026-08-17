const assert = require("node:assert/strict");
const test = require("node:test");

const response = () => ({
  statusCode: null,
  body: null,
  status(code) { this.statusCode = code; return this; },
  json(body) { this.body = body; return this; },
});

const loadController = (mocks) => {
  const originals = Object.entries(mocks).map(([modulePath, exports]) => {
    const resolvedPath = require.resolve(modulePath);
    const original = require.cache[resolvedPath];
    require.cache[resolvedPath] = { id: resolvedPath, filename: resolvedPath, loaded: true, exports };
    return [resolvedPath, original];
  });
  const controllerPath = require.resolve("./refundController");
  delete require.cache[controllerPath];
  const controller = require("./refundController");
  originals.forEach(([resolvedPath, original]) => {
    if (original) require.cache[resolvedPath] = original;
    else delete require.cache[resolvedPath];
  });
  delete require.cache[controllerPath];
  return controller;
};

test("R4 refund list and action derive clinic scope from JWT", { concurrency: false }, async () => {
  let listedClinicId = null;
  let approvedClinicId = null;
  let rejectedOptions = null;
  const controller = loadController({
    "../service/refundService": {
      listManagementRefunds: async (clinicId) => { listedClinicId = clinicId; return { errCode: 0, errMessage: "OK", data: [] }; },
      approvePayosRefund: async (options) => { approvedClinicId = options.clinicId; return { errCode: 0, errMessage: "OK", data: {}, httpStatus: 202 }; },
      rejectPayosRefund: async (options) => { rejectedOptions = options; return { errCode: 0, errMessage: "OK", data: {} }; },
      syncPayosRefund: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
      createPatientRefund: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
      listPatientRefunds: async () => ({ errCode: 0, errMessage: "OK", data: [] }),
    },
    "../service/clinicAccessService": {
      CONFLICT_RESPONSE: { errCode: 409, errMessage: "scope conflict" },
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "forbidden" },
      getR4ClinicScope: async () => ({ errCode: 0, errMessage: "OK", clinicId: 42 }),
    },
  });

  const listRes = response();
  await controller.getClinicManagerRefunds({ user: { id: 8, roleId: "R4" }, query: { clinicId: 999 } }, listRes);
  assert.equal(listRes.statusCode, 200);
  assert.equal(listedClinicId, 42);

  const approveRes = response();
  await controller.postClinicManagerApproveRefund({ user: { id: 8, roleId: "R4" }, params: { refundId: "7" } }, approveRes);
  assert.equal(approveRes.statusCode, 202);
  assert.equal(approvedClinicId, 42);
  assert.equal(Object.prototype.hasOwnProperty.call(approveRes.body, "httpStatus"), false);

  const rejectRes = response();
  await controller.postClinicManagerRejectRefund({
    user: { id: 8, roleId: "R4" },
    params: { refundId: "7" },
    body: { rejectionReason: "Account details are invalid" },
  }, rejectRes);
  assert.equal(rejectRes.statusCode, 200);
  assert.deepEqual(rejectedOptions, {
    refundId: "7",
    actor: { id: 8, roleId: "R4" },
    clinicId: 42,
    reason: "Account details are invalid",
  });
});

test("patient refund endpoint preserves 201 envelope and rejects non-patients", { concurrency: false }, async () => {
  const controller = loadController({
    "../service/refundService": {
      createPatientRefund: async () => ({ errCode: 0, errMessage: "created", data: {}, httpStatus: 201 }),
      listPatientRefunds: async () => ({ errCode: 0, errMessage: "OK", data: [] }),
    },
    "../service/clinicAccessService": {
      CONFLICT_RESPONSE: { errCode: 409, errMessage: "scope conflict" },
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "forbidden" },
      getR4ClinicScope: async () => ({ errCode: 0, errMessage: "OK", clinicId: 42 }),
    },
  });
  const created = response();
  await controller.postPatientRefund({ user: { id: 3, roleId: "R3" }, body: { bookingId: 1 } }, created);
  assert.equal(created.statusCode, 201);
  assert.equal(Object.prototype.hasOwnProperty.call(created.body, "httpStatus"), false);

  const forbidden = response();
  await controller.getPatientRefunds({ user: { id: 1, roleId: "R1" } }, forbidden);
  assert.equal(forbidden.statusCode, 403);
});

test("patient manual refund patch derives booking id from the route", { concurrency: false }, async () => {
  let received = null;
  const controller = loadController({
    "../service/refundService": {
      updatePatientManualRefund: async (options) => {
        received = options;
        return { errCode: 0, errMessage: "updated", data: {}, httpStatus: 200 };
      },
    },
    "../service/clinicAccessService": {
      CONFLICT_RESPONSE: { errCode: 409, errMessage: "scope conflict" },
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "forbidden" },
      getR4ClinicScope: async () => ({ errCode: 0, errMessage: "OK", clinicId: 42 }),
    },
  });

  const res = response();
  await controller.patchPatientManualRefund({
    user: { id: 3, roleId: "R3" },
    params: { bookingId: "12" },
    body: { bankBin: "970415", reason: null },
  }, res);

  assert.equal(res.statusCode, 200);
  assert.deepEqual(received, {
    user: { id: 3, roleId: "R3" },
    bookingId: "12",
    body: { bankBin: "970415", reason: null },
  });
  assert.equal(Object.prototype.hasOwnProperty.call(res.body, "httpStatus"), false);
});
