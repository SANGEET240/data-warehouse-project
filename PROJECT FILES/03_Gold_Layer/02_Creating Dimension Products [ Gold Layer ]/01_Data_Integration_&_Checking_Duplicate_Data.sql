-- Getting all Products information from all Product related TABLES
-- And checking if there is any Duplicate data or not


USE DataWarehouse;


-- STEP 1: Doing the Integration, Merging Data from all Tables
SELECT
		PI.prd_id,
		PI.prd_key,
		PI.prd_nm,
		PI.cat_id,
		PC.CAT,
		PC.SUBCAT,
		PC.MAINTENANCE,
		PI.prd_cost,
		PI.prd_line,
		PI.prd_start_dt
FROM silver.crm_prd_info AS PI

LEFT JOIN silver.erp_px_cat_g1v2 AS PC
ON PI.cat_id = PC.ID

WHERE PI.prd_end_dt IS NULL -- Getting the latest Data, Removing the Historical Data





-- STEP 2: Checking for Duplicates in Data related to Products
SELECT 
	prd_key,
	COUNT(*)
FROM
(
	SELECT
		PI.prd_id,
		PI.prd_key,
		PI.prd_nm,
		PI.cat_id,
		PC.CAT,
		PC.SUBCAT,
		PC.MAINTENANCE,
		PI.prd_cost,
		PI.prd_line,
		PI.prd_start_dt,
		PI.prd_end_dt

	FROM silver.crm_prd_info AS PI

	LEFT JOIN silver.erp_px_cat_g1v2 AS PC
	ON PI.cat_id = PC.ID

	WHERE PI.prd_end_dt IS NULL 
)t

GROUP BY prd_key
HAVING COUNT(*) > 1
-- After Querying this we can conclude that, There is no Duplicate data
