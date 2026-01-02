-- Checking for unwanted spaces in Table 2 [ bronze.crm_prd_info ]
-- Expectations: No Spaces/No result


USE DataWarehouse

SELECT 
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- We got no unwanted spaces [ No result ], which is a good thing


-- Checking for NULL product cost and negative product Cost
SELECT
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL 
-- We got NULL Values, If business allows we can replace those NULLS with '0'