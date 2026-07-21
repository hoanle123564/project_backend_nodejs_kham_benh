-- Run on a restored test copy before deploying code that removes legacy columns.
-- This migration only fills a missing working-rule price when its generated slots agree.

UPDATE doctor_schedule_rule rule_row
INNER JOIN (
  SELECT sourceRuleId, MIN(price) AS price
  FROM schedule
  WHERE sourceRuleId IS NOT NULL AND price > 0
  GROUP BY sourceRuleId
  HAVING COUNT(DISTINCT price) = 1
) inferred ON inferred.sourceRuleId = rule_row.id
SET rule_row.price = inferred.price
WHERE rule_row.ruleType IN ('FIXED', 'FLEXIBLE')
  AND (rule_row.price IS NULL OR rule_row.price <= 0);

UPDATE schedule slot
INNER JOIN doctor_schedule_rule rule_row ON rule_row.id = slot.sourceRuleId
SET slot.price = rule_row.price
WHERE (slot.price IS NULL OR slot.price <= 0)
  AND rule_row.ruleType IN ('FIXED', 'FLEXIBLE')
  AND rule_row.price > 0;

SET @invalid_working_rule_count := (
  SELECT COUNT(*)
  FROM doctor_schedule_rule
  WHERE isActive = 1
    AND ruleType IN ('FIXED', 'FLEXIBLE')
    AND (price IS NULL OR price <= 0)
);
SET @working_rule_guard := IF(
  @invalid_working_rule_count = 0,
  'SELECT ''Working rule prices are ready'' AS migration_check',
  'SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ''Active FIXED/FLEXIBLE rule has no positive price; fix it before cleanup.'''
);
PREPARE cleanup_stmt FROM @working_rule_guard;
EXECUTE cleanup_stmt;
DEALLOCATE PREPARE cleanup_stmt;

SET @invalid_future_schedule_count := (
  SELECT COUNT(*)
  FROM schedule
  WHERE isActive = 1
    AND date >= CURDATE()
    AND (price IS NULL OR price <= 0)
);
SET @future_schedule_guard := IF(
  @invalid_future_schedule_count = 0,
  'SELECT ''Future schedule prices are ready'' AS migration_check',
  'SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ''Active future schedule has no positive price; fix it before cleanup.'''
);
PREPARE cleanup_stmt FROM @future_schedule_guard;
EXECUTE cleanup_stmt;
DEALLOCATE PREPARE cleanup_stmt;
