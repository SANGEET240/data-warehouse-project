-- Correcting the Customer ID [ CID ] In TABLE 5 [ bronze.erp_loc_a101 ]

USE DataWarehouse


-- STEP 1: Check for Impurity in Customer ID, By comparing 2 Tables
SELECT *
FROM bronze.erp_loc_a101

SELECT 
	cst_key
FROM silver.crm_cust_info
/* After Querying Customer ID of 2 Tables can conclude that, There is a '-' Symbol in CID of TABLE 'bronze.erp_loc_a101'
Which is not required, so we will remove it. */


-- STEP 2: Cleaning the Customer ID data
SELECT 
	REPLACE(CID, '-', '') AS CID,
	CNTRY
FROM bronze.erp_loc_a101


-- STEP 3: Checking for Unmatching Customer ID in this table with another TABLE [ silver.crm_cust_info ]
-- Expectations: No result
SELECT 
	REPLACE(CID, '-', '') AS CID,
	CNTRY
FROM bronze.erp_loc_a101
WHERE REPLACE(CID, '-', '') NOT IN
(
	SELECT 
		cst_key
	FROM silver.crm_cust_info
)
-- After Querying this we can conclude that, that there is no Unmatching customerID, which is a good thing