/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
   This script creates views for the Gold layer in the data warehouse.
   The Gold layer represents the final dimension and fact tables (Star Schema)

   Each view performs transformations and combines data from the Silver layer
   to produce a clean, enriched, and business-ready dataset.

Usage:
   - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- Description: This dimension contains clean, business-ready customer information for analysis.
--           Data is merged from CRM and ERP tables in the Silver layer.
-- =============================================================================
-- Checks for and drops the view if it already exists, ensuring the script can be run
-- multiple times without errors.
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    -- Surrogate key: Created using ROW_NUMBER() to ensure unique identification and
    -- efficient joins to the fact table. This is a best practice in data warehouse modeling.
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id                            AS customer_id,
    ci.cst_key                           AS customer_number,
    ci.cst_firstname                     AS first_name,
    ci.cst_lastname                      AS last_name,
    la.cntry                             AS country,
    ci.cst_marital_status                AS marital_status,
    -- Data transformation: Use the gender data from the CRM as the primary source.
    -- If it's not available ('n/a'), use data from the ERP. COALESCE ensures an
    -- 'n/a' value if both sources lack data.
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END                                  AS gender,
    ca.bdate                             AS birthdate,
    ci.cst_create_date                   AS create_date
-- Joins customer data from the CRM with additional data from the ERP using
-- 'cst_key' (from CRM) and 'cid' (from ERP).
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- Description: This dimension contains clean product information, including categories and
--           subcategories, merged from Silver layer tables.
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    -- Surrogate key: Created using ROW_NUMBER() for unique identification.
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id               AS product_id,
    pn.prd_key              AS product_number,
    pn.prd_nm               AS product_name,
    pn.cat_id               AS category_id,
    pc.cat                  AS category,
    pc.subcat               AS subcategory,
    pc.maintenance          AS maintenance,
    pn.prd_cost             AS cost,
    pn.prd_line             AS product_line,
    pn.prd_start_dt         AS start_date
-- Joins product information from the CRM with category data from the ERP.
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
-- Filter: Only includes products that are currently active or do not have an end date.
-- This ensures historical product data is excluded from the dimension.
WHERE pn.prd_end_dt IS NULL;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- Description: This fact table contains sales metrics and foreign keys that link
--           to the customer and product dimensions.
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    -- Foreign key: Joins to the dim_products to get the product_key.
    pr.product_key  AS product_key,
    -- Foreign key: Joins to the dim_customers to get the customer_key.
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
-- Retrieves sales data from the Silver layer.
FROM silver.crm_sales_details sd
-- Performs joins with the previously created dimension views to get the correct foreign keys.
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
