-- Making the Data/Main Customer TABLE More Friendly by giving more Friendly names to the column
-- Using snake naming convention.


USE DataWarehouse;


SELECT 
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_firstname AS first_name,
	CI.cst_lastname AS last_name,
	CL.CNTRY AS country,
	CI.cst_marital_status AS marital_status,

	CASE WHEN CI.cst_gndr != 'unknown' THEN CI.cst_gndr
		ELSE COALESCE(CB.GEN, 'Unknown')
	END AS gender,

	CB.BDATE AS birthdate,
	CI.cst_create_date AS create_date

FROM silver.crm_cust_info AS CI

LEFT JOIN silver.erp_cust_az12 AS CB
ON CI.cst_key = CB.CID

LEFT JOIN silver.erp_loc_a101 AS CL
ON CI.cst_key = CL.CID