-- Inserting the data in our table 'silver.crm_prd_info'
-- First we need to Chnage out data type and table columns [ DDL Command ] to insert the data in such a way that
-- we can connect this table to 'silver.erp_px_cat_g1v2' & 'silver.crm_sales_details' in future


USE DataWarehouse;


/*
-- STEP 1: Change the DDL Command (Changing the Data type and some columns)
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info
CREATE TABLE silver.crm_prd_info (

prd_id INT,
cat_id NVARCHAR(50),
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)
*/


-- STEP 3 ( Its done in last, so we can insert the cleaned data):
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

-- STEP 2 (Cleaning the data):
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  -- Extract the Product categot (Derived Column)
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,  -- Extract the product key (Derived Column)
	TRIM(prd_nm) AS prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,  --  Changing the NULLS to 0 in Cost columns

	CASE UPPER(TRIM(prd_line))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'T' THEN 'Touring'
		ELSE 'Unknown'
	END AS prd_line, -- Data Standardization

	CAST(prd_start_dt AS date) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS date) AS prd_end_dt -- Data Enrichment
FROM bronze.crm_prd_info
