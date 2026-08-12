---Olist_Analytics---

-- =========================================================
-- ORDER ANALYSIS
-- =========================================================


-- Q1. How many total orders were placed?
SELECT
    COUNT(*) AS Total_Orders
FROM orders;


-- Q2. How many unique customers placed orders?
SELECT
    COUNT(DISTINCT customer_id) AS Unique_Customers
FROM orders;


-- Q3. What is the distribution of orders by status?
SELECT
    order_status,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY order_status
ORDER BY Order_Count DESC;


-- Q4. What percentage of orders were delivered?
SELECT
    ROUND(
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS Delivered_Percentage
FROM orders;


-- Q5. What percentage of orders were cancelled?
SELECT
    ROUND(
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS Cancelled_Percentage
FROM orders;


-- Q6. Which year had the highest number of orders?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Count DESC;


-- Q7. What is the monthly order trend?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;


-- Q8. Which month had the highest number of orders?
SELECT TOP 1
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY Order_Count DESC;


-- Q9. How many orders were delivered each year?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(*) AS Delivered_Orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;


-- Q10. How many orders were cancelled each year?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    COUNT(*) AS Cancelled_Orders
FROM orders
WHERE order_status = 'canceled'
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;


-- Q11. What is the order status distribution by year?
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    order_status,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    order_status
ORDER BY
    Order_Year,
    Order_Count DESC;


-- Q12. How many orders were placed by each day of the week?
SELECT
    DATENAME(WEEKDAY, order_purchase_timestamp) AS Day_Name,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY DATENAME(WEEKDAY, order_purchase_timestamp)
ORDER BY Order_Count DESC;


-- Q13. How many orders were placed in each hour?
SELECT
    DATEPART(HOUR, order_purchase_timestamp) AS Order_Hour,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY DATEPART(HOUR, order_purchase_timestamp)
ORDER BY Order_Count DESC;


-- Q14. What is the average time between order purchase and delivery?
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) * 1.0
        ), 2
    ) AS Average_Delivery_Days
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- Q15. What is the average estimated delivery time?
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                order_purchase_timestamp,
                order_estimated_delivery_date
            ) * 1.0
        ), 2
    ) AS Average_Estimated_Delivery_Days
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL;


-- Q16. How many orders were delivered later than the estimated date?
SELECT
    COUNT(*) AS Late_Delivered_Orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;


-- Q17. What percentage of delivered orders were late?
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1
            END
        ) * 100.0
        / COUNT(*), 2
    ) AS Late_Delivery_Percentage
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- Q18. What is the yearly growth in number of orders?
WITH YearlyOrders AS
(
    SELECT
        YEAR(order_purchase_timestamp) AS Order_Year,
        COUNT(*) AS Order_Count
    FROM orders
    GROUP BY YEAR(order_purchase_timestamp)
)
SELECT
    Order_Year,
    Order_Count,
    LAG(Order_Count) OVER (ORDER BY Order_Year) AS Previous_Year_Orders,
    ROUND(
        (Order_Count - LAG(Order_Count) OVER (ORDER BY Order_Year))
        * 100.0
        / NULLIF(LAG(Order_Count) OVER (ORDER BY Order_Year), 0),
        2
    ) AS YoY_Growth_Percentage
FROM YearlyOrders
ORDER BY Order_Year;