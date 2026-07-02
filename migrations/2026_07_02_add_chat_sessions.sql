CREATE TABLE IF NOT EXISTS `chat_sessions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `sessionId` VARCHAR(100) NOT NULL,
  `patientId` INT NULL,
  `state` VARCHAR(50) NOT NULL,
  `collectedInfo` JSON NOT NULL,
  `selectedDoctorId` INT NULL,
  `selectedScheduleId` INT NULL,
  `bookingId` INT NULL,
  `lastAiResult` JSON NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expiresAt` DATETIME NULL,
  UNIQUE KEY `unique_chat_session_id` (`sessionId`),
  KEY `idx_chat_sessions_patient` (`patientId`),
  KEY `idx_chat_sessions_state` (`state`),
  CONSTRAINT `fk_chat_session_patient` FOREIGN KEY (`patientId`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_chat_session_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;
