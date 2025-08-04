-- Creating a Database

CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;

-- Creagting table

CREATE TABLE RawSales (
    `Row ID` INT,
    `Order ID` VARCHAR(20),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(20),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(50),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal Code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(200),
    `Sales` DECIMAL(10,2),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(10,2)
);

-- Cleaning a table 

CREATE TABLE CleanedSales AS
SELECT 
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    `Ship Mode`,
    `Customer ID`,
    `Customer Name`,
    `Segment`,
    `Region`,
    `Category`,
    `Sub-Category`,
    `Product Name`,
    `Sales`,
    `Quantity`,
    `Discount`,
    `Profit`
FROM RawSales
WHERE `Order Date` IS NOT NULL
  AND `Sales` > 0
  AND `Profit` IS NOT NULL;
  
  
-- Daily sales table
CREATE TABLE DailySales AS
SELECT 
    `Order Date` AS order_day,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM CleanedSales
GROUP BY `Order Date`
ORDER BY `Order Date`;

-- -- Sales by Region and Segment
CREATE VIEW RegionSegmentSales AS
SELECT 
    Region,
    Segment,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM CleanedSales
GROUP BY Region, Segment;

-- Sales by Category and Sub-Category
CREATE VIEW CategorySales AS
SELECT 
    Category,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT `Product Name`) AS unique_products
FROM CleanedSales
GROUP BY Category, `Sub-Category`;

-- 
### Profitability vs. Discount Analysis

CREATE VIEW DiscountImpact AS
SELECT 
    `Sub-Category`,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(*) AS order_count
FROM CleanedSales
GROUP BY `Sub-Category`;

### KPI 
CREATE VIEW KPIs AS
SELECT
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(AVG(Quantity), 2) AS avg_quantity
FROM CleanedSales;

