const connection = require("../config/data");

// Lấy executor DB hiện có nếu đang trong transaction, ngược lại dùng connection promise mặc định.
const getDb = (db) => db || connection.promise();

// Chạy một callback trong transaction, tự commit khi thành công và rollback khi có lỗi.
const withTransaction = async (callback) => {
  const db = await connection.promise().getConnection();

  try {
    await db.beginTransaction();
    const result = await callback(db);
    await db.commit();
    return result;
  } catch (error) {
    try {
      await db.rollback();
    } catch (rollbackError) {
      console.error("transaction rollback error:", rollbackError);
    }

    throw error;
  } finally {
    db.release();
  }
};

module.exports = {
  getDb,
  withTransaction,
};
