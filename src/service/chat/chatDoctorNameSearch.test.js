const assert = require("node:assert/strict");
const test = require("node:test");

const dataPath = require.resolve("../../config/data");
const queryCalls = [];
require.cache[dataPath] = {
  id: dataPath,
  filename: dataPath,
  loaded: true,
  exports: {
    promise: () => ({
      query: async (sql, params) => {
        queryCalls.push({ sql, params });
        return [[
          {
            id: 7,
            firstName: "Ngô",
            lastName: "Hải Yến",
            positionVi: "BS.",
            specialty: "Tim mạch",
            city: "Gò Vấp",
            provinceCode: "HCM",
            supportsOnline: 0,
          },
        ]];
      },
    }),
  },
};

const schedulePath = require.resolve("../doctor/doctorScheduleService");
require.cache[schedulePath] = {
  id: schedulePath,
  filename: schedulePath,
  loaded: true,
  exports: {
    GetcheScheduleDoctorByDate: async () => ({
      errCode: 0,
      data: [
        {
          id: 91,
          doctorId: 7,
          date: "2026-08-12",
          startTime: "08:00:00",
          endTime: "08:30:00",
          appointmentTypeId: "AT1",
          price: 200000,
          remaining: 1,
          isActive: 1,
          isBookable: 1,
        },
        {
          id: 92,
          doctorId: 7,
          date: "2026-08-12",
          startTime: "09:00:00",
          endTime: "09:30:00",
          appointmentTypeId: "AT2",
          price: 300000,
          remaining: 1,
          isActive: 1,
          isBookable: 1,
        },
      ],
    }),
  },
};

const searchPath = require.resolve("./chatDoctorSearchService");
delete require.cache[searchPath];
const {
  findDoctorsByNameFromCollectedInfo,
  normalizeDoctorNameQuery,
} = require("./chatDoctorSearchService");

test("doctor-name normalization trims prefixes and collapses whitespace", () => {
  assert.equal(normalizeDoctorNameQuery("  bs.   Ngo   Hai Yen  "), "Ngo Hai Yen");
});

test("named online availability uses actual AT2 slots instead of rule metadata", async () => {
  const doctors = await findDoctorsByNameFromCollectedInfo({
    doctor_name: "Ngô Hải Yến",
    preferred_date: "2026-08-12",
    consultation_type: "online",
  });

  assert.equal(doctors.length, 1);
  assert.equal(doctors[0].available_slots[0].appointmentTypeId, "AT2");
});

test("doctor-name lookup supports availability without specialty", async () => {
  const doctors = await findDoctorsByNameFromCollectedInfo({
    doctor_name: "Ngô Hải Yến",
    preferred_date: "2026-08-12",
    consultation_type: "offline",
  });

  assert.equal(doctors.length, 1);
  assert.equal(doctors[0].id, 7);
  assert.equal(doctors[0].available_slots[0].id, 91);
  const latestQuery = queryCalls[queryCalls.length - 1];
  assert.match(latestQuery.sql, /TRIM\(u\.firstName\)/);
  assert.deepEqual(latestQuery.params, ["%Ngô Hải Yến%"]);
});
