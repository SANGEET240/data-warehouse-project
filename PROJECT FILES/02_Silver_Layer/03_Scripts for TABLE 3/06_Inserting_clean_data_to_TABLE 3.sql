-- Inserting the Clean Data into TABLE 3



-- STEP 1: Let's Check our DDL Command if its correct or not while inserting our cleaned Data [ Making Changes to DDL Command ]
/* IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details
CREATE TABLE silver.crm_sales_details (

sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE, -- Changed from INT to DATE
sls_ship_dt DATE,  -- Changed from INT to DATE
sls_due_dt DATE,   -- Changed from INT to DATE
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()

) */


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