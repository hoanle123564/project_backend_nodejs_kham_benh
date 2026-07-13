-- Run manually after backup on the target MySQL database. This file does not execute automatically.
-- Safety: audit duplicate legacy schedules before adding the logical-slot unique index.

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN startTime TIME NULL AFTER timeType', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'startTime'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN endTime TIME NULL AFTER startTime', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'endTime'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN price INT DEFAULT NULL AFTER appointmentTypeId', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'price'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN capacity INT NOT NULL DEFAULT 1 AFTER price', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'capacity'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN isActive TINYINT(1) NOT NULL DEFAULT 1 AFTER capacity', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'isActive'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN sourceType VARCHAR(20) NOT NULL DEFAULT ''LEGACY'' AFTER isActive', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'sourceType'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN sourceRuleId INT NULL AFTER sourceType', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'sourceRuleId'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN minBookingNoticeDays INT NOT NULL DEFAULT 0 AFTER sourceRuleId', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'minBookingNoticeDays'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN maxBookingAheadDays INT NOT NULL DEFAULT 30 AFTER minBookingNoticeDays', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'maxBookingAheadDays'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD COLUMN discountPercent DECIMAL(5,2) NOT NULL DEFAULT 0 AFTER maxBookingAheadDays', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND COLUMN_NAME = 'discountPercent'
);
PREPARE schedule_stmt FROM @schedule_column;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

ALTER TABLE schedule MODIFY timeType VARCHAR(50) COLLATE utf8mb4_unicode_ci NULL;

UPDATE schedule s
LEFT JOIN lookup lt
  ON lt.keyMap = s.timeType AND lt.type = 'TIME'
SET
  s.startTime = COALESCE(
    s.startTime,
    STR_TO_DATE(TRIM(SUBSTRING_INDEX(lt.value_vi, ' - ', 1)), '%H:%i')
  ),
  s.endTime = COALESCE(
    s.endTime,
    STR_TO_DATE(TRIM(SUBSTRING_INDEX(lt.value_vi, ' - ', -1)), '%H:%i')
  ),
  s.appointmentTypeId = COALESCE(s.appointmentTypeId, 'AT1'),
  s.capacity = GREATEST(COALESCE(s.capacity, 1), 1),
  s.isActive = COALESCE(s.isActive, 1),
  s.sourceType = COALESCE(NULLIF(s.sourceType, ''), 'LEGACY'),
  s.minBookingNoticeDays = GREATEST(COALESCE(s.minBookingNoticeDays, 0), 0),
  s.maxBookingAheadDays = GREATEST(COALESCE(s.maxBookingAheadDays, 30), COALESCE(s.minBookingNoticeDays, 0)),
  s.discountPercent = LEAST(GREATEST(COALESCE(s.discountPercent, 0), 0), 100)
WHERE s.timeType IS NOT NULL;

DROP TEMPORARY TABLE IF EXISTS tmp_schedule_duplicate_audit;
CREATE TEMPORARY TABLE tmp_schedule_duplicate_audit AS
SELECT
  doctorId,
  date,
  COALESCE(appointmentTypeId, 'AT1') AS appointmentTypeId,
  startTime,
  endTime,
  COUNT(*) AS duplicateCount,
  GROUP_CONCAT(id ORDER BY id ASC) AS scheduleIds
FROM schedule
WHERE startTime IS NOT NULL AND endTime IS NOT NULL
GROUP BY doctorId, date, COALESCE(appointmentTypeId, 'AT1'), startTime, endTime
HAVING COUNT(*) > 1;

SELECT * FROM tmp_schedule_duplicate_audit;

SET @duplicate_count := (SELECT COUNT(*) FROM tmp_schedule_duplicate_audit);
SET @duplicate_guard := IF(
  @duplicate_count > 0,
  'SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ''Unsafe schedule unique index: duplicate logical slots found. Review tmp_schedule_duplicate_audit result before rerun.''',
  'SELECT ''No duplicate logical schedule rows found'' AS migration_audit'
);
PREPARE schedule_stmt FROM @duplicate_guard;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

CREATE TABLE IF NOT EXISTS `doctor_schedule_rule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctorId` int NOT NULL,
  `ruleType` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'FIXED, OFF, FLEXIBLE',
  `weekday` tinyint NULL COMMENT '1=Monday, 7=Sunday; used by FIXED',
  `date` date NULL COMMENT 'Used by OFF and FLEXIBLE',
  `appointmentTypeId` varchar(50) COLLATE utf8mb4_unicode_ci NULL COMMENT 'AT1/AT2; NULL OFF applies to all types',
  `startTime` time NOT NULL,
  `endTime` time NOT NULL,
  `slotDurationMinutes` int NULL,
  `capacity` int NULL,
  `minBookingNoticeDays` int NOT NULL DEFAULT 0,
  `maxBookingAheadDays` int NOT NULL DEFAULT 30,
  `price` int DEFAULT NULL,
  `discountPercent` decimal(5,2) NOT NULL DEFAULT 0,
  `isFullDay` tinyint(1) NOT NULL DEFAULT 0,
  `isActive` tinyint(1) NOT NULL DEFAULT 1,
  `createdBy` int DEFAULT NULL,
  `createdAt` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_schedule_rule_doctor_type` (`doctorId`, `ruleType`, `isActive`),
  KEY `idx_schedule_rule_date` (`doctorId`, `date`, `appointmentTypeId`, `isActive`),
  KEY `idx_schedule_rule_weekday` (`doctorId`, `weekday`, `appointmentTypeId`, `isActive`),
  CONSTRAINT `fk_schedule_rule_doctor`
    FOREIGN KEY (`doctorId`) REFERENCES `users` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_schedule_rule_created_by`
    FOREIGN KEY (`createdBy`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

SET @old_schedule_unique := (
  SELECT IF(COUNT(*) > 0, 'ALTER TABLE schedule DROP INDEX unique_schedule', 'SELECT 1')
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND INDEX_NAME = 'unique_schedule'
);
PREPARE schedule_stmt FROM @old_schedule_unique;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @new_schedule_unique := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD UNIQUE KEY unique_schedule_logical_slot (doctorId, date, appointmentTypeId, startTime, endTime)', 'SELECT 1')
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND INDEX_NAME = 'unique_schedule_logical_slot'
);
PREPARE schedule_stmt FROM @new_schedule_unique;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_index := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD KEY idx_schedule_active_slot (doctorId, date, appointmentTypeId, isActive, startTime)', 'SELECT 1')
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND INDEX_NAME = 'idx_schedule_active_slot'
);
PREPARE schedule_stmt FROM @schedule_index;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_index := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD KEY idx_schedule_source_rule (sourceRuleId, sourceType)', 'SELECT 1')
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'schedule' AND INDEX_NAME = 'idx_schedule_source_rule'
);
PREPARE schedule_stmt FROM @schedule_index;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;

SET @schedule_fk := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE schedule ADD CONSTRAINT fk_schedule_source_rule FOREIGN KEY (sourceRuleId) REFERENCES doctor_schedule_rule (id) ON DELETE RESTRICT ON UPDATE CASCADE', 'SELECT 1')
  FROM information_schema.REFERENTIAL_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND CONSTRAINT_NAME = 'fk_schedule_source_rule'
);
PREPARE schedule_stmt FROM @schedule_fk;
EXECUTE schedule_stmt;
DEALLOCATE PREPARE schedule_stmt;
