const connection = require("../../config/data");
const {
  normalizeSlug,
  parseOptionalDisplayOrder,
  parseOptionalIsActive,
  resolveHtmlOnlyRichText,
  getNextDisplayOrder,
  buildUniqueSlug,
  updateDisplayOrderBatch,
  changeActiveStatus,
} = require("../contentMetaService");

const buildDoctorSlugSource = (doctor) => {
  const fullName = `${doctor?.firstName || ""} ${doctor?.lastName || ""}`.trim();
  return fullName || `doctor-${doctor?.id || doctor?.doctorId || ""}`;
};

const resolveDoctorIdForDetail = async ({ id, slug }) => {
  const doctorSlug = String(slug || "").trim();
  const doctorId = Number(id);

  if (doctorSlug) {
    const [rows] = await connection.promise().query(
      `
        SELECT di.doctorId
        FROM doctor_info di
        INNER JOIN users u ON u.id = di.doctorId
        WHERE di.slug = ? AND di.isActive = 1 AND u.roleId = 'R2'
        LIMIT 1
      `,
      [doctorSlug]
    );

    return rows?.[0]?.doctorId || null;
  }

  if (Number.isInteger(doctorId) && doctorId > 0) {
    return doctorId;
  }

  return null;
};

const getTopDoctorHome = async (limit) => {
  const status = {};
  try {
    const limitNum = Number(limit) || 5;

    const [rows] = await connection.promise().query(
      `
             SELECT
            u.id,
            u.email,
            u.firstName,
            u.lastName,
            u.address,
            u.gender,
            u.positionId,
            u.roleId,
            u.image,
            u.phoneNumber,

            -- Position
            p.value_vi AS positionVi,
            p.value_en AS positionEn,

            -- Gender
            g.value_vi AS genderVi,
            g.value_en AS genderEn,

            di.description,

            -- Specialty
            s.id AS specialtyId,
            s.name AS specialtyName,
            s.image AS specialtyImage,
            di.id AS doctorInfoId,
            di.slug,
            di.isActive,
            di.displayOrder

        FROM users AS u

        LEFT JOIN lookup AS p
            ON u.positionId = p.keyMap AND p.type = 'POSITION'

        LEFT JOIN lookup AS g
            ON u.gender = g.keyMap AND g.type = 'GENDER'

        LEFT JOIN doctor_info AS di
            ON di.doctorId = u.id

        LEFT JOIN specialty AS s
            ON s.id = di.specialtyId

        WHERE u.roleId = 'R2'   -- bác sĩ
        ORDER BY u.createdAt DESC
        LIMIT ?;
            `,
      [Math.max(limitNum * 5, 50)]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows
      .filter((item) => Number(item.isActive) === 1)
      .sort((firstItem, secondItem) => {
        const firstOrder = Number(firstItem.displayOrder) || 0;
        const secondOrder = Number(secondItem.displayOrder) || 0;
        return firstOrder - secondOrder;
      })
      .slice(0, limitNum);
    return status;
  } catch (error) {
    console.log("getTopDoctorHome error:", error);
    status.errCode = 1;
    status.errMessage = error;
    status.data = [];
    return status;
  }
};

const getDetailDoctorById = async (query) => {
  const status = {};

  try {
    const doctorId = await resolveDoctorIdForDetail(
      typeof query === "object" ? query : { id: query }
    );

    if (!doctorId) {
      return {
        errCode: 1,
        errMessage: "Missing required parameter: doctorId",
        data: {},
      };
    }

    // LẤY THÔNG TIN NGƯỜI DÙNG
    const [userRows] = await connection.promise().query(
      `
            SELECT
                u.id, u.email, u.firstName, u.lastName, u.address,
                u.phoneNumber, u.image, u.gender, u.positionId, u.roleId,
                p.value_vi AS positionVi, p.value_en AS positionEn,
                g.value_vi AS genderVi, g.value_en AS genderEn
            FROM users AS u
            LEFT JOIN lookup AS p
                ON u.positionId = p.keyMap AND p.type = 'POSITION'
            LEFT JOIN lookup AS g
                ON u.gender = g.keyMap AND g.type = 'GENDER'
            WHERE u.id = ? AND u.roleId = 'R2'
        `,
      [doctorId]
    );

    if (userRows.length === 0) {
      return {
        errCode: 2,
        errMessage: "Doctor not found",
        data: {},
      };
    }

    const user = userRows[0];

    // LẤY doctor_info
    const [clinicRows] = await connection.promise().query(
      `
            SELECT
              di.id AS doctorInfoId, di.doctorId, di.slug, di.isActive, di.displayOrder,
              di.contentHTML, di.description,
              di.clinicId, di.specialtyId,
              c.address AS clinicAddress, c.provinceCode, c.districtCode, c.wardCode,
              COALESCE(lp.value_vi, c.provinceCode) AS province
            FROM doctor_info di
            LEFT JOIN clinic c
              ON c.id = di.clinicId
            LEFT JOIN lookup lp
              ON lp.keyMap = c.provinceCode AND lp.type = 'PROVINCE'
            WHERE di.doctorId = ?
        `,
      [doctorId]
    );

    const dc = clinicRows[0] || {};

    // LẤY GIÁ & PAYMENT
    // LẤY SPECIALTY
    const [specialtyRows] = await connection.promise().query(
      `
            SELECT id AS specialtyId, name AS specialtyName, slug AS specialtySlug
            FROM specialty
            WHERE id = ?
        `,
      [dc.specialtyId]
    );

    const specialty = specialtyRows[0] || {};

    // LẤY CLINIC
    const [clinicDetailRows] = await connection.promise().query(
      `
            SELECT
              c.id AS clinicId, c.name AS clinicName, c.slug AS clinicSlug,
              c.address AS clinicAddress, c.provinceCode, c.districtCode, c.wardCode,
              COALESCE(lp.value_vi, c.provinceCode) AS province
            FROM clinic c
            LEFT JOIN lookup lp
              ON lp.keyMap = c.provinceCode AND lp.type = 'PROVINCE'
            WHERE c.id = ?
        `,
      [dc.clinicId]
    );

    const clinic = clinicDetailRows[0] || {};

    // GỘP TẤT CẢ LẠI
    const data = {
      ...user,
      ...dc,
      ...specialty,
      ...clinic,
    };

    return {
      errCode: 0,
      errMessage: "OK",
      data,
    };
  } catch (error) {
    console.log("getDetailDoctorById error:", error);
    return {
      errCode: 1,
      errMessage: error.message,
      data: {},
    };
  }
};

const getAllDoctorHome = async () => {
  const status = {};
  try {
    const [rows] = await connection.promise().query(
      `
        SELECT
          u.id,
          u.email,
          u.firstName,
          u.lastName,
          u.address,
          u.gender,
          u.positionId,
          u.roleId,
          u.image,
          u.phoneNumber,
          u.provinceCode AS userProvinceCode,
          u.districtCode AS userDistrictCode,
          u.wardCode AS userWardCode,
          u.createdAt,
          u.updatedAt,
          p.value_vi AS positionVi,
          p.value_en AS positionEn,
          di.description,
          di.id AS doctorInfoId,
          di.slug,
          di.isActive,
          di.displayOrder,
          di.specialtyId,
          di.clinicId,
          s.slug AS specialtySlug,
          s.name AS specialtyName,
          c.slug AS clinicSlug,
          c.name AS clinicName,
          c.address AS clinicAddress,
          c.provinceCode,
          c.districtCode,
          c.wardCode,
          COALESCE(lp.value_vi, c.provinceCode) AS province
        FROM users AS u
        LEFT JOIN lookup AS p
          ON u.positionId = p.keyMap AND p.type = 'POSITION'
        LEFT JOIN doctor_info AS di
          ON di.doctorId = u.id
        LEFT JOIN specialty AS s
          ON s.id = di.specialtyId
        LEFT JOIN clinic AS c
          ON c.id = di.clinicId
        LEFT JOIN lookup AS lp
          ON lp.keyMap = c.provinceCode AND lp.type = 'PROVINCE'
        WHERE u.roleId = 'R2'
        ORDER BY di.displayOrder ASC, u.createdAt DESC
      `
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("getAllDoctorHome error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const hasVisibleEditorContent = (value) => {
  if (!value || typeof value !== "string") return false;

  const plainText = value
    .replace(/<[^>]*>/g, " ")
    .replace(/&nbsp;/g, " ")
    .trim();

  return plainText.length > 0;
};

const saveDetailInfoDoctor = async (data) => {
  const status = {};
  try {
    const contentHTML = resolveHtmlOnlyRichText(data, "contentHTML");

    if (
      !data ||
      !hasVisibleEditorContent(contentHTML) ||
      !data.doctorId ||
      !data.specialtyId ||
      !data.clinicId ||
      !data.description
    ) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { doctorId, clinicId, specialtyId, description } = data;

    console.log(">>> Save doctor detail:", data);

    const [doctorUserRows] = await connection.promise().query(
      `SELECT id, firstName, lastName FROM users WHERE id = ? AND roleId = 'R2'`,
      [doctorId]
    );

    if (doctorUserRows.length === 0) {
      status.errCode = 2;
      status.errMessage = `The doctor with id ${doctorId} does not exist`;
      return status;
    }

    const [checkClinic] = await connection
      .promise()
      .query(
        `SELECT id, slug, isActive, displayOrder, clinicId FROM doctor_info WHERE doctorId = ?`,
        [doctorId]
      );

    const existingDoctorInfo = checkClinic[0] || {};

    if (Object.prototype.hasOwnProperty.call(data, "image")) {
      await connection.promise().query(
        `UPDATE users SET image = ? WHERE id = ? AND roleId = 'R2'`,
        [data.image || null, doctorId]
      );
    }

    const slugSource =
      String(data?.slug || "").trim() ||
      existingDoctorInfo.slug ||
      buildDoctorSlugSource(doctorUserRows[0]);
    const normalizedSlug = normalizeSlug(slugSource);

    if (!normalizedSlug) {
      status.errCode = 3;
      status.errMessage = "Slug is required";
      return status;
    }

    const displayOrderFallback = checkClinic.length > 0
      ? existingDoctorInfo.displayOrder
      : await getNextDisplayOrder("doctor_info");
    const displayOrder = parseOptionalDisplayOrder(data?.displayOrder, displayOrderFallback);
    const isActive = parseOptionalIsActive(data?.isActive, existingDoctorInfo.isActive ?? 1);

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

    const slug = await buildUniqueSlug(
      "doctor_info",
      normalizedSlug,
      existingDoctorInfo.id || null
    );

    if (checkClinic.length > 0) {
      // Cập nhật nếu đã tồn tại
      await connection.promise().query(
        `
       UPDATE doctor_info
          SET contentHTML = ?, description = ?,
              specialtyId = ?, clinicId = ?,
              slug = ?, isActive = ?, displayOrder = ?
          WHERE doctorId = ?
        `,
        [
          contentHTML,
          description || null,
          specialtyId,
          clinicId,
          slug,
          isActive,
          displayOrder,
          doctorId,
        ]
      );
    } else {
      // Thêm mới nếu chưa có
      await connection.promise().query(
        `
        INSERT INTO doctor_info
          (doctorId, contentHTML, description, slug, isActive, displayOrder, specialtyId, clinicId)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `,
        [
          doctorId,
          contentHTML,
          description || null,
          slug,
          isActive,
          displayOrder,
          specialtyId,
          clinicId,
        ]
      );
    }

    status.errCode = 0;
    status.errMessage = "Save doctor detail successfully";

    return status;
  } catch (error) {
    console.log("saveDetailInfoDoctor error:", error);
    status.errCode = 2;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

// Định nghĩa 1 hàm chuẩn hóa ngày

const getRelatedDoctorsById = async (doctorId, limit = 10) => {
  const status = {};
  try {
    if (!doctorId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameter: doctorId";
      status.data = [];
      return status;
    }

    // Lấy specialtyId của bác sĩ hiện tại
    const [specialtyRows] = await connection.promise().query(
      `SELECT specialtyId FROM doctor_info WHERE doctorId = ?`,
      [doctorId]
    );

    if (specialtyRows.length === 0 || !specialtyRows[0].specialtyId) {
      status.errCode = 0;
      status.errMessage = "Doctor has no specialty";
      status.data = [];
      return status;
    }

    const specialtyId = specialtyRows[0].specialtyId;

    // Lấy danh sách các bác sĩ có cùng specialtyId (loại trừ bác sĩ hiện tại)
    const [rows] = await connection.promise().query(
      `
        SELECT
            u.id, u.email, u.firstName, u.lastName, u.address, u.gender,
            u.positionId, u.roleId, u.image, u.phoneNumber,
            p.value_vi AS positionVi, p.value_en AS positionEn,
            g.value_vi AS genderVi, g.value_en AS genderEn,
            di.description,
            di.id AS doctorInfoId,
            di.slug,
            di.isActive,
            di.displayOrder,
            s.id AS specialtyId, s.name AS specialtyName, s.image AS specialtyImage, s.slug AS specialtySlug
        FROM users AS u
        LEFT JOIN lookup AS p ON u.positionId = p.keyMap AND p.type = 'POSITION'
        LEFT JOIN lookup AS g ON u.gender = g.keyMap AND g.type = 'GENDER'
        LEFT JOIN doctor_info AS di ON di.doctorId = u.id
        LEFT JOIN specialty AS s ON s.id = di.specialtyId
        WHERE u.roleId = 'R2'
          AND di.specialtyId = ?
          AND di.isActive = 1
          AND s.isActive = 1
          AND u.id != ?
        ORDER BY di.displayOrder ASC, u.createdAt DESC
        LIMIT ?;
      `,
      [specialtyId, doctorId, Number(limit)]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("getRelatedDoctorsById error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const updateDoctorInfoOrder = async (items) => {
  return updateDisplayOrderBatch("doctor_info", items, "doctor info");
};

const changeStatusDoctorInfo = async (data) => {
  const idColumn = data?.doctorId && !data?.id ? "doctorId" : "id";
  return changeActiveStatus("doctor_info", data, "doctor info", idColumn);
};

module.exports = {
  getTopDoctorHome,
  getDetailDoctorById,
  getAllDoctorHome,
  saveDetailInfoDoctor,
  getRelatedDoctorsById,
  updateDoctorInfoOrder,
  changeStatusDoctorInfo,
};
