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
  const controllerPath = require.resolve("./clinicManagerController");
  delete require.cache[controllerPath];
  const controller = require("./clinicManagerController");
  originals.forEach(([resolvedPath, original]) => {
    if (original) require.cache[resolvedPath] = original;
    else delete require.cache[resolvedPath];
  });
  delete require.cache[controllerPath];
  return controller;
};

test("clinic-manager controller derives the clinic from the R4 JWT", { concurrency: false }, async () => {
  let receivedClinicId = null;
  const controller = loadController({
    "../service/clinicManagerService": {
      createClinicDoctor: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
      getClinicPatient: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
      getClinicPatients: async (clinicId) => {
        receivedClinicId = clinicId;
        return { errCode: 0, errMessage: "OK", data: [] };
      },
      updateClinicDoctor: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
      updateClinicPatient: async () => ({ errCode: 0, errMessage: "OK", data: {} }),
    },
    "../service/DoctorService": { changeStatusDoctorInfo: async () => ({ errCode: 0, errMessage: "OK" }) },
    "../service/clinicAccessService": {
      CONFLICT_RESPONSE: { errCode: 409, errMessage: "Clinic manager must be assigned to exactly one clinic" },
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "Permission denied" },
      canManageDoctorSchedule: async () => true,
      getR4ClinicScope: async (user) => user.id === 9
        ? { errCode: 409, errMessage: "Clinic manager must be assigned to exactly one clinic" }
        : { errCode: 0, errMessage: "OK", clinicId: 42 },
    },
  });

  const allowed = response();
  await controller.getPatients({ user: { id: 8, roleId: "R4" }, query: { clinicId: "99" } }, allowed);
  assert.equal(allowed.statusCode, 200);
  assert.equal(receivedClinicId, 42);

  const conflict = response();
  await controller.getPatients({ user: { id: 9, roleId: "R4" }, query: {} }, conflict);
  assert.equal(conflict.statusCode, 409);
  assert.equal(conflict.body.errCode, 409);
});
