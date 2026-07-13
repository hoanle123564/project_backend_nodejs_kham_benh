-- Run manually after backup on the target MySQL database. This file does not execute automatically.
SET @booking_status_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE booking ADD COLUMN cancelReason TEXT NULL', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'cancelReason'
);
PREPARE booking_status_stmt FROM @booking_status_column;
EXECUTE booking_status_stmt;
DEALLOCATE PREPARE booking_status_stmt;

SET @booking_status_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE booking ADD COLUMN rejectReason TEXT NULL', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'rejectReason'
);
PREPARE booking_status_stmt FROM @booking_status_column;
EXECUTE booking_status_stmt;
DEALLOCATE PREPARE booking_status_stmt;

SET @booking_status_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE booking ADD COLUMN noShowNote TEXT NULL', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'noShowNote'
);
PREPARE booking_status_stmt FROM @booking_status_column;
EXECUTE booking_status_stmt;
DEALLOCATE PREPARE booking_status_stmt;

SET @booking_status_column := (
  SELECT IF(COUNT(*) = 0, 'ALTER TABLE booking ADD COLUMN statusUpdatedAt DATETIME NULL', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'statusUpdatedAt'
);
PREPARE booking_status_stmt FROM @booking_status_column;
EXECUTE booking_status_stmt;
DEALLOCATE PREPARE booking_status_stmt;

UPDATE booking
SET statusUpdatedAt = COALESCE(statusUpdatedAt, updatedAt, createdAt, CURRENT_TIMESTAMP);

INSERT INTO lookup (keyMap, type, value_vi, value_en) VALUES
  ('S4', 'STATUS', 'Bệnh nhân hủy lịch', 'Cancelled by patient'),
  ('S5', 'STATUS', 'Bác sĩ hủy lịch', 'Cancelled by doctor'),
  ('S6', 'STATUS', 'Bác sĩ từ chối lịch khám', 'Rejected by doctor'),
  ('S7', 'STATUS', 'Bệnh nhân không đến', 'Patient no-show'),
  ('S8', 'STATUS', 'Bác sĩ đã xác nhận khám', 'Confirmed by doctor')
ON DUPLICATE KEY UPDATE
  value_vi = VALUES(value_vi),
  value_en = VALUES(value_en);
