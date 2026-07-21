-- Run manually against the approved local MySQL database after backup.
-- Rollback: see 2026_07_17_add_sepay_payments_rollback.sql.

CREATE TABLE IF NOT EXISTS appointment_payments (
  id BIGINT NOT NULL AUTO_INCREMENT,
  bookingId INT NOT NULL,
  patientId INT NOT NULL,
  paymentCode VARCHAR(80) NOT NULL,
  amount DECIMAL(12,0) NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'VND',
  statusId VARCHAR(32) NOT NULL,
  providerTransactionId VARCHAR(100) NULL,
  referenceCode VARCHAR(100) NULL,
  transactionContent VARCHAR(500) NULL,
  paidAt DATETIME NULL,
  completedBy INT NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_appointment_payments_booking (bookingId),
  UNIQUE KEY uq_appointment_payments_code (paymentCode),
  UNIQUE KEY uq_appointment_payments_provider_tx (providerTransactionId),
  UNIQUE KEY uq_appointment_payments_reference (referenceCode),
  KEY idx_appointment_payments_status_created (statusId, createdAt),
  CONSTRAINT fk_appointment_payments_booking FOREIGN KEY (bookingId) REFERENCES booking(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_appointment_payments_patient FOREIGN KEY (patientId) REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payment_webhook_events (
  id BIGINT NOT NULL AUTO_INCREMENT,
  provider VARCHAR(32) NOT NULL,
  providerTransactionId VARCHAR(100) NOT NULL,
  payloadHash CHAR(64) NOT NULL,
  processingStatus VARCHAR(32) NOT NULL,
  errorMessage VARCHAR(500) NULL,
  processedAt DATETIME NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_payment_webhook_provider_tx (provider, providerTransactionId),
  KEY idx_payment_webhook_status (processingStatus, createdAt)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payment_refunds (
  id BIGINT NOT NULL AUTO_INCREMENT,
  paymentId BIGINT NOT NULL,
  bookingId INT NOT NULL,
  amount DECIMAL(12,0) NOT NULL,
  statusId VARCHAR(32) NOT NULL,
  reason TEXT NULL,
  refundMode VARCHAR(16) NOT NULL DEFAULT 'MANUAL',
  providerRefundId VARCHAR(100) NULL,
  refundTransactionId VARCHAR(100) NULL,
  receiverAccountName VARCHAR(120) NULL,
  receiverAccountNumber VARCHAR(64) NULL,
  receiverBank VARCHAR(100) NULL,
  requestedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processingAt DATETIME NULL,
  refundedAt DATETIME NULL,
  failedAt DATETIME NULL,
  processedBy INT NULL,
  failureReason VARCHAR(500) NULL,
  createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_payment_refunds_payment (paymentId),
  UNIQUE KEY uq_payment_refunds_transaction (refundTransactionId),
  KEY idx_payment_refunds_status (statusId, requestedAt),
  CONSTRAINT fk_payment_refunds_payment FOREIGN KEY (paymentId) REFERENCES appointment_payments(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_refunds_booking FOREIGN KEY (bookingId) REFERENCES booking(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_refunds_processor FOREIGN KEY (processedBy) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

SET @refund_bank_name_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patient_profile' AND COLUMN_NAME = 'refundBankName');
SET @refund_bank_name_sql := IF(@refund_bank_name_exists = 0, 'ALTER TABLE patient_profile ADD COLUMN refundBankName VARCHAR(100) NULL', 'SELECT 1');
PREPARE stmt FROM @refund_bank_name_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @refund_account_name_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patient_profile' AND COLUMN_NAME = 'refundAccountName');
SET @refund_account_name_sql := IF(@refund_account_name_exists = 0, 'ALTER TABLE patient_profile ADD COLUMN refundAccountName VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @refund_account_name_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @refund_account_number_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'patient_profile' AND COLUMN_NAME = 'refundAccountNumber');
SET @refund_account_number_sql := IF(@refund_account_number_exists = 0, 'ALTER TABLE patient_profile ADD COLUMN refundAccountNumber VARCHAR(64) NULL', 'SELECT 1');
PREPARE stmt FROM @refund_account_number_sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

INSERT INTO lookup (keyMap, type, value_vi, value_en) VALUES
  ('PPS1', 'PAYMENT_TRANSACTION_STATUS', 'Chờ thanh toán', 'Pending payment'),
  ('PPS2', 'PAYMENT_TRANSACTION_STATUS', 'Đã thanh toán, chờ bác sĩ xác nhận', 'Paid, pending doctor confirmation'),
  ('PPS3', 'PAYMENT_TRANSACTION_STATUS', 'Hoàn thành', 'Completed'),
  ('PPS4', 'PAYMENT_TRANSACTION_STATUS', 'Hết hạn', 'Expired'),
  ('PPS5', 'PAYMENT_TRANSACTION_STATUS', 'Cần kiểm tra thủ công', 'Manual review'),
  ('PPS6', 'PAYMENT_TRANSACTION_STATUS', 'Chờ hoàn tiền', 'Refund pending'),
  ('PPS7', 'PAYMENT_TRANSACTION_STATUS', 'Đã hoàn tiền', 'Refunded'),
  ('PPS8', 'PAYMENT_TRANSACTION_STATUS', 'Hoàn tiền thất bại', 'Refund failed'),
  ('RFS1', 'REFUND_STATUS', 'Chờ hoàn tiền', 'Refund pending'),
  ('RFS2', 'REFUND_STATUS', 'Đang hoàn tiền', 'Refund processing'),
  ('RFS3', 'REFUND_STATUS', 'Đã hoàn tiền', 'Refunded'),
  ('RFS4', 'REFUND_STATUS', 'Hoàn tiền thất bại', 'Refund failed')
ON DUPLICATE KEY UPDATE value_vi = VALUES(value_vi), value_en = VALUES(value_en);
