-- Inserting the cleaned Data into TABLE 5 [ silver.erp_loc_a101 ]


USE DataWarehouse;


-- STEP 1: Check the DDL Command, if there is any need to change anything in DDL Command
/* IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101 (

CID NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()

) */


-- STEP 3: Inserting the selected Cleaned Data to Silver TABLE 
INSERT INTO silver.erp_loc_a101 (

CID,
CNTRY

)

-- STEP 2: Selecting the Cleaned Data
SELECT

	REPLACE(CID, '-', '') AS CID, -- Replaced the Inavalid CustomerID, & Corrected it

	CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		 WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'Unknown'
		 ELSE TRIM(CNTRY)
	END AS CNTRY  -- Standardizing the Country Data, & Handling blank values or Country Abbreviations

FROM bronze.erp_loc_a101