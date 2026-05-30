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

module.exports = {
    createPostCategory,
    getPostCategory,
    getPostCategoryDetailById,
    editPostCategory,
    deletePostCategory
};
