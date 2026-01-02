-- Making the Data more Friendly, and changing the column names to more Friendly names


USE DataWarehouse;


SELECT 
	SD.sls_ord_num AS order_number,
	-- SD.sls_prd_key, -- We will not use this, instead we will use Surrogate keys of Dimensions Table
	PR.product_key,

	-- SD.sls_cust_id, -- We will not use this, instead we will use Surrogate keys of Dimensions Table
	CU.customer_key,

	SD.sls_order_dt AS order_date,
	SD.sls_ship_dt AS shipping_date,
	SD.sls_due_dt AS due_date,
	SD.sls_sales AS sales_amount,
	SD.sls_quantity AS quantity,
	SD.sls_price AS price
FROM silver.crm_sales_details AS SD

LEFT JOIN gold.dim_products AS PR
ON SD.sls_prd_key = PR.product_number

LEFT JOIN gold.dim_customers AS CU
ON SD.sls_cust_id = CU.customer_id