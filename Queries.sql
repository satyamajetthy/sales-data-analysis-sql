CREATE TABLE sales (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    customer_name VARCHAR(50),
    customer_age INT,
    gender VARCHAR(10),
    product_id VARCHAR(20),
    product_name VARCHAR(50),
    product_category VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    payment_mode VARCHAR(20),
    purchase_date DATE,
    purchase_time TIMESTAMP,
    status VARCHAR(20)
);

SELECT *
FROM sales;

---DATA CLEANING
---To check for duplication and removal of duplicate records

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY transaction_id
               ORDER BY transaction_id
           ) AS rn
    FROM sales
)
DELETE FROM cte
WHERE rn > 1;

---removal of NULL values
DELETE FROM sales
WHERE Transaction_id IS NULL ;

---consistent formatting 
update sales
set gender='M'
where gender='Male';

update sales
set gender='F'
where gender='Female';

---DATA ANALYSIS

--What are the top 5 most selling products by quantity ?

SELECT 
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM sales
where status='delivered'
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

---Which products are most frequently cancelled ?

SELECT 
    product_name,
    COUNT(*) AS cancelled_count
FROM sales
WHERE status = 'cancelled'
GROUP BY product_name
ORDER BY cancelled_count DESC
LIMIT 1;

---What time of the day has the highest number of purchases?
SELECT 
    CASE 
        WHEN DATEPART(hour, time_of_purchase) BETWEEN 0 AND 5 
            THEN 'NIGHT'
        WHEN DATEPART(hour, time_of_purchase) BETWEEN 6 AND 11 
            THEN 'MORNING'
        WHEN DATEPART(hour, time_of_purchase) BETWEEN 12 AND 17 
            THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS time_of_day
FROM sales;

--who are the top 5 hightest spending customer?

SELECT customer_name,sum(quantiy*prce)as spending
from sales
group by customer_name
order by spending desc
limit 5;

---Which product categories generate the highets revenue?

SELECT product_category,sum(quantiy*prce)as revenue
from sales
group by product_category
order by revenue desc;

---What is the most preferred paymet mode?

SELECT payment_mode,count(*)as total_count
from sales
group by payment_mode
order by total_count desc
LIMIT 1;

---Are certain genders buying more specific product categories ? ?
SELECT 
    gender,
    product_category,
    COUNT(*) AS purchase_count
FROM sales
WHERE status = 'Completed'
GROUP BY gender, product_category
ORDER BY gender, purchase_count DESC;


----How does payment mode affect total revenue?
SELECT 
    payment_mode,
    SUM(price * quantity) AS total_revenue
FROM sales
WHERE status = 'Completed'
GROUP BY payment_mode
ORDER BY total_revenue DESC;

---Which products generate the highest revenue?

SELECT 
    product_name,
    SUM(price * quantity) AS total_revenue
FROM sales
WHERE status = 'Completed'
GROUP BY product_name
ORDER BY total_revenue DESC;













