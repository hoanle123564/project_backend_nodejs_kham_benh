const connection = require("../config/data");
const { parseOptionalIsActive, parseIsActive } = require("./contentMetaService");

const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const normalizeOptionalString = (value) => {
  if (value === undefined || value === null) {
    return null;
  }

  const normalized = String(value).trim();
  return normalized || null;
};

const clinicExists = async (clinicId) => {
  const [rows] = await connection.promise().query(
    `SELECT id FROM clinic WHERE id = ? LIMIT 1`,
    [clinicId]
  );

  return rows.length > 0;
};

const validateSpecialtyId = async (specialtyId) => {
  if (!specialtyId) {
    return {
      errCode: 5,
      errMessage: "specialtyId is required",
    };
  }

  const [rows] = await connection.promise().query(
    `SELECT id FROM specialty WHERE id = ? LIMIT 1`,
    [specialtyId]
  );

  if (rows.length === 0) {
    return {
      errCode: 6,
      errMessage: "specialtyId does not exist",
    };
  }

  return null;
};

const validateUniqueClinicSpecialty = async (clinicId, specialtyId, excludeId = null) => {
  const [rows] = await connection.promise().query(
    `
      SELECT id
      FROM clinic_department
      WHERE clinicId = ?
        AND specialtyId = ?
        AND (? IS NULL OR id <> ?)
      LIMIT 1
    `,
    [clinicId, specialtyId, excludeId, excludeId]
  );

  if (rows.length > 0) {
    return {
      errCode: 7,
      errMessage: "This clinic already has a department for the selected specialty",
    };
  }

  return null;
};

const buildDepartmentPayload = async (data, options = {}) => {
  const clinicId = normalizePositiveId(options.clinicId ?? data?.clinicId);
  const specialtyId = normalizePositiveId(data?.specialtyId);
  const isActive = parseOptionalIsActive(data?.isActive, options.defaultIsActive ?? 1);

  if (!clinicId) {
    return {
      error: {
        errCode: 1,
        errMessage: "clinicId is required",
      },
    };
  }

  if (isActive === null) {
    return {
      error: {
        errCode: 3,
        errMessage: "isActive must be 0 or 1",
      },
    };
  }

  if (!(await clinicExists(clinicId))) {
    return {
      error: {
        errCode: 4,
        errMessage: "clinicId does not exist",
      },
    };
  }

  const specialtyError = await validateSpecialtyId(specialtyId);
  if (specialtyError) {
    return { error: specialtyError };
  }

  const duplicateError = await validateUniqueClinicSpecialty(
    clinicId,
    specialtyId,
    options.excludeId || null
  );
  if (duplicateError) {
    return { error: duplicateError };
  }

  return {
    payload: {
      clinicId,
      specialtyId,
      isActive,
    },
  };
};

const getClinicDepartment = async (query = {}) => {
  try {
    const clinicId = normalizePositiveId(query?.clinicId);
    if (!clinicId) {
      return {
        errCode: 1,
        errMessage: "clinicId is required",
        data: [],
      };
    }

    const [rows] = await connection.promise().query(
      `
        SELECT
          cd.id,
          cd.clinicId,
          cd.specialtyId,
          s.name AS specialtyName,
          cd.isActive,
          cd.createdAt,
          cd.updatedAt,
          c.name AS clinicName
        FROM clinic_department cd
        INNER JOIN clinic c
          ON c.id = cd.clinicId
        INNER JOIN specialty s
          ON s.id = cd.specialtyId
        WHERE cd.clinicId = ?
        ORDER BY cd.isActive DESC, cd.id ASC
      `,
      [clinicId]
    );

    return {
      errCode: 0,
      errMessage: "OK",
      data: rows,
    };
  } catch (error) {
    console.log("getClinicDepartment error:", error);
    return {
      errCode: 1,
      errMessage: "Error from server",
      data: [],
    };
  }
};

const createClinicDepartment = async (data) => {
  try {
    const prepared = await buildDepartmentPayload(data, {
      defaultIsActive: 1,
    });

    if (prepared.error) {
      return prepared.error;
    }

    const { payload } = prepared;

    await connection.promise().query(
      `
        INSERT INTO clinic_department
          (clinicId, specialtyId, isActive)
        VALUES (?, ?, ?)
      `,
      [
        payload.clinicId,
        payload.specialtyId,
        payload.isActive,
      ]
    );

    return {
      errCode: 0,
      errMessage: "Create clinic department successfully",
    };
  } catch (error) {
    console.log("createClinicDepartment error:", error);
    return {
      errCode: 1,
      errMessage: "Error from server",
    };
  }
};

const editClinicDepartment = async (data) => {
  try {
    const departmentId = normalizePositiveId(data?.id);
    if (!departmentId) {
      return {
        errCode: 1,
        errMessage: "Department id is required",
      };
    }

    const [rows] = await connection.promise().query(
      `SELECT * FROM clinic_department WHERE id = ? LIMIT 1`,
      [departmentId]
    );

    if (rows.length === 0) {
      return {
        errCode: 2,
        errMessage: `The clinic department with id ${departmentId} does not exist`,
      };
    }

    const existingDepartment = rows[0];
    const prepared = await buildDepartmentPayload(
      {
        ...existingDepartment,
        ...data,
        clinicId: existingDepartment.clinicId,
        specialtyId:
          data?.specialtyId === undefined ? existingDepartment.specialtyId : data.specialtyId,
        isActive: data?.isActive === undefined ? existingDepartment.isActive : data.isActive,
      },
      {
        clinicId: existingDepartment.clinicId,
        defaultIsActive: existingDepartment.isActive,
        excludeId: departmentId,
      }
    );

    if (prepared.error) {
      return prepared.error;
    }

    const { payload } = prepared;

    await connection.promise().query(
      `
        UPDATE clinic_department
        SET specialtyId = ?, isActive = ?
        WHERE id = ?
      `,
      [
        payload.specialtyId,
        payload.isActive,
        departmentId,
      ]
    );

    return {
      errCode: 0,
      errMessage: "Update clinic department successfully",
    };
  } catch (error) {
    console.log("editClinicDepartment error:", error);
    return {
      errCode: 1,
      errMessage: "Error from server",
    };
  }
};

const changeStatusClinicDepartment = async (data) => {
  try {
    const departmentId = normalizePositiveId(data?.id);
    const isActive = parseIsActive(data?.isActive);

    if (!departmentId) {
      return {
        errCode: 1,
        errMessage: "Department id is required",
      };
    }

    if (isActive === null) {
      return {
        errCode: 1,
        errMessage: "isActive must be 0 or 1",
      };
    }

    const [rows] = await connection.promise().query(
      `SELECT id FROM clinic_department WHERE id = ? LIMIT 1`,
      [departmentId]
    );

    if (rows.length === 0) {
      return {
        errCode: 2,
        errMessage: `The clinic department with id ${departmentId} does not exist`,
      };
    }

    await connection.promise().query(
      `UPDATE clinic_department SET isActive = ? WHERE id = ?`,
      [isActive, departmentId]
    );

    return {
      errCode: 0,
      errMessage: "OK",
    };
  } catch (error) {
    console.log("changeStatusClinicDepartment error:", error);
    return {
      errCode: 1,
      errMessage: "Error from server",
    };
  }
};

module.exports = {
  getClinicDepartment,
  createClinicDepartment,
  editClinicDepartment,
  changeStatusClinicDepartment,
};
