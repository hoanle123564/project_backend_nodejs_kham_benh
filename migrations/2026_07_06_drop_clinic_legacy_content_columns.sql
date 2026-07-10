-- Drop legacy clinic narrative fields and clinic section keys.
-- Run on the active MySQL database only after explicit approval.

SET @clinic_section_key_index_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic_content_section'
    AND INDEX_NAME = 'unique_clinic_section_key'
);

SET @drop_clinic_section_key_index_sql := IF(
  @clinic_section_key_index_exists > 0,
  'ALTER TABLE `clinic_content_section` DROP INDEX `unique_clinic_section_key`',
  'SELECT ''clinic_content_section.unique_clinic_section_key already absent'' AS message'
);

PREPARE stmt FROM @drop_clinic_section_key_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @clinic_section_key_column_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic_content_section'
    AND COLUMN_NAME = 'sectionKey'
);

SET @drop_clinic_section_key_column_sql := IF(
  @clinic_section_key_column_exists > 0,
  'ALTER TABLE `clinic_content_section` DROP COLUMN `sectionKey`',
  'SELECT ''clinic_content_section.sectionKey already absent'' AS message'
);

PREPARE stmt FROM @drop_clinic_section_key_column_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @clinic_description_html_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic'
    AND COLUMN_NAME = 'descriptionHTML'
);

SET @drop_clinic_description_html_sql := IF(
  @clinic_description_html_exists > 0,
  'ALTER TABLE `clinic` DROP COLUMN `descriptionHTML`',
  'SELECT ''clinic.descriptionHTML already absent'' AS message'
);

PREPARE stmt FROM @drop_clinic_description_html_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @clinic_description_markdown_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic'
    AND COLUMN_NAME = 'descriptionMarkdown'
);

SET @drop_clinic_description_markdown_sql := IF(
  @clinic_description_markdown_exists > 0,
  'ALTER TABLE `clinic` DROP COLUMN `descriptionMarkdown`',
  'SELECT ''clinic.descriptionMarkdown already absent'' AS message'
);

PREPARE stmt FROM @drop_clinic_description_markdown_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
