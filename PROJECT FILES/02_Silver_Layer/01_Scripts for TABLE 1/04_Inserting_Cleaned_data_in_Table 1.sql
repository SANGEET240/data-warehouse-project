/*
Let's clean the whole data, By handling the Duplicate data in Primary key, spaces in first & last name
and also Setting data standardization ( Unknown Instead of NULLS, Male & Female Instead of 'M', 'F' and
Married & single instead 'M', 'S')
*/


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