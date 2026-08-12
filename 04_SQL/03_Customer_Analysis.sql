-- Olist_Analytics;

-- =========================================================
-- 03_CUSTOMER_ANALYSIS
-- Customer-level analysis using customer_unique_id
-- =========================================================


-- Q1. How many unique customers are in the dataset?
SELECT
    COUNT(DISTINCT customer_unique_id) AS Unique_Customers
FROM customers;


-- Q2. How many customer records exist?
SELECT
    COUNT(DISTINCT customer_id) AS Customer_Records
FROM customers;


-- Q3. How many customers placed more than one order?
SELECT
    COUNT(*) AS Repeat_Customers
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS CustomerOrders;


-- Q4. How many customers placed only one order?
SELECT
    COUNT(*) AS One_Time_Customers
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) = 1
) AS CustomerOrders;


-- Q5. How many orders did each unique customer place?
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY Total_Orders DESC;


-- Q6. Which customers placed the highest number of orders?
SELECT TOP 10
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY Total_Orders DESC;


-- Q7. What percentage of customers are repeat customers?
WITH CustomerOrderCounts AS
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
        COUNT(CASE WHEN Order_Count > 1 THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Percentage
FROM CustomerOrderCounts;


-- Q8. What percentage of customers are one-time customers?
WITH CustomerOrderCounts AS
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
        COUNT(CASE WHEN Order_Count = 1 THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS One_Time_Customer_Percentage
FROM CustomerOrderCounts;


-- Q9. How many customers placed 1, 2, 3, etc. orders?
WITH CustomerOrderCounts AS
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
    Order_Count,
    COUNT(*) AS Customer_Count
FROM CustomerOrderCounts
GROUP BY Order_Count
ORDER BY Order_Count;


-- Q10. What is the average number of orders per unique customer?
SELECT
    ROUND(
        COUNT(DISTINCT o.order_id) * 1.0
        / COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS Average_Orders_Per_Customer
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id;


-- Q11. What is each customer's first purchase date?
SELECT
    c.customer_unique_id,
    MIN(o.order_purchase_timestamp) AS First_Purchase_Date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY First_Purchase_Date;


-- Q12. What is each customer's most recent purchase date?
SELECT
    c.customer_unique_id,
    MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY Last_Purchase_Date;


-- Q13. What is the average customer purchase lifetime?
WITH CustomerPurchaseDates AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS First_Purchase_Date,
        MAX(o.order_purchase_timestamp) AS Last_Purchase_Date
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
                First_Purchase_Date,
                Last_Purchase_Date
            ) * 1.0
        ),
        2
    ) AS Average_Customer_Lifetime_Days
FROM CustomerPurchaseDates
WHERE First_Purchase_Date <> Last_Purchase_Date;


-- Q14. How many unique customers purchased in each year?
SELECT
    YEAR(o.order_purchase_timestamp) AS Purchase_Year,
    COUNT(DISTINCT c.customer_unique_id) AS Unique_Customers
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY Purchase_Year;


-- Q15. How many new unique customers were acquired each year?
WITH FirstPurchase AS
(
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS First_Purchase_Date
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    YEAR(First_Purchase_Date) AS Acquisition_Year,
    COUNT(*) AS New_Customers
FROM FirstPurchase
GROUP BY YEAR(First_Purchase_Date)
ORDER BY Acquisition_Year;


-- Q16. Which customers have been inactive for the longest period?
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
SELECT TOP 20
    customer_unique_id,
    Last_Purchase_Date
FROM CustomerLastPurchase
ORDER BY Last_Purchase_Date;


-- Q17. What percentage of orders came from repeat customers?
WITH CustomerOrderCounts AS
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
        SUM(
            CASE
                WHEN Order_Count > 1
                THEN Order_Count
                ELSE 0
            END
        ) * 100.0
        / SUM(Order_Count),
        2
    ) AS Orders_From_Repeat_Customers_Percentage
FROM CustomerOrderCounts;


-- Q18. Which customers placed exactly 2 orders?
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) = 2
ORDER BY c.customer_unique_id;


-- Q19. Which customers placed 3 or more orders?
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS Total_Orders
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) >= 3
ORDER BY Total_Orders DESC;


-- Q20. What is the customer purchase-frequency segmentation?
WITH CustomerOrderCounts AS
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
    CASE
        WHEN Order_Count = 1 THEN 'One-Time Customer'
        WHEN Order_Count = 2 THEN 'Repeat Customer'
        WHEN Order_Count >= 3 THEN 'Loyal Customer'
    END AS Customer_Segment,
    COUNT(*) AS Customer_Count
FROM CustomerOrderCounts
GROUP BY
    CASE
        WHEN Order_Count = 1 THEN 'One-Time Customer'
        WHEN Order_Count = 2 THEN 'Repeat Customer'
        WHEN Order_Count >= 3 THEN 'Loyal Customer'
    END
ORDER BY Customer_Count DESC;