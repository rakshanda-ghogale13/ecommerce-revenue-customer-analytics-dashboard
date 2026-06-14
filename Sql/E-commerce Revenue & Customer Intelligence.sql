CREATE TABLE `order items` (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date varchar(20),
    price DECIMAL(15,2),
    freight_value DECIMAL(15,2)
); 

CREATE TABLE `order payments` (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments int,
    payment_value DECIMAL(15,2)
    );
    
#join the tables
SELECT 
    c.customer_city,
    o.order_id,
    oi.price,
    op.payment_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN `order items` oi
ON o.order_id = oi.order_id
join `order payments` op
on oi.order_id = op.order_id
LIMIT 10;

#total payment by city
select
     c.customer_city,
     sum(op.payment_value) as total_payment
from customers c
join orders o
on c.customer_id= o.customer_id
join `order payments` op
on o.order_id= op.order_id
group by c.customer_city
order by total_payment desc
limit 10;

#total payment by state
select
     c.customer_state,
     sum(op.payment_value) as total_payment
from customers c
join orders o
on c.customer_id= o.customer_id
join `order payments` op
on o.order_id= op.order_id
group by c.customer_state
order by total_payment desc;

# total revenue
select
     sum(price) as total_revenue
from `order items`;

# Converted order's purchase_date column from txt to datetime
UPDATE orders
SET purchase_date = STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H:%i')
WHERE order_purchase_timestamp IS NOT NULL
AND order_purchase_timestamp <> '';

# Monthly sales trend
SELECT 
    DATE_FORMAT(purchase_date, '%Y-%m') AS month,
    SUM(op.payment_value) AS revenue
FROM orders o
JOIN `order payments` op
ON o.order_id = op.order_id
WHERE purchase_date IS NOT NULL
GROUP BY month
ORDER BY month;

# Calculation of most used payment method
select
     payment_type,
     count(*) as total_transaction,
     sum(payment_value) as total_payment
from `order payments`
group by payment_type
order by total_payment desc;

# Top customers
SELECT 
    c.customer_unique_id, SUM(op.payment_value) AS total_spent
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    `order payments` op ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

# Average order value
select
     avg(payment_value) as avg_order_value
from `order payments`;

