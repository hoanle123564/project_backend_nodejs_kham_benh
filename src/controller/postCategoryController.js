const {
    createPostCategory,
    getPostCategory,
    getActivePostCategoriesPublic,
    getPostCategoryDetailById,
    getPublicPostCategoryDetailBySlug,
    editPostCategory,
    deletePostCategory,
    updatePostCategoryOrder,
    changeStatusPostCategory
} = require("../service/PostCategoryService");

const postCreatePostCategory = async (req, res) => {
    try {
        let response = await createPostCategory(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postCreatePostCategory error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getAllPostCategory = async (req, res) => {
    try {
        let response = await getPostCategory();
        return res.status(200).json(response);
    } catch (error) {
        console.log("getAllPostCategory error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getPublicPostCategories = async (req, res) => {
    try {
        let response = await getActivePostCategoriesPublic();
        return res.status(200).json(response);
    } catch (error) {
        console.log("getPublicPostCategories error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getDetailPostCategoryById = async (req, res) => {
    try {
        const categoryId = req.query.id;
        let response = await getPostCategoryDetailById(categoryId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getDetailPostCategoryById error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getPublicPostCategoryDetail = async (req, res) => {
    try {
        const categorySlug = req.query.categorySlug;
        let response = await getPublicPostCategoryDetailBySlug(categorySlug);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getPublicPostCategoryDetail error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleEditPostCategory = async (req, res) => {
    try {
        const data = req.body;
        let response = await editPostCategory(data);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleEditPostCategory error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleDeletePostCategory = async (req, res) => {
    try {
        const categoryId = req.body.id;
        let response = await deletePostCategory(categoryId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleDeletePostCategory error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleUpdatePostCategoryOrder = async (req, res) => {
    try {
        let response = await updatePostCategoryOrder(req.body?.items);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleUpdatePostCategoryOrder error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusPostCategory = async (req, res) => {
    try {
        let response = await changeStatusPostCategory(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusPostCategory error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
    postCreatePostCategory,
    getAllPostCategory,
    getPublicPostCategories,
    getDetailPostCategoryById,
    getPublicPostCategoryDetail,
    handleEditPostCategory,
    handleDeletePostCategory,
    handleUpdatePostCategoryOrder,
    handleChangeStatusPostCategory,
};
