-- Drop profile snapshot/audit columns removed from the app contract.
-- Safe to re-run: every DROP is guarded by INFORMATION_SCHEMA.

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP FOREIGN KEY `fk_medical_record_closed_by`',
    'SELECT ''medical_record.fk_medical_record_closed_by already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND CONSTRAINT_NAME = 'fk_medical_record_closed_by'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP INDEX `idx_medical_record_closed_by`',
    'SELECT ''medical_record.idx_medical_record_closed_by already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'medical_record'
    AND INDEX_NAME = 'idx_medical_record_closed_by'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotName`',
    'SELECT ''medical_record.patientSnapshotName already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotName'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotDateOfBirth`',
    'SELECT ''medical_record.patientSnapshotDateOfBirth already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotDateOfBirth'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotGender`',
    'SELECT ''medical_record.patientSnapshotGender already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotGender'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotPhoneNumber`',
    'SELECT ''medical_record.patientSnapshotPhoneNumber already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotPhoneNumber'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotAddress`',
    'SELECT ''medical_record.patientSnapshotAddress already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotAddress'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotCitizenId`',
    'SELECT ''medical_record.patientSnapshotCitizenId already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotCitizenId'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `patientSnapshotHealthInsuranceCode`',
    'SELECT ''medical_record.patientSnapshotHealthInsuranceCode already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'patientSnapshotHealthInsuranceCode'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `closedBy`',
    'SELECT ''medical_record.closedBy already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'closedBy'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `createBy`',
    'SELECT ''medical_record.createBy already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'createBy'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `medical_record` DROP COLUMN `updateBy`',
    'SELECT ''medical_record.updateBy already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'medical_record' AND COLUMN_NAME = 'updateBy'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `patient_profile` DROP COLUMN `heightCm`',
    'SELECT ''patient_profile.heightCm already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patient_profile' AND COLUMN_NAME = 'heightCm'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;

SET @drop_removed_sql = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `patient_profile` DROP COLUMN `weightKg`',
    'SELECT ''patient_profile.weightKg already absent'' AS drop_removed_info')
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patient_profile' AND COLUMN_NAME = 'weightKg'
);
PREPARE drop_removed_stmt FROM @drop_removed_sql;
EXECUTE drop_removed_stmt;
DEALLOCATE PREPARE drop_removed_stmt;
