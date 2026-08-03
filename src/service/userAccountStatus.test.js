const assert = require("node:assert/strict");
const test = require("node:test");

const statements = [];
let authenticatedUsers = [{ id: 2 }];
const dataPath = require.resolve("../config/data");

require.cache[dataPath] = {
    exports: {
        promise: () => ({
            query: async (statement, params = []) => {
                statements.push({ statement, params });
                if (statement.includes("WHERE email")) {
                    return [[{ id: 1, email: "disabled@example.com", password: "hash", isActive: 0 }]];
                }
                if (statement.includes("isActive = 1 LIMIT 1")) {
                    return [authenticatedUsers];
                }
                if (statement.includes("SELECT id FROM users")) {
                    return [[{ id: 2 }]];
                }
                if (statement.includes("UPDATE users SET isActive = ?")) {
                    return [{ affectedRows: 1 }];
                }
                throw new Error(`Unexpected query: ${statement}`);
            },
        }),
    },
};

const { disableUserService, handleUserLoginService } = require("./userService");
const jwt = require("jsonwebtoken");
const originalVerify = jwt.verify;
jwt.verify = () => ({ id: 2 });
const authMiddleware = require("../middleware/authMiddleware");

test("disabled accounts cannot log in", async () => {
    statements.length = 0;
    const result = await handleUserLoginService({ email: "disabled@example.com", password: "secret" });

    assert.equal(result.errCode, 4);
    assert.equal(result.token, null);
    assert.equal(statements.length, 1);
});

test("disabling a user only updates account status", async () => {
    statements.length = 0;
    const result = await disableUserService(2, 0);

    assert.equal(result.errCode, 0);
    assert.ok(statements.some(({ statement, params }) => statement.includes("UPDATE users SET isActive = ?") && params[0] === 0));
    assert.ok(statements.every(({ statement }) => !statement.includes("DELETE")));
});

test("enabling a user only updates account status", async () => {
    statements.length = 0;
    const result = await disableUserService(2, 1);

    assert.equal(result.errCode, 0);
    assert.ok(statements.some(({ statement, params }) => statement.includes("UPDATE users SET isActive = ?") && params[0] === 1));
});

test("disabled accounts cannot use an existing token", async () => {
    authenticatedUsers = [];
    const response = { status(code) { this.code = code; return this; }, json(body) { this.body = body; } };
    let nextCalled = false;

    await authMiddleware({ headers: { authorization: "Bearer token" } }, response, () => { nextCalled = true; });

    assert.equal(response.code, 403);
    assert.equal(response.body.message, "Account is disabled");
    assert.equal(nextCalled, false);
    authenticatedUsers = [{ id: 2 }];
});

test("re-enabled accounts can use an existing token", async () => {
    const response = { status(code) { this.code = code; return this; }, json(body) { this.body = body; } };
    let nextCalled = false;

    await authMiddleware({ headers: { authorization: "Bearer token" } }, response, () => { nextCalled = true; });

    assert.equal(nextCalled, true);
    assert.equal(response.code, undefined);
    jwt.verify = originalVerify;
});
