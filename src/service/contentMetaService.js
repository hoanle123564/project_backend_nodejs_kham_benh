const connection = require("../config/data");

const ALLOWED_SLUG_TABLES = new Set(["specialty", "clinic", "doctor_info"]);

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

const parseDisplayOrder = (value) => {
  const parsedValue = Number(value);
  if (!Number.isFinite(parsedValue)) {
    return null;
  }
  return parsedValue;
};

const parseOptionalDisplayOrder = (value, fallbackValue = 0) => {
  if (value === undefined || value === null || value === "") {
    return fallbackValue;
  }
  return parseDisplayOrder(value);
};

const parseIsActive = (value) => {
  if (value === 0 || value === 1) {
    return value;
  }
  if (value === true) {
    return 1;
  }
  if (value === false) {
    return 0;
  }
  if (value === "0" || value === "1") {
    return Number(value);
  }
  return null;
};

const parseOptionalIsActive = (value, fallbackValue = 1) => {
  if (value === undefined || value === null || value === "") {
    return fallbackValue;
  }
  return parseIsActive(value);
};

const getNextDisplayOrder = async (tableName, executor = connection.promise()) => {
  if (!ALLOWED_SLUG_TABLES.has(tableName)) {
    throw new Error("Invalid table name");
  }

  const [rows] = await executor.query(
    `SELECT COALESCE(MAX(displayOrder), 0) + 1 AS nextDisplayOrder FROM ${tableName}`
  );

  return Number(rows?.[0]?.nextDisplayOrder) || 1;
};

const buildUniqueSlug = async (
  tableName,
  baseSlug,
  excludeId = null,
  executor = connection.promise()
) => {
  if (!ALLOWED_SLUG_TABLES.has(tableName)) {
    throw new Error("Invalid table name");
  }

  let nextSlug = baseSlug;
  let suffix = 1;

  while (true) {
    let query = `SELECT id FROM ${tableName} WHERE slug = ?`;
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

const updateDisplayOrderBatch = async (tableName, items, entityName) => {
  let db;

  try {
    const validationMessage = validateOrderItems(items);
    if (validationMessage) {
      return {
        errCode: 1,
        errMessage: validationMessage,
      };
    }

    if (!ALLOWED_SLUG_TABLES.has(tableName)) {
      return {
        errCode: 1,
        errMessage: "Invalid table name",
      };
    }

    db = await connection.promise().getConnection();
    await db.beginTransaction();

    for (const item of items) {
      const itemId = Number(item.id);
      const displayOrder = Number(item.displayOrder);

      const [rows] = await db.query(
        `SELECT id FROM ${tableName} WHERE id = ?`,
        [itemId]
      );

      if (rows.length === 0) {
        await db.rollback();
        return {
          errCode: 1,
          errMessage: `The ${entityName} with id ${itemId} does not exist`,
        };
      }

      await db.query(
        `UPDATE ${tableName} SET displayOrder = ? WHERE id = ?`,
        [displayOrder, itemId]
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
    console.log(`updateDisplayOrderBatch ${tableName} error:`, error);
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

const changeActiveStatus = async (tableName, data, entityName, idColumn = "id") => {
  const status = {};
  try {
    if (!ALLOWED_SLUG_TABLES.has(tableName)) {
      status.errCode = 1;
      status.errMessage = "Invalid table name";
      return status;
    }

    const entityId = Number(data?.[idColumn] || data?.id);
    const isActive = parseIsActive(data?.isActive);

    if (!Number.isInteger(entityId) || entityId <= 0) {
      status.errCode = 1;
      status.errMessage = `${entityName} id is required`;
      return status;
    }

    if (isActive === null) {
      status.errCode = 1;
      status.errMessage = "isActive must be 0 or 1";
      return status;
    }

    const [rows] = await connection.promise().query(
      `SELECT id FROM ${tableName} WHERE ${idColumn} = ?`,
      [entityId]
    );

    if (rows.length === 0) {
      status.errCode = 1;
      status.errMessage = `The ${entityName} with ${idColumn} ${entityId} does not exist`;
      return status;
    }

    await connection.promise().query(
      `UPDATE ${tableName} SET isActive = ? WHERE ${idColumn} = ?`,
      [isActive, entityId]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    return status;
  } catch (error) {
    console.log(`changeActiveStatus ${tableName} error:`, error);
    status.errCode = 1;
    status.errMessage = "Error from server";
    return status;
  }
};

module.exports = {
  normalizeSlug,
  parseDisplayOrder,
  parseOptionalDisplayOrder,
  parseIsActive,
  parseOptionalIsActive,
  getNextDisplayOrder,
  buildUniqueSlug,
  validateOrderItems,
  updateDisplayOrderBatch,
  changeActiveStatus,
};
