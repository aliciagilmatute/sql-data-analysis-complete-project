-- Explore ALL Countries our customers come from:

SELECT DISTINCT 
	country
FROM gold.dim_customers;

-- SELECT DISTINCT 
-- 	country,
-- 	COUNT(*) AS num_countries
-- FROM gold.dim_customers
-- GROUP BY country;


-- Explore ALL Product Categories 'The Major Divisions':

SELECT DISTINCT
	category,
	subcategory,
	product_name
FROM gold.dim_products
ORDER BY 1,2,3;

-- SELECT DISTINCT
-- 	category,
-- 	subcategory,
-- 	product_name
-- FROM gold.dim_products
-- ORDER BY category, subcategory, product_name;







