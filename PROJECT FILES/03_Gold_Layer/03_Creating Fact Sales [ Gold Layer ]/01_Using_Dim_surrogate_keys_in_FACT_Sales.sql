/* Building Fact
Use the dimension's [ gold.dim_customers & gold.dim_products ] surrogate keys instead 
of FACT Table's IDs [ silver.crm_sales_details ]
to easily connect Fact [ silver.crm_sales_details ] with dimensions */


USE DataWarehouse;


SELECT 
	SD.sls_ord_num,
	-- SD.sls_prd_key, -- We will not use this, instead we will use Surrogate keys of Dimensions Table
	PR.product_key,

	-- SD.sls_cust_id, -- We will not use this, instead we will use Surrogate keys of Dimensions Table
	CU.customer_key,

	SD.sls_order_dt,
	SD.sls_ship_dt,
	SD.sls_due_dt,
	SD.sls_sales,
	SD.sls_quantity,
	SD.sls_price
FROM silver.crm_sales_details AS SD

LEFT JOIN gold.dim_products AS PR
ON SD.sls_prd_key = PR.product_number

LEFT JOIN gold.dim_customers AS CU
ON SD.sls_cust_id = CU.customer_id

