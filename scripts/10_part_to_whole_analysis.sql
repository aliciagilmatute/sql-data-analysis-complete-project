-- Which categories contribute the most to overall sales?

-- con Window function:

SELECT
	category,
	CONCAT(ROUND((total_sales*100.0)/SUM(total_sales) OVER(),2),'%') AS percentage
FROM (
	SELECT
		dp.category AS category,
		SUM(fs.sales_amount) AS total_sales
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
		ON dp.product_key=fs.product_key
	GROUP BY dp.category
)t
ORDER BY percentage DESC;

-- Con CTE:

WITH category_sales AS(
SELECT
	dp.category,
	SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
	ON dp.product_key=fs.product_key
GROUP BY dp.category)

SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((total_sales/SUM(total_sales) OVER())*100,2), '%') AS percentage
FROM category_sales
ORDER BY percentage DESC;



-- Sin widnow function:
SELECT
    category,
    ROUND((total_sales * 100.0) / (
        SELECT SUM(fs.sales_amount)
        FROM gold.fact_sales fs
    ),2) AS percentage
FROM (
    SELECT
        dp.category,
        SUM(fs.sales_amount) AS total_sales
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_products dp
        ON dp.product_key = fs.product_key
    GROUP BY dp.category
) t
ORDER BY percentage DESC;


