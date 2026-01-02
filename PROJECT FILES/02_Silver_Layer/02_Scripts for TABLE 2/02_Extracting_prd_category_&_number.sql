-- Extracting the Product category and the product Number/key[prd_key1] from the Table 'bronze.crm_prd_info'
-- so that we can later on in Future
-- JOIN that table with 'silver.erp_px_cat_g1v2' Table & 'silver.crm_sales_details' Table

USE DataWarehouse


SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info


-- Let's Find out which Category ID are not present in 'bronze.erp_px_cat_g1v2' Table
-- Basically filtering out the unmatched product category
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN
(
	SELECT DISTINCT
	ID
	FROM bronze.erp_px_cat_g1v2
)

-- Let's Find out which product key are not present in 'bronze.crm_sales_details' Table
-- Basically filtering out the unmatched product category
SELECT 
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key1,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN
(
	SELECT DISTINCT
		sls_prd_key
	FROM bronze.crm_sales_details
)
-- So we are getting many Products which didn't got any Orders
-- Which is totally okay, we can go forward with some unmatching products.





