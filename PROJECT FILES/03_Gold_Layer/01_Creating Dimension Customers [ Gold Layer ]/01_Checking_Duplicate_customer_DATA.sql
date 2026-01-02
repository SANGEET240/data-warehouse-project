-- Get all customer INFO from all Tables


USE DataWarehouse;

SELECT 
	CI.cst_id,
	CI.cst_key,
	CI.cst_firstname,
	CI.cst_lastname,
	CI.cst_marital_status,
	CI.cst_gndr,
	CI.cst_create_date,
	CB.BDATE,
	CB.GEN,
	CL.CNTRY
FROM silver.crm_cust_info AS CI

LEFT JOIN silver.erp_cust_az12 AS CB
ON CI.cst_key = CB.CID

LEFT JOIN silver.erp_loc_a101 AS CL
ON CI.cst_key = CL.CID
-- Before joining all TABLES, there might be Duplicate Data, so we need to check if there is any Duplicate Data or not




-- Let's Check if there is any Duplicate Customer Data or not
-- Expectations; No Result
SELECT cst_id, COUNT(*)
FROM
(
	SELECT 
		CI.cst_id,
		CI.cst_key,
		CI.cst_firstname,
		CI.cst_lastname,
		CI.cst_marital_status,
		CI.cst_gndr,
		CI.cst_create_date,
		CB.BDATE,
		CB.GEN,
		CL.CNTRY
	FROM silver.crm_cust_info AS CI

	LEFT JOIN silver.erp_cust_az12 AS CB
	ON CI.cst_key = CB.CID

	LEFT JOIN silver.erp_loc_a101 AS CL
	ON CI.cst_key = CL.CID
)t
GROUP BY cst_id
HAVING COUNT(*) > 1
-- After Querying this we can Conclude that we have no Duplicate customer Values