const connection = require("../../config/data");
const moment = require("moment");
const { getDoctorPriceAtBooking, parsePriceToNumber } = require("../adminDashboardService");
const { getDb, withTransaction } = require("../transactionService");
const {
  buildCapacitySummary,
  cancelBookingsByScheduleChangeInCurrentTransaction,
  getCapacityExcludedStatusIds,
} = require("../bookingStatusService");
const {
  APPOINTMENT_TYPES,
  RULE_TYPES,
  SOURCE_TYPES,
  calculateFinalPrice,
  generateSlots,
  getTimeLabel,
  isDateInBookingWindow,
  isScheduleStarted,
  normalizeDate,
  normalizeTime,
  rangesOverlap,
  validateRulePayload,
} = require("./doctorSchedulePolicy");

const DEFAULT_APPOINTMENT_TYPE_ID = "AT1";
const DEFAULT_MAX_BOOKING_AHEAD_DAYS = 30;
const DYNAMIC_TIME_TYPE_PREFIX = "D";
const CAPACITY_EXCLUDED_STATUS_IDS = getCapacityExcludedStatusIds();

const activeStatusPlaceholders = () => CAPACITY_EXCLUDED_STATUS_IDS.map(() => "?").join(", ");

const normalizePositiveId = (value) => {
  const id = Number(value);
  return Number.isInteger(id) && id > 0 ? id : null;
};

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

const resolveSchedulePriceForSave = async (doctorId, appointmentTypeId, value, db) => {
  const normalized = normalizeSchedulePrice(value);
  if (!normalized.ok || normalized.provided) {
    return normalized;
  }

  const defaultPrice = await getDoctorPriceAtBooking(doctorId, appointmentTypeId, db);
  return {
    ok: true,
    value: defaultPrice > 0 ? defaultPrice : null,
    provided: false,
  };
};

const normalizeAppointmentType = (value, fallback = DEFAULT_APPOINTMENT_TYPE_ID) => {
  const appointmentTypeId = value ? String(value).trim() : fallback;
  return APPOINTMENT_TYPES.includes(appointmentTypeId) ? appointmentTypeId : fallback;
};

const buildDynamicTimeType = (startTime, endTime) => {
  const start = normalizeTime(startTime, "00:00:00").slice(0, 5).replace(":", "");
  const end = normalizeTime(endTime, "00:00:00").slice(0, 5).replace(":", "");
  return `${DYNAMIC_TIME_TYPE_PREFIX}${start}${end}`.slice(0, 10);
};

const parseTimeRangeText = (text) => {
  const value = String(text || "").trim();
  const match = value.match(/(\d{1,2}:\d{2})(?::\d{2})?\s*-\s*(\d{1,2}:\d{2})(?::\d{2})?/);
  if (!match) return null;

  const startTime = normalizeTime(match[1]);
  const endTime = normalizeTime(match[2]);
  if (!startTime || !endTime) return null;
  return { startTime, endTime };
};

const getLookupTimes = async (timeTypes, db) => {
  const keys = [...new Set((timeTypes || []).filter(Boolean))];
  if (!keys.length) return new Map();

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT keyMap, value_vi, value_en
      FROM lookup
      WHERE type = 'TIME' AND keyMap IN (${keys.map(() => "?").join(", ")})
    `,
    keys
  );

  return new Map(
    rows.map((row) => [
      row.keyMap,
      parseTimeRangeText(row.value_vi) || parseTimeRangeText(row.value_en),
    ])
  );
};

const buildLogicalKey = (appointmentTypeId, startTime, endTime) =>
  `${appointmentTypeId}|${normalizeTime(startTime)}|${normalizeTime(endTime)}`;

const normalizeRuleRow = (row = {}) => ({
  ...row,
  date: normalizeDate(row.date),
  startTime: normalizeTime(row.startTime),
  endTime: normalizeTime(row.endTime),
  weekday: row.weekday === null || row.weekday === undefined ? null : Number(row.weekday),
  capacity: row.capacity === null || row.capacity === undefined ? null : Number(row.capacity),
  slotDurationMinutes:
    row.slotDurationMinutes === null || row.slotDurationMinutes === undefined
      ? null
      : Number(row.slotDurationMinutes),
  minBookingNoticeDays: Number(row.minBookingNoticeDays) || 0,
  maxBookingAheadDays:
    row.maxBookingAheadDays === null || row.maxBookingAheadDays === undefined
      ? DEFAULT_MAX_BOOKING_AHEAD_DAYS
      : Number(row.maxBookingAheadDays),
  price: row.price === null || row.price === undefined ? null : Number(row.price),
  discountPercent: Number(row.discountPercent) || 0,
  isFullDay: Number(row.isFullDay) ? 1 : 0,
  isActive: Number(row.isActive) ? 1 : 0,
});

const getScheduleRuleById = async (ruleId, db) => {
  const id = normalizePositiveId(ruleId);
  if (!id) return null;

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT *
      FROM doctor_schedule_rule
      WHERE id = ?
      LIMIT 1
    `,
    [id]
  );

  return rows[0] ? normalizeRuleRow(rows[0]) : null;
};

const getScheduleRules = async (doctorId, filters = {}, db) => {
  const normalizedDoctorId = normalizePositiveId(doctorId);
  if (!normalizedDoctorId) {
    return { errCode: 1, errMessage: "Missing required parameters", data: [] };
  }

  try {
    const executor = getDb(db);
    const where = ["doctorId = ?"];
    const params = [normalizedDoctorId];

    if (filters.ruleType) {
      where.push("ruleType = ?");
      params.push(String(filters.ruleType).trim().toUpperCase());
    }
    if (filters.date) {
      where.push("(date = ? OR date IS NULL)");
      params.push(normalizeDate(filters.date));
    }
    if (filters.isActive !== undefined && filters.isActive !== "") {
      where.push("isActive = ?");
      params.push(Number(filters.isActive) ? 1 : 0);
    }

    const [rows] = await executor.query(
      `
        SELECT *
        FROM doctor_schedule_rule
        WHERE ${where.join(" AND ")}
        ORDER BY
          CASE ruleType WHEN 'FIXED' THEN 1 WHEN 'OFF' THEN 2 ELSE 3 END,
          COALESCE(weekday, 8) ASC,
          COALESCE(date, '9999-12-31') ASC,
          startTime ASC,
          id ASC
      `,
      params
    );

    return {
      errCode: 0,
      errMessage: "OK",
      data: rows.map(normalizeRuleRow),
    };
  } catch (error) {
    console.log("getScheduleRules error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: [] };
  }
};

const loadActiveRulesForDate = async (doctorId, date, db, overrideRule = null) => {
  const normalizedDate = normalizeDate(date);
  const isoWeekday = moment(normalizedDate, "YYYY-MM-DD").isoWeekday();
  const executor = getDb(db);

  const [rows] = await executor.query(
    `
      SELECT *
      FROM doctor_schedule_rule
      WHERE doctorId = ?
        AND isActive = 1
        AND (
          (ruleType = 'FIXED' AND weekday = ?)
          OR (ruleType IN ('OFF', 'FLEXIBLE') AND date = ?)
        )
      ORDER BY id ASC
    `,
    [doctorId, isoWeekday, normalizedDate]
  );

  let rules = rows.map(normalizeRuleRow);
  if (overrideRule) {
    const normalizedOverride = normalizeRuleRow(overrideRule);
    if (normalizedOverride.id) {
      rules = rules.filter((rule) => Number(rule.id) !== Number(normalizedOverride.id));
    }
    if (Number(normalizedOverride.isActive) === 1) {
      rules.push(normalizedOverride);
    }
  }

  return rules.filter((rule) => {
    if (rule.ruleType === RULE_TYPES.FIXED) return Number(rule.weekday) === isoWeekday;
    return rule.date === normalizedDate;
  });
};

const ruleAppliesToAppointmentType = (rule, appointmentTypeId) =>
  !rule.appointmentTypeId || rule.appointmentTypeId === appointmentTypeId;

const getGovernedAppointmentTypes = (rules = []) => {
  const governed = new Set();
  rules.forEach((rule) => {
    if (rule.ruleType === RULE_TYPES.OFF && !rule.appointmentTypeId) {
      APPOINTMENT_TYPES.forEach((type) => governed.add(type));
      return;
    }
    if (rule.appointmentTypeId) governed.add(rule.appointmentTypeId);
  });
  return governed;
};

const getRuleGovernance = (rules = []) => {
  const workAppointmentTypes = new Set();
  const offRules = [];

  rules.forEach((rule) => {
    if (rule.ruleType === RULE_TYPES.OFF) {
      offRules.push(rule);
      return;
    }
    if (rule.appointmentTypeId) {
      workAppointmentTypes.add(rule.appointmentTypeId);
    }
  });

  return {
    appointmentTypes: getGovernedAppointmentTypes(rules),
    workAppointmentTypes,
    offRules,
  };
};

const buildDesiredSlotsFromRules = (rules, date) => {
  const normalizedDate = normalizeDate(date);
  const desired = new Map();
  const offRules = rules.filter((rule) => rule.ruleType === RULE_TYPES.OFF && Number(rule.isActive) === 1);

  APPOINTMENT_TYPES.forEach((appointmentTypeId) => {
    const flexibleRules = rules.filter(
      (rule) =>
        rule.ruleType === RULE_TYPES.FLEXIBLE &&
        Number(rule.isActive) === 1 &&
        rule.date === normalizedDate &&
        rule.appointmentTypeId === appointmentTypeId
    );
    const sourceRules = flexibleRules.length
      ? flexibleRules
      : rules.filter(
          (rule) =>
            rule.ruleType === RULE_TYPES.FIXED &&
            Number(rule.isActive) === 1 &&
            rule.appointmentTypeId === appointmentTypeId
        );

    sourceRules.forEach((rule) => {
      generateSlots(rule.startTime, rule.endTime, rule.slotDurationMinutes).forEach((slot) => {
        const blocked = offRules.some(
          (offRule) =>
            ruleAppliesToAppointmentType(offRule, appointmentTypeId) &&
            rangesOverlap(slot.startTime, slot.endTime, offRule.startTime, offRule.endTime)
        );
        if (blocked) return;

        const key = buildLogicalKey(appointmentTypeId, slot.startTime, slot.endTime);
        desired.set(key, {
          key,
          doctorId: rule.doctorId,
          date: normalizedDate,
          appointmentTypeId,
          startTime: slot.startTime,
          endTime: slot.endTime,
          timeType: buildDynamicTimeType(slot.startTime, slot.endTime),
          capacity: Number(rule.capacity) || 1,
          minBookingNoticeDays: Number(rule.minBookingNoticeDays) || 0,
          maxBookingAheadDays:
            rule.maxBookingAheadDays === null || rule.maxBookingAheadDays === undefined
              ? DEFAULT_MAX_BOOKING_AHEAD_DAYS
              : Number(rule.maxBookingAheadDays),
          price: rule.price === null || rule.price === undefined ? null : Number(rule.price),
          discountPercent: Number(rule.discountPercent) || 0,
          sourceType: flexibleRules.length ? SOURCE_TYPES.FLEXIBLE : SOURCE_TYPES.FIXED,
          sourceRuleId: rule.id || null,
        });
      });
    });
  });

  return desired;
};

const getDefaultPricesByType = async (doctorId, db) => {
  const prices = {};
  for (const appointmentTypeId of APPOINTMENT_TYPES) {
    prices[appointmentTypeId] = await getDoctorPriceAtBooking(doctorId, appointmentTypeId, db);
  }
  return prices;
};

const inferScheduleTimes = (row = {}) => {
  const directStart = normalizeTime(row.startTime);
  const directEnd = normalizeTime(row.endTime);
  if (directStart && directEnd) {
    return { startTime: directStart, endTime: directEnd };
  }

  return parseTimeRangeText(row.value_vi) || parseTimeRangeText(row.value_en) || {
    startTime: null,
    endTime: null,
  };
};

const mapScheduleResponseRow = (row, defaultPrices = {}) => {
  const times = inferScheduleTimes(row);
  const capacitySummary = buildCapacitySummary(row.bookedCount, row.capacity);
  const basePrice =
    row.price !== null && row.price !== undefined
      ? Number(row.price)
      : Number(defaultPrices[row.appointmentTypeId || DEFAULT_APPOINTMENT_TYPE_ID]) || 0;
  const effectivePrice = calculateFinalPrice(basePrice, row.discountPercent);
  const response = {
    ...row,
    startTime: times.startTime,
    endTime: times.endTime,
    value_vi: times.startTime && times.endTime ? getTimeLabel(times) : row.value_vi,
    value_en: times.startTime && times.endTime ? getTimeLabel(times) : row.value_en,
    price: row.price !== null && row.price !== undefined ? Number(row.price) : null,
    defaultPrice: Number(defaultPrices[row.appointmentTypeId || DEFAULT_APPOINTMENT_TYPE_ID]) || 0,
    effectivePrice,
    discountPercent: Number(row.discountPercent) || 0,
    isActive: Number(row.isActive) ? 1 : 0,
    isBookable:
      Number(row.isActive) === 1 &&
      capacitySummary.remaining > 0 &&
      !isScheduleStarted({ ...row, startTime: times.startTime }) &&
      isDateInBookingWindow(row.date, row.minBookingNoticeDays, row.maxBookingAheadDays)
        ? 1
        : 0,
    ...capacitySummary,
  };

  return response;
};

const getScheduleRowsForDate = async (doctorId, date, db, options = {}) => {
  const normalizedDate = normalizeDate(date);
  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
        s.appointmentTypeId,
        s.startTime,
        s.endTime,
        COALESCE(s.capacity, 1) AS capacity,
        COALESCE(s.isActive, 1) AS isActive,
        COALESCE(s.sourceType, 'LEGACY') AS sourceType,
        s.sourceRuleId,
        COALESCE(s.minBookingNoticeDays, 0) AS minBookingNoticeDays,
        COALESCE(s.maxBookingAheadDays, ?) AS maxBookingAheadDays,
        s.price,
        COALESCE(s.discountPercent, 0) AS discountPercent,
        COALESCE(activeBooking.bookedCount, 0) AS bookedCount,
        a.value_vi,
        a.value_en,
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
        WHERE statusId NOT IN (${activeStatusPlaceholders()})
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
        ${options.onlyActive ? "AND COALESCE(s.isActive, 1) = 1" : ""}
      ORDER BY COALESCE(s.startTime, a.value_vi, s.timeType) ASC, s.id ASC
    `,
    [DEFAULT_MAX_BOOKING_AHEAD_DAYS, ...CAPACITY_EXCLUDED_STATUS_IDS, doctorId, normalizedDate]
  );

  const defaultPrices = {
    AT1: parsePriceToNumber(rows[0]?.defaultOfflinePrice),
    AT2: parsePriceToNumber(rows[0]?.defaultOnlinePrice),
  };

  return rows.map((row) => mapScheduleResponseRow(row, defaultPrices));
};

const loadExistingSchedulesForDate = async (doctorId, date, db, options = {}) => {
  const executor = getDb(db);
  const normalizedDate = normalizeDate(date);
  const [rows] = await executor.query(
    `
      SELECT
        s.id,
        s.doctorId,
        s.date,
        s.timeType,
        s.appointmentTypeId,
        s.startTime,
        s.endTime,
        COALESCE(s.capacity, 1) AS capacity,
        COALESCE(s.isActive, 1) AS isActive,
        COALESCE(s.sourceType, 'LEGACY') AS sourceType,
        s.sourceRuleId,
        COALESCE(s.minBookingNoticeDays, 0) AS minBookingNoticeDays,
        COALESCE(s.maxBookingAheadDays, ?) AS maxBookingAheadDays,
        COALESCE(s.discountPercent, 0) AS discountPercent,
        s.price,
        lt.value_vi,
        lt.value_en
      FROM schedule s
      LEFT JOIN lookup lt
        ON lt.keyMap = s.timeType AND lt.type = 'TIME'
      WHERE s.doctorId = ? AND s.date = ?
      ORDER BY COALESCE(s.startTime, lt.value_vi, s.timeType) ASC, s.id ASC
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [DEFAULT_MAX_BOOKING_AHEAD_DAYS, doctorId, normalizedDate]
  );

  return rows.map((row) => ({
    ...row,
    ...inferScheduleTimes(row),
    appointmentTypeId: normalizeAppointmentType(row.appointmentTypeId),
    capacity: Number(row.capacity) || 1,
    isActive: Number(row.isActive) ? 1 : 0,
  }));
};

const getActiveBookingsBySchedule = async (scheduleIds, db, options = {}) => {
  const ids = [...new Set((scheduleIds || []).map(Number).filter((id) => Number.isInteger(id) && id > 0))];
  if (!ids.length) return new Map();

  const executor = getDb(db);
  const [rows] = await executor.query(
    `
      SELECT id, scheduleId, statusId, createdAt
      FROM booking
      WHERE scheduleId IN (${ids.map(() => "?").join(", ")})
        AND statusId NOT IN (${activeStatusPlaceholders()})
      ORDER BY createdAt ASC, id ASC
      ${options.forUpdate ? "FOR UPDATE" : ""}
    `,
    [...ids, ...CAPACITY_EXCLUDED_STATUS_IDS]
  );

  return rows.reduce((map, row) => {
    const list = map.get(Number(row.scheduleId)) || [];
    list.push(row);
    map.set(Number(row.scheduleId), list);
    return map;
  }, new Map());
};

const computeImpactForDesiredSlots = async (doctorId, date, desiredSlots, db, options = {}) => {
  const schedules = await loadExistingSchedulesForDate(doctorId, date, db, {
    forUpdate: options.forUpdate,
  });
  const activeBookingsBySchedule = await getActiveBookingsBySchedule(
    schedules.map((schedule) => schedule.id),
    db,
    { forUpdate: options.forUpdate }
  );
  const impactedSchedules = [];
  const impactedBookings = [];

  schedules.forEach((schedule) => {
    const appointmentTypeId = normalizeAppointmentType(schedule.appointmentTypeId);
    if (options.appointmentTypes && !options.appointmentTypes.has(appointmentTypeId)) {
      return;
    }
    const key = buildLogicalKey(appointmentTypeId, schedule.startTime, schedule.endTime);
    const desired = desiredSlots.get(key);
    const bookings = activeBookingsBySchedule.get(Number(schedule.id)) || [];
    if (!schedule.startTime || !schedule.endTime) return;
    const overlapsOff = (options.offRules || []).some(
      (offRule) =>
        ruleAppliesToAppointmentType(offRule, appointmentTypeId) &&
        rangesOverlap(schedule.startTime, schedule.endTime, offRule.startTime, offRule.endTime)
    );

    if (!desired) {
      if (!overlapsOff && !options.workAppointmentTypes?.has(appointmentTypeId)) {
        return;
      }
      impactedSchedules.push({
        scheduleId: schedule.id,
        appointmentTypeId,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        activeBookingCount: bookings.length,
        newCapacity: 0,
        reason: overlapsOff ? "OFF_OVERLAP" : "NO_LONGER_VALID",
      });
      bookings.forEach((booking) => {
        impactedBookings.push({
          bookingId: booking.id,
          scheduleId: schedule.id,
          reason: overlapsOff ? "OFF_OVERLAP" : "NO_LONGER_VALID",
        });
      });
      return;
    }

    const capacity = Number(desired.capacity) || 1;
    if (bookings.length > capacity) {
      const overflow = bookings.slice(capacity);
      impactedSchedules.push({
        scheduleId: schedule.id,
        appointmentTypeId,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        activeBookingCount: bookings.length,
        newCapacity: capacity,
        reason: "CAPACITY_REDUCTION",
      });
      overflow.forEach((booking) => {
        impactedBookings.push({
          bookingId: booking.id,
          scheduleId: schedule.id,
          reason: "CAPACITY_REDUCTION",
        });
      });
    }
  });

  return {
    affectedBookingCount: impactedBookings.length,
    affectedScheduleCount: impactedSchedules.length,
    schedules: impactedSchedules,
    bookings: impactedBookings,
  };
};

const upsertDesiredSlots = async (desiredSlots, db, defaultPrices) => {
  for (const slot of desiredSlots.values()) {
    const fallbackPrice = Number(defaultPrices[slot.appointmentTypeId]) || 0;
    const price = slot.price === null || slot.price === undefined ? fallbackPrice : Number(slot.price);
    await db.query(
      `
        INSERT INTO schedule (
          doctorId, date, timeType, appointmentTypeId, startTime, endTime,
          capacity, isActive, sourceType, sourceRuleId, minBookingNoticeDays,
          maxBookingAheadDays, price, discountPercent
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
          timeType = VALUES(timeType),
          capacity = VALUES(capacity),
          isActive = 1,
          sourceType = VALUES(sourceType),
          sourceRuleId = VALUES(sourceRuleId),
          minBookingNoticeDays = VALUES(minBookingNoticeDays),
          maxBookingAheadDays = VALUES(maxBookingAheadDays),
          price = VALUES(price),
          discountPercent = VALUES(discountPercent),
          updatedAt = CURRENT_TIMESTAMP
      `,
      [
        slot.doctorId,
        slot.date,
        slot.timeType,
        slot.appointmentTypeId,
        slot.startTime,
        slot.endTime,
        slot.capacity,
        slot.sourceType,
        slot.sourceRuleId,
        slot.minBookingNoticeDays,
        slot.maxBookingAheadDays,
        price,
        slot.discountPercent,
      ]
    );
  }
};

const deactivateInvalidSchedules = async (impact, db) => {
  const invalidScheduleIds = impact.schedules
    .filter((item) => ["NO_LONGER_VALID", "OFF_OVERLAP"].includes(item.reason))
    .map((item) => item.scheduleId);
  if (!invalidScheduleIds.length) return;

  await db.query(
    `
      UPDATE schedule
      SET isActive = 0, updatedAt = CURRENT_TIMESTAMP
      WHERE id IN (${invalidScheduleIds.map(() => "?").join(", ")})
    `,
    invalidScheduleIds
  );
};

const materializeScheduleForDate = async (doctorId, date, options = {}) => {
  const executor = getDb(options.db);
  const normalizedDoctorId = normalizePositiveId(doctorId);
  const normalizedDate = normalizeDate(date);
  if (!normalizedDoctorId || !normalizedDate) {
    return { errCode: 1, errMessage: "Missing required parameters", data: null };
  }

  const run = async (db) => {
    const rules = await loadActiveRulesForDate(normalizedDoctorId, normalizedDate, db);
    if (rules.length === 0) {
      return {
        errCode: 0,
        errMessage: "OK",
        data: {
          date: normalizedDate,
          desiredSlotCount: 0,
          impact: {
            affectedBookingCount: 0,
            affectedScheduleCount: 0,
            schedules: [],
            bookings: [],
          },
        },
      };
    }
    const desiredSlots = buildDesiredSlotsFromRules(rules, normalizedDate);
    const governance = getRuleGovernance(rules);
    const impact = await computeImpactForDesiredSlots(
      normalizedDoctorId,
      normalizedDate,
      desiredSlots,
      db,
      { forUpdate: options.applyBookingImpact, ...governance }
    );
    const defaultPrices = await getDefaultPricesByType(normalizedDoctorId, db);

    await upsertDesiredSlots(desiredSlots, db, defaultPrices);
    await deactivateInvalidSchedules(impact, db);

    if (options.applyBookingImpact) {
      const bookingIds = impact.bookings.map((booking) => booking.bookingId);
      await cancelBookingsByScheduleChangeInCurrentTransaction(
        {
          bookingIds,
          note: "Schedule rule changed; booking is no longer valid or exceeds capacity",
        },
        db
      );
    }

    return {
      errCode: 0,
      errMessage: "OK",
      data: {
        date: normalizedDate,
        desiredSlotCount: desiredSlots.size,
        impact,
      },
    };
  };

  if (options.db) return run(executor);
  return withTransaction(run);
};

const getMaterializationDatesForRule = async (rule, previousRule, db) => {
  const executor = getDb(db);
  const today = moment().startOf("day");
  const rules = [rule, previousRule].filter(Boolean).map(normalizeRuleRow);
  const dates = new Set();

  rules.forEach((item) => {
    if ([RULE_TYPES.OFF, RULE_TYPES.FLEXIBLE].includes(item.ruleType) && item.date) {
      dates.add(item.date);
    }
  });

  const fixedRules = rules.filter((item) => item.ruleType === RULE_TYPES.FIXED);
  if (fixedRules.length) {
    const maxAheadDays = Math.max(
      DEFAULT_MAX_BOOKING_AHEAD_DAYS,
      ...fixedRules.map((item) => Number(item.maxBookingAheadDays) || DEFAULT_MAX_BOOKING_AHEAD_DAYS)
    );
    const maxDate = today.clone().add(maxAheadDays, "days").format("YYYY-MM-DD");
    const doctorId = fixedRules[0].doctorId;

    const [scheduleDates] = await executor.query(
      `
        SELECT DISTINCT date
        FROM schedule
        WHERE doctorId = ? AND date >= ? AND date <= ?
      `,
      [doctorId, today.format("YYYY-MM-DD"), maxDate]
    );
    const [bookingDates] = await executor.query(
      `
        SELECT DISTINCT b.date
        FROM booking b
        INNER JOIN schedule s ON s.id = b.scheduleId
        WHERE s.doctorId = ? AND b.date >= ?
      `,
      [doctorId, today.format("YYYY-MM-DD")]
    );

    [...scheduleDates, ...bookingDates].forEach((row) => {
      const date = normalizeDate(row.date);
      if (!date) return;
      const weekday = moment(date, "YYYY-MM-DD").isoWeekday();
      if (fixedRules.some((item) => Number(item.weekday) === weekday)) {
        dates.add(date);
      }
    });
  }

  return [...dates].sort();
};

const previewScheduleRuleChange = async (data) => {
  try {
    const currentRule = data?.id ? await getScheduleRuleById(data.id) : null;
    const merged = {
      ...(currentRule || {}),
      ...(data || {}),
      doctorId: data?.doctorId || currentRule?.doctorId,
      id: currentRule?.id || data?.id || null,
    };
    const validation = validateRulePayload(merged);
    if (!validation.ok || !merged.doctorId) {
      return {
        errCode: 2,
        errMessage: validation.errors.join("; ") || "Invalid schedule rule",
        data: null,
      };
    }

    const draftRule = normalizeRuleRow({
      ...validation.value,
      id: merged.id,
      doctorId: normalizePositiveId(merged.doctorId),
    });
    const dates = await getMaterializationDatesForRule(draftRule, currentRule);
    const impact = {
      affectedBookingCount: 0,
      affectedScheduleCount: 0,
      schedules: [],
      bookings: [],
    };

    for (const date of dates) {
      const rules = await loadActiveRulesForDate(draftRule.doctorId, date, null, draftRule);
      const desiredSlots = buildDesiredSlotsFromRules(rules, date);
      const governance = getRuleGovernance(rules);
      const dateImpact = await computeImpactForDesiredSlots(
        draftRule.doctorId,
        date,
        desiredSlots,
        null,
        governance
      );
      impact.affectedBookingCount += dateImpact.affectedBookingCount;
      impact.affectedScheduleCount += dateImpact.affectedScheduleCount;
      impact.schedules.push(...dateImpact.schedules.map((item) => ({ ...item, date })));
      impact.bookings.push(...dateImpact.bookings.map((item) => ({ ...item, date })));
    }

    return {
      errCode: 0,
      errMessage: "OK",
      data: {
        dates,
        ...impact,
      },
    };
  } catch (error) {
    console.log("previewScheduleRuleChange error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: null };
  }
};

const insertScheduleRule = async (rule, actorId, db) => {
  const [result] = await db.query(
    `
      INSERT INTO doctor_schedule_rule (
        doctorId, ruleType, weekday, date, appointmentTypeId, startTime, endTime,
        slotDurationMinutes, capacity, minBookingNoticeDays, maxBookingAheadDays,
        price, discountPercent, isFullDay, isActive, createdBy
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `,
    [
      rule.doctorId,
      rule.ruleType,
      rule.weekday,
      rule.date,
      rule.appointmentTypeId,
      rule.startTime,
      rule.endTime,
      rule.slotDurationMinutes,
      rule.capacity,
      rule.minBookingNoticeDays,
      rule.maxBookingAheadDays,
      rule.price,
      rule.discountPercent,
      rule.isFullDay,
      rule.isActive,
      actorId || null,
    ]
  );

  return result.insertId;
};

const updateScheduleRuleRow = async (rule, db) => {
  await db.query(
    `
      UPDATE doctor_schedule_rule
      SET ruleType = ?, weekday = ?, date = ?, appointmentTypeId = ?, startTime = ?,
          endTime = ?, slotDurationMinutes = ?, capacity = ?, minBookingNoticeDays = ?,
          maxBookingAheadDays = ?, price = ?, discountPercent = ?, isFullDay = ?,
          isActive = ?, updatedAt = CURRENT_TIMESTAMP
      WHERE id = ?
    `,
    [
      rule.ruleType,
      rule.weekday,
      rule.date,
      rule.appointmentTypeId,
      rule.startTime,
      rule.endTime,
      rule.slotDurationMinutes,
      rule.capacity,
      rule.minBookingNoticeDays,
      rule.maxBookingAheadDays,
      rule.price,
      rule.discountPercent,
      rule.isFullDay,
      rule.isActive,
      rule.id,
    ]
  );
};

const applyRuleMutationImpact = async (rule, previousRule, db) => {
  const dates = await getMaterializationDatesForRule(rule, previousRule, db);
  const results = [];

  for (const date of dates) {
    const materialized = await materializeScheduleForDate(rule.doctorId, date, {
      db,
      applyBookingImpact: true,
    });
    results.push(materialized.data);
  }

  return {
    dates,
    results,
    affectedBookingCount: results.reduce(
      (total, item) => total + (Number(item?.impact?.affectedBookingCount) || 0),
      0
    ),
  };
};

const createScheduleRule = async (data, actor = {}) => {
  try {
    const validation = validateRulePayload(data);
    const doctorId = normalizePositiveId(data?.doctorId);
    if (!validation.ok || !doctorId) {
      return {
        errCode: 2,
        errMessage: validation.errors.join("; ") || "Invalid schedule rule",
        data: null,
      };
    }

    return await withTransaction(async (db) => {
      const rule = normalizeRuleRow({ ...validation.value, doctorId });
      const id = await insertScheduleRule(rule, actor?.id, db);
      const savedRule = { ...rule, id };
      const impact = await applyRuleMutationImpact(savedRule, null, db);
      return {
        errCode: 0,
        errMessage: "Schedule rule created successfully",
        data: { rule: savedRule, impact },
      };
    });
  } catch (error) {
    console.log("createScheduleRule error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: null };
  }
};

const updateScheduleRule = async (ruleId, data) => {
  try {
    const id = normalizePositiveId(ruleId || data?.id);
    if (!id) return { errCode: 1, errMessage: "Missing required parameters", data: null };

    return await withTransaction(async (db) => {
      const currentRule = await getScheduleRuleById(id, db);
      if (!currentRule) return { errCode: 2, errMessage: "Schedule rule does not exist", data: null };

      const merged = { ...currentRule, ...(data || {}), id, doctorId: currentRule.doctorId };
      const validation = validateRulePayload(merged);
      if (!validation.ok) {
        return {
          errCode: 2,
          errMessage: validation.errors.join("; "),
          data: null,
        };
      }

      const updatedRule = normalizeRuleRow({
        ...validation.value,
        id,
        doctorId: currentRule.doctorId,
      });
      await updateScheduleRuleRow(updatedRule, db);
      const impact = await applyRuleMutationImpact(updatedRule, currentRule, db);
      return {
        errCode: 0,
        errMessage: "Schedule rule updated successfully",
        data: { rule: updatedRule, impact },
      };
    });
  } catch (error) {
    console.log("updateScheduleRule error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: null };
  }
};

const deactivateScheduleRule = async (ruleId) => {
  try {
    const id = normalizePositiveId(ruleId);
    if (!id) return { errCode: 1, errMessage: "Missing required parameters", data: null };

    return await withTransaction(async (db) => {
      const currentRule = await getScheduleRuleById(id, db);
      if (!currentRule) return { errCode: 2, errMessage: "Schedule rule does not exist", data: null };

      const updatedRule = { ...currentRule, isActive: 0 };
      await db.query(
        `UPDATE doctor_schedule_rule SET isActive = 0, updatedAt = CURRENT_TIMESTAMP WHERE id = ?`,
        [id]
      );
      const impact = await applyRuleMutationImpact(updatedRule, currentRule, db);
      return {
        errCode: 0,
        errMessage: "Schedule rule deactivated successfully",
        data: { rule: updatedRule, impact },
      };
    });
  } catch (error) {
    console.log("deactivateScheduleRule error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: null };
  }
};

const PostScheduleDoctor = async (data) => {
  try {
    if (!data || !data.doctorId || !data.date || !Array.isArray(data.timeType)) {
      return { errCode: 1, errMessage: "Missing required parameters", data: [] };
    }

    const doctorId = normalizePositiveId(data.doctorId);
    const normalizedDate = normalizeDate(data.date);
    const appointmentTypeId = normalizeAppointmentType(data.appointmentTypeId);
    if (!doctorId || !normalizedDate) {
      return { errCode: 1, errMessage: "Missing required parameters", data: [] };
    }

    const lookupTimes = await getLookupTimes(data.timeType);
    const schedulePrice = await resolveSchedulePriceForSave(
      doctorId,
      appointmentTypeId,
      data.price
    );
    if (!schedulePrice.ok) {
      return { errCode: 2, errMessage: "Schedule price must be a valid non-negative integer", data: [] };
    }

    const rows = data.timeType
      .map((timeType) => ({ timeType, ...(lookupTimes.get(timeType) || {}) }))
      .filter((slot) => slot.startTime && slot.endTime);

    if (!rows.length) {
      return { errCode: 0, errMessage: "No new schedule to insert", data: [] };
    }

    const result = await withTransaction(async (db) => {
      for (const slot of rows) {
        await db.query(
          `
            INSERT INTO schedule (
              doctorId, date, timeType, appointmentTypeId, startTime, endTime,
              capacity, isActive, sourceType, price
            )
            VALUES (?, ?, ?, ?, ?, ?, 1, 1, 'LEGACY', ?)
            ON DUPLICATE KEY UPDATE
              timeType = VALUES(timeType),
              isActive = 1,
              price = VALUES(price),
              updatedAt = CURRENT_TIMESTAMP
          `,
          [
            doctorId,
            normalizedDate,
            slot.timeType,
            appointmentTypeId,
            slot.startTime,
            slot.endTime,
            schedulePrice.value,
          ]
        );
      }

      return rows.length;
    });

    return {
      errCode: 0,
      errMessage: "Schedule created successfully",
      data: { affectedRows: result },
    };
  } catch (error) {
    console.log("PostScheduleDoctor error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: [] };
  }
};

const GetcheScheduleDoctorByDate = async (doctorId, date, options = {}) => {
  try {
    const normalizedDoctorId = normalizePositiveId(doctorId);
    const normalizedDate = normalizeDate(date);
    if (!normalizedDoctorId || !normalizedDate) {
      return { errCode: 1, errMessage: "Missing required parameters", data: [] };
    }

    await materializeScheduleForDate(normalizedDoctorId, normalizedDate, {
      applyBookingImpact: false,
    });
    const rows = await getScheduleRowsForDate(normalizedDoctorId, normalizedDate, null, {
      onlyActive: options.onlyActive !== false,
    });
    const visibleRows = options.includeUnavailable
      ? rows
      : rows.filter((row) => row.isActive === 1 && row.isBookable === 1);

    return {
      errCode: 0,
      errMessage: "OK",
      data: visibleRows,
    };
  } catch (error) {
    console.log("GetcheScheduleDoctorByDate error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: [] };
  }
};

const updateScheduleDoctor = async (data) => {
  try {
    if (!data || !data.id) {
      return { errCode: 1, errMessage: "Missing required parameters" };
    }

    const id = normalizePositiveId(data.id);
    const normalized = normalizeSchedulePrice(data.price);
    if (!id || !normalized.ok) {
      return { errCode: 2, errMessage: "Schedule price must be a valid non-negative integer" };
    }

    await connection.promise().query(
      `
        UPDATE schedule
        SET price = ?, updatedAt = CURRENT_TIMESTAMP
        WHERE id = ?
      `,
      [normalized.value, id]
    );

    return {
      errCode: 0,
      errMessage: "Update schedule successfully",
      data: { id, price: normalized.value },
    };
  } catch (error) {
    console.log("updateScheduleDoctor error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: {} };
  }
};

const deleteScheduleDoctor = async (scheduleid) => {
  try {
    const id = normalizePositiveId(scheduleid);
    if (!id) {
      return { errCode: 1, errMessage: "Missing required parameters", data: [] };
    }

    await connection.promise().query(
      `
        UPDATE schedule
        SET isActive = 0, updatedAt = CURRENT_TIMESTAMP
        WHERE id = ?
      `,
      [id]
    );

    return { errCode: 0, errMessage: "Deactivate schedule successfully" };
  } catch (error) {
    console.log("deleteScheduleDoctor error:", error);
    return { errCode: 1, errMessage: error.message || "Database error", data: [] };
  }
};

module.exports = {
  normalizeDate,
  PostScheduleDoctor,
  GetcheScheduleDoctorByDate,
  updateScheduleDoctor,
  deleteScheduleDoctor,
  getScheduleRuleById,
  getScheduleRules,
  previewScheduleRuleChange,
  createScheduleRule,
  updateScheduleRule,
  deactivateScheduleRule,
  materializeScheduleForDate,
  buildDesiredSlotsFromRules,
  computeImpactForDesiredSlots,
};
