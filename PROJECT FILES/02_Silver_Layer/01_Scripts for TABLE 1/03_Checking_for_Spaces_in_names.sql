-- Check for unwanted spaces
-- Expectations = No result

USE DataWarehouse


-- Check spaces in first name
SELECT 
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


-- Check spaces in last name
SELECT 
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


-- So, we do have spaces in names, so we will use TRIM Function when we will be inserting our data