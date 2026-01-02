-- Checking for customer ID (cust_id) in TABLE 3 (Bronze) which are not available in TABLE 2 (Silver)
-- Expectation: No result


USE DataWarehouse


SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN
(
	SELECT 
		cst_id
	FROM silver.crm_cust_info
)