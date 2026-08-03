SET @add_user_is_active := (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE users ADD COLUMN isActive TINYINT(1) NOT NULL DEFAULT 1 AFTER image',
    'SELECT 1'
  )
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND COLUMN_NAME = 'isActive'
);
PREPARE user_status_stmt FROM @add_user_is_active;
EXECUTE user_status_stmt;
DEALLOCATE PREPARE user_status_stmt;

SET @add_user_is_active_index := (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE users ADD KEY idx_users_isActive (isActive)',
    'SELECT 1'
  )
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'users' AND INDEX_NAME = 'idx_users_isActive'
);
PREPARE user_status_index_stmt FROM @add_user_is_active_index;
EXECUTE user_status_index_stmt;
DEALLOCATE PREPARE user_status_index_stmt;
