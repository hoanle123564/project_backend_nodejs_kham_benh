const jwt = require("jsonwebtoken");
const connection = require("../config/data");

const authMiddleware = async (req, res, next) => {
    const authHeader = req.headers.authorization;
    console.log("HEADER:", req.headers);

    if (!authHeader)
        return res.status(401).json({ message: "Missing token" });

    const token = authHeader.split(" ")[1];
    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const [users] = await connection.promise().query(
            "SELECT id FROM users WHERE id = ? AND isActive = 1 LIMIT 1",
            [decoded.id]
        );
        if (users.length === 0) {
            return res.status(403).json({ message: "Account is disabled" });
        }
        req.user = decoded;
        next();
    } catch (err) {
        console.log("JWT ERROR:", err.message);
        return res.status(403).json({ message: "Invalid or expired token" });
    }
};

module.exports = authMiddleware;
