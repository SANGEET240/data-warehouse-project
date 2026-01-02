-- Data Standardization on Column 'CNTRY' in TABLE [ bronze.erp_loc_a101 ]


USE DataWarehouse;


-- STEP 1: Checking all types of Data in Column Country [ CNTRY ]
SELECT DISTINCT
	CNTRY
FROM bronze.erp_loc_a101
ORDER BY CNTRY
-- After Querying this we can conclude that, There are Bad Data like NULL, No Value/Space, Country abbreviation


-- STEP 2: Correcting the bad data
SELECT DISTINCT
	
	CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		 WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'Unknown'
		 ELSE TRIM(CNTRY)
	END AS CNTRY


FROM bronze.erp_loc_a101
-- After Querying this, i can say that i have removed the Uncleaned/Bad Data from column 'CNTRY'