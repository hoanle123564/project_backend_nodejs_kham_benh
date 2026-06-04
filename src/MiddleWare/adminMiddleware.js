const adminMiddleware = (req, res, next) => {
    if (!req.user || req.user.roleId !== "R1") {
        return res.status(403).json({
            errCode: 403,
            errMessage: "Admin permission required",
        });
    }

    next();
};

module.exports = adminMiddleware;
