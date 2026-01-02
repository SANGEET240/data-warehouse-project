-- Checking the Foreign Key Integrity ( Surrogate key join )
-- Expectations: No result


USE DataWarehouse;


-- Here we will join the Fact gold Table with Dimension customer + product gold table, 
-- and join them with the help of surrogate keys.
-- and later after joining them we will check if there is any unmatching data from Gold customers + products Dimension TABLE.
-- to know about the integrity of Data.
SELECT *
FROM gold.fact_sales AS F

LEFT JOIN gold.dim_customers AS C
ON C.customer_key = F.customer_key

LEFT JOIN gold.dim_products AS P
ON P.product_key = F.product_key

WHERE C.customer_key IS NULL OR P.product_key IS NULL
-- After querying this we can conclude that, there isn't any Unmatching Data from Both of the Dimensions Table, Which is Good!