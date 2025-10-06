use ecomm;
show tables;
describe customer_churn;
select * from customer_churn;

-- Data Cleaning
-- Handling Missing Values and Outliers

-- Find the mean of WarehouseToHome
SELECT ROUND(AVG(WarehouseToHome), 0) AS mean_value
FROM customer_churn;

SET SQL_SAFE_UPDATES = 0;

-- Replace NULL values with the mean
UPDATE customer_churn
SET WarehouseToHome = (
    SELECT ROUND(AVG(WarehouseToHome), 0)
    FROM (SELECT WarehouseToHome FROM customer_churn) AS t
)
WHERE WarehouseToHome IS NULL;

-- Find the mean of HourSpendOnApp
SELECT ROUND(AVG(HourSpendOnApp), 0) AS mean_value
FROM customer_churn;


-- Replace NULL values with the mean
UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT ROUND(AVG(HourSpendOnApp), 0)
    FROM (SELECT HourSpendOnApp FROM customer_churn) AS t
)
WHERE HourSpendOnApp IS NULL;

-- Find the mean of OrderAmountHikeFromlastYear
SELECT ROUND(AVG(OrderAmountHikeFromlastYear), 0) AS mean_value
FROM customer_churn;


-- Replace NULL values with the mean
UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
    SELECT ROUND(AVG(OrderAmountHikeFromlastYear), 0)
    FROM (SELECT OrderAmountHikeFromlastYear FROM customer_churn) AS t
)
WHERE OrderAmountHikeFromlastYear IS NULL;

-- Find the mean of DaySinceLastOrder
SELECT ROUND(AVG(DaySinceLastOrder), 0) AS mean_value
FROM customer_churn;


-- Replace NULL values with the mean
UPDATE customer_churn
SET DaySinceLastOrder = (
    SELECT ROUND(AVG(DaySinceLastOrder), 0)
    FROM (SELECT DaySinceLastOrder FROM customer_churn) AS t
)
WHERE DaySinceLastOrder IS NULL;

-- mode imputation
-- Step 1: Find the mode of Tenure
SELECT Tenure
FROM customer_churn
GROUP BY Tenure
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Step 2: Replace NULL values with the mode 
UPDATE customer_churn
SET Tenure = 1
WHERE Tenure IS NULL;

-- Step 1: Find the mode of CouponUsed
SELECT CouponUsed
FROM customer_churn
GROUP BY CouponUsed
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Step 2: Replace NULL values with the mode 
UPDATE customer_churn
SET CouponUsed = 1
WHERE CouponUsed IS NULL;

-- Step 1: Find the mode of OrderCount
SELECT OrderCount
FROM customer_churn
GROUP BY OrderCount
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Step 2: Replace NULL values with the mode 
UPDATE customer_churn
SET OrderCount = 2
WHERE OrderCount IS NULL;

-- Outlier detection 
-- using z-score

WITH stats AS (
    SELECT AVG(WarehouseToHome) AS mean_val,
           STDDEV_SAMP(WarehouseToHome) AS std_val
    FROM customer_churn
)
SELECT c.WarehouseToHome,
       (c.WarehouseToHome - s.mean_val) / s.std_val AS z_score
FROM customer_churn c
CROSS JOIN stats s
WHERE ABS((c.WarehouseToHome - s.mean_val) / s.std_val) > 3;

-- handling ouliers by deleting

SET @mean := (SELECT AVG(WarehouseToHome) FROM customer_churn);
SET @std := (SELECT STDDEV(WarehouseToHome) FROM customer_churn);

DELETE FROM customer_churn
WHERE ABS((WarehouseToHome - @mean)/@std) > 3;

-- handling inconsistency
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

-- Data Transformation
-- column Renaming
-- Rename "PreferedOrderCat" to "PreferredOrderCat"
ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

-- Rename "HourSpendOnApp" to "HoursSpentOnApp"
ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

-- column creating
ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);

UPDATE customer_churn
SET ComplaintReceived = CASE 
                           WHEN Complain = 1 THEN 'Yes' 
                           ELSE 'No' 
                         END;
                         
ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(10);

UPDATE customer_churn
SET ChurnStatus = CASE 
                     WHEN Churn = 1 THEN 'Churned' 
                     ELSE 'Active' 
                   END;


-- Dropping column
ALTER TABLE customer_churn
DROP COLUMN Complain;

ALTER TABLE customer_churn
DROP COLUMN Churn;

DESCRIBE customer_churn;

-- Data Exploration and Analysis

-- Count of churned and active customers
SELECT 
    ChurnStatus,
    COUNT(*) AS customer_count
FROM customer_churn
GROUP BY ChurnStatus;

-- Average tenure and total cashback of churned customers
SELECT 
    ROUND(AVG(Tenure), 2) AS avg_tenure,
    SUM(CashbackAmount) AS total_cashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- Percentage of churned customers who complained
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN ComplaintReceived = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS perc_complained
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- City tier with highest number of churned customers whose preferred order category is Laptop & Accessory
SELECT 
    CityTier,
    COUNT(*) AS churned_count
FROM customer_churn
WHERE ChurnStatus = 'Churned'
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY churned_count DESC
LIMIT 1;

-- Most preferred payment mode among active customers
SELECT PreferredPaymentMode, COUNT(*) AS count_customers
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY count_customers DESC
LIMIT 1;

-- Total order amount hike from last year for single customers who prefer mobile phones
SELECT SUM(OrderAmountHikeFromlastYear) AS total_hike
FROM customer_churn
WHERE MaritalStatus = 'Single'
  AND PreferredOrderCat = 'Mobile Phone';
  
-- Average number of devices registered among customers using UPI
SELECT ROUND(AVG(NumberOfDeviceRegistered), 2) AS avg_devices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

-- City tier with the highest number of customers
SELECT CityTier, COUNT(*) AS total_customers
FROM customer_churn
GROUP BY CityTier
ORDER BY total_customers DESC
LIMIT 1;

-- Gender that utilized the highest number of coupons
SELECT Gender, SUM(CouponUsed) AS total_coupons
FROM customer_churn
GROUP BY Gender
ORDER BY total_coupons DESC
LIMIT 1;

-- Number of customers and maximum hours spent on the app per preferred order category
SELECT PreferredOrderCat, 
       COUNT(*) AS num_customers,
       MAX(HoursSpentOnApp) AS max_hours
FROM customer_churn
GROUP BY PreferredOrderCat;

-- Total order count for customers using credit cards with maximum satisfaction
SELECT SUM(OrderCount) AS total_orders
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);
  
-- Average satisfaction score of customers who complained
SELECT ROUND(AVG(SatisfactionScore), 2) AS avg_satisfaction
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

-- Preferred order category among customers who used more than 5 coupons
SELECT PreferredOrderCat, COUNT(*) AS num_customers
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat;

-- Top 3 preferred order categories with highest average cashback
SELECT PreferredOrderCat, ROUND(AVG(CashbackAmount), 2) AS avg_cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY avg_cashback DESC
LIMIT 3;

-- Preferred payment modes of customers with average tenure = 10 months and orders > 500
SELECT PreferredPaymentMode, COUNT(*) AS num_customers
FROM customer_churn
WHERE Tenure = 10
  AND OrderCount > 500
GROUP BY PreferredPaymentMode;

-- Distance categories and churn breakdown
SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS num_customers
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus
ORDER BY DistanceCategory;

-- order details of Customers married, in City Tier-1, with orders above average
SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn);
  

-- Create customer_returns table
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2)
);

-- Insert the data
INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

-- return details along with customer details for churned customers who made complaints
SELECT cr.ReturnID,
       cr.CustomerID,
       cr.ReturnDate,
       cr.RefundAmount,
       cc.ChurnStatus,
       cc.ComplaintReceived,
       cc.PreferredOrderCat,
       cc.PreferredPaymentMode
FROM customer_returns cr
JOIN customer_churn cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes';
  
-- Total Refund Amount for Churned Customers with Complaints
SELECT SUM(cr.RefundAmount) AS TotalRefundAmount
FROM customer_returns cr
JOIN customer_churn cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes';
  
-- grouped by each customer
SELECT cr.CustomerID,
       SUM(cr.RefundAmount) AS TotalRefundAmount
FROM customer_returns cr
JOIN customer_churn cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes'
GROUP BY cr.CustomerID;



  




















                         
                         










    
    
    




