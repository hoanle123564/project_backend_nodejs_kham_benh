const nodemailer = require("nodemailer");
require("dotenv").config();

const sendSimpleEmail = (dataSend) => {
  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_APP,
      pass: process.env.EMAIL_APP_PASSWORD, // app password
    },
  });

  let mailOptions = {
    from: `"LIFE CARE " <${process.env.EMAIL_APP}>`,
    to: dataSend.reciverEmail,
    subject: "THÔNG BÁO ĐẶT LỊCH KHÁM BỆNH ONLINE",
    html: `
                <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
                    <h3>Xin chào ${dataSend.patientName}!</h3>
                    <p>
                        Bạn nhận được email này vì đã đặt lịch khám bệnh online trên 
                        <b>LIFE CARE</b>.
                    </p>

                    <p><b>Thông tin đặt lịch khám bệnh:</b></p>
                    <div><b>Thời gian:</b> ${dataSend.time}</div>
                    <div><b>Bác sĩ:</b> ${dataSend.doctorName}</div>

                    <p>
                        Nếu các thông tin trên là đúng sự thật, vui lòng click vào đường link bên dưới
                        để xác nhận và hoàn tất thủ tục đặt lịch khám bệnh.
                    </p>

                    <div style="margin: 15px 0;">
                        <a 
                        href="${dataSend.redirectLink}" 
                        target="_blank"
                           style="
                                display:inline-block;
                                background-color:#28a745;
                                color:#fff;
                                padding:10px 20px;
                                border-radius:5px;
                                text-decoration:none;
                                font-weight:bold;
                           ">
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

const sendResultEmail = (dataSend) => {
  let transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_APP,
      pass: process.env.EMAIL_APP_PASSWORD,
    },
  });
  const base64Data = dataSend.image.replace(/^data:image\/\w+;base64,/, "");

  let mailOptions = {
    from: `"LIFE CARE" <${process.env.EMAIL_APP}>`,
    to: dataSend.reciverEmail,
    subject: "THÔNG BÁO KẾT QUẢ KHÁM BỆNH ONLINE",

    html: `
          <div style="font-family: Arial, sans-serif; line-height: 1.7; color:#333; background:#f5f5f5; padding:25px;">
  <div style="max-width:650px; margin:auto; background:#fff; padding:30px; border-radius:10px;">

    <!-- TITLE -->
    <h2 style="margin-top:0; color:#222; font-weight:600;">
      Xin chào ${dataSend.patientName || "Hoan"}!
    </h2>

    <!-- INTRO -->
    <p>
      Bạn nhận được email này vì đã <b>đặt lịch khám bệnh online</b> trên hệ thống <b>LIFE CARE</b> thành công.
    </p>

    <p>
      Thông tin kết quả khám / đơn thuốc / hóa đơn của bạn được đính kèm trong file đi kèm email này.  
    </p>

    <p>
      Vui lòng kiểm tra và liên hệ lại với chúng tôi nếu có bất kỳ vấn đề nào.
    </p>

    <!-- BOOKING INFO -->
    <div style="margin:20px 0; padding:15px; background:#f0f8ff; border-left:4px solid #007bff; border-radius:6px;">
      <p style="margin:6px 0;"><b>👨‍⚕️ Bác sĩ phụ trách:</b> ${
        dataSend.doctorName || "Bác sĩ"
      }</p>
      <p style="margin:6px 0;"><b>🕒 Thời gian khám:</b> ${dataSend.time}</p>
      <p style="margin:6px 0;"><b>💳 Mã lịch hẹn:</b> ${
        dataSend.bookingId || "LC_" + Date.now()
      }</p>
       <p style="margin:6px 0;"><b> Lý do khám bệnh:</b> ${
         dataSend.reason || "Lý do khám"
       }</p>
    </div>

    <!-- THANK YOU -->
    <p>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ khám bệnh của chúng tôi!</p>

    <!-- BANNER IMAGE -->
    <div style="margin-top: 25px;">
        <img src="cid:banner_image" style="width: 100%; max-width: 480px; border-radius: 8px;" />
    </div>


    <!-- FOOTER -->
    <p style="font-size:13px; color:#777; margin-top:30px; text-align:center; line-height:1.4;">
      Đây là email tự động, vui lòng không phản hồi trực tiếp.<br />
      LIFE CARE © 2025 — Hệ thống khám bệnh trực tuyến.  
      Hotline hỗ trợ: <b>1900 9999</b>
    </p>

  </div>
</div>
        `,

    attachments: [
      {
        filename: `redemy-${dataSend.patientName}-${new Date().getTime()}.png`,
        content: base64Data, // Đặt Base64 vào đây
        encoding: "base64",
        cid: "banner_image", // giống với cid trong HTML
      },
    ],
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) return console.log(error);
    console.log("Email sent: " + info.response);
  });
};

module.exports = {
  sendSimpleEmail,
  sendResultEmail,
};
