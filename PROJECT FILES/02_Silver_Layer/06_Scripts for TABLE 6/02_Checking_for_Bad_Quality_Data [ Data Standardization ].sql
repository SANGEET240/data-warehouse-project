-- Data Standardization & Consistency

USE DataWarehouse;

-- STEP 1: Check all types of data in Column 1
SELECT DISTINCT
	CAT
FROM bronze.erp_px_cat_g1v2


-- STEP 2: Check all types of data in Column 2
SELECT DISTINCT
	SUBCAT
FROM bronze.erp_px_cat_g1v2


-- STEP 3: Check all types of data in Column 3
SELECT DISTINCT
	MAINTENANCE
FROM bronze.erp_px_cat_g1v2

-- After Querying all Columns we can conclude that, there is no Bad quality data in these columns