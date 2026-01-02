-- Doing Data integration on the Column Gender from 2 Tables

USE DataWarehouse;



/* STEP 1: Check for Unmatching Data, and get data from other TABLES [ silver.erp_cust_az12 ] to 
master TABLE [ silver.crm_cust_info ], if not available [ Unknown ] in master TABLE 

Basically we are considering data from Master table as More accurate and using it!*/
SELECT DISTINCT
	CI.cst_gndr,
	CB.GEN,

	CASE WHEN CI.cst_gndr != 'unknown' THEN CI.cst_gndr
		ELSE COALESCE(CB.GEN, 'Unknown')
	END AS New_GEN

FROM silver.crm_cust_info AS CI

LEFT JOIN silver.erp_cust_az12 AS CB
ON CI.cst_key = CB.CID
-- Basically by using 2 Gender Columns, by Integrating the data from both Tables we did Data Enrichment




-- STEP 2: Use this Enriched data and use it in Table
SELECT 
	CI.cst_id,
	CI.cst_key,
	CI.cst_firstname,
	CI.cst_lastname,
	CI.cst_marital_status,

	CASE WHEN CI.cst_gndr != 'unknown' THEN CI.cst_gndr
		ELSE COALESCE(CB.GEN, 'Unknown')
	END AS New_GEN,

	CI.cst_create_date,
	CB.BDATE,
	CL.CNTRY
FROM silver.crm_cust_info AS CI

LEFT JOIN silver.erp_cust_az12 AS CB
ON CI.cst_key = CB.CID

LEFT JOIN silver.erp_loc_a101 AS CL
ON CI.cst_key = CL.CID