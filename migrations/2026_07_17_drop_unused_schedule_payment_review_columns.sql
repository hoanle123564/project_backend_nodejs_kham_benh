-- Run only after every application instance uses the cleanup release and a tested backup exists.
-- Dropped column values cannot be restored by a SQL rollback.

ALTER TABLE doctor_reviews DROP FOREIGN KEY fk_doctor_reviews_hidden_by;
ALTER TABLE doctor_reviews DROP INDEX idx_doctor_reviews_hidden_by;

ALTER TABLE doctor_info
  DROP COLUMN priceId,
  DROP COLUMN onlinePriceId,
  DROP COLUMN paymentId;

ALTER TABLE schedule
  DROP COLUMN minBookingNoticeDays,
  DROP COLUMN maxBookingAheadDays,
  DROP COLUMN discountPercent;

ALTER TABLE doctor_schedule_rule
  DROP COLUMN minBookingNoticeDays,
  DROP COLUMN maxBookingAheadDays,
  DROP COLUMN discountPercent,
  DROP COLUMN isFullDay;

SET @payment_cleanup_sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND INDEX_NAME = 'idx_appointment_payments_status_expiry') = 1,
  'ALTER TABLE appointment_payments DROP INDEX idx_appointment_payments_status_expiry',
  'SELECT 1'
);
PREPARE payment_cleanup_stmt FROM @payment_cleanup_sql; EXECUTE payment_cleanup_stmt; DEALLOCATE PREPARE payment_cleanup_stmt;

SET @payment_cleanup_sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME IN ('provider', 'paymentMethodId', 'bankGateway', 'accountNumber', 'expiresAt', 'completedAt', 'rawPayload')) > 0,
  CONCAT('ALTER TABLE appointment_payments ', CONCAT_WS(', ',
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'provider'), 'DROP COLUMN provider', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'paymentMethodId'), 'DROP COLUMN paymentMethodId', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'bankGateway'), 'DROP COLUMN bankGateway', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'accountNumber'), 'DROP COLUMN accountNumber', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'expiresAt'), 'DROP COLUMN expiresAt', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'completedAt'), 'DROP COLUMN completedAt', NULL),
    IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND COLUMN_NAME = 'rawPayload'), 'DROP COLUMN rawPayload', NULL)
  )),
  'SELECT 1'
);
PREPARE payment_cleanup_stmt FROM @payment_cleanup_sql; EXECUTE payment_cleanup_stmt; DEALLOCATE PREPARE payment_cleanup_stmt;

SET @payment_cleanup_sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'appointment_payments' AND INDEX_NAME = 'idx_appointment_payments_status_created') = 0,
  'ALTER TABLE appointment_payments ADD KEY idx_appointment_payments_status_created (statusId, createdAt)',
  'SELECT 1'
);
PREPARE payment_cleanup_stmt FROM @payment_cleanup_sql; EXECUTE payment_cleanup_stmt; DEALLOCATE PREPARE payment_cleanup_stmt;

SET @event_cleanup_sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_webhook_events' AND COLUMN_NAME = 'rawPayload') = 1,
  'ALTER TABLE payment_webhook_events DROP COLUMN rawPayload',
  'SELECT 1'
);
PREPARE event_cleanup_stmt FROM @event_cleanup_sql; EXECUTE event_cleanup_stmt; DEALLOCATE PREPARE event_cleanup_stmt;

ALTER TABLE doctor_reviews
  DROP COLUMN hiddenReason,
  DROP COLUMN hiddenBy,
  DROP COLUMN hiddenAt;
