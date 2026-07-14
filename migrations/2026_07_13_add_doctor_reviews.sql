-- Run manually after backup on the target MySQL database.
-- Additive only: no data deletion and no physical review deletes.

INSERT INTO lookup (keyMap, type, value_vi, value_en) VALUES
  ('RV1', 'REVIEW_STATUS', 'Đang hiển thị', 'Visible'),
  ('RV2', 'REVIEW_STATUS', 'Đã ẩn', 'Hidden')
ON DUPLICATE KEY UPDATE
  value_vi = VALUES(value_vi),
  value_en = VALUES(value_en);

CREATE TABLE IF NOT EXISTS `doctor_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `patientId` int NOT NULL,
  `doctorId` int NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `statusId` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RV1',
  `hiddenReason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hiddenBy` int DEFAULT NULL,
  `hiddenAt` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_doctor_review_booking` (`bookingId`),
  KEY `idx_doctor_reviews_doctor_status_created` (`doctorId`, `statusId`, `createdAt`),
  KEY `idx_doctor_reviews_doctor_rating_status_created` (`doctorId`, `rating`, `statusId`, `createdAt`),
  KEY `idx_doctor_reviews_patient_created` (`patientId`, `createdAt`),
  KEY `idx_doctor_reviews_status_created` (`statusId`, `createdAt`),
  KEY `idx_doctor_reviews_hidden_by` (`hiddenBy`),
  CONSTRAINT `chk_doctor_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5),
  CONSTRAINT `fk_doctor_reviews_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_reviews_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_reviews_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_reviews_hidden_by` FOREIGN KEY (`hiddenBy`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `doctor_review_replies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reviewId` int NOT NULL,
  `doctorId` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_doctor_review_reply` (`reviewId`),
  KEY `idx_doctor_review_replies_doctor` (`doctorId`),
  CONSTRAINT `fk_doctor_review_replies_review` FOREIGN KEY (`reviewId`) REFERENCES `doctor_reviews` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_review_replies_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

SET @doctor_notification_review_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE doctor_notifications ADD COLUMN reviewId INT NULL AFTER chatRoomId', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'doctor_notifications' AND COLUMN_NAME = 'reviewId'
);
PREPARE doctor_notification_stmt FROM @doctor_notification_review_column;
EXECUTE doctor_notification_stmt;
DEALLOCATE PREPARE doctor_notification_stmt;

SET @doctor_notification_review_index := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE doctor_notifications ADD UNIQUE KEY unique_doctor_notification_review (reviewId, type)', 'SELECT 1')
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'doctor_notifications' AND INDEX_NAME = 'unique_doctor_notification_review'
);
PREPARE doctor_notification_stmt FROM @doctor_notification_review_index;
EXECUTE doctor_notification_stmt;
DEALLOCATE PREPARE doctor_notification_stmt;

SET @doctor_notification_review_fk := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE doctor_notifications ADD CONSTRAINT fk_doctor_notification_review FOREIGN KEY (reviewId) REFERENCES doctor_reviews (id) ON DELETE RESTRICT ON UPDATE CASCADE', 'SELECT 1')
  FROM information_schema.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'doctor_notifications' AND CONSTRAINT_NAME = 'fk_doctor_notification_review'
);
PREPARE doctor_notification_stmt FROM @doctor_notification_review_fk;
EXECUTE doctor_notification_stmt;
DEALLOCATE PREPARE doctor_notification_stmt;
