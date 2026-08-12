const connection = require("../../config/data");
const {
  buildDoctorName,
  formatMoney,
  normalizeConsultationType,
  normalizeText,
  normalizeWhitespace,
} = require("./chatUtils");

const stripHtml = (value) =>
  String(value || "")
    .replace(/<[^>]*>/g, " ")
    .replace(/&nbsp;/gi, " ")
    .replace(/\s+/g, " ")
    .trim();

const isPriceQuestion = (text) =>
  /\bgia\b|\bphi\b|chi phi|bao nhieu tien|hoc phi/.test(text);

const isClinicQuestion = (text) =>
  /dia chi|o dau|co so|phong kham|chi nhanh/.test(text);

const isContentQuestion = (text) =>
  /quy dinh|dich vu|gioi thieu|chinh sach|tien ich|thong tin phong kham/.test(text);

const formatPriceReply = (rows) => {
  const labels = { AT1: "Tại phòng khám", AT2: "Online" };
  const lines = rows.map((row) => {
    const min = Number(row.minPrice) || 0;
    const max = Number(row.maxPrice) || 0;
    const price = min === max ? formatMoney(min) : `${formatMoney(min)} - ${formatMoney(max)}`;
    return `${labels[row.appointmentTypeId] || row.appointmentTypeId}: ${price}`;
  });
  return `Giá khám hiện có trong lịch hệ thống:\n${lines.join("\n")}`;
};

const APPOINTMENT_TYPE_LABELS = {
  AT1: "Tại phòng khám",
  AT2: "Online",
};

const normalizeDoctorNameQuery = (value) =>
  normalizeWhitespace(value)
    .replace(/^(?:bác sĩ|bac si|bs\.?|dr\.?)\s+/i, "")
    .trim();

const getDoctorReference = async (collectedInfo = {}) => {
  const readOnlyDoctor = collectedInfo.readOnlyAvailability?.doctor;
  const selectedDoctor = collectedInfo.selectedDoctor;
  const doctorId = Number(
    collectedInfo.readOnlyAvailability?.doctorId ||
      selectedDoctor?.id ||
      collectedInfo.doctorId ||
      collectedInfo.doctor_id ||
      collectedInfo.slots?.find((slot) => slot.doctor_id)?.doctor_id
  );
  const knownName =
    readOnlyDoctor?.name || selectedDoctor?.name || collectedInfo.doctor_name;

  if (Number.isInteger(doctorId) && doctorId > 0) {
    return { id: doctorId, name: knownName || null };
  }

  const requestedName = normalizeDoctorNameQuery(knownName);
  if (!requestedName) return null;

  const [rows] = await connection.promise().query(
    `SELECT u.id, u.firstName, u.lastName, p.value_vi AS positionVi
     FROM users u
     INNER JOIN doctor_info di ON di.doctorId = u.id
     LEFT JOIN lookup p ON p.keyMap = u.positionId AND p.type = 'POSITION'
     WHERE u.roleId = 'R2'
       AND u.isActive = 1
       AND di.isActive = 1
       AND CONCAT_WS(' ', NULLIF(TRIM(u.firstName), ''), NULLIF(TRIM(u.lastName), '')) LIKE ?
     ORDER BY di.displayOrder ASC, u.createdAt DESC
     LIMIT 1`,
    [`%${requestedName}%`]
  );

  if (!rows.length) {
    return { id: null, name: knownName || requestedName, notFound: true };
  }

  return { id: Number(rows[0].id), row: rows[0] };
};

const formatDoctorLabel = (doctor, fallbackName) => {
  const rawName = doctor?.row
    ? buildDoctorName(doctor.row)
    : doctor?.name || fallbackName;
  const name = normalizeWhitespace(rawName)
    .replace(/^(?:bác sĩ|bac si|bs\.?|dr\.?)\s+/i, "")
    .trim();
  return name ? `Bác sĩ ${name}` : "Bác sĩ";
};

const formatPriceValue = (row) => {
  const min = Number(row.minPrice) || 0;
  const max = Number(row.maxPrice) || 0;
  return min === max ? formatMoney(min) : `${formatMoney(min)} - ${formatMoney(max)}`;
};

const formatDoctorPriceReply = (doctor, rows, consultationType, fallbackName) => {
  const types = consultationType ? [consultationType] : ["AT1", "AT2"];
  const rowsByType = new Map(rows.map((row) => [row.appointmentTypeId, row]));
  const doctorLabel = formatDoctorLabel(doctor, fallbackName);
  const lines = types.map((type) => {
    const row = rowsByType.get(type);
    return `${APPOINTMENT_TYPE_LABELS[type]}: ${row ? formatPriceValue(row) : "Chưa có dữ liệu giá."}`;
  });

  return `Giá khám của ${doctorLabel}:\n${lines.join("\n")}`;
};

const resolveChatFaq = async (message, collectedInfo = {}) => {
  const text = normalizeText(message);
  if (!text) return null;

  try {
    if (isPriceQuestion(text)) {
      const consultationTypeValue =
        normalizeConsultationType(message) ||
        normalizeConsultationType(collectedInfo.consultation_type);
      const consultationType = consultationTypeValue === "online" ? "AT2" :
        consultationTypeValue === "offline" ? "AT1" : null;
      const doctor = await getDoctorReference(collectedInfo);

      if (doctor) {
        if (!doctor.id) {
          return {
            reply: `Giá khám của ${formatDoctorLabel(doctor, collectedInfo.doctor_name)}: Chưa có dữ liệu giá.`,
            source: "schedule.price",
          };
        }

        const params = [doctor.id];
        const typeFilter = consultationType ? " AND s.appointmentTypeId = ?" : "";
        if (consultationType) params.push(consultationType);
        const [rows] = await connection.promise().query(
          `SELECT s.appointmentTypeId,
                  MIN(s.price) AS minPrice,
                  MAX(s.price) AS maxPrice
           FROM schedule s
           WHERE s.doctorId = ?
             AND s.isActive = 1
             AND s.date >= CURDATE()
             AND s.price > 0${typeFilter}
           GROUP BY s.appointmentTypeId
           ORDER BY s.appointmentTypeId ASC`,
          params
        );

        return {
          reply: formatDoctorPriceReply(
            doctor,
            rows,
            consultationType,
            collectedInfo.doctor_name
          ),
          source: "schedule.price",
        };
      }

      const knownPrices = (collectedInfo.slots || [])
        .map((slot) => Number(slot.effectivePrice || slot.price))
        .filter((price) => Number.isInteger(price) && price > 0);

      if (knownPrices.length) {
        const min = Math.min(...knownPrices);
        const max = Math.max(...knownPrices);
        return {
          reply: `Giá khám của lịch đang hiển thị là ${min === max ? formatMoney(min) : `${formatMoney(min)} - ${formatMoney(max)}`}.`,
          source: "schedule.price",
        };
      }

      const [rows] = await connection.promise().query(
        `SELECT appointmentTypeId, MIN(price) AS minPrice, MAX(price) AS maxPrice
         FROM schedule
         WHERE isActive = 1 AND date >= CURDATE() AND price > 0
         GROUP BY appointmentTypeId
         ORDER BY appointmentTypeId ASC`
      );
      if (!rows.length) return null;
      return { reply: formatPriceReply(rows), source: "schedule.price" };
    }

    if (isClinicQuestion(text)) {
      const [rows] = await connection.promise().query(
        `SELECT name, address, provinceCode
         FROM clinic
         WHERE isActive = 1
         ORDER BY displayOrder ASC, id ASC
         LIMIT 10`
      );
      if (!rows.length) return null;
      const reply = rows
        .map((row) => [row.name, row.address || row.provinceCode].filter(Boolean).join(" - "))
        .join("\n");
      return { reply: `Thông tin cơ sở hiện có:\n${reply}`, source: "clinic" };
    }

    if (isContentQuestion(text)) {
      const keyword = `%${String(message || "").trim().slice(0, 80)}%`;
      const [rows] = await connection.promise().query(
        `SELECT c.name AS clinicName, s.title, s.contentHTML
         FROM clinic_content_section s
         INNER JOIN clinic c ON c.id = s.clinicId
         WHERE s.isActive = 1 AND c.isActive = 1
           AND (s.title LIKE ? OR s.contentHTML LIKE ?)
         ORDER BY s.displayOrder ASC, s.id ASC
         LIMIT 5`,
        [keyword, keyword]
      );
      if (!rows.length) return null;
      const reply = rows
        .map((row) => `${row.clinicName ? `${row.clinicName}: ` : ""}${row.title}\n${stripHtml(row.contentHTML)}`)
        .join("\n\n");
      return { reply, source: "clinic_content_section" };
    }
  } catch (error) {
    console.warn("chat FAQ source unavailable:", error?.message || error);
  }

  return null;
};

module.exports = {
  isPriceQuestion,
  resolveChatFaq,
  stripHtml,
};
