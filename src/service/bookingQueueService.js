const moment = require("moment");
const { getDb, withTransaction } = require("./transactionService");

// Chuẩn hóa id bắt buộc và báo lỗi nếu id không phải số nguyên dương.
const normalizePositiveId = (value, fieldName) => {
  const normalized = Number(value);
  if (Number.isInteger(normalized) && normalized > 0) {
    return normalized;
  }

  const error = new Error(`Missing required parameter: ${fieldName}`);
  error.errCode = 1;
  throw error;
};

// Chuẩn hóa ngày hẹn về định dạng YYYY-MM-DD cho các truy vấn queue.
const normalizeAppointmentDate = (value) => {
  if (value instanceof Date) {
    return moment(value).format("YYYY-MM-DD");
  }

  const normalized = moment(value, ["YYYY-MM-DD", "DD/MM/YYYY", moment.ISO_8601], true);
  if (!normalized.isValid()) {
    const error = new Error("Invalid appointmentDate");
    error.errCode = 1;
    throw error;
  }

  return normalized.format("YYYY-MM-DD");
};

// Nhận diện lỗi trùng khóa để xử lý các luồng tạo queue idempotent.
const isDuplicateEntryError = (error) => error && error.code === "ER_DUP_ENTRY";

// Lấy dòng queue đã gán cho một booking, có thể khóa dòng khi đang trong transaction.
const getBookingQueueByBookingId = async (bookingId, db, options = {}) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT id, bookingId, doctorId, appointmentDate, queueNumber
      FROM booking_queue
      WHERE bookingId = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

// Lấy thông tin booking kèm bác sĩ và queue hiện tại để kiểm tra phạm vi cấp số.
const getBookingQueueContext = async (bookingId, db, options = {}) => {
  const normalizedBookingId = normalizePositiveId(bookingId, "bookingId");
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        b.id AS bookingId,
        b.patientId,
        b.scheduleId,
        b.date AS appointmentDate,
        b.statusId AS bookingStatusId,
        s.doctorId,
        bq.id AS bookingQueueId,
        bq.queueNumber
      FROM booking b
      INNER JOIN schedule s
        ON s.id = b.scheduleId
      LEFT JOIN booking_queue bq
        ON bq.bookingId = b.id
      WHERE b.id = ?
      LIMIT 1
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [normalizedBookingId]
  );

  return rows[0] || null;
};

// Tạo dòng sequence cho cặp bác sĩ/ngày nếu chưa có để chuẩn bị cấp STT.
const createSequenceRowIfMissing = async (db, doctorId, appointmentDate) => {
  await db.query(
    `
      INSERT INTO booking_queue_sequence (doctorId, appointmentDate, currentNumber)
      VALUES (?, ?, 0)
      ON DUPLICATE KEY UPDATE currentNumber = currentNumber
    `,
    [doctorId, appointmentDate]
  );
};

// Khóa dòng sequence hiện tại để tránh hai transaction cấp cùng một STT.
const lockSequenceRow = async (db, doctorId, appointmentDate) => {
  const [rows] = await db.query(
    `
      SELECT currentNumber
      FROM booking_queue_sequence
      WHERE doctorId = ? AND appointmentDate = ?
      LIMIT 1
      FOR UPDATE
    `,
    [doctorId, appointmentDate]
  );

  if (rows.length === 0) {
    const error = new Error("Booking queue sequence row was not created");
    error.errCode = 2;
    throw error;
  }

  return Number(rows[0].currentNumber) || 0;
};

// Tìm STT lớn nhất đã tồn tại trong ngày để tự hồi phục nếu sequence bị lệch.
const getMaxQueueNumberForScope = async (db, doctorId, appointmentDate) => {
  const [rows] = await db.query(
    `
      SELECT COALESCE(MAX(queueNumber), 0) AS maxQueueNumber
      FROM booking_queue
      WHERE doctorId = ? AND appointmentDate = ?
    `,
    [doctorId, appointmentDate]
  );

  return Number(rows[0]?.maxQueueNumber) || 0;
};

// Gán STT khám cho booking trong transaction hiện tại, đảm bảo cùng booking chỉ nhận một số.
const assignBookingQueueNumberInCurrentTransaction = async (data, db) => {
  const executor = getDb(db);
  const bookingId = normalizePositiveId(data?.bookingId, "bookingId");
  const doctorId = normalizePositiveId(data?.doctorId, "doctorId");
  const appointmentDate = normalizeAppointmentDate(data?.appointmentDate);
  const bookingContext = await getBookingQueueContext(bookingId, executor, {
    forUpdate: true,
  });

  if (!bookingContext) {
    const error = new Error("Booking not found");
    error.errCode = 2;
    throw error;
  }

  const bookingAppointmentDate = normalizeAppointmentDate(bookingContext.appointmentDate);
  if (
    Number(bookingContext.doctorId) !== doctorId ||
    bookingAppointmentDate !== appointmentDate
  ) {
    const error = new Error("Booking does not match queue scope");
    error.errCode = 3;
    throw error;
  }

  if (bookingContext.bookingQueueId) {
    return {
      created: false,
      data: {
        id: bookingContext.bookingQueueId,
        bookingId: bookingContext.bookingId,
        doctorId: bookingContext.doctorId,
        appointmentDate: bookingAppointmentDate,
        queueNumber: bookingContext.queueNumber,
      },
    };
  }

  // Khóa sequence rồi lấy số lớn hơn giữa sequence và dữ liệu queue thực tế.
  await createSequenceRowIfMissing(executor, doctorId, appointmentDate);
  const currentNumber = await lockSequenceRow(executor, doctorId, appointmentDate);
  const maxQueueNumber = await getMaxQueueNumberForScope(
    executor,
    doctorId,
    appointmentDate
  );
  const queueNumber = Math.max(currentNumber, maxQueueNumber) + 1;

  await executor.query(
    `
      UPDATE booking_queue_sequence
      SET currentNumber = ?
      WHERE doctorId = ? AND appointmentDate = ?
    `,
    [queueNumber, doctorId, appointmentDate]
  );

  try {
    // Tạo queue mới; nếu race-condition gây trùng khóa thì đọc lại queue đã được transaction khác tạo.
    const [insertResult] = await executor.query(
      `
        INSERT INTO booking_queue (bookingId, doctorId, appointmentDate, queueNumber)
        VALUES (?, ?, ?, ?)
      `,
      [bookingId, doctorId, appointmentDate, queueNumber]
    );

    return {
      created: true,
      data: {
        id: insertResult.insertId,
        bookingId,
        doctorId,
        appointmentDate,
        queueNumber,
      },
    };
  } catch (error) {
    if (!isDuplicateEntryError(error)) {
      throw error;
    }

    const queue = await getBookingQueueByBookingId(bookingId, executor, {
      forUpdate: true,
    });

    if (queue) {
      return { created: false, data: queue };
    }

    throw error;
  }
};

// Gán STT khám, tự mở transaction nếu caller chưa truyền transaction vào.
const assignBookingQueueNumber = async (data, db) => {
  if (db) {
    return assignBookingQueueNumberInCurrentTransaction(data, db);
  }

  return withTransaction((transactionDb) =>
    assignBookingQueueNumberInCurrentTransaction(data, transactionDb)
  );
};

module.exports = {
  getBookingQueueByBookingId,
  getBookingQueueContext,
  assignBookingQueueNumberInCurrentTransaction,
  assignBookingQueueNumber,
};
