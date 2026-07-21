const moment = require("moment");

const RULE_TYPES = Object.freeze({
  FIXED: "FIXED",
  OFF: "OFF",
  FLEXIBLE: "FLEXIBLE",
});

const SOURCE_TYPES = Object.freeze({
  LEGACY: "LEGACY",
  FIXED: "FIXED",
  FLEXIBLE: "FLEXIBLE",
});

const APPOINTMENT_TYPES = Object.freeze(["AT1", "AT2"]);

const normalizeTime = (value, fallback = null) => {
  if (value === undefined || value === null || value === "") return fallback;
  const text = String(value).trim();
  const parsed = moment(text, ["HH:mm:ss", "HH:mm", "H:mm:ss", "H:mm"], true);
  if (!parsed.isValid()) return fallback;
  return parsed.format("HH:mm:ss");
};

const timeToSeconds = (value) => {
  const time = normalizeTime(value);
  if (!time) return null;
  const [hours, minutes, seconds] = time.split(":").map(Number);
  return hours * 3600 + minutes * 60 + seconds;
};

const secondsToTime = (value) => {
  const bounded = Math.max(0, Math.min(86399, Number(value) || 0));
  const hours = Math.floor(bounded / 3600);
  const minutes = Math.floor((bounded % 3600) / 60);
  const seconds = bounded % 60;
  return [hours, minutes, seconds].map((part) => String(part).padStart(2, "0")).join(":");
};

const normalizeDate = (dateValue) => {
  if (!dateValue) return null;
  const parsed = moment(dateValue, ["YYYY-MM-DD", "DD/MM/YYYY", moment.ISO_8601], true);
  return parsed.isValid() ? parsed.format("YYYY-MM-DD") : null;
};

const isPositiveInteger = (value) => Number.isInteger(Number(value)) && Number(value) > 0;

const normalizeCapacity = (value, fallback = 1) => {
  if (value === undefined || value === null || value === "") return fallback;
  const number = Number(value);
  return Number.isInteger(number) && number >= 1 ? number : null;
};

const normalizePrice = (value, fallback = null) => {
  if (value === undefined || value === null || value === "") return fallback;
  const number = Number(value);
  return Number.isInteger(number) && number >= 0 ? number : null;
};

const rangesOverlap = (aStart, aEnd, bStart, bEnd) => {
  const startA = timeToSeconds(aStart);
  const endA = timeToSeconds(aEnd);
  const startB = timeToSeconds(bStart);
  const endB = timeToSeconds(bEnd);
  if ([startA, endA, startB, endB].some((value) => value === null)) return false;
  return startA < endB && endA > startB;
};

const generateSlots = (startTime, endTime, slotDurationMinutes) => {
  const start = timeToSeconds(startTime);
  const end = timeToSeconds(endTime);
  const duration = Number(slotDurationMinutes);
  if (start === null || end === null || start >= end || !isPositiveInteger(duration)) {
    return [];
  }

  const durationSeconds = duration * 60;
  const slots = [];
  for (let cursor = start; cursor + durationSeconds <= end; cursor += durationSeconds) {
    slots.push({
      startTime: secondsToTime(cursor),
      endTime: secondsToTime(cursor + durationSeconds),
    });
  }
  return slots;
};

const getTimeLabel = (item = {}) => {
  const start = normalizeTime(item.startTime);
  const end = normalizeTime(item.endTime);
  if (start && end) return `${start.slice(0, 5)} - ${end.slice(0, 5)}`;
  return item.value_vi || item.value_en || item.timeType || "";
};

const isScheduleStarted = (schedule, now = new Date()) => {
  const date = normalizeDate(schedule?.date);
  const start = normalizeTime(schedule?.startTime);
  if (!date || !start) return false;
  return moment(`${date} ${start}`, "YYYY-MM-DD HH:mm:ss").isSameOrBefore(moment(now));
};

const validateRulePayload = (data = {}) => {
  const errors = [];
  const ruleType = String(data.ruleType || "").trim().toUpperCase();
  const startTime = normalizeTime(data.startTime);
  const endTime = normalizeTime(data.endTime);
  const slotDurationMinutes =
    ruleType === RULE_TYPES.OFF ? null : normalizeCapacity(data.slotDurationMinutes, null);
  const capacity = ruleType === RULE_TYPES.OFF ? null : normalizeCapacity(data.capacity, 1);
  const price = normalizePrice(data.price, null);
  const weekday = data.weekday === undefined || data.weekday === null || data.weekday === ""
    ? null
    : Number(data.weekday);
  const date = normalizeDate(data.date);
  const appointmentTypeId = data.appointmentTypeId ? String(data.appointmentTypeId).trim() : null;

  if (!Object.values(RULE_TYPES).includes(ruleType)) errors.push("Invalid ruleType");
  if (!startTime || !endTime || timeToSeconds(startTime) >= timeToSeconds(endTime)) {
    errors.push("startTime must be before endTime");
  }
  if (ruleType === RULE_TYPES.FIXED && (!Number.isInteger(weekday) || weekday < 1 || weekday > 7)) {
    errors.push("weekday must be 1..7 for FIXED");
  }
  if ([RULE_TYPES.OFF, RULE_TYPES.FLEXIBLE].includes(ruleType) && !date) {
    errors.push("date is required for OFF/FLEXIBLE");
  }
  if (ruleType !== RULE_TYPES.OFF && !slotDurationMinutes) errors.push("slotDurationMinutes must be >= 1");
  if (ruleType !== RULE_TYPES.OFF && !capacity) errors.push("capacity must be >= 1");
  if (ruleType !== RULE_TYPES.OFF && !isPositiveInteger(price)) errors.push("price must be a positive integer");
  if (appointmentTypeId && !APPOINTMENT_TYPES.includes(appointmentTypeId)) {
    errors.push("appointmentTypeId must be AT1 or AT2");
  }

  return {
    ok: errors.length === 0,
    errors,
    value: {
      ruleType,
      weekday,
      date,
      appointmentTypeId,
      startTime,
      endTime,
      slotDurationMinutes,
      capacity,
      price,
      isActive: data.isActive === undefined ? 1 : Number(data.isActive) ? 1 : 0,
    },
  };
};

module.exports = {
  RULE_TYPES,
  SOURCE_TYPES,
  APPOINTMENT_TYPES,
  generateSlots,
  getTimeLabel,
  isScheduleStarted,
  normalizeDate,
  normalizeTime,
  rangesOverlap,
  timeToSeconds,
  validateRulePayload,
};
