-- Inserting the clean data in TABLE 4


USE DataWarehouse;


-- STEP 1: Check our previous DDL Command
/* IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12
CREATE TABLE silver.erp_cust_az12 (

CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()

) */


INSERT INTO silver.erp_cust_az12 (

CID,
BDATE,
GEN

)

SELECT 

	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
		 ELSE CID
	END AS CID, -- Removing 'NAS' From Customer ID [ CID ]

	CASE WHEN BDATE > GETDATE() 
		THEN NULL
	ELSE BDATE
	END AS BDATE, -- Setting Future Birthdays to NULL

	CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
	ELSE 'Unknown'
	END AS GEN -- Data Standardization

FROM bronze.erp_cust_az12