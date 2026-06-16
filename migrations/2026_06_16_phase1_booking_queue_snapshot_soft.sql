-- Phase 1 soft migration: booking STT queue, record snapshot, and closed metadata.
-- Scope: additive schema only. Do not drop, rename, or delete existing data.
-- Manual run only: review guard output first; do not run on live DB without approval.

-- =====================================================
-- 1) Guard queries
-- =====================================================
CREATE TEMPORARY TABLE IF NOT EXISTS `_phase1_guard_failures` (
  `guard_name` varchar(100) NOT NULL,
  `row_count` int NOT NULL,
  `sample_ids` varchar(1000) NULL
) ENGINE=Memory;

TRUNCATE TABLE `_phase1_guard_failures`;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'booking_without_schedule' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(b.id ORDER BY b.id), ',', 10) AS sample_ids
FROM `booking` b
LEFT JOIN `schedule` s ON s.id = b.scheduleId
WHERE s.id IS NULL
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'booking_date_mismatch_schedule_date' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(b.id ORDER BY b.id), ',', 10) AS sample_ids
FROM `booking` b
INNER JOIN `schedule` s ON s.id = b.scheduleId
WHERE b.date <> s.date
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'patient_profile_duplicate_patient' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(dup.patientId ORDER BY dup.patientId), ',', 10) AS sample_ids
FROM (
  SELECT patientId
  FROM `patient_profile`
  GROUP BY patientId
  HAVING COUNT(*) > 1
) dup
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'examination_visit_duplicate_booking' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(dup.bookingId ORDER BY dup.bookingId), ',', 10) AS sample_ids
FROM (
  SELECT bookingId
  FROM `examination_visit`
  GROUP BY bookingId
  HAVING COUNT(*) > 1
) dup
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'examination_visit_duplicate_queue_scope' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(
    GROUP_CONCAT(CONCAT(dup.doctorId, ':', dup.examDate, ':', dup.queueNumber) ORDER BY dup.doctorId, dup.examDate, dup.queueNumber),
    ',',
    10
  ) AS sample_ids
FROM (
  SELECT doctorId, examDate, queueNumber
  FROM `examination_visit`
  GROUP BY doctorId, examDate, queueNumber
  HAVING COUNT(*) > 1
) dup
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'medical_record_duplicate_booking' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(dup.bookingId ORDER BY dup.bookingId), ',', 10) AS sample_ids
FROM (
  SELECT bookingId
  FROM `medical_record`
  GROUP BY bookingId
  HAVING COUNT(*) > 1
) dup
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'medical_record_duplicate_visit' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(dup.examinationVisitId ORDER BY dup.examinationVisitId), ',', 10) AS sample_ids
FROM (
  SELECT examinationVisitId
  FROM `medical_record`
  GROUP BY examinationVisitId
  HAVING COUNT(*) > 1
) dup
HAVING COUNT(*) > 0;

INSERT INTO `_phase1_guard_failures` (`guard_name`, `row_count`, `sample_ids`)
SELECT
  'medical_record_without_patient_user' AS guard_name,
  COUNT(*) AS row_count,
  SUBSTRING_INDEX(GROUP_CONCAT(mr.id ORDER BY mr.id), ',', 10) AS sample_ids
FROM `medical_record` mr
LEFT JOIN `users` u ON u.id = mr.patientId
WHERE u.id IS NULL
HAVING COUNT(*) > 0;

SELECT *
FROM `_phase1_guard_failures`
ORDER BY `guard_name`;

SET @phase1_guard_failed = (SELECT COUNT(*) FROM `_phase1_guard_failures`);
SET @phase1_guard_sql = IF(
  @phase1_guard_failed = 0,
  'SELECT ''Phase 1 guards passed'' AS phase1_status',
  'SELECT * FROM `_phase1_guard_failed_stop_migration`'
);
PREPARE phase1_guard_stmt FROM @phase1_guard_sql;
EXECUTE phase1_guard_stmt;
DEALLOCATE PREPARE phase1_guard_stmt;

-- =====================================================
-- 2) Booking queue tables
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

-- Preserve existing visit STT first if live data already has examination_visit rows.
INSERT INTO `booking_queue` (`bookingId`, `doctorId`, `appointmentDate`, `queueNumber`, `createdAt`, `updatedAt`)
SELECT
  ev.bookingId,
  ev.doctorId,
  ev.examDate,
  ev.queueNumber,
  COALESCE(ev.createdAt, CURRENT_TIMESTAMP),
  CURRENT_TIMESTAMP
FROM `examination_visit` ev
INNER JOIN `booking` b ON b.id = ev.bookingId
INNER JOIN `schedule` s ON s.id = b.scheduleId
LEFT JOIN `booking_queue` existing ON existing.bookingId = ev.bookingId
WHERE existing.id IS NULL;

-- Backfill legacy bookings that do not yet have STT.
INSERT INTO `booking_queue` (`bookingId`, `doctorId`, `appointmentDate`, `queueNumber`, `createdAt`, `updatedAt`)
SELECT
  ranked.bookingId,
  ranked.doctorId,
  ranked.appointmentDate,
  ranked.baseQueueNumber + ranked.rowNumber AS queueNumber,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
FROM (
  SELECT
    b.id AS bookingId,
    s.doctorId AS doctorId,
    b.date AS appointmentDate,
    COALESCE(scope_max.maxQueueNumber, 0) AS baseQueueNumber,
    ROW_NUMBER() OVER (PARTITION BY s.doctorId, b.date ORDER BY b.id) AS rowNumber
  FROM `booking` b
  INNER JOIN `schedule` s ON s.id = b.scheduleId
  LEFT JOIN `booking_queue` existing ON existing.bookingId = b.id
  LEFT JOIN (
    SELECT doctorId, appointmentDate, MAX(queueNumber) AS maxQueueNumber
    FROM `booking_queue`
    GROUP BY doctorId, appointmentDate
  ) scope_max
    ON scope_max.doctorId = s.doctorId
   AND scope_max.appointmentDate = b.date
  WHERE existing.id IS NULL
) ranked;

INSERT INTO `booking_queue_sequence` (`doctorId`, `appointmentDate`, `currentNumber`, `createdAt`, `updatedAt`)
SELECT
  doctorId,
  appointmentDate,
  MAX(queueNumber) AS currentNumber,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
FROM `booking_queue`
GROUP BY doctorId, appointmentDate
ON DUPLICATE KEY UPDATE
  `currentNumber` = GREATEST(`currentNumber`, VALUES(`currentNumber`)),
  `updatedAt` = CURRENT_TIMESTAMP;

-- =====================================================
-- 3) Medical record patient snapshot and closed metadata
-- =====================================================
SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `doctorId`',
    'SELECT ''medical_record.patientSnapshotName already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotName'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotDateOfBirth` date DEFAULT NULL AFTER `patientSnapshotName`',
    'SELECT ''medical_record.patientSnapshotDateOfBirth already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotDateOfBirth'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotGender` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `patientSnapshotDateOfBirth`',
    'SELECT ''medical_record.patientSnapshotGender already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotGender'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotPhoneNumber` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `patientSnapshotGender`',
    'SELECT ''medical_record.patientSnapshotPhoneNumber already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotPhoneNumber'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotAddress` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `patientSnapshotPhoneNumber`',
    'SELECT ''medical_record.patientSnapshotAddress already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotAddress'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotCitizenId` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `patientSnapshotAddress`',
    'SELECT ''medical_record.patientSnapshotCitizenId already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotCitizenId'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `patientSnapshotHealthInsuranceCode` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `patientSnapshotCitizenId`',
    'SELECT ''medical_record.patientSnapshotHealthInsuranceCode already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'patientSnapshotHealthInsuranceCode'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `closedAt` timestamp NULL DEFAULT NULL AFTER `statusId`',
    'SELECT ''medical_record.closedAt already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'closedAt'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `closedBy` int DEFAULT NULL AFTER `closedAt`',
    'SELECT ''medical_record.closedBy already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'closedBy'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD INDEX `idx_medical_record_closed_by` (`closedBy`)',
    'SELECT ''idx_medical_record_closed_by already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND INDEX_NAME = 'idx_medical_record_closed_by'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

SET @phase1_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD CONSTRAINT `fk_medical_record_closed_by` FOREIGN KEY (`closedBy`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE',
    'SELECT ''fk_medical_record_closed_by already exists'' AS phase1_info'
  )
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND CONSTRAINT_NAME = 'fk_medical_record_closed_by'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);
PREPARE phase1_stmt FROM @phase1_sql;
EXECUTE phase1_stmt;
DEALLOCATE PREPARE phase1_stmt;

UPDATE `medical_record` mr
INNER JOIN `users` u ON u.id = mr.patientId
LEFT JOIN `patient_profile` pp ON pp.patientId = mr.patientId
SET
  mr.patientSnapshotName = COALESCE(
    mr.patientSnapshotName,
    NULLIF(TRIM(CONCAT(COALESCE(u.firstName, ''), ' ', COALESCE(u.lastName, ''))), '')
  ),
  mr.patientSnapshotDateOfBirth = COALESCE(mr.patientSnapshotDateOfBirth, pp.dateOfBirth),
  mr.patientSnapshotGender = COALESCE(mr.patientSnapshotGender, u.gender),
  mr.patientSnapshotPhoneNumber = COALESCE(mr.patientSnapshotPhoneNumber, u.phoneNumber),
  mr.patientSnapshotAddress = COALESCE(mr.patientSnapshotAddress, u.address),
  mr.patientSnapshotCitizenId = COALESCE(mr.patientSnapshotCitizenId, pp.citizenId),
  mr.patientSnapshotHealthInsuranceCode = COALESCE(mr.patientSnapshotHealthInsuranceCode, pp.healthInsuranceCode)
WHERE
  mr.patientSnapshotName IS NULL
  OR mr.patientSnapshotDateOfBirth IS NULL
  OR mr.patientSnapshotGender IS NULL
  OR mr.patientSnapshotPhoneNumber IS NULL
  OR mr.patientSnapshotAddress IS NULL
  OR mr.patientSnapshotCitizenId IS NULL
  OR mr.patientSnapshotHealthInsuranceCode IS NULL;

-- =====================================================
-- 4) Post-migration review queries
-- =====================================================
SELECT
  COUNT(*) AS booking_queue_rows,
  COUNT(DISTINCT bookingId) AS booking_queue_bookings
FROM `booking_queue`;

SELECT
  doctorId,
  appointmentDate,
  currentNumber
FROM `booking_queue_sequence`
ORDER BY doctorId, appointmentDate
LIMIT 20;

SELECT
  COUNT(*) AS visits_without_matching_booking_queue
FROM `examination_visit` ev
LEFT JOIN `booking_queue` bq
  ON bq.bookingId = ev.bookingId
 AND bq.doctorId = ev.doctorId
 AND bq.appointmentDate = ev.examDate
 AND bq.queueNumber = ev.queueNumber
WHERE bq.id IS NULL;
