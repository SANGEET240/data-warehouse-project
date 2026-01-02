-- Data Standardization on 'GEN' Column [ Gender ]

USE DataWarehouse;

SELECT 
	GEN,

	CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
	ELSE 'Unknown'
	END AS GEN1

FROM bronze.erp_cust_az12