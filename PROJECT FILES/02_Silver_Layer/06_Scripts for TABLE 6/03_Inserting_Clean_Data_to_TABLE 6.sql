-- Inserting the Cleaned data in TABLE 6

USE DataWarehouse;

-- As there is no Bad Data in TABLE 6, I will insert the Selected Columns as it is.
INSERT INTO silver.erp_px_cat_g1v2
(

ID,
CAT,
SUBCAT,
MAINTENANCE

)

SELECT 
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
FROM bronze.erp_px_cat_g1v2