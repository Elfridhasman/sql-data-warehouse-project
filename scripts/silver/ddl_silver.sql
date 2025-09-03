/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script defines the schema for the 'silver' layer of the data warehouse.
    The silver layer serves as the "trusted" data layer where raw data from the
    bronze layer has been cleaned, validated, and enriched.

Key Features:
    - **Idempotent Script:** Uses `IF OBJECT_ID...DROP TABLE` to ensure the script
      can be safely executed multiple times without errors.
    - **Data Cleansing & Standardization:** Reflects data type corrections and
      preparations for further use (e.g., converting dates from INT to DATE).
    - **Data Lineage:** Includes a `dwh_create_date` column in every table
      to track when the record was loaded into the data warehouse.

Usage:
    This script should be run after the bronze tables have been created and before
    any data transformation or loading into the silver layer begins.
===============================================================================
*/

-- =============================================================================
-- CRM Tables (Cleaned & Standardized)
-- =============================================================================

-- Silver CRM Customer Info Table
-- This table contains cleaned customer data from the CRM system.
-- A dwh_create_date column is added for data lineage.
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO

-- Silver CRM Product Info Table
-- This table stores cleaned product details from the CRM system.
-- The prd_start_dt and prd_end_dt columns are corrected to DATE data type.
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id            INT,
    cat_id            NVARCHAR(50),
    prd_key           NVARCHAR(50),
    prd_nm            NVARCHAR(50),
    prd_cost          INT,
    prd_line          NVARCHAR(50),
    prd_start_dt      DATE,
    prd_end_dt        DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Silver CRM Sales Details Table
-- This table holds validated sales transaction data.
-- Date columns (sls_order_dt, sls_ship_dt, sls_due_dt) are converted to DATE type.
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num    NVARCHAR(50),
    sls_prd_key    NVARCHAR(50),
    sls_cust_id    INT,
    sls_order_dt   DATE,
    sls_ship_dt    DATE,
    sls_due_dt     DATE,
    sls_sales      INT,
    sls_quantity   INT,
    sls_price      INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================================================
-- ERP Tables (Cleaned & Standardized)
-- =============================================================================

-- Silver ERP Location Table (LOC A101)
-- This table contains cleaned location data from the ERP source.
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid           NVARCHAR(50),
    cntry         NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Silver ERP Customer Table (CUST AZ12)
-- This table holds validated customer data from the ERP source.
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid           NVARCHAR(50),
    bdate         DATE,
    gen           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Silver ERP Product Category Table (PX CAT G1V2)
-- This table contains cleaned product category data from the ERP source.
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id            NVARCHAR(50),
    cat           NVARCHAR(50),
    subcat        NVARCHAR(50),
    maintenance   NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
