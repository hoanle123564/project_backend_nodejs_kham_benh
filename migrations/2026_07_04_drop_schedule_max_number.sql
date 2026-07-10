-- Drop deprecated schedule.maxNumber after the app computes slot occupancy
-- from active booking rows. Run on the active MySQL database only after
-- explicit approval.

SET @schedule_max_number_exists := (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'schedule'
    AND COLUMN_NAME = 'maxNumber'
);

SET @drop_schedule_max_number_sql := IF(
  @schedule_max_number_exists > 0,
  'ALTER TABLE schedule DROP COLUMN maxNumber',
  'SELECT ''schedule.maxNumber already absent'' AS message'
);

PREPARE stmt FROM @drop_schedule_max_number_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
