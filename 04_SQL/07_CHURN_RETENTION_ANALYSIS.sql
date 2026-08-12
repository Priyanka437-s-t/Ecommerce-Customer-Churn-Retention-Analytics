-- Olist_Analytics;

-- =========================================================
-- 07_CHURN_RETENTION_ANALYSIS
-- =========================================================


-- Q1. What is the last purchase date in the dataset?
SELECT
    MAX(order_purchase_timestamp) AS Last_Purchase_Date
FROM orders;


-- Q2. What is the first purchase date in the dataset?
SELECT
    MIN(order_purchase_timestamp) AS First_Purchase_Date
FROM orders;


-- Q3. How many unique customers have purchased?
SELECT
    COUNT(DISTINCT c.customer_unique_id) AS Unique_Customers
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;


-- Q4. How many one-time customers are there?
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS One_Time_Customers
FROM CustomerOrders
WHERE Order_Count = 1;


-- Q5. How many repeat customers are there?
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Repeat_Customers
FROM CustomerOrders
WHERE Order_Count >= 2;


-- Q6. What is the repeat customer rate?
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN Order_Count >= 2 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate
FROM CustomerOrders;


-- Q7. What is the average number of orders per customer?
SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) * 1.0
        / COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS Average_Orders_Per_Customer
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;


-- Q8. What is the last purchase date for each customer?
SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY Last_Purchase_Date;


-- Q9. What is the first purchase date for each customer?
SELECT
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS First_Purchase_Date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY First_Purchase_Date;


-- Q10. What is the number of days since each customer's last purchase?
WITH CustomerLastPurchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    Last_Purchase_Date,
    DATEDIFF(
        DAY,
        Last_Purchase_Date,
        (SELECT MAX(order_purchase_timestamp) FROM orders)
    ) AS Days_Since_Last_Purchase
FROM CustomerLastPurchase
ORDER BY Days_Since_Last_Purchase DESC;


-- Q11. How many customers are inactive for more than 180 days?
WITH CustomerLastPurchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Inactive_180_Days
FROM CustomerLastPurchase
WHERE DATEDIFF(
    DAY,
    Last_Purchase_Date,
    (SELECT MAX(order_purchase_timestamp) FROM orders)
) > 180;


-- Q12. What percentage of customers are inactive for more than 180 days?

WITH CustomerLastPurchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
CustomerInactivity AS
(
    SELECT
        customer_unique_id,
        DATEDIFF(
            DAY,
            Last_Purchase_Date,
            (
                SELECT MAX(order_purchase_timestamp)
                FROM orders
            )
        ) AS Days_Since_Last_Purchase
    FROM CustomerLastPurchase
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN Days_Since_Last_Purchase > 180
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Churn_Risk_Percentage
FROM CustomerInactivity;
                   

-- Q13. How many customers are inactive for more than 90 days?
WITH CustomerLastPurchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Inactive_90_Days
FROM CustomerLastPurchase
WHERE DATEDIFF(
    DAY,
    Last_Purchase_Date,
    (SELECT MAX(order_purchase_timestamp) FROM orders)
) > 90;


-- Q14. How many customers are inactive for more than 365 days?
WITH CustomerLastPurchase AS
(
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Inactive_365_Days
FROM CustomerLastPurchase
WHERE DATEDIFF(
    DAY,
    Last_Purchase_Date,
    (SELECT MAX(order_purchase_timestamp) FROM orders)
) > 365;


-- Q15. What is the customer retention rate?
-- Retained customers = customers with 2 or more orders
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN Order_Count >= 2 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Customer_Retention_Rate
FROM CustomerOrders;


-- Q16. What percentage of customers made only one purchase?
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN Order_Count = 1 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS One_Time_Customer_Rate
FROM CustomerOrders;

-- Q17. How many customers made 2, 3, 4, 5+ purchases?

WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
PurchaseFrequency AS
(
    SELECT
        CASE
            WHEN Order_Count >= 5 THEN '5+ Orders'
            ELSE CAST(Order_Count AS VARCHAR(10))
        END AS Purchase_Frequency,
        CASE
            WHEN Order_Count >= 5 THEN 5
            ELSE Order_Count
        END AS Sort_Order
    FROM CustomerOrders
)
SELECT
    Purchase_Frequency,
    COUNT(*) AS Customer_Count
FROM PurchaseFrequency
GROUP BY
    Purchase_Frequency,
    Sort_Order
ORDER BY
    Sort_Order;


-- Q18. What is the average time between first and last purchase
-- for customers who purchased more than once?
WITH CustomerPurchaseDates AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MIN(o.order_purchase_timestamp) AS First_Purchase,
        MAX(o.order_purchase_timestamp) AS Last_Purchase
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                First_Purchase,
                Last_Purchase
            ) * 1.0
        ),
        2
    ) AS Average_Retention_Period_Days
FROM CustomerPurchaseDates
WHERE Order_Count >= 2;


-- Q19. How many customers returned within 30 days?
WITH CustomerPurchaseDates AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MIN(o.order_purchase_timestamp) AS First_Purchase,
        MAX(o.order_purchase_timestamp) AS Last_Purchase
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Returned_Within_30_Days
FROM CustomerPurchaseDates
WHERE Order_Count >= 2
AND DATEDIFF(
    DAY,
    First_Purchase,
    Last_Purchase
) <= 30;


-- Q20. How many customers returned within 90 days?
WITH CustomerPurchaseDates AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MIN(o.order_purchase_timestamp) AS First_Purchase,
        MAX(o.order_purchase_timestamp) AS Last_Purchase
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Returned_Within_90_Days
FROM CustomerPurchaseDates
WHERE Order_Count >= 2
AND DATEDIFF(
    DAY,
    First_Purchase,
    Last_Purchase
) <= 90;


-- Q21. How many customers returned within 180 days?
WITH CustomerPurchaseDates AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MIN(o.order_purchase_timestamp) AS First_Purchase,
        MAX(o.order_purchase_timestamp) AS Last_Purchase
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS Customers_Returned_Within_180_Days
FROM CustomerPurchaseDates
WHERE Order_Count >= 2
AND DATEDIFF(
    DAY,
    First_Purchase,
    Last_Purchase
) <= 180;


-- Q22. What is the retention rate by customer acquisition year?
WITH CustomerFirstPurchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS First_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
CustomerOrderCounts AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    YEAR(f.First_Purchase_Date) AS Acquisition_Year,
    COUNT(*) AS Total_Customers,
    COUNT(
        CASE
            WHEN o.Order_Count >= 2 THEN 1
        END
    ) AS Repeat_Customers,
    ROUND(
        COUNT(
            CASE
                WHEN o.Order_Count >= 2 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Retention_Rate
FROM CustomerFirstPurchase f
INNER JOIN CustomerOrderCounts o
    ON f.customer_unique_id = o.customer_unique_id
GROUP BY YEAR(f.First_Purchase_Date)
ORDER BY Acquisition_Year;


-- Q23. What are the customer retention/churn segments?

WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
CustomerStatus AS
(
    SELECT
        customer_unique_id,
        CASE
            WHEN Order_Count = 1
                THEN 'One-Time Customer'

            WHEN Order_Count >= 2
             AND DATEDIFF(
                    DAY,
                    Last_Purchase_Date,
                    (SELECT MAX(order_purchase_timestamp) FROM orders)
                 ) <= 180
                THEN 'Retained Customer'

            WHEN Order_Count >= 2
             AND DATEDIFF(
                    DAY,
                    Last_Purchase_Date,
                    (SELECT MAX(order_purchase_timestamp) FROM orders)
                 ) > 180
                THEN 'Churned Repeat Customer'
        END AS Customer_Status
    FROM CustomerOrders
)
SELECT
    Customer_Status,
    COUNT(*) AS Customer_Count
FROM CustomerStatus
GROUP BY Customer_Status
ORDER BY Customer_Status;

-- Q24. Identify customers with the highest churn risk.
WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT TOP 20
    customer_unique_id,
    Order_Count,
    Last_Purchase_Date,
    DATEDIFF(
        DAY,
        Last_Purchase_Date,
        (SELECT MAX(order_purchase_timestamp) FROM orders)
    ) AS Days_Since_Last_Purchase
FROM CustomerOrders
WHERE Order_Count >= 2
AND DATEDIFF(
    DAY,
    Last_Purchase_Date,
    (SELECT MAX(order_purchase_timestamp) FROM orders)
) > 180
ORDER BY Days_Since_Last_Purchase DESC;