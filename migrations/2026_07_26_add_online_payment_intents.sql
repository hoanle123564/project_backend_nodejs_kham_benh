-- Apply after the SePay payment migrations. This changes only schema; it does not alter existing payment rows.
ALTER TABLE appointment_payments MODIFY COLUMN bookingId INT NULL;

SET @schedule_id_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'scheduleId');
SET @schedule_id_sql := IF(@schedule_id_exists = 0, 'ALTER TABLE appointment_payments ADD COLUMN scheduleId INT NULL AFTER bookingId', 'SELECT 1');
PREPARE stmt FROM @schedule_id_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @reason_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'reason');
SET @reason_sql := IF(@reason_exists = 0, 'ALTER TABLE appointment_payments ADD COLUMN reason TEXT NULL AFTER patientId', 'SELECT 1');
PREPARE stmt FROM @reason_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @schedule_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND INDEX_NAME = 'idx_appointment_payments_schedule');
SET @schedule_index_sql := IF(@schedule_index_exists = 0, 'ALTER TABLE appointment_payments ADD KEY idx_appointment_payments_schedule (scheduleId, statusId, createdAt)', 'SELECT 1');
PREPARE stmt FROM @schedule_index_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @schedule_fk_exists := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND CONSTRAINT_NAME = 'fk_appointment_payments_schedule');
SET @schedule_fk_sql := IF(@schedule_fk_exists = 0, 'ALTER TABLE appointment_payments ADD CONSTRAINT fk_appointment_payments_schedule FOREIGN KEY (scheduleId) REFERENCES schedule(id) ON DELETE RESTRICT ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @schedule_fk_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

ALTER TABLE payment_refunds MODIFY COLUMN bookingId INT NULL;
