-- Olist_Analytics;

-- ============================================================
-- 10_SELLER_PERFORMANCE_ANALYSIS
-- ============================================================


-- Q1. How many unique sellers are present in the dataset?
SELECT
    COUNT(DISTINCT seller_id) AS Unique_Sellers
FROM sellers;


-- Q2. Which sellers have the highest number of orders?
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS Order_Count
FROM order_items
GROUP BY seller_id
ORDER BY Order_Count DESC;


-- Q3. Which sellers generate the highest revenue?
SELECT TOP 10
    seller_id,
    ROUND(SUM(price), 2) AS Total_Revenue
FROM order_items
GROUP BY seller_id
ORDER BY Total_Revenue DESC;


-- Q4. Which are the top 10 sellers based on revenue,
--     orders and items sold?
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS Order_Count,
    COUNT(*) AS Items_Sold,
    ROUND(SUM(price), 2) AS Total_Revenue
FROM order_items
GROUP BY seller_id
ORDER BY Total_Revenue DESC;


-- Q5. What is the average order value for each seller?
WITH SellerOrderValue AS
(
    SELECT
        seller_id,
        order_id,
        SUM(price) AS Order_Value
    FROM order_items
    GROUP BY
        seller_id,
        order_id
)
SELECT TOP 10
    seller_id,
    COUNT(*) AS Order_Count,
    ROUND(AVG(Order_Value), 2) AS Average_Order_Value
FROM SellerOrderValue
GROUP BY seller_id
ORDER BY Average_Order_Value DESC;


-- Q6. Which sellers have sold the highest number of items?
SELECT TOP 10
    seller_id,
    COUNT(*) AS Items_Sold
FROM order_items
GROUP BY seller_id
ORDER BY Items_Sold DESC;


-- Q7. Which sellers offer the highest number of unique products?
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT product_id) AS Unique_Products
FROM order_items
GROUP BY seller_id
ORDER BY Unique_Products DESC;


-- Q8. Which sellers have the highest average product price?
SELECT TOP 10
    seller_id,
    COUNT(*) AS Items_Sold,
    ROUND(AVG(price), 2) AS Average_Product_Price
FROM order_items
GROUP BY seller_id
HAVING COUNT(*) >= 10
ORDER BY Average_Product_Price DESC;


-- Q9. Which sellers have high order volume and high revenue?
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS Order_Count,
    COUNT(*) AS Items_Sold,
    ROUND(SUM(price), 2) AS Total_Revenue
FROM order_items
GROUP BY seller_id
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY Total_Revenue DESC;


-- Q10. Which sellers generate high revenue per order?
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS Order_Count,
    ROUND(SUM(price), 2) AS Total_Revenue,
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS Revenue_Per_Order
FROM order_items
GROUP BY seller_id
HAVING COUNT(DISTINCT order_id) >= 10
ORDER BY Revenue_Per_Order DESC;


-- Q11. Which sellers generate the highest freight value?
SELECT TOP 10
    seller_id,
    ROUND(SUM(freight_value), 2) AS Total_Freight_Value
FROM order_items
GROUP BY seller_id
ORDER BY Total_Freight_Value DESC;


-- Q12. What is the average freight value per order for each seller?
WITH SellerFreight AS
(
    SELECT
        seller_id,
        order_id,
        SUM(freight_value) AS Order_Freight
    FROM order_items
    GROUP BY
        seller_id,
        order_id
)
SELECT TOP 10
    seller_id,
    COUNT(*) AS Order_Count,
    ROUND(AVG(Order_Freight), 2) AS Average_Freight_Per_Order
FROM SellerFreight
GROUP BY seller_id
ORDER BY Average_Freight_Per_Order DESC;


-- Q13. Which sellers have the highest average review score?
SELECT TOP 10
    oi.seller_id,
    COUNT(DISTINCT r.review_id) AS Review_Count,
    ROUND(
        AVG(CAST(r.review_score AS DECIMAL(10,2))),
        2
    ) AS Average_Review_Score
FROM order_items oi
INNER JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT r.review_id) >= 20
ORDER BY Average_Review_Score DESC;


-- Q14. Which sellers have the lowest average review score?
SELECT TOP 10
    oi.seller_id,
    COUNT(DISTINCT r.review_id) AS Review_Count,
    ROUND(
        AVG(CAST(r.review_score AS DECIMAL(10,2))),
        2
    ) AS Average_Review_Score
FROM order_items oi
INNER JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT r.review_id) >= 20
ORDER BY Average_Review_Score ASC;


-- Q15. Which sellers receive the highest number of 1-star reviews?
SELECT TOP 10
    oi.seller_id,
    COUNT(DISTINCT r.review_id) AS One_Star_Reviews
FROM order_items oi
INNER JOIN order_reviews r
    ON oi.order_id = r.order_id
WHERE r.review_score = 1
GROUP BY oi.seller_id
ORDER BY One_Star_Reviews DESC;


-- Q16. What is the average delivery time for each seller?
SELECT TOP 10
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS Delivered_Orders,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_delivered_carrier_date,
                o.order_delivered_customer_date
            ) * 1.0
        ),
        2
    ) AS Average_Delivery_Days
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_carrier_date IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY Average_Delivery_Days ASC;


-- Q17. Which sellers have the longest average delivery time?
SELECT TOP 10
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS Delivered_Orders,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_delivered_carrier_date,
                o.order_delivered_customer_date
            ) * 1.0
        ),
        2
    ) AS Average_Delivery_Days
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_carrier_date IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY Average_Delivery_Days DESC;


-- Q18. What is the delivery rate for each seller?
WITH SellerOrders AS
(
    SELECT DISTINCT
        oi.seller_id,
        o.order_id,
        o.order_status
    FROM order_items oi
    INNER JOIN orders o
        ON oi.order_id = o.order_id
)
SELECT TOP 10
    seller_id,
    COUNT(*) AS Total_Orders,
    SUM(
        CASE
            WHEN order_status = 'delivered'
            THEN 1
            ELSE 0
        END
    ) AS Delivered_Orders,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'delivered'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Delivery_Rate
FROM SellerOrders
GROUP BY seller_id
HAVING COUNT(*) >= 20
ORDER BY Delivery_Rate DESC;


-- Q19. Which sellers have the highest cancellation rate?
WITH SellerOrders AS
(
    SELECT DISTINCT
        oi.seller_id,
        o.order_id,
        o.order_status
    FROM order_items oi
    INNER JOIN orders o
        ON oi.order_id = o.order_id
)
SELECT TOP 10
    seller_id,
    COUNT(*) AS Total_Orders,
    SUM(
        CASE
            WHEN order_status = 'canceled'
            THEN 1
            ELSE 0
        END
    ) AS Cancelled_Orders,
    ROUND(
        SUM(
            CASE
                WHEN order_status = 'canceled'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Cancellation_Rate
FROM SellerOrders
GROUP BY seller_id
HAVING COUNT(*) >= 20
ORDER BY Cancellation_Rate DESC;


-- Q20. Which sellers have strong sales but poor customer satisfaction?
WITH SellerSales AS
(
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS Order_Count,
        SUM(price) AS Total_Revenue
    FROM order_items
    GROUP BY seller_id
),
SellerReviews AS
(
    SELECT
        oi.seller_id,
        COUNT(DISTINCT r.review_id) AS Review_Count,
        AVG(
            CAST(r.review_score AS DECIMAL(10,2))
        ) AS Average_Review_Score
    FROM order_items oi
    INNER JOIN order_reviews r
        ON oi.order_id = r.order_id
    GROUP BY oi.seller_id
)
SELECT TOP 10
    s.seller_id,
    s.Order_Count,
    ROUND(s.Total_Revenue, 2) AS Total_Revenue,
    sr.Review_Count,
    ROUND(sr.Average_Review_Score, 2) AS Average_Review_Score
FROM SellerSales s
INNER JOIN SellerReviews sr
    ON s.seller_id = sr.seller_id
WHERE sr.Review_Count >= 20
ORDER BY
    s.Total_Revenue DESC,
    sr.Average_Review_Score ASC;


-- Q21. Which sellers have strong customer satisfaction but lower sales?
WITH SellerSales AS
(
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS Order_Count,
        SUM(price) AS Total_Revenue
    FROM order_items
    GROUP BY seller_id
),
SellerReviews AS
(
    SELECT
        oi.seller_id,
        COUNT(DISTINCT r.review_id) AS Review_Count,
        AVG(
            CAST(r.review_score AS DECIMAL(10,2))
        ) AS Average_Review_Score
    FROM order_items oi
    INNER JOIN order_reviews r
        ON oi.order_id = r.order_id
    GROUP BY oi.seller_id
)
SELECT TOP 10
    s.seller_id,
    s.Order_Count,
    ROUND(s.Total_Revenue, 2) AS Total_Revenue,
    sr.Review_Count,
    ROUND(sr.Average_Review_Score, 2) AS Average_Review_Score
FROM SellerSales s
INNER JOIN SellerReviews sr
    ON s.seller_id = sr.seller_id
WHERE sr.Review_Count >= 20
ORDER BY
    sr.Average_Review_Score DESC,
    s.Total_Revenue ASC;


-- Q22. What is the overall seller revenue?
WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS Total_Revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT
    COUNT(*) AS Total_Sellers,
    ROUND(SUM(Total_Revenue), 2) AS Total_Seller_Revenue,
    ROUND(AVG(Total_Revenue), 2) AS Average_Seller_Revenue
FROM SellerRevenue;


-- Q23. What percentage of revenue comes from the top 10 sellers?
WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS Total_Revenue
    FROM order_items
    GROUP BY seller_id
),
RankedSellers AS
(
    SELECT
        seller_id,
        Total_Revenue,
        ROW_NUMBER() OVER (
            ORDER BY Total_Revenue DESC
        ) AS Seller_Rank
    FROM SellerRevenue
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN Seller_Rank <= 10
                THEN Total_Revenue
                ELSE 0
            END
        ) * 100.0 /
        SUM(Total_Revenue),
        2
    ) AS Top_10_Seller_Revenue_Share
FROM RankedSellers;

-- Q24. How many sellers fall into each performance category?

WITH SellerSales AS
(
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS Order_Count,
        SUM(price) AS Total_Revenue
    FROM order_items
    GROUP BY seller_id
),
SellerReviews AS
(
    SELECT
        oi.seller_id,
        COUNT(DISTINCT r.review_id) AS Review_Count,
        AVG(CAST(r.review_score AS DECIMAL(10,2))) AS Average_Review_Score
    FROM order_items oi
    INNER JOIN order_reviews r
        ON oi.order_id = r.order_id
    GROUP BY oi.seller_id
),
SellerPerformance AS
(
    SELECT
        s.seller_id,
        CASE
            WHEN s.Total_Revenue >= 100000
                 AND sr.Average_Review_Score >= 4
                THEN 'High Performer'

            WHEN s.Total_Revenue >= 50000
                 AND sr.Average_Review_Score >= 3.5
                THEN 'Good Performer'

            WHEN sr.Average_Review_Score < 3
                THEN 'Needs Improvement'

            ELSE 'Average Performer'
        END AS Seller_Performance
    FROM SellerSales s
    LEFT JOIN SellerReviews sr
        ON s.seller_id = sr.seller_id
)
SELECT
    Seller_Performance,
    COUNT(*) AS Seller_Count
FROM SellerPerformance
GROUP BY Seller_Performance
ORDER BY Seller_Count DESC;
