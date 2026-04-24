SET @product_id_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'order_products'
      AND column_name = 'product_id'
);

SET @alter_sql = IF(
    @product_id_exists = 0,
    'ALTER TABLE order_products ADD COLUMN product_id varchar(32) NULL COMMENT ''商品编号'' AFTER order_id',
    'SELECT 1'
);

PREPARE stmt FROM @alter_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE order_products op
LEFT JOIN product p ON p.name = op.name
SET op.product_id = p.product_id
WHERE op.product_id IS NULL;

CREATE OR REPLACE VIEW order_purchase AS
SELECT
    o.order_id,
    o.user_id,
    op.product_id,
    o.create_time,
    o.status,
    o.total_amount,
    op.quantity,
    op.price
FROM `order` o
JOIN order_products op ON o.order_id = op.order_id;
