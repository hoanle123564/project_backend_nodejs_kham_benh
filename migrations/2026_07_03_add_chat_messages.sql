SET @add_chat_session_title = (
  SELECT IF(
    COUNT(*) = 0,
    'ALTER TABLE `chat_sessions` ADD COLUMN `title` VARCHAR(255) NULL AFTER `patientId`',
    'SELECT 1'
  )
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'chat_sessions'
    AND COLUMN_NAME = 'title'
);
PREPARE add_chat_session_title_stmt FROM @add_chat_session_title;
EXECUTE add_chat_session_title_stmt;
DEALLOCATE PREPARE add_chat_session_title_stmt;

CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `chatSessionId` INT NOT NULL,
  `role` ENUM('user', 'bot') NOT NULL,
  `message` TEXT NOT NULL,
  `state` VARCHAR(50) NULL,
  `data` JSON NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `idx_chat_messages_session_created` (`chatSessionId`, `createdAt`),
  CONSTRAINT `fk_chat_messages_session`
    FOREIGN KEY (`chatSessionId`) REFERENCES `chat_sessions` (`id`)
    ON DELETE CASCADE
) ENGINE=InnoDB;
