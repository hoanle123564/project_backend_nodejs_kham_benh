CREATE DATABASE IF NOT EXISTS kham_benh_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kham_benh_db;

-- =====================================================
-- BẢNG 1: LOOKUP (Bảng tra cứu)
-- Lưu các giá trị: GENDER, POSITION, PRICE, PAYMENT, TIME, STATUS, PROVINCE
-- =====================================================
CREATE TABLE IF NOT EXISTS `lookup` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `keyMap` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL COMMENT 'GENDER, POSITION, PRICE, PAYMENT, TIME, STATUS, PROVINCE',
    `value_vi` VARCHAR(255) DEFAULT NULL,
    `value_en` VARCHAR(255) DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_keyMap` (`keyMap`),
    INDEX `idx_type` (`type`),
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
    `gender` VARCHAR(10) DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=GENDER',
    `roleId` VARCHAR(10) DEFAULT NULL COMMENT 'R1=Admin, R2=Doctor, R3=Patient',
    `phoneNumber` VARCHAR(20) DEFAULT NULL,
    `positionId` VARCHAR(10) DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=POSITION',
    `image` LONGTEXT DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_email` (`email`),
    INDEX `idx_roleId` (`roleId`),
    INDEX `idx_email` (`email`)
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
  KEY `idx_clinic_displayOrder` (`displayOrder`)
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 5: DOCTOR (Thông tin markdown bác sĩ)
-- =====================================================
CREATE TABLE IF NOT EXISTS `doctor` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `doctorId` INT NOT NULL ,
    `contentHTML` TEXT DEFAULT NULL,
    `contentMarkdown` TEXT DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_doctorId` (`doctorId`),
    INDEX `idx_doctorId` (`doctorId`),
    CONSTRAINT `fk_doctor_user` FOREIGN KEY (`doctorId`) 
        REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- BẢNG 6: DOCTOR_INFO (Thông tin chi tiết bác sĩ)
-- Bao gồm: giá, phương thức thanh toán, chuyên khoa, phòng khám
-- =====================================================
CREATE TABLE IF NOT EXISTS `doctor_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctorId` int NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isActive` int DEFAULT '1',
  `displayOrder` int DEFAULT '0',
  `priceId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PRICE',
  `paymentId` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PAYMENT',
  `province` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tham chiếu lookup.keyMap với type=PROVINCE',
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
-- BẢNG 7: SCHEDULE (Lịch làm việc bác sĩ)
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
  `scheduleId` int DEFAULT NULL,
  `date` date NOT NULL,
  `reason` text COLLATE utf8mb4_unicode_ci COMMENT 'Lý do khám',
  `token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Token xác nhận email',
  `priceAtBooking` int DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_patientId` (`patientId`),
  KEY `idx_date` (`date`),
  KEY `idx_statusId` (`statusId`),
  KEY `idx_token` (`token`),
  KEY `idx_doctor_patient_date_time` (`patientId`,`date`),
  KEY `fk_booking_schedule` (`scheduleId`),
  CONSTRAINT `fk_booking_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_schedule` FOREIGN KEY (`scheduleId`) REFERENCES `schedule` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
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

DROP TABLE IF EXISTS `post_category`;
CREATE TABLE `post_category` (
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

DROP TABLE IF EXISTS `post_category_detail`;
CREATE TABLE `post_category_detail` (
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
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('M', 'GENDER', 'Nam', 'Male'),
('F', 'GENDER', 'Nữ', 'Female'),
('O', 'GENDER', 'Khác', 'Other');


-- ROLE (Vai trò) - Không dùng trực tiếp trong lookup nhưng để tham khảo
-- R1 = Admin, R2 = Doctor, R3 = Patient
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('R1', 'ROLE', 'Quản trị viên', 'Admin'),
('R2', 'ROLE', 'Bác sĩ', 'Doctor'),
('R3', 'ROLE', 'Bệnh nhân', 'Patient');

-- POSITION (Chức vụ bác sĩ)
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('P0', 'POSITION', 'Bác sĩ', 'Doctor'),
('P1', 'POSITION', 'Thạc sĩ', 'Master'),
('P2', 'POSITION', 'Tiến sĩ', 'Doctor of Philosophy'),
('P3', 'POSITION', 'Phó Giáo sư', 'Associate Professor'),
('P4', 'POSITION', 'Giáo sư', 'Professor');

-- PRICE (Giá khám)
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('PRI1', 'PRICE', '100.000 VNĐ', '5 USD'),
('PRI2', 'PRICE', '200.000 VNĐ', '10 USD'),
('PRI3', 'PRICE', '300.000 VNĐ', '15 USD'),
('PRI4', 'PRICE', '400.000 VNĐ', '20 USD'),
('PRI5', 'PRICE', '500.000 VNĐ', '25 USD');

-- PAYMENT (Phương thức thanh toán)
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('PAY1', 'PAYMENT', 'Tiền mặt', 'Cash'),
('PAY2', 'PAYMENT', 'Chuyển khoản', 'Bank Transfer'),
('PAY3', 'PAYMENT', 'Thẻ tín dụng', 'Credit Card');

-- Thời gian khám
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
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
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('S1', 'STATUS', 'Chờ xác nhận', 'Pending'),
('S2', 'STATUS', 'Đã xác nhận', 'Confirmed'),
('S3', 'STATUS', 'Đã khám xong', 'Completed'),
('S4', 'STATUS', 'Đã hủy', 'Cancelled');

-- PROVINCE (Tỉnh thành)
INSERT INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES 
('PRO1', 'PROVINCE', 'Hà Nội', 'Hanoi'),
('PRO2', 'PROVINCE', 'Hồ Chí Minh', 'Ho Chi Minh'),
('PRO3', 'PROVINCE', 'Đà Nẵng', 'Da Nang'),
('PRO4', 'PROVINCE', 'Hải Phòng', 'Hai Phong'),
('PRO5', 'PROVINCE', 'Cần Thơ', 'Can Tho');

-- TÀI KHOẢN ADMIN
-- Mật khẩu: 123456
INSERT INTO `users` (`email`, `password`, `firstName`, `lastName`, `roleId`, `gender`) VALUES 
('admin@gmail.com', '$2b$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX', 'Admin', 'System', 'R1', 'M');
