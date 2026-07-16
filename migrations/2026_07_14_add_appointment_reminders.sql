-- Run manually after backup on the target MySQL database.
-- Additive only: persists per-booking reminder delivery state.

CREATE TABLE IF NOT EXISTS `appointment_reminders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `remindAt` datetime NOT NULL,
  `emailSentAt` datetime DEFAULT NULL,
  `smsSentAt` datetime DEFAULT NULL,
  `inAppNotifiedAt` datetime DEFAULT NULL,
  `smsSkippedAt` datetime DEFAULT NULL,
  `processingAt` datetime DEFAULT NULL,
  `lastError` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_appointment_reminder_booking` (`bookingId`),
  KEY `idx_appointment_reminders_due` (`remindAt`, `processingAt`),
  CONSTRAINT `fk_appointment_reminders_booking`
    FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
