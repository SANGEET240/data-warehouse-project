-- Checking for unwanted spaces in Order number
-- Expectation: No result

USE DataWarehouse

SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)
-- After querying this we can conclude that we have no Unwanted spaces in column 'sls_ord_num'