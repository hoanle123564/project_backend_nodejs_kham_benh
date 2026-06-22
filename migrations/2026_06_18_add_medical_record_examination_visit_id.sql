-- Surgical schema repair for Phase 7/10 runtime queries.
-- Adds the visit link that current backend code expects without running broad migrations.

SET @phase_visit_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `examinationVisitId` int DEFAULT NULL AFTER `bookingId`',
    'SELECT ''medical_record.examinationVisitId already exists'' AS phase_visit_info'
  )
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND COLUMN_NAME = 'examinationVisitId'
);
PREPARE phase_visit_stmt FROM @phase_visit_sql;
EXECUTE phase_visit_stmt;
DEALLOCATE PREPARE phase_visit_stmt;

UPDATE `medical_record` mr
INNER JOIN `examination_visit` ev
  ON ev.bookingId = mr.bookingId
SET mr.examinationVisitId = ev.id
WHERE mr.examinationVisitId IS NULL;

SET @phase_visit_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD UNIQUE KEY `unique_medical_record_visit` (`examinationVisitId`)',
    'SELECT ''unique_medical_record_visit already exists'' AS phase_visit_info'
  )
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND INDEX_NAME = 'unique_medical_record_visit'
);
PREPARE phase_visit_stmt FROM @phase_visit_sql;
EXECUTE phase_visit_stmt;
DEALLOCATE PREPARE phase_visit_stmt;

SET @phase_visit_sql = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD CONSTRAINT `fk_medical_record_visit` FOREIGN KEY (`examinationVisitId`) REFERENCES `examination_visit` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE',
    'SELECT ''fk_medical_record_visit already exists'' AS phase_visit_info'
  )
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND CONSTRAINT_NAME = 'fk_medical_record_visit'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);
PREPARE phase_visit_stmt FROM @phase_visit_sql;
EXECUTE phase_visit_stmt;
DEALLOCATE PREPARE phase_visit_stmt;

SELECT
  COUNT(*) AS medical_record_rows,
  SUM(CASE WHEN examinationVisitId IS NULL THEN 1 ELSE 0 END) AS records_without_visit_link
FROM `medical_record`;
