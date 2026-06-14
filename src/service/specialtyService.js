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

const prepareSpecialtyPayload = async (data, excludeId = null) => {
    const name = String(data?.name || "").trim();
    const descriptionHTML = data?.descriptionHTML || "";
    const descriptionMarkdown = data?.descriptionMarkdown || "";
    const slugSource = String(data?.slug || "").trim() || name;
    const slug = normalizeSlug(slugSource);

    if (!name || !descriptionHTML) {
        return { error: { errCode: 1, errMessage: "Missing required parameters" } };
    }

    if (!slug) {
        return { error: { errCode: 2, errMessage: "Slug is required" } };
    }

    const displayOrderFallback = await getNextDisplayOrder("specialty");
    const displayOrder = parseOptionalDisplayOrder(data?.displayOrder, displayOrderFallback);
    const isActive = parseOptionalIsActive(data?.isActive, 1);

    if (displayOrder === null) {
        return { error: { errCode: 3, errMessage: "Display order must be a valid number" } };
    }

    if (isActive === null) {
        return { error: { errCode: 4, errMessage: "isActive must be 0 or 1" } };
    }

    const uniqueSlug = await buildUniqueSlug("specialty", slug, excludeId);

    return {
        payload: {
            name,
            slug: uniqueSlug,
            image: data?.image,
            descriptionHTML,
            descriptionMarkdown,
            isActive,
            displayOrder,
        },
    };
};

const createSpecialty = async (data) => {
    const status = {};

    try {
        const prepared = await prepareSpecialtyPayload(data);
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
            `INSERT INTO specialty
             (name, slug, image, descriptionHTML, descriptionMarkdown, isActive, displayOrder)
             VALUES (?, ?, ?, ?, ?, ?, ?)`,
            [
                payload.name,
                payload.slug,
                payload.image,
                payload.descriptionHTML,
                payload.descriptionMarkdown,
                payload.isActive,
                payload.displayOrder,
            ]
        );

        status.errCode = 0;
        status.errMessage = "Create specialty successfully";
        return status;
    } catch (error) {
        console.log(" createSpecialty error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const getSpecialty = async (query = {}) => {
    try {
        const publicOnly = query?.publicOnly === "1" || query?.publicOnly === 1 || query?.isPublic === "1";
        const whereClause = publicOnly ? "WHERE isActive = 1" : "";

        const [rows] = await connection.promise().query(
            `SELECT * FROM specialty ${whereClause} ORDER BY displayOrder ASC, id ASC`
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows,
        };
    } catch (error) {
        console.log(" getSpecialty error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: [],
        };
    }
};

const getSpecialtyDetail = async ({ id, slug, location }) => {
    try {
        const specialtySlug = String(slug || "").trim();
        const specialtyId = Number(id);
        const useSlug = Boolean(specialtySlug);

        if (!useSlug && (!Number.isInteger(specialtyId) || specialtyId <= 0)) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {},
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM specialty WHERE ${useSlug ? "slug = ? AND isActive = 1" : "id = ?"} LIMIT 1`,
            [useSlug ? specialtySlug : specialtyId]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: useSlug
                    ? `The specialty with slug ${specialtySlug} does not exist`
                    : `The specialty with id ${specialtyId} does not exist`,
                data: {},
            };
        }

        const specialty = rows[0];
        const doctorParams = [specialty.id];
        const doctorWhere = [`di.specialtyId = ?`];

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

        specialty.doctorSpecialty = doctorRows;

        return {
            errCode: 0,
            errMessage: "OK",
            data: [specialty],
        };
    } catch (error) {
        console.log(" getSpecialtyDetail error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {},
        };
    }
};

const deleteSpecialty = async (specialtyId) => {
    const status = {};
    try {
        if (!specialtyId) {
            status.errCode = 1;
            status.errMessage = "Missing required parameters";
            return status;
        }

        const [doctors] = await connection.promise().query(
            `SELECT id FROM doctor_info WHERE specialtyId = ? LIMIT 1`,
            [specialtyId]
        );

        if (doctors.length > 0) {
            status.errCode = 2;
            status.errMessage = "Cannot delete specialty with existing doctors. Please remove all doctors from this specialty first.";
            return status;
        }

        await connection.promise().query(
            `DELETE FROM specialty WHERE id = ?`,
            [specialtyId]
        );

        status.errCode = 0;
        status.errMessage = "Delete specialty successfully";
        return status;
    }
    catch (error) {
        console.log(" deleteSpecialty error", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const editSpecialty = async (data) => {
    const status = {};
    try {
        const specialtyId = Number(data?.id);
        if (!Number.isInteger(specialtyId) || specialtyId <= 0) {
            status.errCode = 1;
            status.errMessage = "Specialty id is required";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM specialty WHERE id = ?`,
            [specialtyId]
        );

        if (rows.length === 0) {
            status.errCode = 2;
            status.errMessage = `The specialty with id ${specialtyId} does not exist`;
            return status;
        }

        const existingSpecialty = rows[0];
        const prepared = await prepareSpecialtyPayload(
            {
                ...data,
                image: data?.image === undefined ? existingSpecialty.image : data.image,
                isActive: data?.isActive === undefined ? existingSpecialty.isActive : data.isActive,
                displayOrder: data?.displayOrder === undefined ? existingSpecialty.displayOrder : data.displayOrder,
            },
            specialtyId
        );

        if (prepared.error) {
            return prepared.error;
        }

        const { payload } = prepared;

        await connection.promise().query(
            `UPDATE specialty
             SET name = ?, slug = ?, image = ?, descriptionHTML = ?, descriptionMarkdown = ?, isActive = ?, displayOrder = ?
             WHERE id = ?`,
            [
                payload.name,
                payload.slug,
                payload.image,
                payload.descriptionHTML,
                payload.descriptionMarkdown,
                payload.isActive,
                payload.displayOrder,
                specialtyId,
            ]
        );

        status.errCode = 0;
        status.errMessage = "Update specialty successfully";
        return status;
    }
    catch (error) {
        console.log(" editSpecialty error", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

const updateSpecialtyOrder = async (items) => {
    return updateDisplayOrderBatch("specialty", items, "specialty");
};

const changeStatusSpecialty = async (data) => {
    return changeActiveStatus("specialty", data, "specialty");
};

module.exports = {
    createSpecialty,
    getSpecialty,
    getSpecialtyDetail,
    deleteSpecialty,
    editSpecialty,
    updateSpecialtyOrder,
    changeStatusSpecialty,
};
