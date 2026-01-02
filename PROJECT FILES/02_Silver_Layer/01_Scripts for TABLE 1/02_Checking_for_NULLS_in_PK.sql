-- Check for Nulls in primary Key
-- Expectations: No Result

USE DataWarehouse;


-- STEP 1: Check for Duplicates in 'cst_id' (Primary Key)
SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
-- We are getting Duplicate 'cst_id', and also there is NULL 'cst_id' too
-- So we need to check all of those data inside 'cst_id' and let's keep only the latest ones (Most recent acc to date)


-- STEP 2: Rank the duplicate data, and keep only those which are latest by the date
SELECT *
FROM
(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag
	FROM bronze.crm_cust_info
)t
WHERE Flag = 1
-- WHERE Flag != 1 -- This Filters and helps us to find Not latest Duplicate data