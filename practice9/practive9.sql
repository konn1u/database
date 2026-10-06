-- Задание 1
SELECT
category,
COUNT(product_id) value
FROM products
GROUP BY category;

--Задание 2
SELECT sum(price_per_unit * quantity) total_revenue
FROM order_items;

--Задание 3
SELECT 
c.full_name,
COUNT(o.customer_id) total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- Задание 4
SELECT avg(receipt) avg_receipt
FROM (
    SELECT
    order_id,
    sum(price_per_unit * quantity) receipt
    FROM order_items
    GROUP BY order_id
);

-- Задание 5
SELECT
status,
count(order_id) quantity
FROM orders
GROUP BY status;

-- Задание 6
SELECT
category,
COUNT(product_id) value
FROM products
GROUP BY category
HAVING COUNT(product_id) > 1;

-- Задание 7
SELECT 
c.full_name,
COUNT(o.customer_id) total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING count(o.customer_id) > 1;

-- Задание 8
SELECT
p.product_name,
sum(oi.quantity) total_quantity
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p. product_name
ORDER BY total_quantity DESC
FETCH FIRST 1 ROWS WITH TIES;