const connection = require("../config/data");
const { getDb, withTransaction } = require("./transactionService");
const { createDoctorNotification } = require("./doctorNotificationService");
const {
  BOOKING_STATUS,
  LOOKUP_TYPES,
  REVIEW_STATUS,
  assertLookupKey,
} = require("./workflowStatusService");

const ROLE_ADMIN = "R1";
const ROLE_DOCTOR = "R2";
const ROLE_PATIENT = "R3";
const DEFAULT_LIMIT = 10;
const MAX_LIMIT = 50;
const MAX_TEXT_LENGTH = 1000;
const MAX_DATE_RANGE_DAYS = 30;
const REVIEW_NOTIFICATION_TYPE = "NEW_REVIEW";
const STAR_VALUES = [5, 4, 3, 2, 1];

const ok = (data, extra = {}) => ({ errCode: 0, errMessage: "OK", data, ...extra });
const fail = (errMessage, errCode = 1, statusCode = 400, data = {}) => ({
  errCode,
  errMessage,
  statusCode,
  data,
});

const normalizePositiveId = (value) => {
  const normalized = Number(value);
  return Number.isInteger(normalized) && normalized > 0 ? normalized : null;
};

const normalizeRating = (value) => {
  if (typeof value === "string" && !/^[1-5]$/.test(value.trim())) {
    return { ok: false, errMessage: "Rating must be an integer from 1 to 5" };
  }

  const rating = Number(value);
  if (!Number.isInteger(rating) || rating < 1 || rating > 5) {
    return { ok: false, errMessage: "Rating must be an integer from 1 to 5" };
  }

  return { ok: true, value: rating };
};

const normalizeLimitedText = (value, fieldName = "Content") => {
  const text = String(value || "").trim();
  if (!text) return { ok: false, errMessage: `${fieldName} is required` };
  if (text.length > MAX_TEXT_LENGTH) {
    return {
      ok: false,
      errMessage: `${fieldName} must be ${MAX_TEXT_LENGTH} characters or fewer`,
    };
  }
  return { ok: true, value: text };
};

const normalizePageLimit = (query = {}) => {
  const page = Math.max(1, Number.parseInt(query.page, 10) || 1);
  const rawLimit = Number.parseInt(query.limit, 10) || DEFAULT_LIMIT;
  const limit = Math.min(Math.max(1, rawLimit), MAX_LIMIT);
  return { page, limit, offset: (page - 1) * limit };
};

const parseDateOnly = (value) => {
  const text = String(value || "").trim();
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(text);
  if (!match) return null;
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const date = new Date(year, month - 1, day);
  if (
    date.getFullYear() !== year ||
    date.getMonth() !== month - 1 ||
    date.getDate() !== day
  ) {
    return null;
  }
  return { text, date };
};

const startOfToday = () => {
  const today = new Date();
  return new Date(today.getFullYear(), today.getMonth(), today.getDate());
};

const validateDateRange = ({ dateFrom, dateTo } = {}) => {
  const fromText = String(dateFrom || "").trim();
  const toText = String(dateTo || "").trim();
  const from = fromText ? parseDateOnly(fromText) : null;
  const to = toText ? parseDateOnly(toText) : null;

  if ((fromText && !from) || (toText && !to)) {
    return { ok: false, errMessage: "Invalid date range" };
  }

  const today = startOfToday();
  if ((from && from.date > today) || (to && to.date > today)) {
    return { ok: false, errMessage: "Date range cannot include future dates" };
  }

  if (from && to) {
    if (from.date > to.date) {
      return { ok: false, errMessage: "dateFrom cannot be after dateTo" };
    }

    const days = Math.floor((to.date - from.date) / 86400000) + 1;
    if (days > MAX_DATE_RANGE_DAYS) {
      return { ok: false, errMessage: "Date range cannot exceed 30 days" };
    }
  }

  return { ok: true, dateFrom: from?.text || null, dateTo: to?.text || null };
};

const normalizeStatus = (value) => {
  const statusId = String(value || "").trim();
  if (!statusId) return { ok: true, value: null };
  if (![REVIEW_STATUS.VISIBLE, REVIEW_STATUS.HIDDEN].includes(statusId)) {
    return { ok: false, errMessage: "Invalid review status" };
  }
  return { ok: true, value: statusId };
};

const getReviewEligibilityFromBooking = (booking = {}) => {
  const reviewed = Boolean(booking.reviewId);
  if (reviewed) return { eligible: false, reviewed: true, reason: "ALREADY_REVIEWED" };

  switch (booking.statusId) {
    case BOOKING_STATUS.COMPLETED:
      return { eligible: true, reviewed: false, reason: null };
    case BOOKING_STATUS.CANCELLED_BY_PATIENT:
    case BOOKING_STATUS.CANCELLED_BY_DOCTOR:
      return { eligible: false, reviewed: false, reason: "BOOKING_CANCELLED" };
    case BOOKING_STATUS.REJECTED_BY_DOCTOR:
      return { eligible: false, reviewed: false, reason: "DOCTOR_REJECTED" };
    case BOOKING_STATUS.PATIENT_NO_SHOW:
      return { eligible: false, reviewed: false, reason: "PATIENT_NO_SHOW" };
    default:
      return { eligible: false, reviewed: false, reason: "BOOKING_NOT_COMPLETED" };
  }
};

const buildRatingSummary = (rows = []) => {
  const ratingCounts = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
  rows.forEach((row) => {
    const rating = Number(row.rating);
    if (ratingCounts[rating] !== undefined) {
      ratingCounts[rating] = Number(row.count) || 0;
    }
  });

  const totalReviews = Object.values(ratingCounts).reduce((sum, count) => sum + count, 0);
  const weightedSum = Object.entries(ratingCounts).reduce(
    (sum, [rating, count]) => sum + Number(rating) * count,
    0
  );
  const averageRating = totalReviews ? Math.round((weightedSum / totalReviews) * 10) / 10 : 0;
  const ratingPercentages = STAR_VALUES.reduce((acc, rating) => {
    acc[rating] = totalReviews ? Math.round((ratingCounts[rating] / totalReviews) * 100) : 0;
    return acc;
  }, {});

  return { averageRating, totalReviews, ratingCounts, ratingPercentages };
};

const getName = (firstName, lastName, fallback = "-") =>
  `${firstName || ""} ${lastName || ""}`.replace(/\s+/g, " ").trim() || fallback;

const formatReviewRow = (row = {}) => ({
  id: row.id,
  bookingId: row.bookingId,
  patientId: row.patientId,
  doctorId: row.doctorId,
  rating: Number(row.rating) || 0,
  comment: row.comment || "",
  statusId: row.statusId,
  isHidden: row.statusId === REVIEW_STATUS.HIDDEN,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  appointmentDate: row.appointmentDate || null,
  timeVi: row.timeVi || row.timeEn || null,
  timeEn: row.timeEn || row.timeVi || null,
  appointmentTypeVi: row.appointmentTypeVi || null,
  appointmentTypeEn: row.appointmentTypeEn || null,
  patientName: getName(row.patientFirstName, row.patientLastName, "Bệnh nhân"),
  patientFirstName: row.patientFirstName || null,
  patientLastName: row.patientLastName || null,
  patientImage: row.patientImage || null,
  doctorName: getName(row.doctorFirstName, row.doctorLastName, "Bác sĩ"),
  doctorFirstName: row.doctorFirstName || null,
  doctorLastName: row.doctorLastName || null,
  doctorImage: row.doctorImage || null,
  specialtyName: row.specialtyName || null,
  reply: row.replyId
    ? {
        id: row.replyId,
        content: row.replyContent || "",
        doctorId: row.replyDoctorId,
        createdAt: row.replyCreatedAt,
        updatedAt: row.replyUpdatedAt,
      }
    : null,
});

const selectReviewSql = `
  SELECT
    dr.id, dr.bookingId, dr.patientId, dr.doctorId, dr.rating, dr.comment,
    dr.statusId, dr.createdAt, dr.updatedAt,
    b.date AS appointmentDate,
    COALESCE(lt.value_vi, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeVi,
    COALESCE(lt.value_en, CONCAT(TIME_FORMAT(s.startTime, '%H:%i'), ' - ', TIME_FORMAT(s.endTime, '%H:%i'))) AS timeEn,
    lat.value_vi AS appointmentTypeVi,
    lat.value_en AS appointmentTypeEn,
    patient.firstName AS patientFirstName,
    patient.lastName AS patientLastName,
    patient.image AS patientImage,
    doctor.firstName AS doctorFirstName,
    doctor.lastName AS doctorLastName,
    doctor.image AS doctorImage,
    specialty.name AS specialtyName,
    reply.id AS replyId,
    reply.doctorId AS replyDoctorId,
    reply.content AS replyContent,
    reply.createdAt AS replyCreatedAt,
    reply.updatedAt AS replyUpdatedAt
  FROM doctor_reviews dr
  INNER JOIN booking b ON b.id = dr.bookingId
  INNER JOIN schedule s ON s.id = b.scheduleId
  INNER JOIN users patient ON patient.id = dr.patientId
  INNER JOIN users doctor ON doctor.id = dr.doctorId
  LEFT JOIN doctor_info di ON di.doctorId = dr.doctorId
  LEFT JOIN specialty ON specialty.id = di.specialtyId
  LEFT JOIN doctor_review_replies reply ON reply.reviewId = dr.id
  LEFT JOIN lookup lt ON lt.keyMap = s.timeType AND lt.type = 'TIME'
  LEFT JOIN lookup lat ON lat.keyMap = s.appointmentTypeId AND lat.type = 'APPOINTMENT_TYPE'
`;

const getReviewById = async (reviewId, db) => {
  const [rows] = await getDb(db).query(
    `${selectReviewSql} WHERE dr.id = ? LIMIT 1`,
    [reviewId]
  );
  return rows[0] ? formatReviewRow(rows[0]) : null;
};

const getSummary = async ({ doctorId, dateRange = {}, visibleOnly = true }, db) => {
  const filters = [];
  const params = [];

  if (doctorId) {
    filters.push("doctorId = ?");
    params.push(doctorId);
  }
  if (visibleOnly) {
    filters.push("statusId = ?");
    params.push(REVIEW_STATUS.VISIBLE);
  }
  if (dateRange.dateFrom) {
    filters.push("createdAt >= ?");
    params.push(`${dateRange.dateFrom} 00:00:00`);
  }
  if (dateRange.dateTo) {
    filters.push("createdAt <= ?");
    params.push(`${dateRange.dateTo} 23:59:59`);
  }

  const where = filters.length ? `WHERE ${filters.join(" AND ")}` : "";
  const [rows] = await getDb(db).query(
    `SELECT rating, COUNT(*) AS count FROM doctor_reviews ${where} GROUP BY rating`,
    params
  );
  return buildRatingSummary(rows);
};

const appendDateFilters = (filters, params, dateRange) => {
  if (dateRange.dateFrom) {
    filters.push("dr.createdAt >= ?");
    params.push(`${dateRange.dateFrom} 00:00:00`);
  }
  if (dateRange.dateTo) {
    filters.push("dr.createdAt <= ?");
    params.push(`${dateRange.dateTo} 23:59:59`);
  }
};

const listReviews = async ({ filters, params, page, limit, offset }) => {
  const where = filters.length ? `WHERE ${filters.join(" AND ")}` : "";
  const [[countRow]] = await connection.promise().query(
    `
      SELECT COUNT(*) AS total
      FROM doctor_reviews dr
      INNER JOIN users patient ON patient.id = dr.patientId
      INNER JOIN users doctor ON doctor.id = dr.doctorId
      ${where}
    `,
    params
  );
  const [rows] = await connection.promise().query(
    `
      ${selectReviewSql}
      ${where}
      ORDER BY dr.createdAt DESC, dr.id DESC
      LIMIT ? OFFSET ?
    `,
    [...params, limit, offset]
  );
  const totalItems = Number(countRow?.total) || 0;
  return {
    reviews: rows.map(formatReviewRow),
    pagination: {
      page,
      limit,
      totalItems,
      totalPages: Math.max(1, Math.ceil(totalItems / limit)),
    },
  };
};

const getPublicDoctorReviews = async (doctorIdValue, query = {}) => {
  const doctorId = normalizePositiveId(doctorIdValue);
  if (!doctorId) return fail("Missing required parameter: doctorId");

  const ratingFilter = normalizeRating(query.rating || "");
  const rating = query.rating ? ratingFilter.value : null;
  if (query.rating && !ratingFilter.ok) return fail(ratingFilter.errMessage);

  const { page, limit, offset } = normalizePageLimit(query);
  const filters = ["dr.doctorId = ?", "dr.statusId = ?"];
  const params = [doctorId, REVIEW_STATUS.VISIBLE];
  if (rating) {
    filters.push("dr.rating = ?");
    params.push(rating);
  }

  const summary = await getSummary({ doctorId, visibleOnly: true });
  const listed = await listReviews({ filters, params, page, limit, offset });
  return ok(
    { summary, reviews: listed.reviews, pagination: listed.pagination },
    { summary, reviews: listed.reviews, pagination: listed.pagination }
  );
};

const getBookingReviewEligibility = async (user, bookingIdValue) => {
  if (user?.roleId !== ROLE_PATIENT) {
    return fail("Patient permission required", 403, 403, {
      eligible: false,
      reviewed: false,
      reason: "BOOKING_NOT_OWNED",
    });
  }

  const bookingId = normalizePositiveId(bookingIdValue);
  if (!bookingId) return fail("Missing required parameter: bookingId");

  const [rows] = await connection.promise().query(
    `
      SELECT b.id, b.patientId, b.statusId, s.doctorId, dr.id AS reviewId
      FROM booking b
      INNER JOIN schedule s ON s.id = b.scheduleId
      LEFT JOIN doctor_reviews dr ON dr.bookingId = b.id
      WHERE b.id = ?
      LIMIT 1
    `,
    [bookingId]
  );
  const booking = rows[0];
  if (!booking || Number(booking.patientId) !== Number(user.id)) {
    return fail("Booking not found", 404, 404, {
      eligible: false,
      reviewed: false,
      reason: "BOOKING_NOT_OWNED",
    });
  }

  return ok(getReviewEligibilityFromBooking(booking));
};

const createBookingReview = async (user, bookingIdValue, payload = {}) => {
  if (user?.roleId !== ROLE_PATIENT) {
    return fail("Patient permission required", 403, 403);
  }

  const bookingId = normalizePositiveId(bookingIdValue);
  const rating = normalizeRating(payload.rating);
  const comment = normalizeLimitedText(payload.comment, "Comment");
  if (!bookingId) return fail("Missing required parameter: bookingId");
  if (!rating.ok) return fail(rating.errMessage);
  if (!comment.ok) return fail(comment.errMessage);

  try {
    return await withTransaction(async (db) => {
      await assertLookupKey(LOOKUP_TYPES.REVIEW_STATUS, REVIEW_STATUS.VISIBLE, db);
      const [rows] = await db.query(
        `
          SELECT b.id, b.patientId, b.statusId, s.doctorId,
            patient.firstName AS patientFirstName,
            patient.lastName AS patientLastName,
            dr.id AS reviewId
          FROM booking b
          INNER JOIN schedule s ON s.id = b.scheduleId
          INNER JOIN users patient ON patient.id = b.patientId
          LEFT JOIN doctor_reviews dr ON dr.bookingId = b.id
          WHERE b.id = ?
          LIMIT 1
          FOR UPDATE
        `,
        [bookingId]
      );
      const booking = rows[0];
      if (!booking || Number(booking.patientId) !== Number(user.id)) {
        return fail("Booking not found", 404, 404);
      }

      const eligibility = getReviewEligibilityFromBooking(booking);
      if (!eligibility.eligible) {
        return fail(eligibility.reason || "Booking is not eligible for review", 409, 409, eligibility);
      }

      const [result] = await db.query(
        `
          INSERT INTO doctor_reviews
            (bookingId, patientId, doctorId, rating, comment, statusId)
          VALUES (?, ?, ?, ?, ?, ?)
        `,
        [booking.id, booking.patientId, booking.doctorId, rating.value, comment.value, REVIEW_STATUS.VISIBLE]
      );

      const patientName = getName(booking.patientFirstName, booking.patientLastName, "bệnh nhân");
      await createDoctorNotification(
        {
          doctorId: booking.doctorId,
          bookingId: booking.id,
          reviewId: result.insertId,
          type: REVIEW_NOTIFICATION_TYPE,
          content: `Bạn vừa nhận được đánh giá ${rating.value} sao từ bệnh nhân ${patientName}.`,
        },
        db
      );

      const review = await getReviewById(result.insertId, db);
      return ok(review);
    });
  } catch (error) {
    if (error?.code === "ER_DUP_ENTRY") {
      return fail("Booking has already been reviewed", 409, 409);
    }
    return fail(error.message || "Error from server");
  }
};

const parseListFilters = (query = {}) => {
  const ratingResult = query.rating ? normalizeRating(query.rating) : { ok: true, value: null };
  if (!ratingResult.ok) return ratingResult;
  const statusResult = normalizeStatus(query.status);
  if (!statusResult.ok) return statusResult;
  const dateRange = validateDateRange(query);
  if (!dateRange.ok) return dateRange;
  return { ok: true, rating: ratingResult.value, statusId: statusResult.value, dateRange };
};

const getDoctorReviews = async (user, query = {}) => {
  if (user?.roleId !== ROLE_DOCTOR || !normalizePositiveId(user.id)) {
    return fail("Doctor permission required", 403, 403);
  }

  const parsed = parseListFilters(query);
  if (!parsed.ok) return fail(parsed.errMessage);
  const { page, limit, offset } = normalizePageLimit(query);
  const filters = ["dr.doctorId = ?"];
  const params = [Number(user.id)];
  appendDateFilters(filters, params, parsed.dateRange);
  if (parsed.rating) {
    filters.push("dr.rating = ?");
    params.push(parsed.rating);
  }
  if (parsed.statusId) {
    filters.push("dr.statusId = ?");
    params.push(parsed.statusId);
  }
  const reviewId = normalizePositiveId(query.reviewId);
  if (reviewId) {
    filters.push("dr.id = ?");
    params.push(reviewId);
  }

  const summary = await getSummary({
    doctorId: Number(user.id),
    dateRange: parsed.dateRange,
    visibleOnly: true,
  });
  const listed = await listReviews({ filters, params, page, limit, offset });
  return ok(
    { summary, reviews: listed.reviews, pagination: listed.pagination },
    { summary, reviews: listed.reviews, pagination: listed.pagination }
  );
};

const getAdminReviews = async (user, query = {}) => {
  if (user?.roleId !== ROLE_ADMIN) return fail("Admin permission required", 403, 403);

  const parsed = parseListFilters(query);
  if (!parsed.ok) return fail(parsed.errMessage);
  const { page, limit, offset } = normalizePageLimit(query);
  const filters = [];
  const params = [];
  appendDateFilters(filters, params, parsed.dateRange);
  if (parsed.rating) {
    filters.push("dr.rating = ?");
    params.push(parsed.rating);
  }
  if (parsed.statusId) {
    filters.push("dr.statusId = ?");
    params.push(parsed.statusId);
  }
  const doctorId = normalizePositiveId(query.doctorId);
  if (doctorId) {
    filters.push("dr.doctorId = ?");
    params.push(doctorId);
  }
  const search = String(query.search || query.patientName || query.doctorName || "").trim();
  if (search) {
    const keyword = `%${search}%`;
    filters.push(`(
      CONCAT_WS(' ', patient.firstName, patient.lastName) LIKE ?
      OR CONCAT_WS(' ', doctor.firstName, doctor.lastName) LIKE ?
      OR patient.email LIKE ?
      OR doctor.email LIKE ?
    )`);
    params.push(keyword, keyword, keyword, keyword);
  }

  const summary = await getSummary({ dateRange: parsed.dateRange, visibleOnly: true });
  const listed = await listReviews({ filters, params, page, limit, offset });
  return ok(
    { summary, reviews: listed.reviews, pagination: listed.pagination },
    { summary, reviews: listed.reviews, pagination: listed.pagination }
  );
};

const saveDoctorReviewReply = async (user, reviewIdValue, payload = {}, mode = "create") => {
  if (user?.roleId !== ROLE_DOCTOR || !normalizePositiveId(user.id)) {
    return fail("Doctor permission required", 403, 403);
  }
  const reviewId = normalizePositiveId(reviewIdValue);
  const content = normalizeLimitedText(payload.content, "Reply");
  if (!reviewId) return fail("Missing required parameter: reviewId");
  if (!content.ok) return fail(content.errMessage);

  return withTransaction(async (db) => {
    const [rows] = await db.query(
      `SELECT id, doctorId FROM doctor_reviews WHERE id = ? LIMIT 1 FOR UPDATE`,
      [reviewId]
    );
    const review = rows[0];
    if (!review || Number(review.doctorId) !== Number(user.id)) {
      return fail("Review not found", 404, 404);
    }

    const [replyRows] = await db.query(
      `SELECT id FROM doctor_review_replies WHERE reviewId = ? LIMIT 1`,
      [reviewId]
    );
    const hasReply = replyRows.length > 0;
    if (mode === "create" && hasReply) {
      return fail("Review already has a doctor reply", 409, 409);
    }
    if (mode === "update" && !hasReply) {
      return fail("Reply not found", 404, 404);
    }

    if (mode === "create") {
      await db.query(
        `INSERT INTO doctor_review_replies (reviewId, doctorId, content) VALUES (?, ?, ?)`,
        [reviewId, user.id, content.value]
      );
    } else {
      await db.query(
        `UPDATE doctor_review_replies SET content = ?, updatedAt = CURRENT_TIMESTAMP WHERE reviewId = ?`,
        [content.value, reviewId]
      );
    }

    return ok(await getReviewById(reviewId, db));
  });
};

const updateReviewVisibility = async (user, reviewIdValue, payload = {}) => {
  if (user?.roleId !== ROLE_ADMIN) return fail("Admin permission required", 403, 403);
  const reviewId = normalizePositiveId(reviewIdValue);
  if (!reviewId) return fail("Missing required parameter: reviewId");
  if (payload.hidden !== true && payload.hidden !== false) {
    return fail("hidden must be true or false");
  }
  return withTransaction(async (db) => {
    const [rows] = await db.query(
      `SELECT id, statusId FROM doctor_reviews WHERE id = ? LIMIT 1 FOR UPDATE`,
      [reviewId]
    );
    const review = rows[0];
    if (!review) return fail("Review not found", 404, 404);

    const nextStatusId = payload.hidden ? REVIEW_STATUS.HIDDEN : REVIEW_STATUS.VISIBLE;
    await assertLookupKey(LOOKUP_TYPES.REVIEW_STATUS, nextStatusId, db);
    if (review.statusId !== nextStatusId) {
      await db.query(
        "UPDATE doctor_reviews SET statusId = ? WHERE id = ?",
        [nextStatusId, reviewId]
      );
    }

    return ok(await getReviewById(reviewId, db));
  });
};

module.exports = {
  MAX_DATE_RANGE_DAYS,
  MAX_TEXT_LENGTH,
  REVIEW_NOTIFICATION_TYPE,
  STAR_VALUES,
  buildRatingSummary,
  createBookingReview,
  getAdminReviews,
  getBookingReviewEligibility,
  getDoctorReviews,
  getPublicDoctorReviews,
  getReviewEligibilityFromBooking,
  normalizeLimitedText,
  normalizeRating,
  saveDoctorReviewReply,
  updateReviewVisibility,
  validateDateRange,
};
