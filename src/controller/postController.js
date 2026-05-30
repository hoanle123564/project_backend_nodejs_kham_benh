const {
    createPost,
    getPost,
    getPostDetailById,
    editPost,
    deletePost,
    changeStatusPost
} = require("../service/PostService");

const postCreatePost = async (req, res) => {
    try {
        let response = await createPost(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("postCreatePost error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getAllPost = async (req, res) => {
    try {
        let response = await getPost(req.query);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getAllPost error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const getDetailPostById = async (req, res) => {
    try {
        const postId = req.query.id;
        let response = await getPostDetailById(postId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("getDetailPostById error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleEditPost = async (req, res) => {
    try {
        let response = await editPost(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleEditPost error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleDeletePost = async (req, res) => {
    try {
        const postId = req.body.id;
        let response = await deletePost(postId);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleDeletePost error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

const handleChangeStatusPost = async (req, res) => {
    try {
        let response = await changeStatusPost(req.body);
        return res.status(200).json(response);
    } catch (error) {
        console.log("handleChangeStatusPost error", error);
        return res.status(400).json({
            errCode: -1,
            errMessage: "Error from server",
        });
    }
};

module.exports = {
    postCreatePost,
    getAllPost,
    getDetailPostById,
    handleEditPost,
    handleDeletePost,
    handleChangeStatusPost
};
