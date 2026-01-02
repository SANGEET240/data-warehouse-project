/*
-------------------------------------------------------------------------------
Stored Procedure: Load Bronze Layer (Source -> Bronze)
-------------------------------------------------------------------------------
Script purpose:
	This stored procedure loads data into the 'bronze' schema from external CSV files.
	It performs the following actions:
		- Truncates the bronze tables before loading data.
		- Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

	Parameters :
		None.
		This stored procedure does not accept any parameters or return any values


	Usage Example:
		EXEC bronze. load bronze;
-------------------------------------------------------------------------------

*/


-- Inserting our data from CSV Files to our SQL Server tables

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
	SET @batch_start_time = GETDATE();


		PRINT '======================== | Bronze Layer Loaded | ==========================='
		PRINT ' '
		PRINT '------------------------- | crm Tables Loaded | -----------------------------'




		-- TABLE 1 | crm -----------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE [bronze].[crm_cust_info]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT [bronze].[crm_cust_info]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_crm\cust_info.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'



		-- TABLE 2 | crm ---------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE [bronze].[crm_prd_info]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT [bronze].[crm_prd_info]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_crm\prd_info.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'



		-- TABLE 3 | crm ---------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE [bronze].[crm_sales_details]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT [bronze].[crm_sales_details]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_crm\sales_details.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'
		PRINT ' '
		PRINT '------------------------- | erp Tables Loaded | -----------------------------'




		-- TABLE 4 | erp ---------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE [bronze].[erp_cust_az12]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		BULK INSERT [bronze].[erp_cust_az12]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_erp\CUST_AZ12.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'



		-- TABLE 5 | erp ---------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE [bronze].[erp_loc_a101]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT [bronze].[erp_loc_a101]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_erp\LOC_A101.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'



		-- TABLE 6 | erp ---------------------------------------------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]; -- Deleting all data from this table if there are any already existing Data

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT [bronze].[erp_px_cat_g1v2]
		FROM 'C:\Users\SANGEET\Desktop\datasets\source_erp\PX_CAT_G1V2.csv' 
		WITH (

			FIRSTROW = 2,  -- Telling SQL that 2nd row in CSV file is the First Row
			FIELDTERMINATOR = ',',  -- Mentioning Seperator in our CSV file
			TABLOCK

		)
		SET @end_time = GETDATE();
		PRINT ' '
		PRINT 'Load Time taken: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '----------------'



		SET @batch_end_time = GETDATE();
		PRINT ' '
		PRINT '------------------------------------'
		PRINT 'Loading Bronze layer is complete!'
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