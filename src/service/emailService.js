const nodemailer = require("nodemailer");
require("dotenv").config();

const createEmailTransporter = () =>
  nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_APP,
      pass: process.env.EMAIL_APP_PASSWORD,
    },
  });

const escapeHtml = (value) => {
  if (value === undefined || value === null) return "";

  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
};

const formatQuantity = (value) => {
  if (value === undefined || value === null || value === "") return "";

  const numericValue = Number(value);
  if (!Number.isFinite(numericValue)) return escapeHtml(value);

  return escapeHtml(Number.isInteger(numericValue) ? numericValue : numericValue.toString());
};

const hasItems = (items) => Array.isArray(items) && items.length > 0;

const formatDateValue = (value) => {
  if (!value) return "";
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return value.toISOString().slice(0, 10);
  }

  return String(value).trim().slice(0, 10);
};

const paraclinicalTypeLabels = {
  XET_NGHIEM: "X&eacute;t nghi&#7879;m",
  CHAN_DOAN_HINH_ANH: "Ch&#7849;n &#273;o&aacute;n h&igrave;nh &#7843;nh",
  KHAC: "Kh&aacute;c",
};

const buildPrescriptionTableRows = (items = []) => {
  return items
    .map(
      (item) => `
        <tr>
          <td style="padding:10px; border:1px solid #d8e0ea;">${escapeHtml(item.medicineName)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea; text-align:center;">${formatQuantity(item.morningQty)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea; text-align:center;">${formatQuantity(item.noonQty)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea; text-align:center;">${formatQuantity(item.afternoonQty)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea; text-align:center;">${formatQuantity(item.eveningQty)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea;">${escapeHtml(item.dosageForm)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea;">${escapeHtml(item.instruction)}</td>
        </tr>
      `
    )
    .join("");
};

const buildPrescriptionSection = (items = []) => {
  if (!hasItems(items)) return "";

  return `
    <h3 style="margin:25px 0 12px; color:#222;">Toa thu&#7889;c</h3>
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
      <thead>
        <tr style="background:#eef5ff;">
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Tên thuốc</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:center;">Sáng</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:center;">Trưa</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:center;">Chiều</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:center;">Tối</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Dạng dùng</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Cách dùng</th>
        </tr>
      </thead>
      <tbody>
        ${buildPrescriptionTableRows(items)}
      </tbody>
    </table>
  `;
};

const buildParaclinicalTableRows = (items = []) =>
  items
    .map((item) => {
      const typeLabel = paraclinicalTypeLabels[item.type] || escapeHtml(item.type);

      return `
        <tr>
          <td style="padding:10px; border:1px solid #d8e0ea;">${typeLabel}</td>
          <td style="padding:10px; border:1px solid #d8e0ea;">${escapeHtml(item.name)}</td>
          <td style="padding:10px; border:1px solid #d8e0ea; white-space:pre-line;">${escapeHtml(item.resultSummary)}</td>
        </tr>
      `;
    })
    .join("");

const buildParaclinicalSection = (items = []) => {
  if (!hasItems(items)) return "";

  return `
    <h3 style="margin:25px 0 12px; color:#222;">C&#7853;n l&acirc;m s&agrave;ng</h3>
    <table style="width:100%; border-collapse:collapse; font-size:14px;">
      <thead>
        <tr style="background:#eef5ff;">
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Loại chỉ định</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Tên chỉ định</th>
          <th style="padding:10px; border:1px solid #d8e0ea; text-align:left;">Kết quả</th>
        </tr>
      </thead>
      <tbody>
        ${buildParaclinicalTableRows(items)}
      </tbody>
    </table>
  `;
};

const buildDoctorConclusionSection = (doctorConclusion) => {
  const normalizedConclusion = escapeHtml(doctorConclusion || "");
  if (!normalizedConclusion) return "";

  return `
    <div style="margin:20px 0; padding:15px; background:#fff8e7; border-left:4px solid #f0ad4e; border-radius:6px;">
      <p style="margin:0 0 8px;"><b>Kết luận của bác sĩ:</b></p>
      <p style="margin:0; white-space:pre-line;">${normalizedConclusion}</p>
    </div>
  `;
};

const buildFollowUpDateSection = (followUpDate) => {
  const formattedDate = escapeHtml(formatDateValue(followUpDate));
  if (!formattedDate) return "";

  return `
    <div style="margin:20px 0; padding:15px; background:#eefaf1; border-left:4px solid #28a745; border-radius:6px;">
      <p style="margin:0;"><b>Ngày hẹn khám lại:</b> ${formattedDate}</p>
    </div>
  `;
};

const sendSimpleEmail = (dataSend) => {
  const transporter = createEmailTransporter();

  const mailOptions = {
    from: `"LIFE CARE " <${process.env.EMAIL_APP}>`,
    to: dataSend.reciverEmail,
    subject: "THÔNG BÁO ĐẶT LỊCH KHÁM BỆNH ONLINE",
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
        <h3>Xin chào ${escapeHtml(dataSend.patientName)}!</h3>
        <p>
          Bạn nhận được email này vì đã đặt lịch khám bệnh online trên
          <b>LIFE CARE</b>.
        </p>

        <p><b>Thông tin đặt lịch khám bệnh:</b></p>
        <div><b>Thời gian:</b> ${escapeHtml(dataSend.time)}</div>
        <div><b>Bác sĩ:</b> ${escapeHtml(dataSend.doctorName)}</div>

        ${buildDoctorConclusionSection(dataSend.doctorConclusion)}

        <p>
          Nếu các thông tin trên là đúng, vui lòng click vào đường link bên dưới
          để xác nhận và hoàn tất thủ tục đặt lịch khám bệnh.
        </p>

        <div style="margin: 15px 0;">
          <a
            href="${escapeHtml(dataSend.redirectLink)}"
            target="_blank"
            style="display:inline-block; background-color:#28a745; color:#fff; padding:10px 20px; border-radius:5px; text-decoration:none; font-weight:bold;"
          >
            Xác nhận lịch khám
          </a>
        </div>

        <div>Xin chân thành cảm ơn!</div>
      </div>
    `,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) return console.log(error);
    console.log("Email sent: " + info.response);
  });
};

const sendResultEmail = async (dataSend) => {
  const transporter = createEmailTransporter();
  const prescriptionItems = dataSend?.prescription?.items || dataSend?.prescriptionItems || [];
  const paraclinicalResults = dataSend?.paraclinicalResults || [];

  const mailOptions = {
    from: `"LIFE CARE" <${process.env.EMAIL_APP}>`,
    to: dataSend.reciverEmail,
    subject: "THÔNG BÁO KẾT QUẢ KHÁM BỆNH ONLINE",
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.7; color:#333; background:#f5f5f5; padding:25px;">
        <div style="max-width:650px; margin:auto; background:#fff; padding:30px; border-radius:10px;">
          <h2 style="margin-top:0; color:#222; font-weight:600;">
            Xin chào ${escapeHtml(dataSend.patientName || "ban")}!
          </h2>

          <p>
            Bạn nhận được email này vì bác sĩ đã hoàn thành lượt khám trên hệ thống <b>LIFE CARE</b>.
          </p>

          <p>
            Thông tin kết quả khám và toa thuốc của bạn được gửi trong email này.
          </p>

          <div style="margin:20px 0; padding:15px; background:#f0f8ff; border-left:4px solid #007bff; border-radius:6px;">
            <p style="margin:6px 0;"><b>Bác sĩ phụ trách:</b> ${escapeHtml(dataSend.doctorName || "")}</p>
            <p style="margin:6px 0;"><b>Thời gian khám:</b> ${escapeHtml(dataSend.time || "")}</p>
            <p style="margin:6px 0;"><b>Mã lịch hẹn:</b> ${escapeHtml(dataSend.bookingId || "")}</p>
            <p style="margin:6px 0;"><b>Lý do khám bệnh:</b> ${escapeHtml(dataSend.reason || "")}</p>
          </div>

          ${buildDoctorConclusionSection(dataSend.doctorConclusion)}

          ${buildFollowUpDateSection(dataSend.followUpDate)}

          ${buildPrescriptionSection(prescriptionItems)}

          ${buildParaclinicalSection(paraclinicalResults)}

          <p style="margin-top:25px;">Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ khám bệnh của chúng tôi!</p>

          <p style="font-size:13px; color:#777; margin-top:30px; text-align:center; line-height:1.4;">
            Đây là email tự động, vui lòng không phản hồi trực tiếp.<br />
            LIFE CARE © 2025 - Hệ thống khám bệnh trực tuyến.
            Hotline hỗ trợ: <b>1900 9999</b>
          </p>
        </div>
      </div>
    `,
  };

  const info = await transporter.sendMail(mailOptions);
  console.log("Email sent: " + info.response);
};

module.exports = {
  sendSimpleEmail,
  sendResultEmail,
};
