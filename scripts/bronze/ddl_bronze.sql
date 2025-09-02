/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script is designed for data warehouse setup. It defines and creates all
    necessary tables within the 'bronze' schema. This schema serves as the
    landing zone for raw, unvalidated data from various source systems (CRM, ERP, etc.).

Key Features:
    - **Idempotent Script:** The `IF OBJECT_ID...DROP TABLE` statements ensure the
      script can be run multiple times without causing errors. It safely drops
      existing tables before recreating them with the defined structure.
    - **Clear Data Typing:** Each table defines the columns with appropriate data types
      to match the raw CSV data, such as `INT`, `NVARCHAR`, and `DATE`.
    - **Schema Organization:** All tables are created within the 'bronze' schema,
      promoting a structured and organized database environment.

Usage:
    This script should be executed as a preliminary step before running data
    loading procedures, such as `bronze.load_bronze`. It ensures the target
    tables exist with the correct schema to receive data.
===============================================================================
*/

-- =============================================================================
-- CRM Tables
-- =============================================================================

-- CRM Customer Info Table
-- This table stores raw customer data directly from the CRM source system.
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);
GO

-- CRM Product Info Table
-- This table holds raw product details from the CRM source system.
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

-- CRM Sales Details Table
-- This table captures raw sales transaction data from the CRM source system.
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num    NVARCHAR(50),
    sls_prd_key    NVARCHAR(50),
    sls_cust_id    INT,
    sls_order_dt   INT,
    sls_ship_dt    INT,
    sls_due_dt     INT,
    sls_sales      INT,
    sls_quantity   INT,
    sls_price      INT
);
GO

-- =============================================================================
-- ERP Tables
-- =============================================================================

-- ERP Location Table (LOC A101)
-- This table contains raw location data from a specific ERP source system.
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- ERP Customer Table (CUST AZ12)
-- This table stores raw customer data from the ERP source system.
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- ERP Product Category Table (PX CAT G1V2)
-- This table holds raw product category information from the ERP source system.
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO
