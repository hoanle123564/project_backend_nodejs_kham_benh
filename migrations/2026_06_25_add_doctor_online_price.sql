-- Add optional online consultation price to doctor_info.
-- This is additive and safe to run before the application code is deployed.

SET @column_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'doctor_info'
    AND COLUMN_NAME = 'onlinePriceId'
);

SET @ddl := IF(
  @column_exists = 0,
  'ALTER TABLE doctor_info ADD COLUMN onlinePriceId varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT ''Logical reference to lookup.keyMap where type=PRICE for online consultation'' AFTER priceId',
  'SELECT ''doctor_info.onlinePriceId already exists'' AS message'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
