const connection = require("../config/data");
const {
    normalizeSlug,
    parseOptionalDisplayOrder,
    parseOptionalIsActive,
    getNextDisplayOrder,
    buildUniqueSlug,
    updateDisplayOrderBatch,
    changeActiveStatus,
} = require("./contentMetaService");

const normalizeOptionalString = (value) => {
    if (value === undefined || value === null) {
        return null;
    }

    const normalized = String(value).trim();
    return normalized || null;
};

const validateClinicTypeId = (clinicTypeId) => {
    if (!clinicTypeId) {
        return null;
    }

    if (!["CT1", "CT2"].includes(clinicTypeId)) {
        return { errCode: 5, errMessage: "clinicTypeId must be CT1 or CT2" };
    }

    return null;
};

const normalizeManagerUserId = async (managerUserId) => {
    if (managerUserId === undefined || managerUserId === null || String(managerUserId).trim() === "") {
        return { value: null };
    }

    const normalizedManagerId = Number(managerUserId);
    if (!Number.isInteger(normalizedManagerId) || normalizedManagerId <= 0) {
        return { error: { errCode: 6, errMessage: "managerUserId must be a valid user id" } };
    }

    const [rows] = await connection.promise().query(
        `SELECT id, roleId FROM users WHERE id = ? LIMIT 1`,
        [normalizedManagerId]
    );

    if (rows.length === 0 || !["R4", "R2"].includes(rows[0].roleId)) {
        return { error: { errCode: 7, errMessage: "managerUserId must belong to a clinic manager or doctor" } };
    }

    return { value: normalizedManagerId };
};

const prepareClinicPayload = async (data, excludeId = null) => {
    const name = String(data?.name || "").trim();
    const address = String(data?.address || "").trim();
    const descriptionHTML = data?.descriptionHTML || "";
    const descriptionMarkdown = data?.descriptionMarkdown || "";
    const slugSource = String(data?.slug || "").trim() || name;
    const slug = normalizeSlug(slugSource);
    const clinicTypeId = normalizeOptionalString(data?.clinicTypeId);
    const provinceCode = normalizeOptionalString(data?.provinceCode);
    const districtCode = normalizeOptionalString(data?.districtCode);
    const wardCode = normalizeOptionalString(data?.wardCode);

    if (!name || !address || !descriptionHTML) {
        return { error: { errCode: 1, errMessage: "Missing required parameters" } };
    }

    if (!slug) {
        return { error: { errCode: 2, errMessage: "Slug is required" } };
    }

    const displayOrderFallback = await getNextDisplayOrder("clinic");
    const displayOrder = parseOptionalDisplayOrder(data?.displayOrder, displayOrderFallback);
    const isActive = parseOptionalIsActive(data?.isActive, 1);

    if (displayOrder === null) {
        return { error: { errCode: 3, errMessage: "Display order must be a valid number" } };
    }

    if (isActive === null) {
        return { error: { errCode: 4, errMessage: "isActive must be 0 or 1" } };
    }

    const clinicTypeError = validateClinicTypeId(clinicTypeId);
    if (clinicTypeError) {
        return { error: clinicTypeError };
    }

    const managerResult = await normalizeManagerUserId(data?.managerUserId);
    if (managerResult.error) {
        return { error: managerResult.error };
    }

    const uniqueSlug = await buildUniqueSlug("clinic", slug, excludeId);

    return {
        payload: {
            name,
            slug: uniqueSlug,
            address,
            image: data?.image,
            clinicTypeId,
            managerUserId: managerResult.value,
            provinceCode,
            districtCode,
            wardCode,
            descriptionHTML,
            descriptionMarkdown,
            isActive,
            displayOrder,
        },
    };
};

const createClinic = async (clinicData) => {
    const status = {};

    try {
        const prepared = await prepareClinicPayload(clinicData);
        if (prepared.error) {
            return prepared.error;
        }

        const { payload } = prepared;
        if (!payload.image) {
            status.errCode = 1;
            status.errMessage = "Missing required parameters";
            return status;
        }

        await connection.promise().query(
            `INSERT INTO clinic
             (name, slug, image, address, clinicTypeId, managerUserId, provinceCode, districtCode, wardCode,
              descriptionHTML, descriptionMarkdown, isActive, displayOrder)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                payload.name,
                payload.slug,
                payload.image,
                payload.address,
                payload.clinicTypeId,
                payload.managerUserId,
                payload.provinceCode,
                payload.districtCode,
                payload.wardCode,
                payload.descriptionHTML,
                payload.descriptionMarkdown,
                payload.isActive,
                payload.displayOrder,
            ]
        );

        status.errCode = 0;
        status.errMessage = "Create clinic successfully";
        return status;
    } catch (error) {
        console.log(" createClinic error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const getClinic = async (query = {}) => {
    try {
        const publicOnly = query?.publicOnly === "1" || query?.publicOnly === 1 || query?.isPublic === "1";
        const whereClause = publicOnly ? "WHERE isActive = 1" : "";

        const [rows] = await connection.promise().query(
            `SELECT * FROM clinic ${whereClause} ORDER BY displayOrder ASC, id ASC`
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows,
        };

    } catch (error) {
        console.log(" getClinic error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: [],
        };
    }
};

const getClinicDetail = async ({ id, slug, location }) => {
    try {
        const clinicSlug = String(slug || "").trim();
        const clinicId = Number(id);
        const useSlug = Boolean(clinicSlug);

        if (!useSlug && (!Number.isInteger(clinicId) || clinicId <= 0)) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {},
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM clinic WHERE ${useSlug ? "slug = ? AND isActive = 1" : "id = ?"} LIMIT 1`,
            [useSlug ? clinicSlug : clinicId]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: useSlug
                    ? `The clinic with slug ${clinicSlug} does not exist`
                    : `The clinic with id ${clinicId} does not exist`,
                data: {},
            };
        }

        const clinic = rows[0];
        const doctorParams = [clinic.id];
        const doctorWhere = [`di.clinicId = ?`];

        if (useSlug) {
            doctorWhere.push(`di.isActive = 1`);
        }

        if (location && location !== "ALL") {
            doctorWhere.push(`(c.provinceCode = ? OR lp.value_vi = ? OR lp.value_en = ?)`);
            doctorParams.push(location, location, location);
        }

        const [doctorRows] = await connection.promise().query(
            `SELECT
                di.id, di.doctorId, di.slug, di.isActive, di.displayOrder,
                di.clinicId, c.clinicTypeId, c.address AS clinicAddress,
                c.provinceCode, c.districtCode, c.wardCode,
                COALESCE(lp.value_vi, c.provinceCode) AS province
             FROM doctor_info di
             LEFT JOIN clinic c
               ON c.id = di.clinicId
             LEFT JOIN lookup lp
               ON lp.keyMap = c.provinceCode AND lp.type = 'PROVINCE'
             WHERE ${doctorWhere.join(" AND ")}
             ORDER BY di.displayOrder ASC, di.id ASC`,
            doctorParams
        );

        clinic.doctorClinic = doctorRows;

        return {
            errCode: 0,
            errMessage: "OK",
            data: [clinic],
        };

    } catch (error) {
        console.log(" getClinicDetail error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {},
        };
    }
};

const deleteClinic = async (clinicId) => {
    const status = {};
    try {
        if (!clinicId) {
            status.errCode = 1;
            status.errMessage = "Missing required parameters";
            return status;
        }

        const [row] = await connection.promise().query(
            `SELECT * FROM clinic WHERE id = ?`,
            [clinicId]
        );

        if (row.length === 0) {
            status.errCode = 2;
            status.errMessage = `The clinic with id ${clinicId} does not exist`;
            return status;
        }

        const [doctors] = await connection.promise().query(
            `SELECT id FROM doctor_info WHERE clinicId = ? LIMIT 1`,
            [clinicId]
        );

        if (doctors.length > 0) {
            status.errCode = 3;
            status.errMessage = "Cannot delete clinic with existing doctors. Please remove all doctors from this clinic first.";
            return status;
        }

        await connection.promise().query(
            `DELETE FROM clinic WHERE id = ?`,
            [clinicId]
        );

        status.errCode = 0;
        status.errMessage = "Delete clinic successfully";
        return status;
    } catch (error) {
        console.log(" deleteClinic error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const editClinic = async (data) => {
    const status = {};
    try {
        const clinicId = Number(data?.id);
        if (!Number.isInteger(clinicId) || clinicId <= 0) {
            status.errCode = 1;
            status.errMessage = "Clinic id is required";
            return status;
        }

        const [row] = await connection.promise().query(
            `SELECT * FROM clinic WHERE id = ?`,
            [clinicId]
        );

        if (row.length === 0) {
            status.errCode = 2;
            status.errMessage = `The clinic with id ${clinicId} does not exist`;
            return status;
        }

        const existingClinic = row[0];
        const prepared = await prepareClinicPayload(
            {
                ...data,
                image: data?.image === undefined ? existingClinic.image : data.image,
                clinicTypeId: data?.clinicTypeId === undefined ? existingClinic.clinicTypeId : data.clinicTypeId,
                managerUserId: data?.managerUserId === undefined ? existingClinic.managerUserId : data.managerUserId,
                provinceCode: data?.provinceCode === undefined ? existingClinic.provinceCode : data.provinceCode,
                districtCode: data?.districtCode === undefined ? existingClinic.districtCode : data.districtCode,
                wardCode: data?.wardCode === undefined ? existingClinic.wardCode : data.wardCode,
                isActive: data?.isActive === undefined ? existingClinic.isActive : data.isActive,
                displayOrder: data?.displayOrder === undefined ? existingClinic.displayOrder : data.displayOrder,
            },
            clinicId
        );

        if (prepared.error) {
            return prepared.error;
        }

        const { payload } = prepared;

        await connection.promise().query(
            `UPDATE clinic
             SET name = ?, slug = ?, address = ?, clinicTypeId = ?, managerUserId = ?, provinceCode = ?,
                 districtCode = ?, wardCode = ?, descriptionHTML = ?,
                 descriptionMarkdown = ?, image = ?, isActive = ?, displayOrder = ?
             WHERE id = ?`,
            [
                payload.name,
                payload.slug,
                payload.address,
                payload.clinicTypeId,
                payload.managerUserId,
                payload.provinceCode,
                payload.districtCode,
                payload.wardCode,
                payload.descriptionHTML,
                payload.descriptionMarkdown,
                payload.image,
                payload.isActive,
                payload.displayOrder,
                clinicId,
            ]
        );

        status.errCode = 0;
        status.errMessage = "Update clinic successfully";
        return status;
    } catch (error) {
        console.log(" editClinic error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const updateClinicOrder = async (items) => {
    return updateDisplayOrderBatch("clinic", items, "clinic");
};

const changeStatusClinic = async (data) => {
    return changeActiveStatus("clinic", data, "clinic");
};

module.exports = {
    createClinic,
    getClinic,
    getClinicDetail,
    deleteClinic,
    editClinic,
    updateClinicOrder,
    changeStatusClinic,
};
