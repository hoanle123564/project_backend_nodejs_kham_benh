-- Drop UI-removed medical record, prescription item, and payment detail columns.
-- Safe to re-run: every DROP COLUMN is guarded by INFORMATION_SCHEMA.

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `temperatureC`',
    'SELECT ''medical_record.temperatureC already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'temperatureC'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `spo2`',
    'SELECT ''medical_record.spo2 already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'spo2'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `chiefComplaint`',
    'SELECT ''medical_record.chiefComplaint already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'chiefComplaint'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `clinicalSigns`',
    'SELECT ''medical_record.clinicalSigns already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'clinicalSigns'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `treatmentPlan`',
    'SELECT ''medical_record.treatmentPlan already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'treatmentPlan'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `finalDiagnosis`',
    'SELECT ''medical_record.finalDiagnosis already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'finalDiagnosis'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `followUpNote`',
    'SELECT ''medical_record.followUpNote already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'followUpNote'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `prescription_item` DROP COLUMN `strength`',
    'SELECT ''prescription_item.strength already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prescription_item' AND COLUMN_NAME = 'strength'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `prescription_item` DROP COLUMN `unit`',
    'SELECT ''prescription_item.unit already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prescription_item' AND COLUMN_NAME = 'unit'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `prescription_item` DROP COLUMN `note`',
    'SELECT ''prescription_item.note already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'prescription_item' AND COLUMN_NAME = 'note'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `examination_visit` DROP COLUMN `paidAmount`',
    'SELECT ''examination_visit.paidAmount already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'examination_visit' AND COLUMN_NAME = 'paidAmount'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `examination_visit` DROP COLUMN `paidAt`',
    'SELECT ''examination_visit.paidAt already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'examination_visit' AND COLUMN_NAME = 'paidAt'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;
