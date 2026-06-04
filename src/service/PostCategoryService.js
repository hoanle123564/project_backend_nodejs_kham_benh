const connection = require("../config/data");

// Chuẩn hóa chuỗi đầu vào thành slug tiếng Việt không dấu.
const normalizeSlug = (value) => {
    return String(value || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[đĐ]/g, "d")
        .toLowerCase()
        .replace(/[^a-z0-9\s-]/g, " ")
        .trim()
        .replace(/\s+/g, "-")
        .replace(/-+/g, "-")
        .replace(/^-+|-+$/g, "");
};

// Ép displayOrder về số hợp lệ, sai kiểu thì trả null.
const parseDisplayOrder = (value) => {
    const parsedValue = Number(value);
    if (!Number.isFinite(parsedValue)) {
        return null;
    }
    return parsedValue;
};

// Chuẩn hóa isActive về 0 hoặc 1.
const parseIsActive = (value) => {
    if (value === 0 || value === 1) {
        return value;
    }
    if (value === "0" || value === "1") {
        return Number(value);
    }
    return null;
};

// Kiểm tra mảng items cập nhật thứ tự có đúng định dạng id/displayOrder hay không.
const validateOrderItems = (items) => {
    if (!Array.isArray(items) || items.length === 0) {
        return "Items must be a non-empty array";
    }

    for (const item of items) {
        const itemId = Number(item?.id);
        const itemDisplayOrder = parseDisplayOrder(item?.displayOrder);

        if (!Number.isInteger(itemId) || itemId <= 0) {
            return "Each item must have a valid id";
        }

        if (itemDisplayOrder === null) {
            return "Each item must have a valid displayOrder";
        }
    }

    return null;
};

// Sinh slug duy nhất trong bảng post_category, có thể bỏ qua id đang sửa.
const buildUniqueSlug = async (baseSlug, excludeId = null) => {
    let nextSlug = baseSlug;
    let suffix = 1;

    while (true) {
        let query = `SELECT id FROM post_category WHERE slug = ?`;
        let params = [nextSlug];

        if (excludeId) {
            query += ` AND id != ?`;
            params.push(excludeId);
        }

        const [rows] = await connection.promise().query(query, params);
        if (rows.length === 0) {
            return nextSlug;
        }

        nextSlug = `${baseSlug}-${suffix}`;
        suffix += 1;
    }
};

// Tạo mới danh mục bài viết sau khi validate và xử lý slug unique.
const createPostCategory = async (data) => {
    const status = {};
    try {
        const name = String(data?.name || "").trim();
        const slugSource = String(data?.slug || "").trim() || name;
        const slug = normalizeSlug(slugSource);
        const displayOrder = parseDisplayOrder(data?.displayOrder);
        const isActive = parseIsActive(data?.isActive);

        if (!name) {
            status.errCode = 1;
            status.errMessage = "Category name is required";
            return status;
        }

        if (!slug) {
            status.errCode = 2;
            status.errMessage = "Slug is required";
            return status;
        }

        if (displayOrder === null) {
            status.errCode = 3;
            status.errMessage = "Display order must be a valid number";
            return status;
        }

        if (isActive === null) {
            status.errCode = 4;
            status.errMessage = "isActive must be 0 or 1";
            return status;
        }

        const uniqueSlug = await buildUniqueSlug(slug);

        await connection.promise().query(
            `INSERT INTO post_category (name, slug, displayOrder, isActive)
             VALUES (?, ?, ?, ?)`,
            [name, uniqueSlug, displayOrder, isActive]
        );

        status.errCode = 0;
        status.errMessage = "Create post category successfully";
        return status;
    } catch (error) {
        console.log("createPostCategory error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

// Lấy toàn bộ danh mục bài viết theo thứ tự hiển thị.
const getPostCategory = async () => {
    try {
        const [rows] = await connection.promise().query(
            `SELECT * FROM post_category ORDER BY displayOrder ASC, id ASC`
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows
        };
    } catch (error) {
        console.log("getPostCategory error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: []
        };
    }
};

// Lấy danh sách danh mục public đang bật hiển thị theo đúng thứ tự public.
const getActivePostCategoriesPublic = async () => {
    try {
        const [rows] = await connection.promise().query(
            `SELECT * FROM post_category WHERE isActive = 1 ORDER BY displayOrder ASC, id ASC`
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows
        };
    } catch (error) {
        console.log("getActivePostCategoriesPublic error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: []
        };
    }
};

// Lấy chi tiết một danh mục bài viết theo id.
const getPostCategoryDetailById = async (categoryId) => {
    try {
        if (!categoryId) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {}
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM post_category WHERE id = ?`,
            [categoryId]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: `The post category with id ${categoryId} does not exist`,
                data: {}
            };
        }

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows[0]
        };
    } catch (error) {
        console.log("getPostCategoryDetailById error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {}
        };
    }
};

// Lấy chi tiết danh mục public theo slug.
const getPublicPostCategoryDetailBySlug = async (categorySlug) => {
    try {
        const normalizedSlug = String(categorySlug || "").trim();
        if (!normalizedSlug) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {}
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM post_category WHERE slug = ? AND isActive = 1 LIMIT 1`,
            [normalizedSlug]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: `The post category with slug ${normalizedSlug} does not exist`,
                data: {}
            };
        }

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows[0]
        };
    } catch (error) {
        console.log("getPublicPostCategoryDetailBySlug error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {}
        };
    }
};

// Cập nhật danh mục bài viết và chuẩn hóa lại slug trước khi lưu.
const editPostCategory = async (data) => {
    const status = {};
    try {
        const categoryId = data?.id;
        const name = String(data?.name || "").trim();
        const slugSource = String(data?.slug || "").trim() || name;
        const slug = normalizeSlug(slugSource);
        const displayOrder = parseDisplayOrder(data?.displayOrder);
        const isActive = parseIsActive(data?.isActive);

        if (!categoryId) {
            status.errCode = 1;
            status.errMessage = "Category id is required";
            return status;
        }

        if (!name) {
            status.errCode = 2;
            status.errMessage = "Category name is required";
            return status;
        }

        if (!slug) {
            status.errCode = 3;
            status.errMessage = "Slug is required";
            return status;
        }

        if (displayOrder === null) {
            status.errCode = 4;
            status.errMessage = "Display order must be a valid number";
            return status;
        }

        if (isActive === null) {
            status.errCode = 5;
            status.errMessage = "isActive must be 0 or 1";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT id FROM post_category WHERE id = ?`,
            [categoryId]
        );

        if (rows.length === 0) {
            status.errCode = 6;
            status.errMessage = `The post category with id ${categoryId} does not exist`;
            return status;
        }

        const uniqueSlug = await buildUniqueSlug(slug, categoryId);

        await connection.promise().query(
            `UPDATE post_category
             SET name = ?, slug = ?, displayOrder = ?, isActive = ?
             WHERE id = ?`,
            [name, uniqueSlug, displayOrder, isActive, categoryId]
        );

        status.errCode = 0;
        status.errMessage = "Update post category successfully";
        return status;
    } catch (error) {
        console.log("editPostCategory error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

// Xóa cứng danh mục bài viết sau khi kiểm tra bản ghi tồn tại.
const deletePostCategory = async (categoryId) => {
    const status = {};
    try {
        if (!categoryId) {
            status.errCode = 1;
            status.errMessage = "Category id is required";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT id FROM post_category WHERE id = ?`,
            [categoryId]
        );

        if (rows.length === 0) {
            status.errCode = 2;
            status.errMessage = `The post category with id ${categoryId} does not exist`;
            return status;
        }

        await connection.promise().query(
            `DELETE FROM post_category WHERE id = ?`,
            [categoryId]
        );

        status.errCode = 0;
        status.errMessage = "Delete post category successfully";
        return status;
    } catch (error) {
        console.log("deletePostCategory error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

// Cập nhật hàng loạt thứ tự hiển thị của danh mục bài viết bằng transaction.
const updatePostCategoryOrder = async (items) => {
    let db;

    try {
        const validationMessage = validateOrderItems(items);
        if (validationMessage) {
            return {
                errCode: 1,
                errMessage: validationMessage,
            };
        }

        db = await connection.promise().getConnection();
        await db.beginTransaction();

        for (const item of items) {
            const categoryId = Number(item.id);
            const displayOrder = Number(item.displayOrder);

            const [rows] = await db.query(
                `SELECT id FROM post_category WHERE id = ?`,
                [categoryId]
            );

            if (rows.length === 0) {
                await db.rollback();
                return {
                    errCode: 1,
                    errMessage: `The post category with id ${categoryId} does not exist`,
                };
            }

            await db.query(
                `UPDATE post_category SET displayOrder = ? WHERE id = ?`,
                [displayOrder, categoryId]
            );
        }

        await db.commit();
        return {
            errCode: 0,
            errMessage: "OK",
        };
    } catch (error) {
        if (db) {
            await db.rollback();
        }
        console.log("updatePostCategoryOrder error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
        };
    } finally {
        if (db) {
            db.release();
        }
    }
};

// Chỉ cập nhật trạng thái hiển thị của danh mục để tránh ảnh hưởng slug hoặc displayOrder.
const changeStatusPostCategory = async (data) => {
    const status = {};
    try {
        const categoryId = Number(data?.id);
        const isActive = parseIsActive(data?.isActive);

        if (!Number.isInteger(categoryId) || categoryId <= 0) {
            status.errCode = 1;
            status.errMessage = "Category id is required";
            return status;
        }

        if (isActive === null) {
            status.errCode = 1;
            status.errMessage = "isActive must be 0 or 1";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT id FROM post_category WHERE id = ?`,
            [categoryId]
        );

        if (rows.length === 0) {
            status.errCode = 1;
            status.errMessage = `The post category with id ${categoryId} does not exist`;
            return status;
        }

        await connection.promise().query(
            `UPDATE post_category SET isActive = ? WHERE id = ?`,
            [isActive, categoryId]
        );

        status.errCode = 0;
        status.errMessage = "OK";
        return status;
    } catch (error) {
        console.log("changeStatusPostCategory error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

module.exports = {
    createPostCategory,
    getPostCategory,
    getActivePostCategoriesPublic,
    getPostCategoryDetailById,
    getPublicPostCategoryDetailBySlug,
    editPostCategory,
    deletePostCategory,
    updatePostCategoryOrder,
    changeStatusPostCategory
};
