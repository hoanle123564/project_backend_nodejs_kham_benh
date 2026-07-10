const connection = require("../../config/data");
const moment = require("moment");
const { getDoctorPriceAtBooking, parsePriceToNumber } = require("../adminDashboardService");

const normalizeDate = (dateValue) => {
  if (!dateValue) return null;

  // Nếu là chuỗi DD/MM/YYYY
  if (typeof dateValue === "string" && dateValue.includes("/")) {
    return moment(dateValue, "DD/MM/YYYY", true).format("YYYY-MM-DD");
  }

  // Nếu là đối tượng Date hoặc ISO string
  return moment(dateValue).format("YYYY-MM-DD");
};

const DEFAULT_APPOINTMENT_TYPE_ID = "AT1";

const normalizeSchedulePrice = (value) => {
  if (value === undefined || value === null || value === "") {
    return { ok: true, value: null, provided: false };
  }

  const price = Number(value);
  if (!Number.isFinite(price) || price < 0 || !Number.isInteger(price)) {
    return { ok: false, value: null, provided: true };
  }

  return { ok: true, value: price, provided: true };
};

const resolveSchedulePriceForSave = async (doctorId, appointmentTypeId, value) => {
  const normalized = normalizeSchedulePrice(value);
  if (!normalized.ok || normalized.provided) {
    return normalized;
  }

  const defaultPrice = await getDoctorPriceAtBooking(doctorId, appointmentTypeId);
  return {
    ok: true,
    value: defaultPrice > 0 ? defaultPrice : null,
    provided: false,
  };
};

const PostScheduleDoctor = async (data) => {
  const status = {};
  try {
    if (!data || !data.doctorId || !data.date || !data.timeType) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const { doctorId, date, timeType } = data;
    const appointmentTypeId =
      data.appointmentTypeId && String(data.appointmentTypeId).trim()
        ? String(data.appointmentTypeId).trim()
        : DEFAULT_APPOINTMENT_TYPE_ID;
    const schedulePrice = await resolveSchedulePriceForSave(
      doctorId,
      appointmentTypeId,
      data.price
    );

    if (!schedulePrice.ok) {
      status.errCode = 2;
      status.errMessage = "Schedule price must be a valid non-negative integer";
      return status;
    }

    // Chuẩn hóa định dạng ngày (trước khi dùng)

    // Chuẩn bị mảng insert
    let values = timeType.map((slot) => [
      doctorId,
      date,
      slot,
      appointmentTypeId,
      schedulePrice.value,
    ]);
    console.log("Bulk insert values:", values);

    const [rows] = await connection
      .promise()
      .query(`SELECT doctorId, date, timeType FROM schedule`);

    // Lọc trùng
    values = values.filter((v) => {
      return !rows.some((row) => {
        console.log("row.date", row.date);

        const rowDate = moment(row.date).format("YYYY-MM-DD");
        v[1] = moment(v[1], ["DD/MM/YYYY", moment.ISO_8601]).format(
          "YYYY-MM-DD"
        );
        return (
          Number(row.doctorId) === Number(v[0]) &&
          rowDate === v[1] &&
          row.timeType === v[2]
        );
      });
    });

    console.log("Values after filter:", values);

    //  Chuyển tất cả date về YYYY-DD-MM một lần nữa để chắc chắn
    values = values.map((v) => {
      v[1] = moment(v[1], ["DD/MM/YYYY", moment.ISO_8601]).format("YYYY-MM-DD");
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
      INSERT INTO schedule (doctorId, date, timeType, appointmentTypeId, price)
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
       SELECT s.id, s.doctorId, s.date, s.timeType, s.appointmentTypeId, s.price,
            COALESCE(activeBooking.bookedCount, 0) AS bookedCount,
            CASE WHEN COALESCE(activeBooking.bookedCount, 0) > 0 THEN 1 ELSE 0 END AS hasActiveBooking,
            a.value_vi, a.value_en,
            appointmentType.value_vi AS appointmentTypeVi,
            appointmentType.value_en AS appointmentTypeEn,
            offlinePrice.value_vi AS defaultOfflinePrice,
            onlinePrice.value_vi AS defaultOnlinePrice
    FROM schedule AS s
    LEFT JOIN doctor_info AS di
        ON di.doctorId = s.doctorId
    LEFT JOIN (
        SELECT scheduleId, COUNT(*) AS bookedCount
        FROM booking
        WHERE statusId <> 'S4'
        GROUP BY scheduleId
    ) AS activeBooking
        ON activeBooking.scheduleId = s.id
    LEFT JOIN lookup AS a
        ON s.timeType = a.keyMap AND a.type = 'TIME'
    LEFT JOIN lookup AS appointmentType
        ON s.appointmentTypeId = appointmentType.keyMap AND appointmentType.type = 'APPOINTMENT_TYPE'
    LEFT JOIN lookup AS offlinePrice
        ON offlinePrice.keyMap = di.priceId AND offlinePrice.type = 'PRICE'
    LEFT JOIN lookup AS onlinePrice
        ON onlinePrice.keyMap = di.onlinePriceId AND onlinePrice.type = 'PRICE'
    WHERE s.doctorId = ? AND s.date = ?
    ORDER BY CAST(SUBSTRING(s.timeType, 2) AS UNSIGNED) ASC
      `,
      [doctorId, normalizedDate]
    );
    console.log("schedules", rows);
    const data = rows.map((row) => {
      const price = row.price !== null && row.price !== undefined ? Number(row.price) : null;
      const defaultPrice = parsePriceToNumber(
        row.appointmentTypeId === "AT2" ? row.defaultOnlinePrice : row.defaultOfflinePrice
      );

      return {
        ...row,
        price,
        bookedCount: Number(row.bookedCount) || 0,
        hasActiveBooking: Number(row.hasActiveBooking) ? 1 : 0,
        defaultPrice,
        effectivePrice: price !== null ? price : defaultPrice,
      };
    });

    status.errCode = 0;
    status.errMessage = "OK";
    status.data = data;
    return status;
  } catch (error) {
    console.log("GetcheScheduleDoctorByDate error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = [];
    return status;
  }
};

const updateScheduleDoctor = async (data) => {
  const status = {};
  try {
    if (!data || !data.id) {
      status.errCode = 1;
      status.errMessage = "Missing required parameters";
      return status;
    }

    const normalized = normalizeSchedulePrice(data.price);
    if (!normalized.ok) {
      status.errCode = 2;
      status.errMessage = "Schedule price must be a valid non-negative integer";
      return status;
    }

    await connection.promise().query(
      `
      UPDATE schedule
      SET price = ?
      WHERE id = ?
      `,
      [normalized.value, data.id]
    );

    status.errCode = 0;
    status.errMessage = "Update schedule successfully";
    status.data = { id: data.id, price: normalized.value };
    return status;
  } catch (error) {
    console.log("updateScheduleDoctor error:", error);
    status.errCode = 1;
    status.errMessage = error.message || "Database error";
    status.data = {};
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

module.exports = {
  normalizeDate,
  PostScheduleDoctor,
  GetcheScheduleDoctorByDate,
  updateScheduleDoctor,
  deleteScheduleDoctor,
};
