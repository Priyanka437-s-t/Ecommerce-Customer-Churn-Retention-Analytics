-- Olist_Analytics;

-- =========================================================
-- 04_PRODUCT_ANALYSIS
-- =========================================================


-- Q1. How many unique products are available?
SELECT
    COUNT(DISTINCT product_id) AS Unique_Products
FROM products;


-- Q2. How many products are available in each category?
SELECT
    product_category_name,
    COUNT(DISTINCT product_id) AS Product_Count
FROM products
GROUP BY product_category_name
ORDER BY Product_Count DESC;


-- Q3. Which product categories contain the most products?
SELECT TOP 10
    product_category_name,
    COUNT(DISTINCT product_id) AS Product_Count
FROM products
GROUP BY product_category_name
ORDER BY Product_Count DESC;


-- Q4. Which product categories contain the fewest products?
SELECT TOP 10
    product_category_name,
    COUNT(DISTINCT product_id) AS Product_Count
FROM products
GROUP BY product_category_name
ORDER BY Product_Count ASC;


-- Q5. How many products have been sold?
SELECT
    COUNT(DISTINCT product_id) AS Sold_Products
FROM order_items;


-- Q6. Which products have been ordered the most?
SELECT TOP 10
    product_id,
    COUNT(*) AS Order_Item_Count
FROM order_items
GROUP BY product_id
ORDER BY Order_Item_Count DESC;


-- Q7. Which product categories have the highest order volume?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    COUNT(*) AS Order_Item_Count
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Order_Item_Count DESC;


-- Q8. Which product categories generate the highest revenue?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    ROUND(SUM(oi.price), 2) AS Total_Revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Total_Revenue DESC;


-- Q9. Which products generate the highest revenue?
SELECT TOP 10
    oi.product_id,
    ROUND(SUM(oi.price), 2) AS Total_Revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY Total_Revenue DESC;


-- Q10. What is the average selling price by product category?
SELECT
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    ROUND(AVG(oi.price), 2) AS Average_Selling_Price
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Average_Selling_Price DESC;


-- Q11. Which product categories have the highest average selling price?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    ROUND(AVG(oi.price), 2) AS Average_Selling_Price
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Average_Selling_Price DESC;


-- Q12. Which product categories have the lowest average selling price?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    ROUND(AVG(oi.price), 2) AS Average_Selling_Price
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Average_Selling_Price ASC;


-- Q13. Which products have the highest average selling price?
SELECT TOP 10
    product_id,
    ROUND(AVG(price), 2) AS Average_Selling_Price
FROM order_items
GROUP BY product_id
ORDER BY Average_Selling_Price DESC;


-- Q14. Which product categories have the highest number of unique products sold?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    COUNT(DISTINCT oi.product_id) AS Unique_Products_Sold
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Unique_Products_Sold DESC;


-- Q15. What is the monthly product sales trend?
SELECT
    YEAR(o.order_purchase_timestamp) AS Sales_Year,
    MONTH(o.order_purchase_timestamp) AS Sales_Month,
    COUNT(DISTINCT oi.order_id) AS Orders,
    COUNT(*) AS Items_Sold,
    ROUND(SUM(oi.price), 2) AS Revenue
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Sales_Year,
    Sales_Month;


-- Q16. Which products have generated revenue from the highest number of orders?
SELECT TOP 10
    product_id,
    COUNT(DISTINCT order_id) AS Number_Of_Orders,
    ROUND(SUM(price), 2) AS Total_Revenue
FROM order_items
GROUP BY product_id
ORDER BY Number_Of_Orders DESC;


-- Q17. Which product categories generate the highest revenue per order item?
SELECT TOP 10
    COALESCE(t.product_category_name_english,
             p.product_category_name) AS Product_Category,
    COUNT(*) AS Order_Items,
    ROUND(SUM(oi.price), 2) AS Total_Revenue,
    ROUND(AVG(oi.price), 2) AS Revenue_Per_Item
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(t.product_category_name_english,
             p.product_category_name)
ORDER BY Revenue_Per_Item DESC;


-- Q18. What percentage of products have never been sold?
SELECT
    ROUND(
        COUNT(CASE WHEN oi.product_id IS NULL THEN 1 END)
        * 100.0 / COUNT(*),
        2
    ) AS Unsold_Product_Percentage
FROM products p
LEFT JOIN
(
    SELECT DISTINCT product_id
    FROM order_items
) oi
    ON p.product_id = oi.product_id;


-- Q19. How many products have never been sold?
SELECT
    COUNT(*) AS Unsold_Product_Count
FROM products p
LEFT JOIN
(
    SELECT DISTINCT product_id
    FROM order_items
) oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- Q20. What is the overall product revenue?
SELECT
    ROUND(SUM(price), 2) AS Total_Product_Revenue
FROM order_items;