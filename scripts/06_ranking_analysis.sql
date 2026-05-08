-- Which 5 products generate the highest revenue?

SELECT
	fs.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
	ON dp.product_key=fs.product_key
GROUP BY fs.product_key, dp.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Con Window Functions:

SELECT
	*
FROM (
	SELECT
		fs.product_key,
		dp.product_name,
		SUM(fs.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS ranking
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
		ON dp.product_key=fs.product_key
GROUP BY fs.product_key, dp.product_name
)t
WHERE ranking <=5;


-- What are the 5 worst-performing products in terms of sales?

SELECT
	fs.product_key,
	dp.product_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
	ON dp.product_key=fs.product_key
GROUP BY fs.product_key, dp.product_name
ORDER BY total_revenue 
LIMIT 5;


-- Con Window Functions:

SELECT
	*
FROM (
	SELECT
		fs.product_key,
		dp.product_name,
		SUM(fs.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount)) AS ranking
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
		ON dp.product_key=fs.product_key
	GROUP BY fs.product_key, dp.product_name
)t
WHERE ranking <=5;


-- Find the top-10 customers who have generated the highest revenue.

SELECT
	fs.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
	ON dc.customer_key=fs.customer_key
GROUP BY fs.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- And 3 customer with the fewest orders placed.

SELECT
	fs.customer_key,
	dc.first_name,
	dc.last_name,
	COUNT(DISTINCT fs.order_number) AS total_orders
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
	ON dc.customer_key=fs.customer_key
GROUP BY fs.customer_key, dc.first_name, dc.last_name
ORDER BY total_orders 
LIMIT 3;






