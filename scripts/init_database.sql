/*
=============================================================
Create Database and Schemas (PostgreSQL Version)
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Connect to the default 'postgres' database first, then run this:

-- Drop and recreate the 'DataWarehouseAnalytics' database
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = 'DataWarehouseAnalytics') THEN
        -- Disconnect all users from the database
        PERFORM pg_terminate_backend(pg_stat_activity.pid)
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = 'DataWarehouseAnalytics';
        
        DROP DATABASE DataWarehouseAnalytics;
    END IF;
    
    CREATE DATABASE DataWarehouseAnalytics
    WITH OWNER = postgres
    ENCODING = 'UTF8';
END $$;

-- Now connect to the new 'DataWarehouseAnalytics' database and run the following:

-- Create Schema
CREATE SCHEMA IF NOT EXISTS gold;

-- Create Tables
CREATE TABLE gold.dim_customers(
    customer_key int,
    customer_id int,
    customer_number varchar(50),
    first_name varchar(50),
    last_name varchar(50),
    country varchar(50),
    marital_status varchar(50),
    gender varchar(50),
    birthdate date,
    create_date date
);

CREATE TABLE gold.dim_products(
    product_key int,
    product_id int,
    product_number varchar(50),
    product_name varchar(50),
    category_id varchar(50),
    category varchar(50),
    subcategory varchar(50),
    maintenance varchar(50),
    cost int,
    product_line varchar(50),
    start_date date
);

CREATE TABLE gold.fact_sales(
    order_number varchar(50),
    product_key int,
    customer_key int,
    order_date date,
    shipping_date date,
    due_date date,
    sales_amount int,
    quantity smallint,  -- PostgreSQL uses smallint instead of tinyint
    price int
);

-- Truncate tables (not really needed as they're newly created)
TRUNCATE TABLE gold.dim_customers;
TRUNCATE TABLE gold.dim_products;
TRUNCATE TABLE gold.fact_sales;

-- Import data using COPY command (run these commands one by one in psql or pgAdmin)
-- Note: You need to use the full path to your CSV files
/*
COPY gold.dim_customers FROM 'C:/sql/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv' WITH CSV HEADER DELIMITER ',';
COPY gold.dim_products FROM 'C:/sql/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv' WITH CSV HEADER DELIMITER ',';
COPY gold.fact_sales FROM 'C:/sql/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv' WITH CSV HEADER DELIMITER ',';
*/
