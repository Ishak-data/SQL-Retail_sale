-- ==============================
-- RETAIL SALES SQL PROJECT
-- ==============================


-- ==============================
-- 1. TABLE CREATION
-- ==============================

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(25),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);


-- ==============================
-- 2. BASIC CHECK
-- ==============================

SELECT COUNT(*) FROM retail_sales;   -- expected: 2000


-- ==============================
-- 3. DATA CLEANING
-- ==============================

-- Check NULL values
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Remove NULL values
DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Verify after cleaning
SELECT COUNT(*) FROM retail_sales;   -- expected: 1997


-- ==============================
-- 4. DATA EXPLORATION
-- ==============================

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT COUNT(DISTINCT category) FROM retail_sales;


-- ==============================
-- 5. DATA ANALYSIS
-- ==============================

-- Q1: Sales on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2: Clothing sales > 10 units in Nov 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';


-- Q3: Total sales by category
SELECT category,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;


-- Q4: Average age of Beauty customers
SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty';


-- Q5: Transactions with total_sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q6: Transactions by gender and category
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


-- Q7: Best selling month in each year
SELECT month, year, avg_sale
FROM (
    SELECT EXTRACT(MONTH FROM sale_date) AS month,
           EXTRACT(YEAR FROM sale_date) AS year,
           AVG(total_sale) AS avg_sale,
           RANK() OVER (
               PARTITION BY EXTRACT(YEAR FROM sale_date)
               ORDER BY AVG(total_sale) DESC
           ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t
WHERE rank = 1;


-- Q8: Top 5 customers by total sales
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9: Unique customers per category
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;


-- Q10: Orders by shift
WITH hourly_sales AS (
    SELECT *,
           EXTRACT(HOUR FROM sale_time) AS hour,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;