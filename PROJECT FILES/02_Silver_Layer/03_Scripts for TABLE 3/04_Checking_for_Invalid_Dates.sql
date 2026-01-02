-- Checking for Invalid dates in TABLE 3


USE DataWarehouse


-- | Working with column 'sls_order_dt' | ---------------------------------------------------


-- STEP 1:
-- Let's check for Dates which are Zero
SELECT
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
-- After querying this we can conclude that there are dates with value 0, we will convert it into NULL
SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details




-- STEP 2: 
-- We have Date as integer, so the length will be exactly '8', let's check that
SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt) != 8 
-- After querying this we can conclude that, there are 2 Data which doesn't look like a Date




-- STEP 3: Check for unrealistic dates (Boundary Dates)
SELECT
	NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101 OR sls_order_dt < 19000101
-- After querying this we can conclude that there aren't any Dates which are beyond the boundary ( Year - 2050 & 1900 )




-- STEP 4: Check for Invalid Date Orders
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
-- After querying this we can conclude that, That there arent any unrealistic order of Date



-- WE DID ALL OF THESE CHECKS FOR ONE COLUMN ONLY I.E., sls_order_dt
-- BUT WE CAN CHECK OTHER COLUMNS TOO, SIMILARLY LIKE THIS!