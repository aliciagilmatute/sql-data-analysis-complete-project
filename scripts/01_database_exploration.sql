-- Explore ALL OBJECTS in the Database

SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT 
	table_catalog,
	table_schema,
	table_name,
	table_type
FROM INFORMATION_SCHEMA.TABLES
ORDER BY table_schema, table_name;


-- Explore ALL COLUMNS in the Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY table_schema, table_name;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
ORDER BY table_schema, table_name;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
ORDER BY table_schema, table_name;
