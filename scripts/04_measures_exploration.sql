-- Find the Total Sales:

SELECT
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


-- Find how many items are sold:

SELECT
	SUM(quantity) AS total_items
FROM gold.fact_sales;


-- Find the average selling price:

SELECT
	ROUND(AVG(price),2) AS avg_price
FROM gold.fact_sales;

-- Find the Total number of orders:

SELECT 	
	COUNT(order_number) AS total_orders
FROM gold.fact_sales;

SELECT 	
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

--------------------------------------------------------------------------------------------------------------
-- La discrepancia de los resultados de ambas queries implica que 
-- el mismo pedido se repite varias veces en nuestra tabla. ¿por que?

SELECT
    order_number,
    COUNT(*) AS total_rows
FROM gold.fact_sales
GROUP BY order_number
ORDER BY total_rows DESC;

-- Se debe a que en un mismo pedido se piden 3 o mas productos 
-- gold.fact_sales se organiza por product ounico, no por pedido unico

-- La query correcta que resuelve este ejercicio es:

SELECT 	
	COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

--------------------------------------------------------------------------------------------------------------

-- Find the total number of products:
-- Products available:

SELECT
	COUNT(DISTINCT product_id) AS total_products_available
FROM gold.dim_products;


SELECT
	COUNT(product_id) AS total_products_available
FROM gold.dim_products;    -- Ambas queries nos devuelven el mismo valor


-- Find the total number of customers:
-- Historial de clientes:

SELECT 
	COUNT(DISTINCT customer_id) AS total_historical_customers
FROM gold.dim_customers;


SELECT 
	COUNT(customer_id) AS total_historical_customers
FROM gold.dim_customers;   -- Ambas queries nos devuelven el mismo valor


-- Find the total number of customers that has placed an order:
-- En la tabla gold.fact_sales

SELECT 
	COUNT(DISTINCT customer_key) AS total_historical_customers
FROM gold.fact_sales;

/*
==================================================================================
			Generate a Report that shows all key metrics of the business
==================================================================================
*/

SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price),2) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', 	COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(DISTINCT product_id) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr.Customers', COUNT(customer_id) FROM gold.dim_customers; 





