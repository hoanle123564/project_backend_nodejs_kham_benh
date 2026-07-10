const connection = require("../config/data");
const { resolveHtmlOnlyRichText } = require("./contentMetaService");

const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 10;

// Chuẩn hóa tiêu đề hoặc slug nhập tay thành slug tiếng Việt không dấu.
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

// Ép tham số phân trang về số nguyên dương, nếu sai thì dùng fallback.
const parsePositiveInt = (value, fallback) => {
    const parsedValue = Number(value);
    if (!Number.isInteger(parsedValue) || parsedValue <= 0) {
        return fallback;
    }
    return parsedValue;
};

// Kiểm tra categoryIds đầu vào, loại id trùng và loại giá trị không hợp lệ.
const parseCategoryIds = (value) => {
    if (!Array.isArray(value)) {
        return null;
    }

    const normalizedIds = value
        .map((item) => Number(item))
        .filter((item) => Number.isInteger(item) && item > 0);

    const uniqueIds = [...new Set(normalizedIds)];
    return uniqueIds.length > 0 ? uniqueIds : null;
};

// Xác nhận toàn bộ categoryIds gửi lên đều tồn tại trong bảng danh mục.
const ensureCategoryIdsExist = async (categoryIds, executor = connection.promise()) => {
    const placeholders = categoryIds.map(() => "?").join(", ");
    const [rows] = await executor.query(
        `SELECT id FROM post_category WHERE id IN (${placeholders})`,
        categoryIds
    );

    return rows.length === categoryIds.length;
};

// Sinh slug duy nhất trong bảng post, có thể bỏ qua chính bài viết đang sửa.
const buildUniqueSlug = async (baseSlug, excludeId = null, executor = connection.promise()) => {
    let nextSlug = baseSlug;
    let suffix = 1;

    while (true) {
        let query = `SELECT id FROM post WHERE slug = ?`;
        const params = [nextSlug];

        if (excludeId) {
            query += ` AND id != ?`;
            params.push(excludeId);
        }

        const [rows] = await executor.query(query, params);
        if (rows.length === 0) {
            return nextSlug;
        }

        nextSlug = `${baseSlug}-${suffix}`;
        suffix += 1;
    }
};

// Gom validate và chuẩn hóa payload bài viết trước khi insert hoặc update.
const buildPostPayload = async (data, executor = connection.promise(), excludeId = null) => {
    const title = String(data?.title || "").trim();
    const slugSource = String(data?.slug || "").trim() || title;
    const slug = normalizeSlug(slugSource);
    const displayOrder = parseDisplayOrder(data?.displayOrder);
    const isActive = parseIsActive(data?.isActive);
    const categoryIds = parseCategoryIds(data?.categoryIds);

    if (!title) {
        return { error: { errCode: 1, errMessage: "Post title is required" } };
    }

    if (!slug) {
        return { error: { errCode: 2, errMessage: "Slug is required" } };
    }

    if (displayOrder === null) {
        return { error: { errCode: 3, errMessage: "Display order must be a valid number" } };
    }

    if (isActive === null) {
        return { error: { errCode: 4, errMessage: "isActive must be 0 or 1" } };
    }

    if (!categoryIds) {
        return { error: { errCode: 5, errMessage: "Post category ids must be a valid non-empty array" } };
    }

    const categoriesExist = await ensureCategoryIdsExist(categoryIds, executor);
    if (!categoriesExist) {
        return { error: { errCode: 6, errMessage: "One or more post categories do not exist" } };
    }

    const uniqueSlug = await buildUniqueSlug(slug, excludeId, executor);

    return {
        payload: {
            title,
            slug: uniqueSlug,
            image: data?.image || null,
            bannerImage: data?.bannerImage || null,
            isActive,
            displayOrder,
            shortDescription: data?.shortDescription || "",
            contentHTML: resolveHtmlOnlyRichText(data, "contentHTML"),
            categoryIds
        }
    };
};

const buildCategoryMetaSelect = (postAlias = "p") => `
    COALESCE((
        SELECT GROUP_CONCAT(
            CONCAT_WS('::', pc.id, pc.name, pc.slug)
            ORDER BY pc.displayOrder ASC, pc.id ASC
            SEPARATOR '|||'
        )
        FROM post_category_detail pcd
        INNER JOIN post_category pc ON pc.id = pcd.postCategoryId
        WHERE pcd.postId = ${postAlias}.id
          AND pc.isActive = 1
    ), '') AS categoryMeta
`;

const parseCategoryMeta = (value) => {
    if (!value) {
        return [];
    }

    return String(value)
        .split("|||")
        .map((item) => item.trim())
        .filter(Boolean)
        .map((item) => {
            const [id, name, slug] = item.split("::");
            return {
                id: Number(id),
                name: name || "",
                slug: slug || "",
            };
        })
        .filter((item) => Number.isInteger(item.id) && item.id > 0 && item.slug);
};

const formatPublicPost = (item) => {
    const categories = parseCategoryMeta(item?.categoryMeta);
    const { categoryMeta, ...postData } = item || {};

    return {
        ...postData,
        categories,
    };
};

// Thêm các liên kết giữa bài viết và danh mục vào bảng post_category_detail.
const insertPostCategories = async (postId, categoryIds, db) => {
    if (!categoryIds || categoryIds.length === 0) {
        return;
    }

    const values = categoryIds.map((categoryId) => [postId, categoryId]);
    await db.query(
        `INSERT INTO post_category_detail (postId, postCategoryId) VALUES ?`,
        [values]
    );
};

// Cập nhật hàng loạt displayOrder cho bài viết sau khi admin kéo thả sắp xếp.
const updatePostOrder = async (items) => {
    let db;

    try {
        if (!Array.isArray(items) || items.length === 0) {
            return {
                errCode: 1,
                errMessage: "Post order items must be a non-empty array"
            };
        }

        const normalizedItems = items.map((item) => ({
            id: Number(item?.id),
            displayOrder: parseDisplayOrder(item?.displayOrder),
        }));

        const hasInvalidItem = normalizedItems.some(
            (item) => !Number.isInteger(item.id) || item.id <= 0 || item.displayOrder === null
        );

        if (hasInvalidItem) {
            return {
                errCode: 2,
                errMessage: "Each item must include a valid id and displayOrder"
            };
        }

        db = await connection.promise().getConnection();
        await db.beginTransaction();

        for (const item of normalizedItems) {
            const [rows] = await db.query(`SELECT id FROM post WHERE id = ?`, [item.id]);
            if (rows.length === 0) {
                await db.rollback();
                return {
                    errCode: 3,
                    errMessage: `The post with id ${item.id} does not exist`
                };
            }

            await db.query(
                `UPDATE post SET displayOrder = ? WHERE id = ?`,
                [item.displayOrder, item.id]
            );
        }

        await db.commit();
        return {
            errCode: 0,
            errMessage: "OK"
        };
    } catch (error) {
        if (db) {
            await db.rollback();
        }
        console.log("updatePostOrder error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server"
        };
    } finally {
        if (db) {
            db.release();
        }
    }
};

// Tạo mới bài viết và lưu danh mục liên kết trong cùng một transaction.
const createPost = async (data) => {
    let db;

    try {
        db = await connection.promise().getConnection();
        await db.beginTransaction();

        const prepared = await buildPostPayload(data, db);
        if (prepared.error) {
            await db.rollback();
            return prepared.error;
        }

        const { payload } = prepared;
        const [insertResult] = await db.query(
            `
                INSERT INTO post
                    (title, shortDescription, contentHTML, slug, image, bannerImage, isActive, displayOrder)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            `,
            [
                payload.title,
                payload.shortDescription,
                payload.contentHTML,
                payload.slug,
                payload.image,
                payload.bannerImage,
                payload.isActive,
                payload.displayOrder
            ]
        );

        await insertPostCategories(insertResult.insertId, payload.categoryIds, db);
        await db.commit();

        return {
            errCode: 0,
            errMessage: "Create post successfully"
        };
    } catch (error) {
        if (db) {
            await db.rollback();
        }
        console.log("createPost error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server"
        };
    } finally {
        if (db) {
            db.release();
        }
    }
};

// Lấy danh sách bài viết có phân trang, tìm kiếm và lọc theo danh mục hoặc trạng thái.
const getPost = async (query) => {
    try {
        const page = parsePositiveInt(query?.page, DEFAULT_PAGE);
        const limit = parsePositiveInt(query?.limit, DEFAULT_LIMIT);
        const offset = (page - 1) * limit;
        const keyword = String(query?.keyword || "").trim();
        const categoryId = query?.categoryId ? Number(query.categoryId) : null;
        const isActive = query?.isActive === "" || query?.isActive === undefined ? null : parseIsActive(query?.isActive);

        if (query?.isActive !== "" && query?.isActive !== undefined && isActive === null) {
            return {
                errCode: 1,
                errMessage: "isActive must be 0 or 1",
                data: {
                    posts: [],
                    total: 0,
                    totalPages: 0,
                    currentPage: page
                }
            };
        }

        if (query?.categoryId && (!Number.isInteger(categoryId) || categoryId <= 0)) {
            return {
                errCode: 2,
                errMessage: "categoryId must be a valid number",
                data: {
                    posts: [],
                    total: 0,
                    totalPages: 0,
                    currentPage: page
                }
            };
        }

        const whereClauses = [];
        const params = [];

        if (keyword) {
            whereClauses.push(`p.title LIKE ?`);
            params.push(`%${keyword}%`);
        }

        if (isActive !== null) {
            whereClauses.push(`p.isActive = ?`);
            params.push(isActive);
        }

        if (categoryId) {
            whereClauses.push(`
                EXISTS (
                    SELECT 1
                    FROM post_category_detail pcd
                    WHERE pcd.postId = p.id
                      AND pcd.postCategoryId = ?
                )
            `);
            params.push(categoryId);
        }

        const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(" AND ")}` : "";

        const [countRows] = await connection.promise().query(
            `
                SELECT COUNT(*) AS total
                FROM post p
                ${whereSql}
            `,
            params
        );

        const total = countRows[0]?.total || 0;
        const totalPages = total > 0 ? Math.ceil(total / limit) : 0;

        const [rows] = await connection.promise().query(
            `
                SELECT
                    p.*,
                    COALESCE((
                        SELECT GROUP_CONCAT(pcd.postCategoryId ORDER BY pcd.postCategoryId ASC)
                        FROM post_category_detail pcd
                        WHERE pcd.postId = p.id
                    ), '') AS categoryIds
                FROM post p
                ${whereSql}
                ORDER BY p.displayOrder ASC, p.updatedAt DESC, p.id DESC
                LIMIT ? OFFSET ?
            `,
            [...params, limit, offset]
        );

        const posts = rows.map((item) => ({
            ...item,
            categoryIds: item.categoryIds
                ? item.categoryIds.split(",").map((id) => Number(id))
                : []
        }));

        return {
            errCode: 0,
            errMessage: "OK",
            data: {
                posts,
                total,
                totalPages,
                currentPage: page
            }
        };
    } catch (error) {
        console.log("getPost error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {
                posts: [],
                total: 0,
                totalPages: 0,
                currentPage: DEFAULT_PAGE
            }
        };
    }
};

// Lấy danh sách bài viết public theo category slug và chỉ trả về bài active.
const getPublicPostsByCategorySlug = async (query) => {
    try {
        const categorySlug = String(query?.categorySlug || "").trim();
        const page = parsePositiveInt(query?.page, DEFAULT_PAGE);
        const limit = parsePositiveInt(query?.limit, DEFAULT_LIMIT);
        const offset = (page - 1) * limit;

        if (!categorySlug) {
            return {
                errCode: 1,
                errMessage: "categorySlug is required",
                data: {
                    category: null,
                    posts: [],
                    total: 0,
                    totalPages: 0,
                    currentPage: page
                }
            };
        }

        const [categoryRows] = await connection.promise().query(
            `SELECT * FROM post_category WHERE slug = ? AND isActive = 1 LIMIT 1`,
            [categorySlug]
        );

        if (categoryRows.length === 0) {
            return {
                errCode: 2,
                errMessage: `The post category with slug ${categorySlug} does not exist`,
                data: {
                    category: null,
                    posts: [],
                    total: 0,
                    totalPages: 0,
                    currentPage: page
                }
            };
        }

        const category = categoryRows[0];

        const [countRows] = await connection.promise().query(
            `
                SELECT COUNT(DISTINCT p.id) AS total
                FROM post p
                WHERE p.isActive = 1
                  AND EXISTS (
                    SELECT 1
                    FROM post_category_detail pcd
                    INNER JOIN post_category pc ON pc.id = pcd.postCategoryId
                    WHERE pcd.postId = p.id
                      AND pc.slug = ?
                      AND pc.isActive = 1
                  )
            `,
            [categorySlug]
        );

        const total = countRows[0]?.total || 0;
        const totalPages = total > 0 ? Math.ceil(total / limit) : 0;

        const [rows] = await connection.promise().query(
            `
                SELECT
                    p.*,
                    ${buildCategoryMetaSelect("p")}
                FROM post p
                WHERE p.isActive = 1
                  AND EXISTS (
                    SELECT 1
                    FROM post_category_detail pcd
                    INNER JOIN post_category pc ON pc.id = pcd.postCategoryId
                    WHERE pcd.postId = p.id
                      AND pc.slug = ?
                      AND pc.isActive = 1
                  )
                ORDER BY p.displayOrder ASC, p.updatedAt DESC, p.id DESC
                LIMIT ? OFFSET ?
            `,
            [categorySlug, limit, offset]
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: {
                category,
                posts: rows.map(formatPublicPost),
                total,
                totalPages,
                currentPage: page
            }
        };
    } catch (error) {
        console.log("getPublicPostsByCategorySlug error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {
                category: null,
                posts: [],
                total: 0,
                totalPages: 0,
                currentPage: DEFAULT_PAGE
            }
        };
    }
};

// Lấy chi tiết một bài viết kèm danh sách categoryIds đã được gán.
const getPostDetailById = async (postId) => {
    try {
        if (!postId) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {}
            };
        }

        const [rows] = await connection.promise().query(
            `SELECT * FROM post WHERE id = ?`,
            [postId]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: `The post with id ${postId} does not exist`,
                data: {}
            };
        }

        const [categoryRows] = await connection.promise().query(
            `SELECT postCategoryId FROM post_category_detail WHERE postId = ? ORDER BY postCategoryId ASC`,
            [postId]
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: {
                ...rows[0],
                categoryIds: categoryRows.map((item) => item.postCategoryId)
            }
        };
    } catch (error) {
        console.log("getPostDetailById error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {}
        };
    }
};

// Lấy chi tiết bài viết public theo cặp categorySlug + postSlug để chặn sai quan hệ.
const getPublicPostDetail = async (query) => {
    try {
        const categorySlug = String(query?.categorySlug || "").trim();
        const postSlug = String(query?.postSlug || "").trim();

        if (!categorySlug || !postSlug) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: {}
            };
        }

        const [rows] = await connection.promise().query(
            `
                SELECT
                    p.*,
                    ${buildCategoryMetaSelect("p")}
                FROM post p
                WHERE p.isActive = 1
                  AND p.slug = ?
                  AND EXISTS (
                    SELECT 1
                    FROM post_category_detail pcd
                    INNER JOIN post_category pc ON pc.id = pcd.postCategoryId
                    WHERE pcd.postId = p.id
                      AND pc.slug = ?
                      AND pc.isActive = 1
                  )
                LIMIT 1
            `,
            [postSlug, categorySlug]
        );

        if (rows.length === 0) {
            return {
                errCode: 2,
                errMessage: `The post with slug ${postSlug} does not exist in category ${categorySlug}`,
                data: {}
            };
        }

        const post = formatPublicPost(rows[0]);
        const currentCategory = (post.categories || []).find((item) => item.slug === categorySlug) || null;

        return {
            errCode: 0,
            errMessage: "OK",
            data: {
                ...post,
                currentCategory
            }
        };
    } catch (error) {
        console.log("getPublicPostDetail error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: {}
        };
    }
};

const getPublicRelatedPosts = async (query) => {
    try {
        const categorySlug = String(query?.categorySlug || "").trim();
        const postSlug = String(query?.postSlug || "").trim();
        const limit = parsePositiveInt(query?.limit, 7);

        if (!categorySlug || !postSlug) {
            return {
                errCode: 1,
                errMessage: "Missing required parameters",
                data: []
            };
        }

        const [currentPostRows] = await connection.promise().query(
            `
                SELECT p.id
                FROM post p
                WHERE p.isActive = 1
                  AND p.slug = ?
                  AND EXISTS (
                    SELECT 1
                    FROM post_category_detail pcd
                    INNER JOIN post_category pc ON pc.id = pcd.postCategoryId
                    WHERE pcd.postId = p.id
                      AND pc.slug = ?
                      AND pc.isActive = 1
                  )
                LIMIT 1
            `,
            [postSlug, categorySlug]
        );

        if (currentPostRows.length === 0) {
            return {
                errCode: 2,
                errMessage: "Post not found",
                data: []
            };
        }

        const currentPostId = currentPostRows[0].id;
        const [rows] = await connection.promise().query(
            `
                SELECT
                    p.*,
                    ${buildCategoryMetaSelect("p")}
                FROM post p
                WHERE p.isActive = 1
                  AND p.id != ?
                  AND EXISTS (
                    SELECT 1
                    FROM post_category_detail related_pcd
                    INNER JOIN post_category pc ON pc.id = related_pcd.postCategoryId
                    INNER JOIN post_category_detail current_pcd
                        ON current_pcd.postCategoryId = related_pcd.postCategoryId
                    WHERE related_pcd.postId = p.id
                      AND current_pcd.postId = ?
                      AND pc.isActive = 1
                  )
                ORDER BY p.displayOrder ASC, p.updatedAt DESC, p.id DESC
                LIMIT ?
            `,
            [currentPostId, currentPostId, limit]
        );

        return {
            errCode: 0,
            errMessage: "OK",
            data: rows.map(formatPublicPost)
        };
    } catch (error) {
        console.log("getPublicRelatedPosts error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server",
            data: []
        };
    }
};

// Cập nhật bài viết và làm mới toàn bộ liên kết danh mục trong cùng transaction.
const editPost = async (data) => {
    let db;

    try {
        const postId = data?.id;
        if (!postId) {
            return {
                errCode: 1,
                errMessage: "Post id is required"
            };
        }

        db = await connection.promise().getConnection();
        await db.beginTransaction();

        const [existingRows] = await db.query(
            `SELECT id FROM post WHERE id = ?`,
            [postId]
        );

        if (existingRows.length === 0) {
            await db.rollback();
            return {
                errCode: 2,
                errMessage: `The post with id ${postId} does not exist`
            };
        }

        const prepared = await buildPostPayload(data, db, postId);
        if (prepared.error) {
            await db.rollback();
            return prepared.error;
        }

        const { payload } = prepared;
        await db.query(
            `
                UPDATE post
                SET title = ?, shortDescription = ?, contentHTML = ?, slug = ?, image = ?, bannerImage = ?, isActive = ?, displayOrder = ?
                WHERE id = ?
            `,
            [
                payload.title,
                payload.shortDescription,
                payload.contentHTML,
                payload.slug,
                payload.image,
                payload.bannerImage,
                payload.isActive,
                payload.displayOrder,
                postId
            ]
        );

        await db.query(
            `DELETE FROM post_category_detail WHERE postId = ?`,
            [postId]
        );

        await insertPostCategories(postId, payload.categoryIds, db);
        await db.commit();

        return {
            errCode: 0,
            errMessage: "Update post successfully"
        };
    } catch (error) {
        if (db) {
            await db.rollback();
        }
        console.log("editPost error:", error);
        return {
            errCode: 1,
            errMessage: "Error from server"
        };
    } finally {
        if (db) {
            db.release();
        }
    }
};

// Xóa cứng bài viết sau khi kiểm tra bản ghi tồn tại.
const deletePost = async (postId) => {
    const status = {};
    try {
        if (!postId) {
            status.errCode = 1;
            status.errMessage = "Post id is required";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT id FROM post WHERE id = ?`,
            [postId]
        );

        if (rows.length === 0) {
            status.errCode = 2;
            status.errMessage = `The post with id ${postId} does not exist`;
            return status;
        }

        await connection.promise().query(
            `DELETE FROM post WHERE id = ?`,
            [postId]
        );

        status.errCode = 0;
        status.errMessage = "Delete post successfully";
        return status;
    } catch (error) {
        console.log("deletePost error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

// Bật hoặc tắt trạng thái hiển thị của bài viết.
const changeStatusPost = async (data) => {
    const status = {};
    try {
        const postId = data?.id;
        const isActive = parseIsActive(data?.isActive);

        if (!postId) {
            status.errCode = 1;
            status.errMessage = "Post id is required";
            return status;
        }

        if (isActive === null) {
            status.errCode = 2;
            status.errMessage = "isActive must be 0 or 1";
            return status;
        }

        const [rows] = await connection.promise().query(
            `SELECT id FROM post WHERE id = ?`,
            [postId]
        );

        if (rows.length === 0) {
            status.errCode = 3;
            status.errMessage = `The post with id ${postId} does not exist`;
            return status;
        }

        await connection.promise().query(
            `UPDATE post SET isActive = ? WHERE id = ?`,
            [isActive, postId]
        );

        status.errCode = 0;
        status.errMessage = "Change post status successfully";
        return status;
    } catch (error) {
        console.log("changeStatusPost error:", error);
        status.errCode = 1;
        status.errMessage = "Error from server";
        return status;
    }
};

module.exports = {
    createPost,
    getPost,
    getPublicPostsByCategorySlug,
    getPostDetailById,
    getPublicPostDetail,
    getPublicRelatedPosts,
    editPost,
    deletePost,
    changeStatusPost,
    updatePostOrder
};
