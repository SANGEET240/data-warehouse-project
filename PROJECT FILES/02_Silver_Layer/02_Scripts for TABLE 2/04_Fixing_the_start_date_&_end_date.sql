-- Fixing the Start date and end date columns in the Table 'bronze.crm_prd_info'
-- Columns - prd_start_dt, prd_end_dt

USE DataWarehouse

SELECT
	prd_id,
	prd_key,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
-- After querying we can see, start date and date makes no sense, some are overlapping 
-- and some end date are before the start date, which is never possible, so we need to FIX it.

USE DataWarehouse

SELECT
	prd_id,
	prd_key,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info


-- We fixed it by Taking the next start date as end date on the basis of Product key(prd_key)
-- Used LEAD() Function
