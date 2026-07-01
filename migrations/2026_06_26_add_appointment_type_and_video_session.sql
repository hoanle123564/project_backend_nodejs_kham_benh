-- Add appointment type lookup, schedule appointment type, and video session table.
-- This is additive. Run on the active MySQL database before deploying video consultation flows.

SET time_zone = '+07:00';

INSERT IGNORE INTO `lookup` (`keyMap`, `type`, `value_vi`, `value_en`) VALUES
('AT1', 'APPOINTMENT_TYPE', 'Kham tai phong kham', 'In-person visit'),
('AT2', 'APPOINTMENT_TYPE', 'Kham online/video', 'Online video visit'),
('VCS1', 'VIDEO_SESSION_STATUS', 'Chua mo', 'Not opened'),
('VCS2', 'VIDEO_SESSION_STATUS', 'Dang goi', 'In call'),
('VCS3', 'VIDEO_SESSION_STATUS', 'Da ket thuc', 'Ended'),
('VCS4', 'VIDEO_SESSION_STATUS', 'Huy/loi', 'Cancelled/error');

SET @schedule_appointment_type_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'schedule'
    AND COLUMN_NAME = 'appointmentTypeId'
);

SET @add_schedule_appointment_type_sql := IF(
  @schedule_appointment_type_exists = 0,
  'ALTER TABLE schedule ADD COLUMN appointmentTypeId varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT ''AT1'' COMMENT ''AT1=Kham tai phong kham, AT2=Kham online/video'' AFTER timeType',
  'SELECT ''schedule.appointmentTypeId already exists'' AS message'
);

PREPARE stmt FROM @add_schedule_appointment_type_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE schedule
SET appointmentTypeId = 'AT1'
WHERE appointmentTypeId IS NULL OR appointmentTypeId = '';

SET @schedule_appointment_type_index_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'schedule'
    AND INDEX_NAME = 'idx_schedule_appointment_type'
);

SET @add_schedule_appointment_type_index_sql := IF(
  @schedule_appointment_type_index_exists = 0,
  'ALTER TABLE schedule ADD INDEX idx_schedule_appointment_type (appointmentTypeId)',
  'SELECT ''schedule appointment type index already exists'' AS message'
);

PREPARE stmt FROM @add_schedule_appointment_type_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS `video_consultation_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `examinationVisitId` int DEFAULT NULL,
  `roomId` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `statusId` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VCS1' COMMENT 'VCS1=Chua mo, VCS2=Dang goi, VCS3=Da ket thuc, VCS4=Huy/loi',
  `startedAt` datetime NULL DEFAULT NULL,
  `endedAt` datetime NULL DEFAULT NULL,
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_video_session_booking` (`bookingId`),
  UNIQUE KEY `unique_video_session_room` (`roomId`),
  KEY `idx_video_session_visit` (`examinationVisitId`),
  KEY `idx_video_session_status` (`statusId`),
  CONSTRAINT `fk_video_session_booking`
    FOREIGN KEY (`bookingId`) REFERENCES `booking` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_video_session_visit`
    FOREIGN KEY (`examinationVisitId`) REFERENCES `examination_visit` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;
