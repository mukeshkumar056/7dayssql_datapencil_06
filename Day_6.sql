USE sql7challenge;


-- How many orders belong to each order status?
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- How many deliveries belong to each delivery status?
SELECT delivery_status, COUNT(*) AS total_deliveries
FROM deliveries
GROUP BY delivery_status
ORDER BY total_deliveries DESC;


-- On average, how many days does a completed delivery take?
SELECT AVG(DATEDIFF(delivery_date, dispatch_date)) AS avg_delivery_days
FROM deliveries
WHERE delivery_status = 'Delivered';


-- Which 10 delivered orders took the longest to arrive?
SELECT order_id, dispatch_date, delivery_date, DATEDIFF(delivery_date, dispatch_date) AS delivery_days
FROM deliveries
WHERE delivery_status = 'Delivered'
ORDER BY delivery_days DESC
LIMIT 10;


-- How does order volume change month by month?
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month ASC;


-- How are payment records distributed across statuses?
SELECT payment_status, COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status
ORDER BY total_payments DESC;


-- Which completed deliveries took longer than five days?
SELECT delivery_id, order_id, dispatch_date, delivery_date, DATEDIFF(delivery_date, dispatch_date) AS delivery_days
FROM deliveries
WHERE delivery_status = 'Delivered' AND DATEDIFF(delivery_date, dispatch_date) > 5
ORDER BY delivery_days DESC;


-- Which customer cities have the longest average delivery times?
SELECT customers.city, ROUND(AVG(DATEDIFF(deliveries.delivery_date, deliveries.dispatch_date)), 2) AS avg_delivery_days
FROM deliveries
JOIN orders ON orders.order_id = deliveries.order_id
JOIN customers ON customers.customer_id = orders.customer_id
WHERE deliveries.delivery_status = 'Delivered'
GROUP BY customers.city
ORDER BY avg_delivery_days DESC;



-- Insights
-- Only 60% of orders are delivered. Of the 3,000 orders, 1,796 are Delivered. A further 688 (23%) are Shipped or Processing, and 516 (17%) are Returned or Cancelled.
-- 29% of deliveries are Delayed, yet delivery is fast. Of 2,764 deliveries, 61% are Delivered, 29% (795) Delayed and 10% (280) Returned. The average delivery takes 4.46 days and none takes longer than 7.
-- Cities perform about the same. Mumbai is slowest at 4.89 days and Surat fastest at 4.03, against an overall 4.46.
-- Order volume is flat at about 143 a month. It was 143 a month in both 2025 and 2026, ranging from 123 (February 2025) to 161 (April 2025). There is no growth over 21 months,
-- 84.7% of payments are Paid, 7.9% (236) are Refunded and 7.4% (222) are Failed.