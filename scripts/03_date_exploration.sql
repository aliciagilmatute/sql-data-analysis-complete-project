-- Find the date of the first and last order
-- How many years of sales are available?

SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) AS years_of_sales
FROM gold.fact_sales;


-- SELECT
-- 	MIN(order_date) AS first_order_date,
-- 	MAX(order_date) AS last_order_date,
-- 	AGE(MAX(order_date), MIN(order_date)) AS years_of_sales
-- FROM gold.fact_sales;


-- Find the youngest and oldest customer:

SELECT
    MIN(birthdate) AS oldest_birthdate,
    DATE_PART('year', AGE(CURRENT_DATE, MIN(birthdate))) AS age_oldest_customer,
    MAX(birthdate) AS youngest_birthdate,
    DATE_PART('year', AGE(CURRENT_DATE, MAX(birthdate))) AS age_youngest_customer
FROM gold.dim_customers;

