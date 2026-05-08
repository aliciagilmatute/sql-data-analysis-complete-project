/*
=====================================================================================================
									CUSTOMER REPORT
=====================================================================================================
Objetivo:

	- Este reporte concentra las métricas clave y el comportamiento de los clientes

Highlights:

	1. Cubre campos esenciales como el nombre, la edad y los detalles de las transacciones.
	2. Clasifica a los clientes en categorias (VIP, Regular, New) y en grupos de edad.
	3. Agregaciones de métricas a nivel-cliente:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
		
	4. Cálculo de KPI's:
		- recency (months since last order)
		- average order value
		- average monthly spend
=====================================================================================================
*/
--------------------------------------------------------------------------------------------

CREATE OR REPLACE VIEW gold.report_customers AS
WITH base_query AS(
	/*-----------------------------------------------------------------------------------
	1) Base Query: Recoge las principales columnas de las tablas
	*/-----------------------------------------------------------------------------------

	SELECT
		fs.order_number,
		fs.product_key,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dc.customer_key,
		dc.customer_number,
		CONCAT(dc.first_name,' ', dc.last_name) AS customer_name,
		gold.DATE_DIFF('year',CURRENT_DATE, dc.birthdate) AS age
FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers dc
		ON fs.customer_key = dc.customer_key
	WHERE order_date IS NOT NULL
)
, customer_agreggation AS (
	/*-----------------------------------------------------------------------------------
	2) Customer Aggregations: Resumen de las metricas clave a nivel-cliente
	*/-----------------------------------------------------------------------------------
	
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		gold.DATE_DIFF('month',MAX(order_date),MIN(order_date)) AS lifespan_months
	FROM base_query
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		age
)

SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE 
		WHEN age <20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 30 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	CASE
		WHEN lifespan_months >=12 AND total_sales>5000 THEN 'VIP'
		WHEN lifespan_months >=12 AND total_sales <=5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	lifespan_months	,
	gold.DATE_DIFF('month', CURRENT_DATE,last_order_date) AS recency,
	-- Compute average order value (AVO)
	CASE WHEN total_orders=0 THEN 0
		ELSE ROUND(total_sales/total_orders,2) 
	END AS avg_order_value,
	-- Compute average monthly spend
	CASE WHEN lifespan_months = 0 THEN total_sales   -- en lifespan tenemos ceros pero no significa que no haya meses, sino que el cliente existe por 1 año solo (es decir, el total-sales del cliente)
		ELSE ROUND(total_sales/lifespan_months,2) 
	END AS avg_monthly_spend
FROM customer_agreggation;




