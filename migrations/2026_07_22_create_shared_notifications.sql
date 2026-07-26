-- Run manually after backup on the target MySQL database.
-- Expand only: legacy doctor_notifications remains available for rollback.

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `recipientUserId` INT NOT NULL,
  `recipientRole` VARCHAR(10) NOT NULL COMMENT 'R2 doctor, R3 patient',
  `bookingId` INT NOT NULL,
  `chatRoomId` INT DEFAULT NULL,
  `reviewId` INT DEFAULT NULL,
  `sourceMessageId` INT DEFAULT NULL,
  `reminderId` INT DEFAULT NULL,
  `bookingStatusId` VARCHAR(10) DEFAULT NULL,
  `type` VARCHAR(40) NOT NULL,
  `content` VARCHAR(500) DEFAULT NULL,
  `isRead` TINYINT(1) NOT NULL DEFAULT 0,
  `readAt` DATETIME DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_notification_message` (`sourceMessageId`, `recipientRole`),
  UNIQUE KEY `unique_notification_review` (`reviewId`, `type`, `recipientRole`),
  UNIQUE KEY `unique_notification_reminder` (`reminderId`, `type`, `recipientRole`),
  UNIQUE KEY `unique_notification_booking_status` (`bookingId`, `bookingStatusId`, `type`, `recipientRole`),
  KEY `idx_notification_feed` (`recipientUserId`, `recipientRole`, `isRead`, `createdAt`),
  CONSTRAINT `fk_notification_recipient` FOREIGN KEY (`recipientUserId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_booking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_room` FOREIGN KEY (`chatRoomId`) REFERENCES `chat_rooms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_review` FOREIGN KEY (`reviewId`) REFERENCES `doctor_reviews` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_message` FOREIGN KEY (`sourceMessageId`) REFERENCES `chat_room_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_reminder` FOREIGN KEY (`reminderId`) REFERENCES `appointment_reminders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET @doctor_notifications_exist := (
  SELECT COUNT(*)
  FROM information_schema.TABLES
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'doctor_notifications'
);
SET @doctor_notification_has_review_id := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'doctor_notifications' AND COLUMN_NAME = 'reviewId'
);
SET @backfill_doctor_notifications_sql := IF(
  @doctor_notifications_exist = 0,
  'SELECT 1',
  IF(
    @doctor_notification_has_review_id = 1,
    'INSERT IGNORE INTO notifications (recipientUserId, recipientRole, bookingId, chatRoomId, reviewId, sourceMessageId, type, content, isRead, readAt, createdAt) SELECT doctorId, ''R2'', bookingId, chatRoomId, reviewId, sourceMessageId, type, content, isRead, readAt, createdAt FROM doctor_notifications',
    'INSERT IGNORE INTO notifications (recipientUserId, recipientRole, bookingId, chatRoomId, sourceMessageId, type, content, isRead, readAt, createdAt) SELECT doctorId, ''R2'', bookingId, chatRoomId, sourceMessageId, type, content, isRead, readAt, createdAt FROM doctor_notifications'
  )
);
PREPARE backfill_doctor_notifications FROM @backfill_doctor_notifications_sql;
EXECUTE backfill_doctor_notifications;
DEALLOCATE PREPARE backfill_doctor_notifications;

SELECT COUNT(*) AS shared_doctor_notification_count
FROM notifications
WHERE recipientRole = 'R2';
