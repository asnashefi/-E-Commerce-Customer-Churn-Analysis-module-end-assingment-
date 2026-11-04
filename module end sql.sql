use ecomm;

-- Data Cleaning --
-- WarehouseToHome
SET SQL_SAFE_UPDATES = 0;
UPDATE customer_churn
SET WarehouseToHome = ROUND(
    (SELECT AVG(WarehouseToHome)
     FROM (SELECT WarehouseToHome
           FROM customer_churn
           WHERE WarehouseToHome IS NOT NULL) AS temp)
)
WHERE WarehouseToHome IS NULL;

-- HourSpendOnApp
UPDATE customer_churn
SET HourSpendOnApp = ROUND(
    (SELECT AVG(HourSpendOnApp)
     FROM (SELECT HourSpendOnApp
           FROM  customer_churn
           WHERE HourSpendOnApp IS NOT NULL) AS temp)
)
WHERE HourSpendOnApp IS NULL;

-- OrderAmountHikeFromlastYear
UPDATE  customer_churn
SET OrderAmountHikeFromlastYear = ROUND(
    (SELECT AVG(OrderAmountHikeFromlastYear)
     FROM (SELECT OrderAmountHikeFromlastYear
           FROM  customer_churn
           WHERE OrderAmountHikeFromlastYear IS NOT NULL) AS temp)
)
WHERE OrderAmountHikeFromlastYear IS NULL;

-- DaySinceLastOrder
UPDATE  customer_churn
SET DaySinceLastOrder = ROUND(
    (SELECT AVG(DaySinceLastOrder)
     FROM (SELECT DaySinceLastOrder
           FROM  customer_churn
           WHERE DaySinceLastOrder IS NOT NULL) AS temp)
)
WHERE DaySinceLastOrder IS NULL;

select *from  customer_churn;

-- Mode of Tenure
SELECT Tenure, COUNT(*) AS Frequency
FROM customer_churn
GROUP BY Tenure
ORDER BY Frequency DESC
LIMIT 1;

-- Mode of CouponUsed
SELECT CouponUsed, COUNT(*) AS Frequency
FROM customer_churn
GROUP BY CouponUsed
ORDER BY Frequency DESC
LIMIT 1;

-- Mode of OrderCount
SELECT OrderCount, COUNT(*) AS Frequency
FROM customer_churn
GROUP BY OrderCount
ORDER BY Frequency DESC
LIMIT 1;

--- DELETING OUTLIAR-- 
DELETE FROM customer_churn
WHERE WarehouseToHome > 100;
 
 
 
          -- Dealing with Inconsistencies:
          
       -- 1.
       UPDATE customer_CHURN SET PreferredLoginDevice = "Mobile Phone" WHERE PreferredLoginDevice = "Phone";
          
          DESC customer_CHURN;
          SELECT * FROM customer_CHURN;

        -- 2.          
          UPDATE customer_CHURN SET PreferedOrderCat = "Mobile Phone" WHERE PreferedOrderCat = "Mobile";
          
           SELECT * FROM customer_CHURN;
           -- 3.
           
		 UPDATE customer_CHURN SET PreferredPaymentMode = "Cash on Delivery"  WHERE PreferredPaymentMode = "COD";
         select * from customer_churn;
         
         -- 4.
         UPDATE customer_churn SET PreferredPaymentMode = "Credit Card" WHERE PreferredPaymentMode = "CC";
          select * from customer_churn;
          
          
          -- DATA TRANSFORMATION--
          
          -- COLUMN RENAMING --
          
          -- 1.
          ALTER TABLE CUSTOMER_CHURN RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;
           desc customer_CHURN;
           
          -- 2. 
           ALTER TABLE CUSTOMER_CHURN RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;
           desc customer_CHURN;
           
           -- CREATE NEW COLUMN--
           -- 1.
             ALTER TABLE CUSTOMER_CHURN ADD COLUMN ComplaintReceived VARCHAR(3);
             
             UPDATE CUSTOMER_CHURN SET ComplaintReceived = CASE WHEN Complain = 1 THEN "Yes" ELSE "No"
             END;
             
             SELECT * from  Customer_churn;
             
             ALTER TABLE customer_churn ADD COLUMN ChurnStatus VARCHAR(10);
             
			UPDATE customer_churn SET ChurnStatus =case WHEN Churn = 1 THEN "Churned" ELSE "Active"
        END;
           SELECT * from  Customer_churn;
           
           
           -- DROPPING THE COLUMN --
           ALTER TABLE CUSTOMER_CHURN DROP COLUMN Churn, DROP COLUMN Complain;
           DESCRIBE CUSTOMER_CHURN;
           
           
           -- DATA EXPLORATION AND ANALYSIS --
           
           -- QUE 1?
                
                SELECT ChurnStatus, COUNT(*) AS Customer_Count FROM CUSTOMER_CHURN
                 GROUP BY ChurnStatus;
             
            -- QUE 2?
                 
	       SELECT AVG(Tenure) AS Average_Tenure,
           SUM(CashbackAmount) AS Total_Cashback_Amount
           FROM customer_churn WHERE ChurnStatus = "Churned";
     
            -- QUE 3?
            
            SELECT ROUND( (COUNT(CASE WHEN ComplaintReceived = "Yes" THEN 1 END) * 100.0)/ COUNT(*), 2)AS Complaint_Percentage
            FROM customer_churn WHERE ChurnStatus = "Churned";
            
            -- QUE 4?
            
              SELECT CityTier, COUNT(*) AS churned_cus_Count
              FROM customer_churn WHERE ChurnStatus = "Churned"
              AND PreferredOrderCat = "Laptop & Accessory"
               GROUP BY CityTier ORDER BY Churned_cus_count DESC
               LIMIT 1;
           
            -- QUE 5?
               
               
           -- que 5?
             
              SELECT PreferredPaymentMode,COUNT(*) AS Customer_Count FROM customer_churn
              WHERE ChurnStatus = "Active" GROUP BY PreferredPaymentMode ORDER BY Customer_Count DESC
               LIMIT 1;
               
			-- QUE 6?
            
              SELECT COUNT(*) AS Customer_Count,
              SUM(OrderAmountHikeFromlastYear) AS Total_Order_Amount_Hike
              FROM customer_churn WHERE MaritalStatus = "Single"
               AND PreferredOrderCat = "Mobile Phone";
               
			-- QUE 7?
            
               SELECT COUNT(*) AS UPI_Customers,
			 ROUND(AVG(NumberOfDeviceRegistered), 2) AS Average_Devices_Registered
             FROM customer_churn WHERE PreferredPaymentMode = "UPI";
             
		 -- QUE 8?
            
            SELECT CityTier,COUNT(*) AS Customer_Count FROM customer_churn
            GROUP BY CityTier ORDER BY Customer_Count DESC LIMIT 1;
            
		-- QUE 9?
            
            SELECT Gender, SUM(CouponUsed) AS Total_Coupons_Used FROM customer_churn
            GROUP BY Gender ORDER BY Total_Coupons_Used DESC LIMIT 1;
            
	   -- QUE 10?
           
           SELECT PreferredOrderCat,COUNT(*) AS Customer_Count,
           MAX(HoursSpentOnApp) AS Max_Hours_Spent_On_App
           FROM customer_churn GROUP BY PreferredOrderCat;
           
	   -- QUE 11?
       
           SELECT SUM(OrderCount) AS Total_Order_Count
            FROM customer_churn WHERE PreferredPaymentMode = "Credit Card"
             AND SatisfactionScore = (SELECT MAX(SatisfactionScore)
              FROM customer_churn);
              
		-- QUE 12?
            
            SELECT ROUND(AVG(SatisfactionScore), 2) AS Average_Satisfaction_Score
               FROM customer_churn WHERE ComplaintReceived = "Yes";
               
		 -- QUE 13?
            
             SELECT PreferredOrderCat,COUNT(*) AS Customer_Count
               FROM customer_churn  WHERE CouponUsed > 5
               GROUP BY PreferredOrderCat ORDER BY Customer_Count DESC;
               
		  -- QUE 14?
              
              SELECT PreferredOrderCat, ROUND(AVG(CashbackAmount), 2) AS Average_Cashback_Amount
              FROM customer_churn
               GROUP BY PreferredOrderCat ORDER BY Average_Cashback_Amount DESC
               LIMIT 3;
               
		  -- QUE 15?
          
                  SELECT PreferredPaymentMode,
               ROUND(AVG(Tenure), 2) AS Average_Tenure, COUNT(*) AS Customer_Count
                 FROM customer_churn
			WHERE OrderCount > 500 GROUP BY PreferredPaymentMode
             HAVING AVG(Tenure) = 10;
             
		  -- QUE 16?
            
            SELECT CASE
        WHEN WarehouseToHome <= 5 THEN "Very Close Distance"
        WHEN WarehouseToHome <= 10 THEN "Close Distance"
        WHEN WarehouseToHome <= 15 THEN "Moderate Distance"
        ELSE "Far Distance"
       END AS Distance_Category,ChurnStatus,
    COUNT(*) AS Customer_Count FROM customer_churn
      GROUP BY CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END,
    ChurnStatus ORDER BY Distance_Category, ChurnStatus;
    
    
       -- QUE 17?
       
           SELECT * FROM customer_churn WHERE MaritalStatus = "Married"
            AND CityTier = 1 AND OrderCount > (SELECT AVG(OrderCount)
            FROM customer_churn);
            
		
        -- QUE 18?
             USE ECOMM;
          create TABLE CUSTOMER_RETURNS ( ReturnID INT PRIMARY KEY,CustomerID INT,ReturnDate DATE,
    RefundAmount DECIMAL(10,2));
    
           INSERT INTO customer_returns(ReturnID, CustomerID, ReturnDate, RefundAmount)
              VALUES (1001, 50022, "2023-01-01", 2130),(1002, 50316, "2023-01-23", 2000),(1003, 51099, "2023-02-14", 2290),(1004, 52321, "2023-03-08", 2510),
            (1005, 52928, "2023-03-20", 3000),(1006, 53749, "2023-04-17", 1740),(1007, 54206, "2023-04-21", 3250),
             (1008, 54838, "2023-04-30", 1990);
             
             SELECT * FROM customer_RETURNS;
             select cr.*, customer_churn.*FROM customer_returns cr
              INNER JOIN customer_churn ON cr.CustomerID = customer_churn.CustomerID
              WHERE customer_churn.ChurnStatus = "Churned"AND customer_churn.ComplaintReceived = "Yes";

     
         