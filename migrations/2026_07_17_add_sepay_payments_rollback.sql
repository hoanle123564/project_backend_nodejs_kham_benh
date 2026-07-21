-- Destructive rollback for the local migration only. Back up payment records first.
DROP TABLE IF EXISTS payment_refunds;
DROP TABLE IF EXISTS payment_webhook_events;
DROP TABLE IF EXISTS appointment_payments;
ALTER TABLE patient_profile DROP COLUMN refundBankName, DROP COLUMN refundAccountName, DROP COLUMN refundAccountNumber;
DELETE FROM lookup WHERE (type = 'PAYMENT_TRANSACTION_STATUS' AND keyMap IN ('PPS1','PPS2','PPS3','PPS4','PPS5','PPS6','PPS7','PPS8')) OR (type = 'REFUND_STATUS' AND keyMap IN ('RFS1','RFS2','RFS3','RFS4'));
