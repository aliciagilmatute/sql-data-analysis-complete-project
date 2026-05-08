-- Analyze the yearly performance of products by comparing each product's sales
-- to both it's average sales performance and the previous year's sales

-- Analiza el rendimiento anual de los productos comparando las ventas de cada producto
-- tanto con su rendimiento promedio de ventas como con las ventas del año anterior


-- Con CTE:

WITH yearly_product_sales AS (
	SELECT
		DATE_TRUNC('year',fs.order_date)::date AS order_date,
		fs.product_key,
		dp.product_name,
		SUM(fs.sales_amount) AS total_sales
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
		ON fs.product_key=dp.product_key
	WHERE order_date IS NOT NULL
	GROUP BY DATE_TRUNC('year',fs.order_date)::date,fs.product_key, dp.product_name
)

SELECT 
	order_date,
	product_name,
	total_sales,
	ROUND(AVG(total_sales) OVER(PARTITION BY product_name),2) AS avg_current_sales,
	total_sales - 	ROUND(AVG(total_sales) OVER(PARTITION BY product_name),2) AS diff_avg,
	CASE WHEN total_sales - 	ROUND(AVG(total_sales) OVER(PARTITION BY product_name),2)>0 THEN 'Above Avg'
		WHEN total_sales - 	ROUND(AVG(total_sales) OVER(PARTITION BY product_name),2) <0 THEN 'Below Avg'
		ELSE 'Avg'
	END avg_change,
	-- Year-over-year Analysis
	LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS py_sales,
	total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS diff_py,
	CASE WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_date)>0 THEN 'Increase'
		WHEN total_sales - LAG(total_sales) OVER(PARTITION BY product_name ORDER BY order_date)<0 THEN 'Decrease'
		ELSE 'No change'
	END py_change
FROM yearly_product_sales
ORDER BY product_name, order_date;


-- Con window functions:

SELECT
    order_date,
    product_key,
    product_name,
    total_sales,

    -- Average yearly sales per product
    ROUND(
        AVG(total_sales) OVER (
            PARTITION BY product_key
        ),
        2
    ) AS avg_sales,

    -- Previous year's sales
    LAG(total_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_date
    ) AS previous_year_sales,

    -- Difference vs product average
    ROUND(
        total_sales - AVG(total_sales) OVER (
            PARTITION BY product_key
        ),
        2
    ) AS diff_vs_avg,

    -- Difference vs previous year
    total_sales - LAG(total_sales) OVER (
        PARTITION BY product_key
        ORDER BY order_date
    ) AS diff_vs_previous_year,

    -- Performance vs average classification
    CASE
        WHEN total_sales > AVG(total_sales) OVER (
            PARTITION BY product_key
        ) THEN 'Above Avg'
        WHEN total_sales < AVG(total_sales) OVER (
            PARTITION BY product_key
        ) THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_performance,

    -- Year-over-year trend classification
    CASE
        WHEN LAG(total_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_date
        ) IS NULL THEN 'No Prior Year'
        WHEN total_sales > LAG(total_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_date
        ) THEN 'Increase'
        WHEN total_sales < LAG(total_sales) OVER (
            PARTITION BY product_key
            ORDER BY order_date
        ) THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_trend

FROM (
    SELECT
        DATE_TRUNC('year', fs.order_date)::date AS order_date,
        fs.product_key,
        dp.product_name,
        SUM(fs.sales_amount) AS total_sales
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_products dp
        ON fs.product_key = dp.product_key
    WHERE fs.order_date IS NOT NULL
    GROUP BY
        DATE_TRUNC('year', fs.order_date)::date,
        fs.product_key,
        dp.product_name
) t

ORDER BY
    product_key,
    order_date;







