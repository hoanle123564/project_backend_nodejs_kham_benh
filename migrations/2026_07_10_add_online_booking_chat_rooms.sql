-- Add doctor-patient chat rooms for online bookings.
-- Run on the active MySQL database only after explicit approval.

CREATE TABLE IF NOT EXISTS `chat_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `doctorId` int NOT NULL,
  `patientId` int NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE, CLOSED, DISABLED',
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_chat_room_booking` (`bookingId`),
  KEY `idx_chat_rooms_doctor` (`doctorId`),
  KEY `idx_chat_rooms_patient` (`patientId`),
  KEY `idx_chat_rooms_status` (`status`),
  CONSTRAINT `fk_chat_rooms_booking`
    FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_rooms_doctor`
    FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_rooms_patient`
    FOREIGN KEY (`patientId`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `chat_room_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomId` int NOT NULL,
  `senderId` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `messageType` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TEXT',
  `isRead` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_room_messages_room_created` (`roomId`, `createdAt`, `id`),
  KEY `idx_chat_room_messages_sender` (`senderId`),
  KEY `idx_chat_room_messages_unread` (`roomId`, `senderId`, `isRead`),
  CONSTRAINT `fk_chat_room_messages_room`
    FOREIGN KEY (`roomId`) REFERENCES `chat_rooms` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_chat_room_messages_sender`
    FOREIGN KEY (`senderId`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
