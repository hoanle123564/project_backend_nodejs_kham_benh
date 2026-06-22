-- Phase 7 soft migration: medical record vitals, clinical draft, diagnosis, and follow-up fields.
-- Scope: additive schema only. Do not run on live DB without explicit approval.

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `heightCm` decimal(5,2) DEFAULT NULL AFTER `patientSnapshotHealthInsuranceCode`',
    'SELECT ''medical_record.heightCm already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'heightCm'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `weightKg` decimal(5,2) DEFAULT NULL AFTER `heightCm`',
    'SELECT ''medical_record.weightKg already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'weightKg'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `temperatureC` decimal(4,1) DEFAULT NULL AFTER `weightKg`',
    'SELECT ''medical_record.temperatureC already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'temperatureC'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `bloodPressure` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL AFTER `temperatureC`',
    'SELECT ''medical_record.bloodPressure already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'bloodPressure'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `pulsePerMinute` int DEFAULT NULL AFTER `bloodPressure`',
    'SELECT ''medical_record.pulsePerMinute already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'pulsePerMinute'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `respiratoryRate` int DEFAULT NULL AFTER `pulsePerMinute`',
    'SELECT ''medical_record.respiratoryRate already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'respiratoryRate'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `spo2` decimal(5,2) DEFAULT NULL AFTER `respiratoryRate`',
    'SELECT ''medical_record.spo2 already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'spo2'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `bmi` decimal(5,2) DEFAULT NULL AFTER `spo2`',
    'SELECT ''medical_record.bmi already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'bmi'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `chiefComplaint` text COLLATE utf8mb4_unicode_ci AFTER `bmi`',
    'SELECT ''medical_record.chiefComplaint already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'chiefComplaint'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `symptoms` text COLLATE utf8mb4_unicode_ci AFTER `chiefComplaint`',
    'SELECT ''medical_record.symptoms already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'symptoms'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `clinicalSigns` text COLLATE utf8mb4_unicode_ci AFTER `symptoms`',
    'SELECT ''medical_record.clinicalSigns already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'clinicalSigns'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `preliminaryDiagnosis` text COLLATE utf8mb4_unicode_ci AFTER `clinicalSigns`',
    'SELECT ''medical_record.preliminaryDiagnosis already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'preliminaryDiagnosis'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `finalDiagnosis` text COLLATE utf8mb4_unicode_ci AFTER `preliminaryDiagnosis`',
    'SELECT ''medical_record.finalDiagnosis already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'finalDiagnosis'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `treatmentPlan` text COLLATE utf8mb4_unicode_ci AFTER `finalDiagnosis`',
    'SELECT ''medical_record.treatmentPlan already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'treatmentPlan'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `doctorConclusion` text COLLATE utf8mb4_unicode_ci AFTER `treatmentPlan`',
    'SELECT ''medical_record.doctorConclusion already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'doctorConclusion'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `generalNote` text COLLATE utf8mb4_unicode_ci AFTER `doctorConclusion`',
    'SELECT ''medical_record.generalNote already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'generalNote'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `followUpDate` date DEFAULT NULL AFTER `generalNote`',
    'SELECT ''medical_record.followUpDate already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'followUpDate'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;

SET @phase7_sql = (
  SELECT IF(COUNT(*) = 0,
    'ALTER TABLE `medical_record` ADD COLUMN `followUpNote` text COLLATE utf8mb4_unicode_ci AFTER `followUpDate`',
    'SELECT ''medical_record.followUpNote already exists'' AS phase7_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'followUpNote'
);
PREPARE phase7_stmt FROM @phase7_sql;
EXECUTE phase7_stmt;
DEALLOCATE PREPARE phase7_stmt;
