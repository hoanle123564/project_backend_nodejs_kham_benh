-- Convert ReactQuill rich text storage to HTML-only.
-- Run on the active MySQL database only after explicit approval.

SET @clinic_section_content_markdown_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic_content_section'
    AND COLUMN_NAME = 'contentMarkdown'
);

SET @backfill_clinic_section_content_sql := IF(
  @clinic_section_content_markdown_exists > 0,
  'UPDATE `clinic_content_section`
   SET `contentHTML` = `contentMarkdown`
   WHERE COALESCE(TRIM(`contentHTML`), '''') = ''''
     AND COALESCE(TRIM(`contentMarkdown`), '''') <> ''''',
  'SELECT ''clinic_content_section.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @backfill_clinic_section_content_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_clinic_section_content_markdown_sql := IF(
  @clinic_section_content_markdown_exists > 0,
  'ALTER TABLE `clinic_content_section` DROP COLUMN `contentMarkdown`',
  'SELECT ''clinic_content_section.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @drop_clinic_section_content_markdown_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @doctor_info_content_markdown_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'doctor_info'
    AND COLUMN_NAME = 'contentMarkdown'
);

SET @backfill_doctor_info_content_sql := IF(
  @doctor_info_content_markdown_exists > 0,
  'UPDATE `doctor_info`
   SET `contentHTML` = `contentMarkdown`
   WHERE COALESCE(TRIM(`contentHTML`), '''') = ''''
     AND COALESCE(TRIM(`contentMarkdown`), '''') <> ''''',
  'SELECT ''doctor_info.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @backfill_doctor_info_content_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_doctor_info_content_markdown_sql := IF(
  @doctor_info_content_markdown_exists > 0,
  'ALTER TABLE `doctor_info` DROP COLUMN `contentMarkdown`',
  'SELECT ''doctor_info.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @drop_doctor_info_content_markdown_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @specialty_description_markdown_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'specialty'
    AND COLUMN_NAME = 'descriptionMarkdown'
);

SET @backfill_specialty_description_sql := IF(
  @specialty_description_markdown_exists > 0,
  'UPDATE `specialty`
   SET `descriptionHTML` = `descriptionMarkdown`
   WHERE COALESCE(TRIM(`descriptionHTML`), '''') = ''''
     AND COALESCE(TRIM(`descriptionMarkdown`), '''') <> ''''',
  'SELECT ''specialty.descriptionMarkdown already absent'' AS message'
);

PREPARE stmt FROM @backfill_specialty_description_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_specialty_description_markdown_sql := IF(
  @specialty_description_markdown_exists > 0,
  'ALTER TABLE `specialty` DROP COLUMN `descriptionMarkdown`',
  'SELECT ''specialty.descriptionMarkdown already absent'' AS message'
);

PREPARE stmt FROM @drop_specialty_description_markdown_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @post_content_markdown_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'post'
    AND COLUMN_NAME = 'contentMarkdown'
);

SET @backfill_post_content_sql := IF(
  @post_content_markdown_exists > 0,
  'UPDATE `post`
   SET `contentHTML` = `contentMarkdown`
   WHERE COALESCE(TRIM(`contentHTML`), '''') = ''''
     AND COALESCE(TRIM(`contentMarkdown`), '''') <> ''''',
  'SELECT ''post.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @backfill_post_content_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @drop_post_content_markdown_sql := IF(
  @post_content_markdown_exists > 0,
  'ALTER TABLE `post` DROP COLUMN `contentMarkdown`',
  'SELECT ''post.contentMarkdown already absent'' AS message'
);

PREPARE stmt FROM @drop_post_content_markdown_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
