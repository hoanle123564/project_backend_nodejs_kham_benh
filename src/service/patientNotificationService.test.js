const assert = require("assert");
const {
  NOTIFICATION_ROLE,
  NOTIFICATION_TYPE,
  assertRecipient,
  createNotification,
} = require("./notificationService");

assert.doesNotThrow(() => assertRecipient({ id: 1, roleId: "R3" }, NOTIFICATION_ROLE.PATIENT));
assert.throws(() => assertRecipient({ id: 1, roleId: "R2" }, NOTIFICATION_ROLE.PATIENT), /Permission denied/);

let query;
createNotification({
  recipientUserId: 7,
  recipientRole: NOTIFICATION_ROLE.PATIENT,
  bookingId: 9,
  chatRoomId: 3,
  sourceMessageId: 11,
  type: NOTIFICATION_TYPE.NEW_MESSAGE,
}, {
  query: async (sql, params) => {
    query = { sql, params };
    return [{ insertId: 1 }];
  },
}).then((insertId) => {
  assert.strictEqual(insertId, 1);
  assert(query.sql.includes("INSERT IGNORE INTO notifications"));
  assert.deepStrictEqual(query.params, [7, "R3", 9, 3, null, 11, null, null, "NEW_MESSAGE", null]);
}).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
