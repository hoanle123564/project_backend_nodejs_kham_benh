const jwt = require('jsonwebtoken');
require('dotenv').config();

// KEY bí mật
const SECRET_KEY = process.env.JWT_SECRET || "my_super_secret_key";

const createToken = (data) => {
    return jwt.sign(data, SECRET_KEY, {
        expiresIn: "4h"  // token hết hạn sau 4 giờ
    });
};

const verifyToken = (token) => {
    return jwt.verify(token, SECRET_KEY);
};

module.exports = {
    createToken,
    verifyToken
};
