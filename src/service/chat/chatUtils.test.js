const assert = require("node:assert/strict");
const test = require("node:test");

const { buildDoctorName, parsePreferredTime } = require("./chatUtils");

test("doctor display name removes extra whitespace from stored name parts", () => {
  assert.equal(
    buildDoctorName({
      firstName: "Nguyen Tuong ",
      lastName: " Van ",
      positionVi: "BS. ",
    }),
    "BS. Nguyen Tuong Van"
  );
});

test("preferred-time parsing does not treat the Vietnamese pronoun as evening", () => {
  assert.equal(parsePreferredTime("Tôi muốn tìm bác sĩ"), null);
  assert.equal(parsePreferredTime("Bác sĩ còn lịch tối mai không?"), "toi");
  assert.equal(parsePreferredTime("Bác sĩ còn lịch 8h30 không?"), "08:30");
});
