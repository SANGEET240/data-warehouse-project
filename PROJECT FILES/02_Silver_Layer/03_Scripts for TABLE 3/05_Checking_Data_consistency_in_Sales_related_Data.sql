-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.


USE DataWarehouse

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0

ORDER BY sls_sales, sls_quantity, sls_price
-- After Querying this we can Conclude that, there are many Bad quality Data in the Table


/*
	#1 Solution
		Data Issues will be fixed direct in source system


	#2 Solution
		Data Issues has to be fixed in data warehouse

	But what if we want to Fix it in WareHouse only ? ( if Businness Rules allows it )
	As there are No NULLS and No '0' in 'sls_quantity' column, so we will use it to recreate our
	New Data (Derived Data) by the help of that column, which will be more clean and accurate!
	So
		Rules:
			If Sales is negative, zero, or null, derive it using Quantity and Price.
			If Price is zero or null, calculate it using Sales and Quantity.
			If Price is negative, convert it to a positive value
*/


-- Let's clean the Sales and price data
SELECT DISTINCT
	sls_sales AS OLD_sls_sales,
	sls_quantity,
	sls_price AS OLD_sls_price,

	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,

	CASE WHEN sls_price IS NULL OR sls_price <= 0
		 THEN sls_sales / NULLIF(sls_quantity, 0)
		 ELSE sls_price
	END AS sls_price


FROM bronze.crm_sales_details
-- By Querying this we can say, that we have cleaned up the column 'sls_sales' & 'sls_price'