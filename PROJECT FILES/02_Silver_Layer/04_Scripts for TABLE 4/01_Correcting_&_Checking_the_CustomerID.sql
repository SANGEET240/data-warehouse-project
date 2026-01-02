/* Checking for unmatching customer ID and correcting it, so that in future we can join the TABLE 
'silver.erp_cust_az12' with 'silver.crm_cust_info' */

USE DataWarehouse;


-- STEP 1: Identifying/Checking the Impurity in CID [ Customer ID ]
SELECT *
FROM bronze.erp_cust_az12
/* After Querying this we can Conclude that, That we have lots of customer ID which have 'NAS' at starting
Example: 'NASAW00011000'
Which is not good, or maybe that 'NAS' is not that necessary, so we can remove it and join it with 
'cst_key' in TABLE 'silver.crm_cust_info' */



-- STEP 2: Let's Correct it, by removing that 'NAS' part in 'CID' Column
SELECT
	CID,

	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
		 ELSE CID
	END AS CID2,

	BDATE,
	GEN
FROM bronze.erp_cust_az12
/* After Querying this we need to check if these Customer ID (CID) is actually all matching with 'cst_key' or not
From the TABLE 'silver.crm_cust_info' */


-- STEP 3: Let's check the unmatching Customer ID [ CID & cst_key ]
-- Expectation: No result
SELECT

	CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
		 ELSE CID
	END AS CID,

	BDATE,
	GEN
FROM bronze.erp_cust_az12
WHERE 
CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
	 ELSE CID
END NOT IN
		   (
		   SELECT
		       cst_key
		   FROM silver.crm_cust_info
		   )
-- After Querying this we can conclude that, that there is no unmatching Data, which is a Good thing