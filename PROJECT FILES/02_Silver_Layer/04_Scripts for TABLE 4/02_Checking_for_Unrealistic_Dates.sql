/* Identifying Unrealistic customer Birth Dates 
[ Customers more than 100 years old OR Customers with Bdate in Future ] */


USE DataWarehouse;


-- STEP 1: Checking Bad Data 
SELECT 
	BDATE
FROM bronze.erp_cust_az12
WHERE BDATE < '1925-01-01' OR BDATE > GETDATE()
/* After querying this we can conclude that, that there are bad data 
[ Customers more than 100 years old OR Customers with Bdate in Future ] */



-- STEP 2: Replacing the Future BirthDays with NULL 
SELECT
	BDATE,

	CASE WHEN BDATE > GETDATE() 
		THEN NULL
	ELSE BDATE
	END AS BDATE

FROM bronze.erp_cust_az12