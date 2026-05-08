/*
Calculate the total sales per month and the running total of sales over time
*/


SELECT
	month_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY month_date) AS running_total
FROM (
	SELECT
		DATE_TRUNC('month', order_date)::date AS month_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL	
	GROUP BY DATE_TRUNC('month', order_date)::date
)t;


-- La ventana empieza la acumulacion de nuevo (se actualiza) a cada año:
-- (pero la granularidad sigue siendo de mes a mes):

SELECT
	month_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY month_date ORDER BY month_date) AS running_total
FROM (
	SELECT
		DATE_TRUNC('month', order_date)::date AS month_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL	
	GROUP BY DATE_TRUNC('month', order_date)::date
)t;


-- La ventana empieza la acumulacion de nuevo (se actualiza) a cada año:
-- (pero la granularidad es año a año):

SELECT
	year_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY year_date ORDER BY year_date) AS running_total
FROM (
	SELECT
		DATE_TRUNC('year', order_date)::date AS year_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL	
	GROUP BY DATE_TRUNC('year', order_date)::date
)t;


/*

Calculate the total sales per month and the moving average of prices over time

*/

SELECT
	month_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY month_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER(ORDER BY month_date),2) AS moving_average_price
FROM (
	SELECT
		DATE_TRUNC('month', order_date)::date AS month_date,
		SUM(sales_amount) AS total_sales,
		ROUND(AVG(price),2) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL	
	GROUP BY DATE_TRUNC('month', order_date)::date
)t;


SELECT
	year_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY year_date) AS running_total_sales,
	ROUND(AVG(avg_price) OVER(ORDER BY year_date),2) AS moving_average_price
FROM (
	SELECT
		DATE_TRUNC('year', order_date)::date AS year_date,
		SUM(sales_amount) AS total_sales,
		ROUND(AVG(price),2) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL	
	GROUP BY DATE_TRUNC('year', order_date)::date
)t;









