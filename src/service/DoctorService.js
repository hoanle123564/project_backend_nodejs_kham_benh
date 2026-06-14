const connection = require("../config/data");
const moment = require("moment");
const { sendResultEmail } = require("./emailService");
const {
  normalizeSlug,
  parseOptionalDisplayOrder,
  parseOptionalIsActive,
  getNextDisplayOrder,
  buildUniqueSlug,
  updateDisplayOrderBatch,
  changeActiveStatus,
} = require("./contentMetaService");
const { getBookingListScope } = require("./clinicAccessService");

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
              di.contentHTML, di.contentMarkdown, di.description,
              di.priceId, di.paymentId, di.clinicId, di.specialtyId,
              c.clinicTypeId, c.address AS clinicAddress, c.provinceCode, c.districtCode, c.wardCode,
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
    const [priceRows] = await connection.promise().query(
      `
            SELECT value_vi AS priceVi, value_en AS priceEn
            FROM lookup
            WHERE keyMap = ? AND type = 'PRICE'
        `,
      [dc.priceId]
    );

    const price = priceRows[0] || {};

    const [paymentRows] = await connection.promise().query(
      `
            SELECT value_vi AS paymentVi, value_en AS paymentEn
            FROM lookup
            WHERE keyMap = ? AND type = 'PAYMENT'
        `,
      [dc.paymentId]
    );

    const payment = paymentRows[0] || {};

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
              c.address AS clinicAddress, c.clinicTypeId, c.provinceCode, c.districtCode, c.wardCode,
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
      ...price,
      ...payment,
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
          c.clinicTypeId,
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
    const contentHTML = data?.contentHTML || "";
    const contentMarkdown = data?.contentMarkdown || contentHTML;

    if (
      !data ||
      !hasVisibleEditorContent(contentHTML) ||
      !data.doctorId ||
      !data.priceId ||
      !data.paymentId ||
      !data.specialtyId ||
      !data.clinicId ||
      !data.description
    ) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { doctorId, priceId, paymentId, clinicId, specialtyId, description } = data;

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
          SET contentHTML = ?, contentMarkdown = ?, description = ?,
              priceId = ?, paymentId = ?, specialtyId = ?, clinicId = ?,
              slug = ?, isActive = ?, displayOrder = ?
          WHERE doctorId = ?
        `,
        [
          contentHTML,
          contentMarkdown,
          description || null,
          priceId,
          paymentId,
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
          (doctorId, contentHTML, contentMarkdown, description, slug, isActive, displayOrder, priceId, paymentId, specialtyId, clinicId)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `,
        [
          doctorId,
          contentHTML,
          contentMarkdown,
          description || null,
          slug,
          isActive,
          displayOrder,
          priceId,
          paymentId,
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
const normalizeDate = (dateValue) => {
  if (!dateValue) return null;

  // Nếu là chuỗi DD/MM/YYYY
  if (typeof dateValue === "string" && dateValue.includes("/")) {
    return moment(dateValue, "DD/MM/YYYY", true).format("YYYY-MM-DD");
  }

  // Nếu là đối tượng Date hoặc ISO string
  return moment(dateValue).format("YYYY-MM-DD");
};

const PostScheduleDoctor = async (data) => {
  const status = {};
  try {
    if (!data || !data.doctorId || !data.date || !data.timeType) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const maxNumber = 10;
    const { doctorId, date, timeType } = data;

    // Chuẩn hóa định dạng ngày (trước khi dùng)

    // Chuẩn bị mảng insert
    let values = timeType.map((slot) => [maxNumber, doctorId, date, slot]);
    console.log("Bulk insert values:", values);

    const [rows] = await connection
      .promise()
      .query(`SELECT doctorId, date, timeType FROM schedule`);

    // Lọc trùng
    values = values.filter((v) => {
      return !rows.some((row) => {
        console.log("row.date", row.date);

        const rowDate = moment(row.date).format("YYYY-MM-DD");
        v[2] = moment(v[2], ["DD/MM/YYYY", moment.ISO_8601]).format(
          "YYYY-MM-DD"
        );
        return (
          Number(row.doctorId) === Number(v[1]) &&
          rowDate === v[2] &&
          row.timeType === v[3]
        );
      });
    });

    console.log("Values after filter:", values);

    //  Chuyển tất cả date về YYYY-DD-MM một lần nữa để chắc chắn
    values = values.map((v) => {
      v[2] = moment(v[2], ["DD/MM/YYYY", moment.ISO_8601]).format("YYYY-MM-DD");
      return v;
    });

    // Nếu không có giá trị mới thì dừng
    if (values.length === 0) {
      status.errCode = 0;
      status.errMessage = "No new schedule to insert";
      status.data = [];
      return status;
    }

    //  Insert dữ liệu chuẩn
    const [result] = await connection.promise().query(
      `
      INSERT INTO schedule (maxNumber, doctorId, date, timeType)
      VALUES ?`,
      [values]
    );

    status.errCode = 0;
    status.errMessage = "Schedule created successfully";
    status.data = result;
    return status;
  } catch (error) {
    console.log("PostScheduleDoctor error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const GetcheScheduleDoctorByDate = async (doctorId, date) => {
  const status = {};
  console.log("doctorId, date", doctorId, date);

  try {
    if (!doctorId || !date) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      status.data = [];
      return status;
    }
    const normalizedDate = normalizeDate(date);
    const [rows] = await connection.promise().query(
      `
       SELECT s.id, s.doctorId, s.date, s.timeType, s.maxNumber,
           a.value_vi, a.value_en
    FROM schedule AS s
    LEFT JOIN lookup AS a 
        ON s.timeType = a.keyMap AND a.type = 'TIME'
    WHERE s.doctorId = ? AND s.date = ?
    ORDER BY CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      [doctorId, normalizedDate]
    );
    console.log("schedules", rows);

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("GetcheScheduleDoctorByDate error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const GetListPatientForDoctor = async (doctorId, date) => {
  const status = {};
  try {
    if (!doctorId || !date) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      status.data = [];
      return status;
    }
    const normalizedDate = normalizeDate(date);
    const [rows] = await connection.promise().query(
      `
         SELECT b.id, b.scheduleId, b.date, s.timeType, b.statusId, b.reason,
         s.doctorId, b.patientId,
                u.email, u.firstName, u.lastName, u.address, u.phoneNumber,
                a.value_vi AS timeTypeVi, a.value_en AS timeTypeEn
         FROM booking AS b
            INNER JOIN schedule AS s ON b.scheduleId = s.id
            LEFT JOIN users AS u ON b.patientId = u.id
            LEFT JOIN lookup AS a 
                ON s.timeType = a.keyMap AND a.type = 'TIME'
         WHERE s.doctorId = ? AND b.date = ? AND b.statusId = 'S2'
         ORDER BY CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
        `,
      [doctorId, normalizedDate]
    );

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  } catch (error) {
    console.log("GetListPatientForDoctor error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const sendRemedy = async (data) => {
  const status = {};
  try {
    if (
      !data ||
      !data.email ||
      !data.bookingId ||
      !data.time ||
      !data.image ||
      !data.firstNamePatient ||
      !data.lastNamePatient
    ) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }
    const {
      email,
      bookingId,
      image,
      time,
      firstNamePatient,
      lastNamePatient,
      reason,
    } = data;

    // Cập nhật trạng thái booking
    const [bookingRows] = await connection.promise().query(
      `
        SELECT b.id, u.firstName, u.lastName
        FROM booking b
        INNER JOIN schedule s
          ON b.scheduleId = s.id
        INNER JOIN users u
          ON s.doctorId = u.id
        WHERE b.id = ? AND b.statusId = 'S2'
        LIMIT 1
      `,
      [bookingId]
    );

    if (bookingRows.length === 0) {
      status.errCode = 2;
      status.errMessage = "Appointment does not exist or is not ready for completion";
      return status;
    }

    await connection.promise().query(
      `
        UPDATE booking
        SET statusId = 'S3'
        WHERE id = ? AND statusId = 'S2'
      `,
      [bookingId]
    );

    // Gửi email (giả lập)
    console.log(`Sending remedy to ${email} with attachment...`);
    // Thực tế bạn sẽ sử dụng một thư viện gửi email như nodemailer để thực hiện việc này
    // await new Promise((resolve) => setTimeout(resolve, 1000)); // Giả lập delay

    // Lấy tên bác sĩ và bệnh nhân
    const doctorInfo = bookingRows;
    const doctorName =
      doctorInfo.length > 0
        ? `${doctorInfo[0].firstName} ${doctorInfo[0].lastName}`
        : "Bác sĩ";

    const patientName = `${firstNamePatient} ${lastNamePatient}`;

    await sendResultEmail({
      reciverEmail: email,
      patientName: patientName,
      doctorName: doctorName,
      image: image,
      time: time,
      reason: reason,
    });

    console.log(`Remedy sent to ${email} successfully.`);
    status.errCode = 0;
    status.errMessage = "Remedy sent successfully";
    return status;
  } catch (error) {
    console.log("sendRemedy error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const deleteScheduleDoctor = async (scheduleid) => {
  const status = {};
  try {
    if (!scheduleid) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    // Kiểm tra xem lịch hẹn có bệnh nhân đặt không
    const [bookings] = await connection.promise().query(
      `
        SELECT b.id, b.statusId
        FROM booking b
        WHERE b.scheduleId = ? AND b.statusId IN ('S1', 'S2')
      `,
      [scheduleid]
    );

    if (bookings.length > 0) {
      status.errCode = 2;
      status.errMessage = "Cannot delete schedule with existing patient bookings";
      return status;
    }

    // Nếu không có bệnh nhân đặt, thực hiện xóa
    await connection.promise().query(
      `
        DELETE FROM schedule WHERE id = ?
      `,
      [scheduleid]
    );

    status.errCode = 0;
    status.errMessage = "Delete schedule successfully";
    return status;
  } catch (error) {
    console.log("deleteScheduleDoctor error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const GetListAppointment = async (doctorId) => {
  const status = {};
  try {
    if (!doctorId) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      status.data = [];
      return status;
    }
    const [rows] = await connection.promise().query(
      `
         SELECT b.id, b.scheduleId, b.date, s.timeType, b.statusId, b.reason, b.patientId,
                s.doctorId, u.email, u.firstName, u.lastName, u.address, u.phoneNumber,
                a.value_vi AS timeTypeVi, a.value_en AS timeTypeEn
         FROM booking AS b
            INNER JOIN schedule AS s ON b.scheduleId = s.id
            LEFT JOIN users AS u ON b.patientId = u.id
            LEFT JOIN lookup AS a 
                ON s.timeType = a.keyMap AND a.type = 'TIME'
          WHERE s.doctorId = ?
          ORDER BY b.date DESC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
        `,
      [doctorId]
    );
    status.errCode = 0;
    status.errMessage = "OK";
    status.data = rows;
    return status;
  }
  catch (error) {
    console.log("GetListAppointment error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};


const ListBooking = async (user) => {
  try {
    const scope = getBookingListScope(user);
    if (!scope.allowed) {
      return {
        errCode: 403,
        errMessage: "Permission denied",
        data: [],
      };
    }

    const [rows] = await connection.promise().query(
      `
      SELECT 
          b.id,
          b.scheduleId,
          b.date,
          s.timeType,
          b.statusId,
          b.reason,
          b.token,

          -- Trạng thái khám bệnh
          ls.value_en AS statusEn,
          ls.value_vi AS statusVi,

          -- Khung giờ khám
          lt.value_en AS timeEn,
          lt.value_vi AS timeVi,

          -- Thông tin bác sĩ
          doctor.firstName AS doctorFirstName,
          doctor.lastName AS doctorLastName,
          doctor.email AS doctorEmail,

          -- Thông tin bệnh nhân
          patient.firstName AS patientFirstName,
          patient.lastName AS patientLastName,
          patient.email AS patientEmail,
          patient.phoneNumber AS patientPhoneNumber,
          patient.address AS patientAddress,
          patient.gender AS patientGender

      FROM booking b
      JOIN schedule s
          ON b.scheduleId = s.id

      -- JOIN bảng users cho bác sĩ
      JOIN users doctor 
          ON s.doctorId = doctor.id

      LEFT JOIN doctor_info di
          ON di.doctorId = s.doctorId

      LEFT JOIN clinic c
          ON c.id = di.clinicId

      -- JOIN bảng users cho bệnh nhân
      JOIN users patient
          ON b.patientId = patient.id

      -- Lookup STATUS
      LEFT JOIN lookup ls 
          ON b.statusId = ls.keyMap 
         AND ls.type = 'STATUS'

      -- Lookup TIME
      LEFT JOIN lookup lt
          ON s.timeType = lt.keyMap
         AND lt.type = 'TIME'

      ${scope.whereClause}
      ORDER BY b.date DESC, CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      scope.params
    );

    if (!rows || rows.length === 0) {
      return {
        errCode: 1,
        errMessage: "No bookings found",
        data: [],
      };
    }

    return {
      errCode: 0,
      errMessage: "OK",
      data: rows,
    };
  } catch (error) {
    console.log("ListBooking error:", error);
    return {
      errCode: 1,
      errMessage: error.message || "Database error",
      data: [],
    };
  }
};

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
  PostScheduleDoctor,
  GetcheScheduleDoctorByDate,
  GetListPatientForDoctor,
  sendRemedy,
  deleteScheduleDoctor,
  GetListAppointment,
  ListBooking,
  getRelatedDoctorsById,
  updateDoctorInfoOrder,
  changeStatusDoctorInfo
};
