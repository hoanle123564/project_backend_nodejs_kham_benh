-- Apply after 2026_07_17_add_sepay_payments.sql when upgrading an already-migrated local database.
SET @payment_completed_by_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'completedBy');
SET @payment_completed_by_sql := IF(@payment_completed_by_exists = 0, 'ALTER TABLE appointment_payments ADD COLUMN completedBy INT NULL AFTER paidAt', 'SELECT 1');
PREPARE stmt FROM @payment_completed_by_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @payment_reference_code_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'referenceCode');
SET @payment_reference_code_sql := IF(@payment_reference_code_exists = 0, 'ALTER TABLE appointment_payments ADD COLUMN referenceCode VARCHAR(100) NULL AFTER providerTransactionId, ADD UNIQUE KEY uq_appointment_payments_reference (referenceCode)', 'SELECT 1');
PREPARE stmt FROM @payment_reference_code_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
