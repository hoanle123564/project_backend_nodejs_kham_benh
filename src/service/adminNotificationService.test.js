const assert = require("node:assert/strict");
const test = require("node:test");
const {
  NOTIFICATION_ROLE,
  NOTIFICATION_TYPE,
  assertRecipient,
  createAdminRefundNotifications,
} = require("./notificationService");

test("R1 is an allowed notification recipient", () => {
  assert.doesNotThrow(() => assertRecipient({ id: 1, roleId: "R1" }, NOTIFICATION_ROLE.ADMIN));
  assert.throws(() => assertRecipient({ id: 1, roleId: "R4" }, NOTIFICATION_ROLE.ADMIN), /Permission denied/);
});

test("refund notifications are created for every admin", async () => {
  const calls = [];
  await createAdminRefundNotifications({ bookingId: 12 }, {
    query: async (sql, params) => {
      calls.push({ sql, params });
      if (sql.includes("SELECT id FROM users")) return [[{ id: 1 }, { id: 2 }]];
      return [{ insertId: 1 }];
    },
  });

  const inserts = calls.filter(({ sql }) => sql.includes("INSERT IGNORE INTO notifications"));
  assert.equal(inserts.length, 2);
  assert.deepEqual(inserts.map(({ params }) => params), [
    [1, "R1", 12, null, null, null, null, null, NOTIFICATION_TYPE.REFUND_REQUESTED, null],
    [2, "R1", 12, null, null, null, null, null, NOTIFICATION_TYPE.REFUND_REQUESTED, null],
  ]);
});
