# Data Warehouse and Analytics Projects

This repository contains a hands-on data engineering project demonstrating the construction of a data warehouse on SQL Server using the **Medallion Architecture** (Bronze, Silver, and Gold layers). The project focuses on building a robust and scalable data pipeline from raw, fragmented source data into a clean, business-ready dataset optimized for analytics.

## Project Overview

The primary goal of this project is to transform raw data from disparate source systems (CRM and ERP) into a unified, structured, and trustworthy data warehouse. The process involves:
* **Extracting & Loading** raw data into a landing zone.
* **Cleansing & Validating** the data to ensure consistency and quality.
* **Transforming** the data into a star schema for efficient reporting and business intelligence.

## Medallion Architecture

The project is built on a three-tiered data architecture:

| Layer | Description | Key Activities |
| :--- | :--- | :--- |
| **Bronze** 🥉 | The raw data layer. Data is loaded as-is from source systems without any modifications. | Bulk loading, creating raw tables. |
| **Silver** 🥈 | The trusted data layer. Raw data is cleansed, filtered, and standardized to ensure quality. | Data cleansing, validation, enrichment, handling duplicates. |
| **Gold** 🥇 | The business-ready layer. Cleaned data is modeled into a star schema (fact and dimension tables) for business analytics. | Creating dimension tables, creating fact tables, data aggregation. |

## Project Structure

The repository is organized into a clear and logical structure:

- `init_database.sql`: A script to create the `DataWarehouse` database and the `bronze`, `silver`, and `gold` schemas.
- **Bronze Layer**:
    - `ddl_bronze.sql`: Defines the tables for the bronze layer.
    - `proc_load_bronze.sql`: A stored procedure to perform the bulk loading of raw data from CSV files into the bronze tables.
- **Silver Layer**:
    - `ddl_silver.sql`: Defines the tables for the silver layer.
    - `proc_load_silver.sql`: A stored procedure to perform transformations, cleansing, and loading of data from the bronze to the silver layer.
    - `quality_checks_silver.sql`: Scripts to run various data quality checks on the silver layer.
- **Gold Layer**:
    - `ddl_gold.sql`: Defines the views for the gold layer, including dimension (`dim_customers`, `dim_products`) and fact (`fact_sales`) tables.
    - `quality_checks_gold.sql`: Scripts to validate the uniqueness of keys and referential integrity in the gold layer.

## Key Features

- **Robust ETL/ELT Pipeline:** The project demonstrates a full data pipeline from raw ingestion to a final analytical model.
- **Data Cleansing & Standardization:** Code includes specific techniques for handling inconsistent data types, normalizing values, and managing missing data.
- **Data Quality & Validation:** Comprehensive SQL scripts are included to perform quality checks at both the silver and gold layers, ensuring data integrity.
- **Star Schema Modeling:** The project showcases the best practice of modeling data into a star schema, a key concept for effective data warehousing.

## How to Run the Project

1.  Clone this repository to your local machine.
2.  Open SQL Server Management Studio (SSMS).
3.  Run the scripts in the following order:
    1.  `init_database.sql` (to create the database and schemas).
    2.  `ddl_bronze.sql` (to create the bronze tables).
    3.  `proc_load_bronze.sql` (to load the raw data).
    4.  `ddl_silver.sql` (to create the silver tables).
    5.  `proc_load_silver.sql` (to transform and load data to the silver layer).
    6.  `ddl_gold.sql` (to create the gold layer views).
    7.  (`quality_checks_silver.sql` and `quality_checks_gold.sql` can be run at any time to validate the data).

## Acknowledgements

This project was developed by following the excellent tutorial and instructions provided by **Data with Bara**.
A big thank you for the detailed and hands-on guidance in building this data warehouse from scratch.

* **Video:** [SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project](https://www.youtube.com/watch?v=9GVqKuTVANE)
* **Channel:** [Data with Bara](https://www.youtube.com/@DataWithBaraa)
