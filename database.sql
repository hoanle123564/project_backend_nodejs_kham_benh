CREATE DATABASE IF NOT EXISTS kham_benh_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kham_benh_db;

-- =====================================================
-- BẢNG 1: LOOKUP (Bảng tra cứu)
-- Lưu các giá trị: GENDER, POSITION, PRICE, PAYMENT, TIME, STATUS, PROVINCE
-- =====================================================
CREATE TABLE IF NOT EXISTS `lookup` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `keyMap` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL COMMENT 'GENDER, POSITION, PRICE, PAYMENT, TIME, STATUS, PROVINCE, DISTRICT, WARD, CLINIC_TYPE',
    `parentKeyMap` VARCHAR(50) DEFAULT NULL COMMENT 'Hierarchical lookup parent: DISTRICT -> PROVINCE, WARD -> DISTRICT',
    `value_vi` VARCHAR(255) DEFAULT NULL,
    `value_en` VARCHAR(255) DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_keyMap` (`keyMap`),
    INDEX `idx_type` (`type`),
    INDEX `idx_lookup_type_parent` (`type`, `parentKeyMap`),
    UNIQUE KEY `unique_keyMap_type` (`keyMap`, `type`)
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 2: USERS (Người dùng)
-- Lưu thông tin: Admin (R1), Bác sĩ (R2), Bệnh nhân (R3)
-- =====================================================
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) DEFAULT NULL COMMENT 'Có thể null với khách vãng lai',
    `firstName` VARCHAR(100) DEFAULT NULL,
    `lastName` VARCHAR(100) DEFAULT NULL,
    `address` VARCHAR(500) DEFAULT NULL,
    `provinceCode` VARCHAR(50) DEFAULT NULL COMMENT 'Personal address province, lookup.keyMap type=PROVINCE',
    `districtCode` VARCHAR(50) DEFAULT NULL COMMENT 'Personal address district, lookup.keyMap type=DISTRICT',
    `wardCode` VARCHAR(50) DEFAULT NULL COMMENT 'Personal address ward, lookup.keyMap type=WARD',
    `gender` VARCHAR(10) DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=GENDER',
    `roleId` VARCHAR(10) DEFAULT NULL COMMENT 'R1=Admin, R2=Doctor, R3=Patient, R4=Clinic Manager',
    `phoneNumber` VARCHAR(20) DEFAULT NULL,
    `positionId` VARCHAR(10) DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=POSITION',
    `image` LONGTEXT DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_email` (`email`),
    INDEX `idx_roleId` (`roleId`),
    INDEX `idx_email` (`email`),
    INDEX `idx_users_location` (`provinceCode`, `districtCode`, `wardCode`)
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 3: SPECIALTY (Chuyên khoa)
-- =====================================================
CREATE TABLE IF NOT EXISTS `specialty` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Base64 image',
  `descriptionHTML` text COLLATE utf8mb4_unicode_ci,
  `descriptionMarkdown` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isActive` tinyint(1) DEFAULT '1',
  `displayOrder` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_specialty_slug` (`slug`),
  KEY `idx_name` (`name`),
  KEY `idx_specialty_isActive` (`isActive`),
  KEY `idx_specialty_displayOrder` (`displayOrder`)
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 4: CLINIC (Phòng khám)
-- =====================================================
CREATE TABLE IF NOT EXISTS `clinic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `clinicTypeId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CT1=Clinic, CT2=Hospital',
  `managerUserId` int DEFAULT NULL COMMENT 'FK to users.id, usually role R4',
  `provinceCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clinic work province, lookup.keyMap type=PROVINCE',
  `districtCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clinic district, lookup.keyMap type=DISTRICT',
  `wardCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Clinic ward, lookup.keyMap type=WARD',
  `image` longtext COLLATE utf8mb4_unicode_ci,
  `descriptionHTML` text COLLATE utf8mb4_unicode_ci,
  `descriptionMarkdown` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isActive` tinyint(1) DEFAULT '1',
  `displayOrder` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_clinic_slug` (`slug`),
  KEY `idx_name` (`name`),
  KEY `idx_clinic_isActive` (`isActive`),
  KEY `idx_clinic_displayOrder` (`displayOrder`),
  KEY `idx_clinic_type` (`clinicTypeId`),
  KEY `idx_clinic_manager` (`managerUserId`),
  KEY `idx_clinic_location` (`provinceCode`, `districtCode`, `wardCode`),
  CONSTRAINT `fk_clinic_manager` FOREIGN KEY (`managerUserId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `clinic_department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clinicId` int NOT NULL,
  `specialtyId` int NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `isActive` tinyint(1) DEFAULT '1',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_clinic_department_specialty` (`clinicId`, `specialtyId`),
  KEY `idx_clinic_department_clinic` (`clinicId`),
  KEY `idx_clinic_department_specialty` (`specialtyId`),
  KEY `idx_clinic_department_active` (`isActive`),
  CONSTRAINT `fk_clinic_department_clinic` FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_clinic_department_specialty` FOREIGN KEY (`specialtyId`) REFERENCES `specialty` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 5: DOCTOR_INFO (Thông tin chi tiết bác sĩ)
-- Bao gồm: giá, phương thức thanh toán, chuyên khoa, phòng khám
-- =====================================================
CREATE TABLE IF NOT EXISTS `doctor_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctorId` int NOT NULL,
  `contentHTML` TEXT DEFAULT NULL,
  `contentMarkdown` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` int DEFAULT '1',
  `displayOrder` int DEFAULT '0',
  `priceId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PRICE',
  `paymentId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PAYMENT',
  `specialtyId` int DEFAULT NULL COMMENT 'FK to specialty.id',
  `clinicId` int DEFAULT NULL COMMENT 'FK to clinic.id',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_doctorId` (`doctorId`),
  UNIQUE KEY `unique_doctor_info_slug` (`slug`),
  KEY `idx_doctorId` (`doctorId`),
  KEY `idx_specialtyId` (`specialtyId`),
  KEY `idx_clinicId` (`clinicId`),
  CONSTRAINT `fk_doctor_info_clinic` FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_info_specialty` FOREIGN KEY (`specialtyId`) REFERENCES `specialty` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_info_user` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 6: SCHEDULE (Lịch làm việc bác sĩ)
-- =====================================================
CREATE TABLE IF NOT EXISTS `schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctorId` int NOT NULL COMMENT 'FK to users.id',
  `date` date NOT NULL,
  `timeType` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tham chiếu lookup.keyMap với type=TIME (T1-T8)',
  `maxNumber` int DEFAULT '10' COMMENT 'Số lượng bệnh nhân tối đa',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_schedule` (`doctorId`,`date`,`timeType`),
  KEY `idx_doctorId` (`doctorId`),
  KEY `idx_date` (`date`),
  KEY `idx_doctorId_date` (`doctorId`,`date`),
  CONSTRAINT `fk_schedule_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 8: BOOKING (Đặt lịch khám)
-- statusId: S1=Chờ xác nhận, S2=Đã xác nhận, S3=Đã khám, S4=Đã hủy
-- =====================================================
CREATE TABLE IF NOT EXISTS `booking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statusId` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'S1' COMMENT 'S1=Chờ xác nhận, S2=Đã xác nhận, S3=Đã khám, S4=Đã hủy',
  `patientId` int NOT NULL COMMENT 'FK to users.id (Patient)',
  `scheduleId` int NOT NULL,
  `date` date NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci COMMENT 'Lý do khám',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Token xác nhận email',
  `priceAtBooking` int DEFAULT '0',
  `paymentMethodId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Phương thức thanh toán bệnh nhân chọn lúc đặt lịch',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_patientId` (`patientId`),
  KEY `idx_date` (`date`),
  KEY `idx_statusId` (`statusId`),
  KEY `idx_token` (`token`),
  KEY `idx_doctor_patient_date_time` (`patientId`,`date`),
  KEY `idx_booking_payment_method` (`paymentMethodId`),
  KEY `fk_booking_schedule` (`scheduleId`),
  CONSTRAINT `fk_booking_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_schedule` FOREIGN KEY (`scheduleId`) REFERENCES `schedule` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BANG 8A: BOOKING_QUEUE_SEQUENCE (Bo dem STT theo bac si/ngay)
-- Dung cho transaction cap STT booking bang row lock o cac phase runtime sau.
-- =====================================================
CREATE TABLE IF NOT EXISTS `booking_queue_sequence` (
  `doctorId` int NOT NULL,
  `appointmentDate` date NOT NULL,
  `currentNumber` int NOT NULL DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`doctorId`,`appointmentDate`),
  CONSTRAINT `fk_booking_queue_sequence_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BANG 8B: BOOKING_QUEUE (STT kham duoc cap tai thoi diem booking)
-- Luu STT rieng voi booking vi booking giu scheduleId lam quan he loi va khong co doctorId truc tiep.
-- =====================================================
CREATE TABLE IF NOT EXISTS `booking_queue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `doctorId` int NOT NULL,
  `appointmentDate` date NOT NULL,
  `queueNumber` int NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_booking_queue_booking` (`bookingId`),
  UNIQUE KEY `unique_booking_queue_scope` (`doctorId`,`appointmentDate`,`queueNumber`),
  KEY `idx_booking_queue_doctor_date` (`doctorId`,`appointmentDate`),
  KEY `idx_booking_queue_number` (`queueNumber`),
  CONSTRAINT `fk_booking_queue_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_queue_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 9: EXAMINATION_VISIT (Lượt khám trong ngày)
-- Quản lý STT khám theo từng bác sĩ/ngày, trạng thái khám và thanh toán
-- =====================================================
CREATE TABLE IF NOT EXISTS `examination_visit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `patientId` int NOT NULL,
  `doctorId` int NOT NULL,
  `examDate` date NOT NULL,
  `queueNumber` int NOT NULL COMMENT 'STT khám theo từng bác sĩ trong ngày',
  `statusId` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'VS1' COMMENT 'VS1=Chờ khám, VS2=Đang khám, VS3=Đã khám xong',
  `paymentStatusId` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'PS1' COMMENT 'PS1=Chưa thanh toán, PS2=Đã thanh toán',
  `paidAmount` int DEFAULT '0',
  `paymentMethodId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PAYMENT',
  `paidAt` timestamp NULL DEFAULT NULL,
  `startedAt` timestamp NULL DEFAULT NULL,
  `completedAt` timestamp NULL DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_examination_visit_booking` (`bookingId`),
  UNIQUE KEY `unique_doctor_exam_queue` (`doctorId`,`examDate`,`queueNumber`),
  KEY `idx_examination_visit_patient` (`patientId`),
  KEY `idx_examination_visit_doctor_date` (`doctorId`,`examDate`),
  KEY `idx_examination_visit_status` (`statusId`),
  KEY `idx_examination_visit_payment` (`paymentStatusId`),
  CONSTRAINT `fk_examination_visit_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_examination_visit_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_examination_visit_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 10: PATIENT_PROFILE (Hồ sơ nền của bệnh nhân)
-- =====================================================
CREATE TABLE IF NOT EXISTS `patient_profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patientId` int NOT NULL,
  `medicalCode` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `bloodType` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `heightCm` decimal(5,2) DEFAULT NULL,
  `weightKg` decimal(5,2) DEFAULT NULL,
  `allergies` text COLLATE utf8mb4_unicode_ci,
  `citizenId` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ethnicityId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Logical reference to lookup.keyMap with type=ETHNICITY',
  `occupation` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `healthInsuranceCode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_patient_profile_patient` (`patientId`),
  UNIQUE KEY `unique_patient_profile_code` (`medicalCode`),
  KEY `idx_patient_profile_patient` (`patientId`),
  KEY `idx_patient_profile_citizen` (`citizenId`),
  KEY `idx_patient_profile_ethnicity` (`ethnicityId`),
  CONSTRAINT `fk_patient_profile_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 11: MEDICAL_RECORD (Bệnh án theo từng lần khám)
-- =====================================================
CREATE TABLE IF NOT EXISTS `medical_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `examinationVisitId` int NOT NULL,
  `patientId` int NOT NULL,
  `doctorId` int NOT NULL,
  `patientSnapshotName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientSnapshotDateOfBirth` date DEFAULT NULL,
  `patientSnapshotGender` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientSnapshotPhoneNumber` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientSnapshotAddress` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientSnapshotCitizenId` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patientSnapshotHealthInsuranceCode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `chiefComplaint` text COLLATE utf8mb4_unicode_ci,
  `symptoms` text COLLATE utf8mb4_unicode_ci,
  `clinicalSigns` text COLLATE utf8mb4_unicode_ci,
  `preliminaryDiagnosis` text COLLATE utf8mb4_unicode_ci,
  `finalDiagnosis` text COLLATE utf8mb4_unicode_ci,
  `treatmentPlan` text COLLATE utf8mb4_unicode_ci,
  `doctorConclusion` text COLLATE utf8mb4_unicode_ci,
  `generalNote` text COLLATE utf8mb4_unicode_ci,
  `followUpDate` date DEFAULT NULL,
  `followUpNote` text COLLATE utf8mb4_unicode_ci,
  `statusId` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'MR1' COMMENT 'MR1=Open draft, MR2=Closed record',
  `closedAt` timestamp NULL DEFAULT NULL,
  `closedBy` int DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_medical_record_booking` (`bookingId`),
  UNIQUE KEY `unique_medical_record_visit` (`examinationVisitId`),
  KEY `idx_medical_record_patient` (`patientId`),
  KEY `idx_medical_record_doctor` (`doctorId`),
  KEY `idx_medical_record_status` (`statusId`),
  KEY `idx_medical_record_closed_by` (`closedBy`),
  KEY `idx_medical_record_follow_up` (`followUpDate`),
  CONSTRAINT `fk_medical_record_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_medical_record_visit` FOREIGN KEY (`examinationVisitId`) REFERENCES `examination_visit` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_medical_record_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_medical_record_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_medical_record_closed_by` FOREIGN KEY (`closedBy`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 12: PARACLINICAL_RESULT (Cận lâm sàng)
-- Lưu xét nghiệm, chẩn đoán hình ảnh hoặc kết quả cận lâm sàng khác theo bệnh án
-- =====================================================
CREATE TABLE IF NOT EXISTS `paraclinical_result` (
  `id` int NOT NULL AUTO_INCREMENT,
  `medicalRecordId` int NOT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'XET_NGHIEM, CHAN_DOAN_HINH_ANH, KHAC',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resultSummary` text COLLATE utf8mb4_unicode_ci,
  `note` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_paraclinical_record` (`medicalRecordId`),
  CONSTRAINT `fk_paraclinical_record` FOREIGN KEY (`medicalRecordId`) REFERENCES `medical_record` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 13: PRESCRIPTION (Đơn thuốc)
-- =====================================================
CREATE TABLE IF NOT EXISTS `prescription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `medicalRecordId` int NOT NULL,
  `patientId` int NOT NULL,
  `doctorId` int NOT NULL,
  `prescriptionCode` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_prescription_record` (`medicalRecordId`),
  UNIQUE KEY `unique_prescription_code` (`prescriptionCode`),
  KEY `idx_prescription_patient` (`patientId`),
  KEY `idx_prescription_doctor` (`doctorId`),
  CONSTRAINT `fk_prescription_record` FOREIGN KEY (`medicalRecordId`) REFERENCES `medical_record` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 14: PRESCRIPTION_ITEM (Chi tiết thuốc)
-- =====================================================
CREATE TABLE IF NOT EXISTS `prescription_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `prescriptionId` int NOT NULL,
  `medicineName` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dosageForm` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `strength` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usageDays` int DEFAULT '1',
  `morningQty` decimal(5,2) DEFAULT '0.00',
  `noonQty` decimal(5,2) DEFAULT '0.00',
  `afternoonQty` decimal(5,2) DEFAULT '0.00',
  `eveningQty` decimal(5,2) DEFAULT '0.00',
  `totalQuantity` decimal(10,2) DEFAULT '0.00',
  `instruction` text COLLATE utf8mb4_unicode_ci,
  `note` text COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_prescription_item_prescription` (`prescriptionId`),
  CONSTRAINT `fk_prescription_item_prescription` FOREIGN KEY (`prescriptionId`) REFERENCES `prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `post` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tiêu đề bài viết',
  `shortDescription` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả ngắn nội dung bài viết',
  `contentHTML` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Nội dung bài viết dạng HTML',
  `contentMarkdown` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Nội dung bài viết dạng Markdown',
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ảnh đại diện bài viết, có thể lưu URL hoặc Base64',
  `bannerImage` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Ảnh banner bên trong bài viết',
  `isActive` tinyint(1) DEFAULT '1' COMMENT '1=Hiển thị, 0=Tắt',
  `displayOrder` int DEFAULT '0' COMMENT 'Số thứ tự hiển thị',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_post_slug` (`slug`),
  KEY `idx_post_title` (`title`),
  KEY `idx_post_slug` (`slug`),
  KEY `idx_post_isActive` (`isActive`),
  KEY `idx_post_displayOrder` (`displayOrder`),
  KEY `idx_post_createdAt` (`createdAt`),
  CONSTRAINT `chk_post_isActive` CHECK ((`isActive` in (0,1)))
) ENGINE=InnoDB;


--
-- Table structure for table `post_category`
--

CREATE TABLE IF NOT EXISTS `post_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên danh mục bài viết',
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Slug danh mục bài viết',
  `displayOrder` int DEFAULT '0' COMMENT 'Số thứ tự hiển thị',
  `isActive` int DEFAULT '1' COMMENT '1=Hiển thị, 0=Tắt',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_post_category_slug` (`slug`),
  KEY `idx_post_category_name` (`name`),
  KEY `idx_post_category_displayOrder` (`displayOrder`),
  KEY `idx_post_category_isActive` (`isActive`),
  CONSTRAINT `chk_post_category_isActive` CHECK ((`isActive` in (0,1)))
) ENGINE=InnoDB;

--
-- Table structure for table `post_category_detail`
--

CREATE TABLE IF NOT EXISTS `post_category_detail` (
  `postId` int NOT NULL,
  `postCategoryId` int NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`postId`,`postCategoryId`),
  KEY `idx_post_category_detail_postCategoryId` (`postCategoryId`),
  CONSTRAINT `fk_post_category_detail_category` FOREIGN KEY (`postCategoryId`) REFERENCES `post_category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_category_detail_post` FOREIGN KEY (`postId`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
-- =====================================================
-- DỮ LIỆU MẪU CHO BẢNG LOOKUP
-- =====================================================

-- GENDER (Giới tính)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('M', 'GENDER', 'Nam', 'Male'),
('F', 'GENDER', 'Nữ', 'Female'),
('O', 'GENDER', 'Khác', 'Other');


-- ROLE (Vai trò) - Không dùng trực tiếp trong lookup nhưng để tham khảo
-- R1 = Admin, R2 = Doctor, R3 = Patient
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('R1', 'ROLE', 'Quản trị viên', 'Admin'),
('R2', 'ROLE', 'Bác sĩ', 'Doctor'),
('R3', 'ROLE', 'Bệnh nhân', 'Patient'),
('R4', 'ROLE', 'Quản lý cơ sở', 'Clinic Manager');

-- POSITION (Chức vụ bác sĩ)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('P0', 'POSITION', 'Bác sĩ', 'Doctor'),
('P1', 'POSITION', 'Thạc sĩ', 'Master'),
('P2', 'POSITION', 'Tiến sĩ', 'Doctor of Philosophy'),
('P3', 'POSITION', 'Phó Giáo sư', 'Associate Professor'),
('P4', 'POSITION', 'Giáo sư', 'Professor');

-- PRICE (Giá khám)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('PRI1', 'PRICE', '50000', '2.5'),
('PRI2', 'PRICE', '100000', '5'),
('PRI3', 'PRICE', '150000', '7.5'),
('PRI4', 'PRICE', '200000', '10'),
('PRI5', 'PRICE', '250000', '12.5'),
('PRI6', 'PRICE', '300000', '15'),
('PRI7', 'PRICE', '350000', '17.5'),
('PRI8', 'PRICE', '400000', '20'),
('PRI9', 'PRICE', '450000', '22.5'),
('PRI10', 'PRICE', '500000', '25'),
('PRI11', 'PRICE', '550000', '27.5'),
('PRI12', 'PRICE', '600000', '30'),
('PRI13', 'PRICE', '650000', '32.5'),
('PRI14', 'PRICE', '700000', '35'),
('PRI15', 'PRICE', '750000', '37.5'),
('PRI16', 'PRICE', '800000', '40'),
('PRI17', 'PRICE', '850000', '42.5'),
('PRI18', 'PRICE', '900000', '45'),
('PRI19', 'PRICE', '950000', '47.5'),
('PRI20', 'PRICE', '1000000', '50');

-- PAYMENT (Phương thức thanh toán)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('PAY1', 'PAYMENT', 'Tiền mặt', 'Cash'),
('PAY2', 'PAYMENT', 'Chuyển khoản', 'Bank Transfer'),
('PAY3', 'PAYMENT', 'Thẻ tín dụng', 'Credit Card');

-- CLINIC_TYPE (Loại cơ sở khám)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('CT1', 'CLINIC_TYPE', 'Phòng khám', 'Clinic'),
('CT2', 'CLINIC_TYPE', 'Bệnh viện', 'Hospital');

-- Thời gian khám
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
-- Sáng
('T1', 'TIME', '08:00 - 08:30', '8:00 AM - 8:30 AM'),
('T2', 'TIME', '08:30 - 09:00', '8:30 AM - 9:00 AM'),
('T3', 'TIME', '09:00 - 09:30', '9:00 AM - 9:30 AM'),
('T4', 'TIME', '09:30 - 10:00', '9:30 AM - 10:00 AM'),
('T5', 'TIME', '10:00 - 10:30', '10:00 AM - 10:30 AM'),
('T6', 'TIME', '10:30 - 11:00', '10:30 AM - 11:00 AM'),
('T7', 'TIME', '11:00 - 11:30', '11:00 AM - 11:30 AM'),
('T8', 'TIME', '11:30 - 12:00', '11:30 AM - 12:00 PM'),
-- Chiều
('T9', 'TIME', '12:00 - 12:30', '12:00 PM - 12:30 PM'),
('T10', 'TIME', '12:30 - 13:00', '12:30 PM - 1:00 PM'),
('T11', 'TIME', '13:00 - 13:30', '1:00 PM - 1:30 PM'),
('T12', 'TIME', '13:30 - 14:00', '1:30 PM - 2:00 PM'),
('T13', 'TIME', '14:00 - 14:30', '2:00 PM - 2:30 PM'),
('T14', 'TIME', '14:30 - 15:00', '2:30 PM - 3:00 PM'),
('T15', 'TIME', '15:00 - 15:30', '3:00 PM - 3:30 PM'),
('T16', 'TIME', '15:30 - 16:00', '3:30 PM - 4:00 PM'),
('T17', 'TIME', '16:00 - 16:30', '4:00 PM - 4:30 PM'),
('T18', 'TIME', '16:30 - 17:00', '4:30 PM - 5:00 PM'),
('T19', 'TIME', '17:00 - 17:30', '5:00 PM - 5:30 PM'),
('T20', 'TIME', '17:30 - 18:00', '5:30 PM - 6:00 PM');

-- STATUS (Trạng thái đặt lịch)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('S1', 'STATUS', 'Chờ xác nhận', 'Pending'),
('S2', 'STATUS', 'Đã xác nhận', 'Confirmed'),
('S3', 'STATUS', 'Đã khám xong', 'Completed'),
('S4', 'STATUS', 'Đã hủy', 'Cancelled');

-- VISIT_STATUS (Trạng thái lượt khám)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('VS1', 'VISIT_STATUS', 'Chờ khám', 'Waiting'),
('VS2', 'VISIT_STATUS', 'Đang khám', 'In progress'),
('VS3', 'VISIT_STATUS', 'Đã khám xong', 'Completed');

-- PAYMENT_STATUS (Trạng thái thanh toán)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('PS1', 'PAYMENT_STATUS', 'Chưa thanh toán', 'Unpaid'),
('PS2', 'PAYMENT_STATUS', 'Đã thanh toán', 'Paid');

-- MEDICAL_RECORD_STATUS (Trạng thái bệnh án)
INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('MR1', 'MEDICAL_RECORD_STATUS', 'Bản nháp', 'Draft'),
('MR2', 'MEDICAL_RECORD_STATUS', 'Hoàn thành', 'Completed');

-- TÀI KHOẢN ADMIN
-- Mật khẩu: 123456
INSERT IGNORE INTO `users` (`email`, `password`, `firstName`, `lastName`, `roleId`, `gender`) VALUES
('admin@gmail.com', '$2b$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX', 'Admin', 'System', 'R1', 'M');
