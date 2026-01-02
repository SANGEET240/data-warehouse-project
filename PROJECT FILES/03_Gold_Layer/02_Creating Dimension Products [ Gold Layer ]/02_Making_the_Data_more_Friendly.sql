-- Making the Data more Friendly, Giving Friendly names to the Columns [ Preparing the Data for Gold Layer ]

USE DataWarehouse;



SELECT
		PI.prd_id AS product_id,
		PI.prd_key AS product_number,
		PI.prd_nm AS product_name,
		PI.cat_id AS category_id,
		PC.CAT AS category,
		PC.SUBCAT AS subcategory,
		PC.MAINTENANCE,
		PI.prd_cost AS product_cost,
		PI.prd_line AS product_line,
		PI.prd_start_dt AS start_date
FROM silver.crm_prd_info AS PI

LEFT JOIN silver.erp_px_cat_g1v2 AS PC
ON PI.cat_id = PC.ID

WHERE PI.prd_end_dt IS NULL