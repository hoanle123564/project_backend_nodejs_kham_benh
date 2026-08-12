const assert = require("node:assert/strict");
const test = require("node:test");

test("FastAPI adapter preserves doctor and preferred time fields", async () => {
  global.fetch = async () => ({
    ok: true,
    status: 200,
    json: async () => ({
      success: true,
      normalized: {
        intent: "ASK_AVAILABLE_SLOT",
        doctor_name: "Ngô Hải Yến",
        preferred_date: "2026-08-12",
        preferred_time: "sáng",
        specialty_state: "known_none",
        specialty_taxonomy_mismatches: ["legacy"],
      },
    }),
  });

  const modulePath = require.resolve("./fastApiAiService");
  delete require.cache[modulePath];
  const { analyzeMessage } = require("./fastApiAiService");
  const result = await analyzeMessage("Bác sĩ Ngô Hải Yến còn lịch sáng mai không?");

  assert.equal(result.normalized.doctor_name, "Ngô Hải Yến");
  assert.equal(result.normalized.preferred_time, "sáng");
  assert.equal(result.normalized.specialty_state, "known_none");
  assert.deepEqual(result.normalized.specialty_taxonomy_mismatches, ["legacy"]);
});
