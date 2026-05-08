/*
=====================================================================================================
									PRODUCT REPORT
=====================================================================================================
Objetivo:

	- Este reporte concentra las métricas clave y el comportamiento de los productos

Highlights:

	1. Cubre campos esenciales como el nombre del producto, categoria, subcategoria, y coste.
	2. Clasifica a los productos por rentabilidad para identificar alta-rentabilidad, media-rentabilidad o baja-rentabilidad
	3. Agregaciones de métricas a nivel-producto:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
		
	4. Cálculo de KPI's:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
=====================================================================================================
*/
--------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW gold.report_products AS

WITH base_query AS(
	/*-----------------------------------------------------------------------------------
	1) Base Query: Recoge las principales columnas de las tablas
	*/-----------------------------------------------------------------------------------

	SELECT
		fs.order_number,
		fs.product_key,
		fs.customer_key,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dp.product_name,
		dp.category,
		dp.subcategory,
		dp.cost
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
		ON dp.product_key=fs.product_key
	WHERE order_date IS NOT NULL
)

, product_aggregations AS (
	/*-----------------------------------------------------------------------------------
	2) Customer Aggregations: Resumen de las metricas clave a nivel-producto
	*/-----------------------------------------------------------------------------------
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		MAX(order_date) AS last_sale_date,
		gold.DATE_DIFF('month', MIN(order_date),MAX(order_date)) AS lifespan_months,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity_sold,
		COUNT(DISTINCT customer_key) AS total_customers,
		ROUND(AVG(sales_amount/NULLIF(quantity,0)),2) AS avg_selling_price
		
	FROM base_query
	GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		quantity
)

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	lifespan_months,
	total_orders,
	total_sales,
	CASE 
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales <=10000 THEN 'Mid-Performer'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_quantity_sold,
	total_customers,
	avg_selling_price,
	gold.DATE_DIFF('month',last_sale_date, CURRENT_DATE) AS recency,
	
	-- average order revenue (AOR)
	CASE 
		WHEN total_orders=0 THEN 0
		ELSE ROUND(total_sales/total_orders,2) 
	END AS avg_order_revenue,
	
	-- average monthly revenue
	CASE 
		WHEN lifespan_months = 0 THEN total_sales
		ELSE ROUND(total_sales/lifespan_months,2)
	END AS avg_monthly_revenue
FROM product_aggregations;










