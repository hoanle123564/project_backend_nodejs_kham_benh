-- Add optional concrete consultation price to schedule.
-- Run on the active MySQL database only after explicit approval.

SET @schedule_price_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'schedule'
    AND COLUMN_NAME = 'price'
);

SET @add_schedule_price_sql := IF(
  @schedule_price_exists = 0,
  'ALTER TABLE schedule ADD COLUMN price INT DEFAULT NULL COMMENT ''Concrete consultation price for this schedule slot'' AFTER maxNumber',
  'SELECT ''schedule.price already exists'' AS message'
);

PREPARE stmt FROM @add_schedule_price_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
