# 🛒 Retail Sales SQL Project

## 📌 Project Overview

This project analyzes retail sales data using SQL. It includes data cleaning, exploration, and business-driven queries to extract insights.

---

## 🗂️ Table Creation

```sql
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
```

---

## 🧹 Data Cleaning

### Check NULL Values

```sql
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
```

### Remove NULL Records

```sql
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
```

---

## 📊 Data Exploration

```sql
SELECT COUNT(*) AS total_rows FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

SELECT COUNT(DISTINCT category) AS total_categories FROM retail_sales;
```

---

## 📈 Business Questions & SQL Analysis

### 1. Sales on a Specific Date

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

### 2. Clothing Sales > 10 Units in Nov 2022

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

---

### 3. Total Sales by Category

```sql
SELECT category,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

---

### 4. Average Age (Beauty Category)

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

---

### 5. Transactions with Sales > 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

---

### 6. Transactions by Gender & Category

```sql
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

---

### 7. Best Selling Month Each Year

```sql
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
```

---

### 8. Top 5 Customers by Sales

```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### 9. Unique Customers per Category

```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### 10. Orders by Shift

```sql
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
```

---

## 📌 Key Insights

* Customer purchasing behavior varies by category and time of day.
* Certain months show higher average sales trends.
* High-value customers contribute significantly to total revenue.

---

## 🛠️ Tools Used

* PostgreSQL
* SQL (Data Cleaning, Aggregation, Window Functions)

---

## 🚀 Conclusion

This project demonstrates SQL skills including:

* Data cleaning
* Aggregations
* Window functions
* Business problem solving

---
