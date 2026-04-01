## 📊 Retail Sales Analysis

## 📌 Project Overview

**Database:** `sql_project`  

This project demonstrates SQL skills used to clean, explore, and analyze retail sales data. It includes database creation, data cleaning, exploratory analysis, and solving business problems using SQL queries.

---

## 🎯 Objectives

- Create and manage a retail sales database  
- Clean and prepare raw data  
- Perform exploratory data analysis (EDA)  
- Solve business problems using SQL  
- Generate insights from data  

---

## 🏗️ Database Setup

```sql
-- Create Database
CREATE DATABASE sql_project;

-- Drop Table if Exists
DROP TABLE IF EXISTS retail_sales;

-- Create Table
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

### 🔍 Identify Missing Values

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

### 🗑️ Remove NULL Records

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

### 📌 Total Transactions

```sql
SELECT COUNT(*) AS total_rows 
FROM retail_sales;
```

### 📌 Unique Customers

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales;
```

### 📌 Product Categories

```sql
SELECT COUNT(DISTINCT category) AS total_categories 
FROM retail_sales;
```

---

## 📈 Data Analysis

### 1️⃣ Sales on Specific Date

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2️⃣ High Quantity Clothing Sales (Nov 2022)

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 10
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

### 3️⃣ Total Revenue by Category

```sql
SELECT category,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;
```

### 4️⃣ Average Age (Beauty Category)

```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5️⃣ Transactions Above 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

### 6️⃣ Transactions by Gender & Category

```sql
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

### 7️⃣ Best Sales Month Each Year

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

### 8️⃣ Top 5 Customers

```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 9️⃣ Customer Reach by Category

```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

### 🔟 Sales by Time Shift

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

- Sales vary significantly across product categories  
- High-value customers contribute a major portion of revenue  
- Sales patterns change based on time of day  
- Monthly trends help identify peak performance periods  

---

## 🛠️ Tools Used

- PostgreSQL  
- SQL (Aggregation, Window Functions, CTEs)  

---

## 🚀 Conclusion

This project demonstrates core SQL skills including data cleaning, data exploration, and extracting meaningful business insights from structured retail sales data.
