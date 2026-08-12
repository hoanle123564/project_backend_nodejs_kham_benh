const assert = require("node:assert/strict");
const test = require("node:test");
const queryCalls = [];

const dataPath = require.resolve("../../config/data");
require.cache[dataPath] = {
  id: dataPath,
  filename: dataPath,
  loaded: true,
  exports: {
    promise: () => ({
      query: async (sql, params = []) => {
        queryCalls.push({ sql, params });
        if (sql.includes("FROM users u")) {
          return [[{
            id: 7,
            firstName: "Nguyễn Tường ",
            lastName: "Vân",
            positionVi: "",
          }]];
        }
        if (sql.includes("FROM schedule s")) {
          if (Number(params[0]) === 999) return [[]];
          if (params[1] === "AT2") {
            return [[{ appointmentTypeId: "AT2", minPrice: 10000, maxPrice: 10000 }]];
          }
          return [[
            { appointmentTypeId: "AT1", minPrice: 100000, maxPrice: 400000 },
            { appointmentTypeId: "AT2", minPrice: 10000, maxPrice: 10000 },
          ]];
        }
        if (sql.includes("MIN(price)")) {
          return [[{ appointmentTypeId: "AT1", minPrice: 100000, maxPrice: 200000 }]];
        }
        if (sql.includes("clinic_content_section")) {
          return [[{ clinicName: "Phòng khám A", title: "Dịch vụ", contentHTML: "<p>Khám tổng quát</p>" }]];
        }
        return [[{ name: "Phòng khám A", address: "Gò Vấp", provinceCode: "HCM" }]];
      },
    }),
  },
};

const faqPath = require.resolve("./chatFaqService");
delete require.cache[faqPath];
const { resolveChatFaq } = require("./chatFaqService");

test("doctor price FAQ resolves the doctor name before grouping prices", async () => {
  const price = await resolveChatFaq("gia kham", {
    doctor_name: "Nguyễn Tường Vân",
  });

  assert.match(price.reply, /Bác sĩ Nguyễn Tường Vân/);
  assert.match(price.reply, /100.*400/);
});

test("doctor price FAQ returns min-max grouped by appointment type without slots", async () => {
  const price = await resolveChatFaq("gia kham", {
    selectedDoctor: { id: 7, name: "Nguyen Tuong Van" },
  });

  assert.equal(price.source, "schedule.price");
  assert.match(price.reply, /100.*400/);
  assert.match(price.reply, /Online/);
  assert.match(price.reply, /10/);
  assert.doesNotMatch(price.reply, /08:00|09:00|slot/i);
});

test("doctor price FAQ respects explicit online consultation type", async () => {
  const price = await resolveChatFaq("gia kham online", {
    selectedDoctor: { id: 7, name: "Nguyen Tuong Van" },
  });

  assert.equal(price.reply.split("\n").length, 2);
  assert.match(price.reply, /Online/);
  assert.match(price.reply, /10/);
});

test("doctor price FAQ reports missing data instead of falling back globally", async () => {
  queryCalls.length = 0;
  const price = await resolveChatFaq("gia kham", {
    selectedDoctor: { id: 999, name: "Bac si Khong Co Gia" },
  });

  assert.match(price.reply, /Chưa có dữ liệu giá/);
  assert.equal(queryCalls.filter(({ sql }) => sql.includes("FROM schedule s")).length, 1);
  assert.equal(queryCalls.some(({ sql }) => sql.includes("MIN(price)")), false);
});

test("FAQ resolver answers only source-backed clinic data", async () => {
  const price = await resolveChatFaq("Giá khám bao nhiêu?");
  assert.equal(price.source, "schedule.price");
  assert.match(price.reply, /100/);

  const clinic = await resolveChatFaq("Phòng khám ở đâu?");
  assert.equal(clinic.source, "clinic");
  assert.match(clinic.reply, /Gò Vấp/);

  const unsupported = await resolveChatFaq("Tôi nên uống thuốc gì?");
  assert.equal(unsupported, null);
});
