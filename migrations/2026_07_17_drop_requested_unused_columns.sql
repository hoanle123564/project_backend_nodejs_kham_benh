-- Deploy the code cleanup first and run this manually only after a tested backup.
-- This follows the SePay migrations dated 2026-07-17; dropped values cannot be restored.

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinic' AND INDEX_NAME = 'idx_clinic_type') = 1,
  'ALTER TABLE clinic DROP INDEX idx_clinic_type',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinic' AND COLUMN_NAME = 'clinicTypeId') = 1,
  'ALTER TABLE clinic DROP COLUMN clinicTypeId',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinic_department' AND COLUMN_NAME = 'description') = 1,
  'ALTER TABLE clinic_department DROP COLUMN description',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME IN ('cancelReason', 'rejectReason', 'noShowNote', 'statusUpdatedAt')) > 0,
  CONCAT('ALTER TABLE booking ', CONCAT_WS(', ',
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'cancelReason') = 1, 'DROP COLUMN cancelReason', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'rejectReason') = 1, 'DROP COLUMN rejectReason', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'noShowNote') = 1, 'DROP COLUMN noShowNote', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'booking' AND COLUMN_NAME = 'statusUpdatedAt') = 1, 'DROP COLUMN statusUpdatedAt', NULL)
  )),
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND INDEX_NAME = 'uq_appointment_payments_provider_tx') = 1,
  'ALTER TABLE appointment_payments DROP INDEX uq_appointment_payments_provider_tx',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND INDEX_NAME = 'uq_appointment_payments_reference') = 1,
  'ALTER TABLE appointment_payments DROP INDEX uq_appointment_payments_reference',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME IN ('providerTransactionId', 'referenceCode', 'transactionContent', 'completedBy', 'currency')) > 0,
  CONCAT('ALTER TABLE appointment_payments ', CONCAT_WS(', ',
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'providerTransactionId') = 1, 'DROP COLUMN providerTransactionId', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'referenceCode') = 1, 'DROP COLUMN referenceCode', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'transactionContent') = 1, 'DROP COLUMN transactionContent', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'completedBy') = 1, 'DROP COLUMN completedBy', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'currency') = 1, 'DROP COLUMN currency', NULL)
  )),
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND INDEX_NAME = 'idx_appointment_reminders_due') = 1,
  'ALTER TABLE appointment_reminders DROP INDEX idx_appointment_reminders_due',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND COLUMN_NAME IN ('inAppNotifiedAt', 'smsSkippedAt', 'processingAt', 'lastError')) > 0,
  CONCAT('ALTER TABLE appointment_reminders ', CONCAT_WS(', ',
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND COLUMN_NAME = 'inAppNotifiedAt') = 1, 'DROP COLUMN inAppNotifiedAt', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND COLUMN_NAME = 'smsSkippedAt') = 1, 'DROP COLUMN smsSkippedAt', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND COLUMN_NAME = 'processingAt') = 1, 'DROP COLUMN processingAt', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND COLUMN_NAME = 'lastError') = 1, 'DROP COLUMN lastError', NULL)
  )),
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_reminders' AND INDEX_NAME = 'idx_appointment_reminders_due') = 0,
  'ALTER TABLE appointment_reminders ADD KEY idx_appointment_reminders_due (remindAt)',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'chat_sessions' AND COLUMN_NAME = 'expiresAt') = 1,
  'ALTER TABLE chat_sessions DROP COLUMN expiresAt',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
