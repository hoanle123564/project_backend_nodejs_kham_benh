-- Add clinic banner and ordered public content sections.
-- Run on the active MySQL database only after explicit approval.

SET @clinic_banner_img_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic'
    AND COLUMN_NAME = 'banner_img'
);

SET @add_clinic_banner_img_sql := IF(
  @clinic_banner_img_exists = 0,
  'ALTER TABLE clinic ADD COLUMN banner_img LONGTEXT NULL AFTER image',
  'SELECT ''clinic.banner_img already exists'' AS message'
);

PREPARE stmt FROM @add_clinic_banner_img_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS `clinic_content_section` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `clinicId` INT NOT NULL,
  `title` VARCHAR(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contentHTML` LONGTEXT COLLATE utf8mb4_unicode_ci NULL,
  `displayOrder` INT DEFAULT 0,
  `isActive` TINYINT(1) DEFAULT 1,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_clinic_content_section_clinic` (`clinicId`),
  KEY `idx_clinic_content_section_public_order` (`clinicId`, `isActive`, `displayOrder`),
  CONSTRAINT `fk_clinic_content_section_clinic`
    FOREIGN KEY (`clinicId`) REFERENCES `clinic` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET @clinic_legacy_description_columns_exist := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'clinic'
    AND COLUMN_NAME IN ('descriptionHTML', 'descriptionMarkdown')
);

SET @backfill_clinic_content_section_sql := IF(
  @clinic_legacy_description_columns_exist = 2,
  'INSERT INTO `clinic_content_section`
     (`clinicId`, `title`, `contentHTML`, `displayOrder`, `isActive`)
   SELECT
     c.id,
     ''Gioi thieu'',
     CASE
       WHEN COALESCE(TRIM(c.descriptionHTML), '''') <> '''' THEN c.descriptionHTML
       ELSE c.descriptionMarkdown
     END,
     1,
     1
   FROM `clinic` c
   WHERE (
       COALESCE(TRIM(c.descriptionHTML), '''') <> ''''
       OR COALESCE(TRIM(c.descriptionMarkdown), '''') <> ''''
     )
     AND NOT EXISTS (
       SELECT 1
       FROM `clinic_content_section` s
       WHERE s.clinicId = c.id
     )',
  'SELECT ''clinic legacy description columns already absent'' AS message'
);

PREPARE stmt FROM @backfill_clinic_content_section_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
