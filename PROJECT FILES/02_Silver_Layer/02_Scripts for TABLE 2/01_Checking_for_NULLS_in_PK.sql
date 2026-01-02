-- Checking for NULLS & Duplicates in PK
-- Expectations: No results

USE DataWarehouse

SELECT
	prd_id,
	COUNT(*) AS FLAG
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- We got no NULL Values or Duplicate numbers in Column prd_id, which is a good thing!