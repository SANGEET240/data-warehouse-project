-- Checking for product keys in TABLE 3 (Bronze) which are not available in TABLE 2 (Silver)
-- Expectation: No result


USE DataWarehouse

SELECT *
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN
(
	SELECT 
		prd_key
	FROM silver.crm_prd_info
)
-- After Querying this we can conclude that there are no unmatching product key from TABLE 3 to TABLE 2