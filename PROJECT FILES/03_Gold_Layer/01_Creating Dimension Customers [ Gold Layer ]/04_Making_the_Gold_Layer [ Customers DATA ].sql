/* Making the GOLD Layer as a VIEW with a Surrogate key, Because sometimes its necessary to make it while working with
Dimension Table */

/*
----------------------------------------------------------------------------------------------------
DDL Script: Create Gold Views
----------------------------------------------------------------------------------------------------
Script Purpose:
	This script creates views for the Gold layer in the data warehouse.
	The Gold layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the Silver layer
	to produce a clean, enriched, and business-ready dataset.

Usage:
	These views can be queried directly for analytics and reporting.
----------------------------------------------------------------------------------------------------

*/



USE DataWarehouse;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY CI.cst_id) AS customer_key, -- Surrogate Primary key
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_firstname AS first_name,
	CI.cst_lastname AS last_name,
	CL.CNTRY AS country,
	CI.cst_marital_status AS marital_status,

	CASE WHEN CI.cst_gndr != 'unknown' THEN CI.cst_gndr
		ELSE COALESCE(CB.GEN, 'Unknown')
	END AS gender,

	CB.BDATE AS birthdate,
	CI.cst_create_date AS create_date

FROM silver.crm_cust_info AS CI

LEFT JOIN silver.erp_cust_az12 AS CB
ON CI.cst_key = CB.CID

LEFT JOIN silver.erp_loc_a101 AS CL
ON CI.cst_key = CL.CID