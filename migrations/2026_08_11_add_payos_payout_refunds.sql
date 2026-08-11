-- Additive, idempotent migration for PAYOS refund requests.
-- Run only against an approved disposable/test or explicitly approved database.

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'receiverBankBin');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN receiverBankBin VARCHAR(10) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'referenceId');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN referenceId VARCHAR(100) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'idempotencyKey');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN idempotencyKey VARCHAR(100) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'payosPayoutId');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN payosPayoutId VARCHAR(100) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'payosTransactionId');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN payosTransactionId VARCHAR(100) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'payosProviderState');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN payosProviderState VARCHAR(64) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'requestedBy');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN requestedBy INT NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'approvedBy');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN approvedBy INT NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'rejectedBy');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN rejectedBy INT NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'approvedAt');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN approvedAt DATETIME NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'rejectedAt');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN rejectedAt DATETIME NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_column_exists := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND COLUMN_NAME = 'rejectionReason');
SET @payos_sql := IF(@payos_column_exists = 0, 'ALTER TABLE payment_refunds ADD COLUMN rejectionReason VARCHAR(500) NULL', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND INDEX_NAME = 'uq_payment_refunds_reference');
SET @payos_sql := IF(@payos_index_exists = 0, 'ALTER TABLE payment_refunds ADD UNIQUE KEY uq_payment_refunds_reference (referenceId)', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND INDEX_NAME = 'uq_payment_refunds_idempotency');
SET @payos_sql := IF(@payos_index_exists = 0, 'ALTER TABLE payment_refunds ADD UNIQUE KEY uq_payment_refunds_idempotency (idempotencyKey)', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND INDEX_NAME = 'idx_payment_refunds_mode_status_updated');
SET @payos_sql := IF(@payos_index_exists = 0, 'ALTER TABLE payment_refunds ADD KEY idx_payment_refunds_mode_status_updated (refundMode, statusId, updatedAt)', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND INDEX_NAME = 'idx_payment_refunds_payos_payout');
SET @payos_sql := IF(@payos_index_exists = 0, 'ALTER TABLE payment_refunds ADD KEY idx_payment_refunds_payos_payout (payosPayoutId)', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_index_exists := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND INDEX_NAME = 'idx_payment_refunds_payos_transaction');
SET @payos_sql := IF(@payos_index_exists = 0, 'ALTER TABLE payment_refunds ADD KEY idx_payment_refunds_payos_transaction (payosTransactionId)', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_fk_exists := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND CONSTRAINT_NAME = 'fk_payment_refunds_requested_by');
SET @payos_sql := IF(@payos_fk_exists = 0, 'ALTER TABLE payment_refunds ADD CONSTRAINT fk_payment_refunds_requested_by FOREIGN KEY (requestedBy) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_fk_exists := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND CONSTRAINT_NAME = 'fk_payment_refunds_approved_by');
SET @payos_sql := IF(@payos_fk_exists = 0, 'ALTER TABLE payment_refunds ADD CONSTRAINT fk_payment_refunds_approved_by FOREIGN KEY (approvedBy) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

SET @payos_fk_exists := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND TABLE_NAME = 'payment_refunds' AND CONSTRAINT_NAME = 'fk_payment_refunds_rejected_by');
SET @payos_sql := IF(@payos_fk_exists = 0, 'ALTER TABLE payment_refunds ADD CONSTRAINT fk_payment_refunds_rejected_by FOREIGN KEY (rejectedBy) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE payos_stmt FROM @payos_sql; EXECUTE payos_stmt; DEALLOCATE PREPARE payos_stmt;

INSERT INTO lookup (keyMap, type, value_vi, value_en) VALUES
  ('RFS5', 'REFUND_STATUS', 'Đã duyệt hoàn tiền', 'Refund approved'),
  ('RFS6', 'REFUND_STATUS', 'Từ chối hoàn tiền', 'Refund rejected')
ON DUPLICATE KEY UPDATE value_vi = VALUES(value_vi), value_en = VALUES(value_en);
