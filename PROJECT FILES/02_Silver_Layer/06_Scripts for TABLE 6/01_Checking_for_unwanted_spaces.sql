-- Checking for Unwanted spaces in Columns of TABLE 6


USE DataWarehouse;


-- STEP 1: Checking for Unwanted Spaces
-- Expectations: No results
SELECT 
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
FROM bronze.erp_px_cat_g1v2
WHERE CAT != TRIM(CAT) OR SUBCAT != TRIM(SUBCAT) OR MAINTENANCE != TRIM(MAINTENANCE)
-- After Querying this we can conclude that, there is no Unwanted spaces in ALL columns, Which is Good