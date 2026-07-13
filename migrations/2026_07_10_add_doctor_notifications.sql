CREATE TABLE IF NOT EXISTS `doctor_notifications` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `doctorId` INT NOT NULL,
  `bookingId` INT NOT NULL,
  `chatRoomId` INT DEFAULT NULL,
  `sourceMessageId` INT DEFAULT NULL,
  `type` VARCHAR(30) NOT NULL,
  `content` VARCHAR(500) DEFAULT NULL,
  `isRead` TINYINT(1) NOT NULL DEFAULT 0,
  `readAt` DATETIME DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_doctor_notification_message` (`sourceMessageId`),
  KEY `idx_doctor_notification_feed` (`doctorId`, `isRead`, `createdAt`),
  CONSTRAINT `fk_doctor_notification_doctor` FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_notification_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
