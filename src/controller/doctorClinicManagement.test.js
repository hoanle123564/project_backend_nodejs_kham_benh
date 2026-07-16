const assert = require("node:assert/strict");
const test = require("node:test");

const createResponse = () => ({
  statusCode: null,
  body: null,
  status(code) {
    this.statusCode = code;
    return this;
  },
  json(body) {
    this.body = body;
    return this;
  },
});

const loadController = (controllerPath, mocks) => {
  const originals = Object.entries(mocks).map(([modulePath, exports]) => {
    const resolvedPath = require.resolve(modulePath);
    const original = require.cache[resolvedPath];
    require.cache[resolvedPath] = { id: resolvedPath, filename: resolvedPath, loaded: true, exports };
    return [resolvedPath, original];
  });
  const resolvedControllerPath = require.resolve(controllerPath);

  delete require.cache[resolvedControllerPath];
  const controller = require(controllerPath);

  originals.forEach(([resolvedPath, original]) => {
    if (original) require.cache[resolvedPath] = original;
    else delete require.cache[resolvedPath];
  });
  delete require.cache[resolvedControllerPath];
  return controller;
};

test("doctor scoped clinic reads use the JWT owner and reject unowned access", { concurrency: false }, async () => {
  let listQuery;
  let clinics = [{ id: 11, managerUserId: 7 }];
  const clinicController = loadController("./clinicController", {
    "../service/ClinicService": {
      createClinic: async () => ({}),
      getClinic: async (query) => {
        listQuery = query;
        return { errCode: 0, errMessage: "OK", data: clinics };
      },
      getClinicDetail: async () => ({ errCode: 0, errMessage: "OK", data: [] }),
      deleteClinic: async () => ({}),
      editClinic: async () => ({}),
      updateClinicOrder: async () => ({}),
      changeStatusClinic: async () => ({}),
      getClinicContentSections: async () => ({}),
      createClinicContentSection: async () => ({}),
      editClinicContentSection: async () => ({}),
      deleteClinicContentSection: async () => ({}),
      changeStatusClinicContentSection: async () => ({}),
      updateClinicContentSectionOrder: async () => ({}),
    },
    "../service/clinicAccessService": {
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "Permission denied" },
      canManageClinic: async () => false,
    },
  });

  const listResponse = createResponse();
  await clinicController.getAllClinic(
    { query: { managedOnly: "1", managerUserId: "99" }, user: { id: 7, roleId: "R2" } },
    listResponse
  );
  assert.equal(listResponse.statusCode, 200);
  assert.equal(listQuery.managerUserId, 7);

  const detailResponse = createResponse();
  await clinicController.getDetailClinicById(
    { query: { id: "22", managedOnly: "1" }, user: { id: 7, roleId: "R2" } },
    detailResponse
  );
  assert.equal(detailResponse.statusCode, 403);
  assert.equal(detailResponse.body.errCode, 403);

  clinics = [];
  const deniedListResponse = createResponse();
  await clinicController.getAllClinic(
    { query: { managedOnly: "1" }, user: { id: 8, roleId: "R2" } },
    deniedListResponse
  );
  assert.equal(deniedListResponse.statusCode, 403);
  assert.equal(deniedListResponse.body.errCode, 403);
});

test("doctor profile update derives its target from JWT", { concurrency: false }, async () => {
  let updateOptions;
  const userController = loadController("./userController", {
    "../service/userService": {
      handleUserLoginService: async () => ({}),
      getAllUsersService: async () => ({}),
      createNewUserService: async () => ({}),
      changePasswordService: async () => ({}),
      deleteUserService: async () => ({}),
      updateUserService: async (_data, options) => {
        updateOptions = options;
        return { errCode: 0, errMessage: "Update successful", data: {} };
      },
      getLookUpService: async () => ({}),
    },
  });

  const response = createResponse();
  await userController.handleEditUserAPI(
    {
      user: { id: 7, roleId: "R2" },
      body: { id: 99, email: "other@example.com", roleId: "R1", firstName: "Doctor" },
    },
    response
  );

  assert.equal(response.statusCode, 200);
  assert.deepEqual(updateOptions, { selfUserId: 7 });
});

test("doctor professional profile uses the JWT doctor id", { concurrency: false }, async () => {
  const { canSaveDoctorInfo } = require("../service/clinicAccessService");
  assert.equal(await canSaveDoctorInfo({ id: 1, roleId: "R1" }, 99), true);
  assert.equal(await canSaveDoctorInfo({ id: 7, roleId: "R2" }, 7), true);
  assert.equal(await canSaveDoctorInfo({ id: 7, roleId: "R2" }, 99), false);

  let savedDoctorInfo;
  const doctorController = loadController("./doctorController", {
    "../service/DoctorService": {
      saveDetailInfoDoctor: async (data) => {
        savedDoctorInfo = data;
        return { errCode: 0, errMessage: "OK" };
      },
    },
    "../service/clinicAccessService": {
      FORBIDDEN_RESPONSE: { errCode: 403, errMessage: "Permission denied" },
      canSaveDoctorInfo: async () => true,
    },
  });

  const response = createResponse();
  await doctorController.postInfoDoctor(
    {
      user: { id: 7, roleId: "R2" },
      body: { doctorId: 99, clinicId: 12, contentHTML: "<p>Profile</p>" },
    },
    response
  );

  assert.equal(response.statusCode, 200);
  assert.equal(savedDoctorInfo.doctorId, 7);
});
