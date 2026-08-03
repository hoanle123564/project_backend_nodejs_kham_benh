const connection = require("../config/data");
const bcrypt = require("bcrypt");
const { createToken } = require("../jwtService");
const { withTransaction } = require("./transactionService");
const { ensurePatientProfileRow } = require("./patientProfileService");

const PATIENT_ROLE_ID = "R3";

const ensurePatientProfileForRole = async (userId, roleId, db) => {
    if (roleId === PATIENT_ROLE_ID) {
        await ensurePatientProfileRow(userId, db);
    }
};


// LOGIN SERVICE
const handleUserLoginService = async (data) => {
    try {
        const { email, password } = data;

        if (!email || !password) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                user: null,
                token: null,
                data: {}
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM users WHERE email = ?`,
            [email]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: "Email does not exist",
                user: null,
                token: null,
                data: {}
            };
        }

        const user = rows[0];
        if (Number(user.isActive) !== 1) {
            return {
                errCode: 4,
                errMessage: "Account is disabled",
                user: null,
                token: null,
                data: {}
            };
        }

        const checkPass = await bcrypt.compare(password, user.password || "");
        if (!checkPass) {
            return {
                errCode: 3,
                errMessage: "Wrong password",
                user: null,
                token: null,
                data: {}
            };
        }

        const { password: pw, ...cleanUser } = user;

        const token = createToken({
            id: user.id,
            email: user.email,
            roleId: user.roleId
        });

        return {
            errCode: 0,
            errMessage: "Login success",

            // format mới
            user: cleanUser,
            token: token,

            // format cũ
            data: {
                user: cleanUser,
                token: token
            }
        };

    } catch (error) {
        console.log("handleUserLoginService error:", error);
        return {
            errCode: -1,
            errMessage: "Server error",
            user: null,
            token: null,
            data: {}
        };
    }
};



// GET ALL USERS
const getAllUsersService = async (id) => {
    try {
        if (!id) {
            return { errCode: 1, errMessage: "Missing required parameter", data: [] };
        }

        if (id === "ALL") {
            const [rows] = await connection.promise().query(`SELECT * FROM users`);
            // loại bỏ mật khẩu
            // duyệt qua các phần tử rồi sẽ loại bỏ trường mật khẩu ra và tạo ra biến mới tên rest
            const users = rows.map(({ password, ...rest }) => rest);

            return {
                errCode: 0,
                errMessage: "OK",
                users: users
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM users WHERE id = ?`,
            [id]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: "User not found",
                users: []
            };
        }

        const users = rows.map(({ password, ...rest }) => rest);

        return {
            errCode: 0,
            errMessage: "OK",
            users: users
        };

    } catch (error) {
        console.log("getAllUsersService error:", error);
        return {
            errCode: -1,
            errMessage: "Error from server",
            users: []
        };
    }
};



// CREATE USER
const createNewUserService = async (data) => {
    try {
        const {
            email,
            password,
            firstName,
            lastName,
            address,
            provinceCode,
            districtCode,
            wardCode,
            gender,
            roleId,
            phoneNumber,
            positionId,
            image
        } = data;

        if (!email || !password || !firstName || !lastName) {
            return { errCode: 1, errMessage: "Missing required parameters" };
        }

        const [check] = await connection.promise().query(
            `SELECT id, email, password FROM users WHERE email = ?`,
            [email]
        );

        // Nếu email đã tồn tại
        if (check.length > 0) {
            const existingUser = check[0];

            // Kiểm tra nếu là khách vãng lai (không có mật khẩu hoặc mật khẩu null)
            if (!existingUser.password || existingUser.password === null || existingUser.password === '') {
                // Cập nhật thông tin cho khách vãng lai
                const hashedPass = await bcrypt.hash(password, 10);

                await withTransaction(async (db) => {
                    await db.query(
                        `UPDATE users
                         SET password = ?, firstName = ?, lastName = ?, address = ?,
                             provinceCode = ?, districtCode = ?, wardCode = ?,
                             gender = ?, roleId = ?, phoneNumber = ?, positionId = ?, image = ?
                         WHERE id = ?`,
                        [
                            hashedPass, firstName, lastName,
                            address || null,
                            provinceCode || null,
                            districtCode || null,
                            wardCode || null,
                            gender || null,
                            roleId || null, phoneNumber || null,
                            positionId || null, image || null,
                            existingUser.id
                        ]
                    );

                    await ensurePatientProfileForRole(existingUser.id, roleId, db);
                });

                return {
                    errCode: 0,
                    errMessage: "Guest account upgraded to full user successfully",
                    userId: existingUser.id
                };
            }

            // Nếu email đã có tài khoản đầy đủ
            return { errCode: 2, errMessage: "Email already exists" };
        }

        // Tạo mới user nếu email chưa tồn tại
        const hashedPass = await bcrypt.hash(password, 10);

        const userId = await withTransaction(async (db) => {
            const [result] = await db.query(
                `INSERT INTO users(email, password, firstName, lastName, address, provinceCode, districtCode, wardCode, gender, roleId, phoneNumber, positionId, image)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    email, hashedPass, firstName, lastName,
                    address || null,
                    provinceCode || null,
                    districtCode || null,
                    wardCode || null,
                    gender || null,
                    roleId || null, phoneNumber || null,
                    positionId || null, image || null
                ]
            );

            await ensurePatientProfileForRole(result.insertId, roleId, db);

            return result.insertId;
        });

        return {
            errCode: 0,
            errMessage: "User created successfully",
            userId
        };

    } catch (error) {
        console.log("createNewUserService error:", error);
        return { errCode: -1, errMessage: "Error from server" };
    }
};

// CHANGE PASSWORD
const changePasswordService = async (userId, data) => {
    try {
        const { currentPassword, newPassword, confirmPassword } = data || {};

        if (!userId || !currentPassword || !newPassword || !confirmPassword) {
            return { errCode: 1, errMessage: "Missing required parameter" };
        }

        if (newPassword !== confirmPassword) {
            return { errCode: 3, errMessage: "New password and confirm password do not match" };
        }

        if (newPassword === currentPassword) {
            return { errCode: 4, errMessage: "New password must be different from current password" };
        }

        if (newPassword.length < 6) {
            return { errCode: 6, errMessage: "New password must be at least 6 characters" };
        }

        const [rows] = await connection.promise().query(
            `SELECT id, password FROM users WHERE id = ?`,
            [userId]
        );

        if (rows.length === 0) {
            return { errCode: 5, errMessage: "User not found" };
        }

        const user = rows[0];

        if (!user.password) {
            return { errCode: 5, errMessage: "This account does not support password change" };
        }

        const isCurrentPasswordCorrect = await bcrypt.compare(currentPassword, user.password);
        if (!isCurrentPasswordCorrect) {
            return { errCode: 2, errMessage: "Current password is incorrect" };
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);

        await connection.promise().query(
            `UPDATE users SET password = ? WHERE id = ?`,
            [hashedPassword, userId]
        );

        return { errCode: 0, errMessage: "Change password successfully" };
    } catch (error) {
        console.log("changePasswordService error:", error);
        return { errCode: -1, errMessage: "Error from server" };
    }
};


// DISABLE USER
const disableUserService = async (id, isActive) => {
    try {
        const userId = Number(id);
        if (!Number.isInteger(userId) || userId <= 0) {
            return { errCode: 1, errMessage: "Missing required parameter" };
        }
        const nextIsActive = Number(isActive);
        if (![0, 1].includes(nextIsActive)) {
            return { errCode: 3, errMessage: "isActive must be 0 or 1" };
        }

        const [check] = await connection.promise().query(
            `SELECT id FROM users WHERE id = ?`,
            [userId]
        );

        if (check.length === 0) {
            return { errCode: 2, errMessage: "User does not exist" };
        }

        await connection.promise().query(
            `UPDATE users SET isActive = ? WHERE id = ?`,
            [nextIsActive, userId]
        );

        return {
            errCode: 0,
            errMessage: nextIsActive === 1
                ? "User account enabled successfully"
                : "User account disabled successfully"
        };

    } catch (error) {
        console.log("disableUserService error:", error);
        return { errCode: -1, errMessage: "Error from server" };
    }
};

// UPDATE USER
const updateUserService = async (data, { selfUserId } = {}) => {
    try {
        const {
            id: requestedId,
            firstName,
            lastName,
            email: requestedEmail,
            address,
            provinceCode,
            districtCode,
            wardCode,
            gender,
            roleId: requestedRoleId,
            phoneNumber,
            positionId,
            image
        } = data;
        const normalizedSelfUserId = Number(selfUserId);
        const id = Number.isInteger(normalizedSelfUserId) && normalizedSelfUserId > 0
            ? normalizedSelfUserId
            : requestedId;
        if (image) { console.log('image in service:'); }

        if (!id) {
            return { errCode: 1, errMessage: "Missing required parameter" };
        }

        const [check] = await connection.promise().query(
            `SELECT * FROM users WHERE id = ?`,
            [id]
        );

        if (check.length === 0) {
            return { errCode: 2, errMessage: "User not found" };
        }

        const currentUser = check[0];
        const email = selfUserId ? currentUser.email : requestedEmail;
        const roleId = selfUserId ? currentUser.roleId : requestedRoleId;

        await connection.promise().query(
            `UPDATE users
             SET firstName=?, lastName=?, email=?, address=?, provinceCode=?, districtCode=?, wardCode=?,
                 gender=?, roleId=?, phoneNumber=?, positionId=?, image=?
             WHERE id=?`,
            [
                firstName || null, lastName || null, email || null,
                address || null,
                provinceCode || null,
                districtCode || null,
                wardCode || null,
                gender || null, roleId || null,
                phoneNumber || null, positionId || null, image || null,
                id
            ]
        );
        let [edit] = await connection.promise().query(
            `SELECT * FROM users WHERE id = ?`,
            [id]
        );
        edit = edit.map(({ password, ...rest }) => rest)[0];

        return { errCode: 0, errMessage: "Update successful", data: edit || [] };

    } catch (error) {
        console.log("updateUserService error:", error);
        return { errCode: -1, errMessage: "Error from server" };
    }
};


// GET ALL LOOKUP
const getLookUpService = async (type, parentKeyMap) => {
    try {
        if (!type) {
            return { errCode: 1, errMessage: "Missing required parameter", data: [] };
        }

        const params = [type];
        const whereConditions = [`type = ?`];

        if (parentKeyMap !== undefined && parentKeyMap !== null && String(parentKeyMap).trim() !== "") {
            whereConditions.push(`parentKeyMap = ?`);
            params.push(String(parentKeyMap).trim());
        }

        const [rows] = await connection.promise().query(
            `
            SELECT *
            FROM lookup
            WHERE ${whereConditions.join(" AND ")}
            ORDER BY
                CASE WHEN type = 'TIME' THEN STR_TO_DATE(SUBSTRING_INDEX(value_vi, ' - ', 1), '%H:%i') END ASC,
                value_vi ASC,
                id ASC
            `,
            params
        );

        return { errCode: 0, errMessage: "OK", data: rows };

    } catch (error) {
        console.log("getLookUpService error:", error);
        return { errCode: -1, errMessage: "Error from server", data: [] };
    }
};


module.exports = {
    handleUserLoginService,
    getAllUsersService,
    createNewUserService,
    changePasswordService,
    disableUserService,
    updateUserService,
    getLookUpService
};
