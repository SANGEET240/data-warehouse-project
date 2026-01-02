-- Making the Gold Layer/View Table for this Data


/*
----------------------------------------------------------------------------------------------------
DDL Script: Create Gold Views
----------------------------------------------------------------------------------------------------
Script Purpose:
	This script creates views for the Gold layer in the data warehouse.
	The Gold layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the Silver layer
	to produce a clean, enriched, and business-ready dataset.

Usage:
	These views can be queried directly for analytics and reporting.
----------------------------------------------------------------------------------------------------

*/



USE DataWarehouse;
GO

CREATE VIEW gold.dim_products AS 
SELECT
		ROW_NUMBER() OVER(ORDER BY PI.prd_start_dt, PI.prd_key) AS product_key, -- Surrogate Primary Key
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