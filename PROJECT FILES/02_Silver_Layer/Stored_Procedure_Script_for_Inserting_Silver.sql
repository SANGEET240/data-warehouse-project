-- Creating the Stored Procedure for all TABLE's Insert Command, so we can refresh our Data and load 
-- New data from Bronze Layer/Tables to Silver Layer/Tables

/*

------------------------------------------------------------------------------------------
Stored Procedure : Load Silver Layer (Bronze -> Silver)
------------------------------------------------------------------------------------------
Script Purpose:
	This stored procedure performs the ETL (Extract, Transform, Load) process to
	populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
	- Truncates Silver tables.
	- Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters :
	None.
	This stored procedure does not accept any parameters or return any values .

Usage Example:
	EXEC Silver. load silver;
-----------------------------------------------------------------------------------------

*/



USE DataWarehouse;
GO




CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN




	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
	

		PRINT '======================== | Silver Layer Loaded | ============================'
		PRINT ' '
		PRINT '------------------------- | crm Tables Loaded | -----------------------------'






		-- Insertion Cmd - TABLE 1 ( silver.crm_cust_info ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		PRINT '>> Inserting Data Into: silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info
		(
			cst_id, 
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)


		SELECT 
			cst_id, 
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,


			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'  
				 WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				 ELSE 'Unknown'
			END AS cst_marital_status, -- I did data standardization here
			-- Used TRIM & Then UPPER Function so if any spaces and lower case charecters are there in this column, 
			-- then it will get Filtered out.


			CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				 WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				 ELSE 'Unknown'
			END AS cst_gndr, -- I did data standardization here 
			-- Used TRIM & Then UPPER Function so if any spaces and lower case charecters are there in this column, 
			-- then it will get Filtered out.


			cst_create_date
		FROM 
		(
			SELECT 
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag
			FROM bronze.crm_cust_info
		)t
		WHERE Flag = 1

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'










		-- Insertion Cmd - TABLE 2 ( silver.crm_prd_info ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info
		PRINT '>> Inserting Data Into: silver.crm_prd_info'
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

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'










		-- Insertion Cmd - TABLE 3 ( silver.crm_sales_details ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		PRINT '>> Inserting Data Into: silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details (

			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price

		)


		-- STEP 2: Selecting Cleaned Data

		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,

			CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS varchar) AS date)
			END AS sls_order_dt,  -- Converting the Correct Date into Actual 'DATE' data type, and rest become NULLS

			CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS varchar) AS date)
			END AS sls_ship_dt,  -- Converting the Correct Date into Actual 'DATE' data type, and rest become NULLS

			CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS varchar) AS date)
			END AS sls_due_dt,  -- Converting the Correct Date into Actual 'DATE' data type, and rest become NULLS

			CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				 THEN sls_quantity * ABS(sls_price)
				 ELSE sls_sales
			END AS sls_sales,  -- Correcting the NULL, Negative & Wrong sales value [ Price x Quantity ]

			sls_quantity,

			CASE WHEN sls_price IS NULL OR sls_price <= 0
				 THEN sls_sales / NULLIF(sls_quantity, 0)
				 ELSE sls_price
			END AS sls_price  -- Correcting the NULL & Negative Price values [ Sales / Quantity ]

		FROM bronze.crm_sales_details	

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'











		-- Insertion Cmd - TABLE 4 ( silver.erp_cust_az12 ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT '>> Inserting Data Into: silver.erp_cust_az12'
		INSERT INTO silver.erp_cust_az12 (

		CID,
		BDATE,
		GEN

		)

		SELECT 

			CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
				 ELSE CID
			END AS CID, -- Removing 'NAS' From Customer ID [ CID ]

			CASE WHEN BDATE > GETDATE() 
				THEN NULL
			ELSE BDATE
			END AS BDATE, -- Setting Future Birthdays to NULL

			CASE WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
				WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
			ELSE 'Unknown'
			END AS GEN -- Data Standardization

		FROM bronze.erp_cust_az12

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'










		-- Insertion Cmd - TABLE 5 ( silver.erp_loc_a101 ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT '>> Inserting Data Into: silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101 (

		CID,
		CNTRY

		)

		-- STEP 2: Selecting the Cleaned Data
		SELECT

			REPLACE(CID, '-', '') AS CID, -- Replaced the Inavalid CustomerID, & Corrected it

			CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
				 WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
				 WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'Unknown'
				 ELSE TRIM(CNTRY)
			END AS CNTRY  -- Standardizing the Country Data, & Handling blank values or Country Abbreviations

		FROM bronze.erp_loc_a101

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'










		-- Insertion Cmd - TABLE 6 ( silver.erp_px_cat_g1v2 ) | ----------------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2'
		INSERT INTO silver.erp_px_cat_g1v2
		(

		ID,
		CAT,
		SUBCAT,
		MAINTENANCE

		)

		SELECT 
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'








		SET @batch_end_time = GETDATE();
		PRINT ' '
		PRINT '------------------------------------'
		PRINT 'Loading Silver layer is complete!'
		PRINT 'Total Duration taken to load: ' + 
		CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '------------------------------------'
	END TRY
		




	BEGIN CATCH 
		PRINT '-----------------------------------------'
		PRINT 'ERROR OCCURED WHILE LOADING BRONZE LAYER'
		PRINT 'Error message: ' + ERROR_MESSAGE();
		PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '-----------------------------------------'
	END CATCH


END 
