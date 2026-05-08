-- Segment products into costs ranges
-- and count how many products fall into each segment

WITH cost_segments AS(

SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END cost_range
FROM gold.dim_products
)

SELECT
	cost_range,
	COUNT(DISTINCT product_key) AS total_products
FROM cost_segments
GROUP BY cost_range
ORDER BY total_products DESC;


/*
==========================================
				MI SOLUCION
==========================================

*/


/*
Group customers into three segments based on their spending behavior:

	- VIP: Customers with at least 12 months of history and spending more than $5000
	- Regular: Customers with at least 12 months of history but spending $5000 or less
	- New: Customers with a lifespan less than 12 months

And find the total number of customers by each group
*/

-- Para la antiguedad (timespan) va a usar order_date, no create_date.
-- Y va a calcular el periodo entre el primer y ultimo pedido de cada cliente

WITH customers_stats AS (
    SELECT
        fs.customer_key,
        dc.first_name,
        dc.last_name,
        SUM(fs.sales_amount) AS total_sales,
        MIN(fs.order_date) AS first_order,
        MAX(fs.order_date) AS last_order,
		gold.date_diff('month',MIN(order_date),MAX(order_date)) AS lifespan_months
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_customers dc
        ON dc.customer_key = fs.customer_key
	WHERE order_date IS NOT NULL
    GROUP BY
        fs.customer_key,
        dc.first_name,
        dc.last_name
),

customers_segments AS (
    SELECT
        customer_key,
        first_name,
        last_name,
        total_sales,
        CASE
            WHEN lifespan_months>=12 AND total_sales > 5000 THEN 'VIP'
			WHEN lifespan_months>=12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_group
    FROM customers_stats
)

SELECT
    customer_group,
    COUNT(DISTINCT customer_key) AS total_customers
FROM customers_segments
GROUP BY customer_group
ORDER BY total_customers DESC;


/*
==========================================
			SOLUCION VIDEO
==========================================
*/


/*
Group customers into three segments based on their spending behavior:

	- VIP: Customers with at least 12 months of history and spending more than $5000
	- Regular: Customers with at least 12 months of history but spending $5000 or less
	- New: Customers with a lifespan less than 12 months

And find the total number of customers by each group
*/

-- Para la antiguedad (timespan) va a usar order_date, no create_date.
-- Y va a calcular el periodo entre el primer y ultimo pedido de cada cliente

WITH customer_spending AS(
	SELECT
		dc.customer_key,
		dc.first_name,
		dc.last_name,
		SUM(fs.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		gold.date_diff('month',MIN(order_date),MAX(order_date)) AS lifespan_months
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers dc
		ON fs.customer_key=dc.customer_key
	WHERE order_date IS NOT NULL
	GROUP BY 
		dc.customer_key,
		dc.first_name,
		dc.last_name
)

SELECT
	CASE WHEN lifespan_months>= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan_months >=12 AND total_spending <=5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment,
	COUNT(DISTINCT customer_key) AS total_customers
FROM customer_spending
GROUP BY customer_segment
ORDER BY total_customers DESC;




















	
	