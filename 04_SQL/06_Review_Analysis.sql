-- Olist_Analytics;

-- =========================================================
-- 06_REVIEW_ANALYSIS
-- =========================================================


-- Q1. How many reviews are recorded?
SELECT
    COUNT(*) AS Total_Reviews
FROM order_reviews;


-- Q2. What is the average review score?
SELECT
    ROUND(AVG(review_score * 1.0), 2) AS Average_Review_Score
FROM order_reviews;


-- Q3. What is the distribution of review scores?
SELECT
    review_score,
    COUNT(*) AS Review_Count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- Q4. What percentage of reviews belong to each score?
SELECT
    review_score,
    COUNT(*) AS Review_Count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_reviews),
        2
    ) AS Review_Percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- Q5. How many reviews were given for each year?
SELECT
    YEAR(review_creation_date) AS Review_Year,
    COUNT(*) AS Review_Count
FROM order_reviews
WHERE review_creation_date IS NOT NULL
GROUP BY YEAR(review_creation_date)
ORDER BY Review_Year;


-- Q6. What is the average review score by year?
SELECT
    YEAR(review_creation_date) AS Review_Year,
    ROUND(AVG(review_score * 1.0), 2) AS Average_Review_Score
FROM order_reviews
WHERE review_creation_date IS NOT NULL
GROUP BY YEAR(review_creation_date)
ORDER BY Review_Year;


-- Q7. Which product categories have the highest average review scores?
SELECT TOP 10
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ) AS Product_Category,
    ROUND(AVG(r.review_score * 1.0), 2) AS Average_Review_Score,
    COUNT(*) AS Review_Count
FROM order_reviews r
INNER JOIN order_items oi
    ON r.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    )
HAVING COUNT(*) >= 50
ORDER BY Average_Review_Score DESC;


-- Q8. Which product categories have the lowest average review scores?
SELECT TOP 10
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ) AS Product_Category,
    ROUND(AVG(r.review_score * 1.0), 2) AS Average_Review_Score,
    COUNT(*) AS Review_Count
FROM order_reviews r
INNER JOIN order_items oi
    ON r.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    )
HAVING COUNT(*) >= 50
ORDER BY Average_Review_Score ASC;


-- Q9. Which product categories receive the most reviews?
SELECT TOP 10
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ) AS Product_Category,
    COUNT(*) AS Review_Count,
    ROUND(AVG(r.review_score * 1.0), 2) AS Average_Review_Score
FROM order_reviews r
INNER JOIN order_items oi
    ON r.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    )
ORDER BY Review_Count DESC;


-- Q10. How many reviews have a written comment?
SELECT
    COUNT(
        CASE
            WHEN review_comment_message IS NOT NULL
             AND LTRIM(RTRIM(review_comment_message)) <> ''
            THEN 1
        END
    ) AS Reviews_With_Comments
FROM order_reviews;


-- Q11. What percentage of reviews contain written comments?
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN review_comment_message IS NOT NULL
                 AND LTRIM(RTRIM(review_comment_message)) <> ''
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Reviews_With_Comments_Percentage
FROM order_reviews;


-- Q12. How many reviews have a review title?
SELECT
    COUNT(
        CASE
            WHEN review_comment_title IS NOT NULL
             AND LTRIM(RTRIM(review_comment_title)) <> ''
            THEN 1
        END
    ) AS Reviews_With_Titles
FROM order_reviews;


-- Q13. What is the average review score for reviews with comments
--      versus reviews without comments?
SELECT
    CASE
        WHEN review_comment_message IS NOT NULL
         AND LTRIM(RTRIM(review_comment_message)) <> ''
        THEN 'With Comment'
        ELSE 'Without Comment'
    END AS Comment_Status,
    COUNT(*) AS Review_Count,
    ROUND(AVG(review_score * 1.0), 2) AS Average_Review_Score
FROM order_reviews
GROUP BY
    CASE
        WHEN review_comment_message IS NOT NULL
         AND LTRIM(RTRIM(review_comment_message)) <> ''
        THEN 'With Comment'
        ELSE 'Without Comment'
    END;


-- Q14. What is the average review score by order status?
SELECT
    o.order_status,
    COUNT(r.review_id) AS Review_Count,
    ROUND(AVG(r.review_score * 1.0), 2) AS Average_Review_Score
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY o.order_status
ORDER BY Average_Review_Score DESC;


-- Q15. What is the average review score for delivered orders?
SELECT
    ROUND(AVG(r.review_score * 1.0), 2) AS Delivered_Order_Average_Review_Score
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';


-- Q16. What is the average delivery time for each review score?
SELECT
    r.review_score,
    COUNT(*) AS Review_Count,
    ROUND(
        AVG(
            DATEDIFF(
                DAY,
                o.order_purchase_timestamp,
                o.order_delivered_customer_date
            ) * 1.0
        ),
        2
    ) AS Average_Delivery_Days
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score DESC;


-- Q17. How many low-rated reviews were given?
-- Low rating = 1 or 2 stars
SELECT
    COUNT(*) AS Low_Rated_Reviews
FROM order_reviews
WHERE review_score IN (1, 2);


-- Q18. What percentage of reviews are low-rated?
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN review_score IN (1, 2)
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Low_Rating_Percentage
FROM order_reviews;


-- Q19. How many high-rated reviews were given?
-- High rating = 4 or 5 stars
SELECT
    COUNT(*) AS High_Rated_Reviews
FROM order_reviews
WHERE review_score IN (4, 5);


-- Q20. What percentage of reviews are high-rated?
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN review_score IN (4, 5)
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS High_Rating_Percentage
FROM order_reviews;


-- Q21. What is the average review score by delivery performance?
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
        ELSE 'Unknown'
    END AS Delivery_Performance,
    COUNT(*) AS Review_Count,
    ROUND(AVG(r.review_score * 1.0), 2) AS Average_Review_Score
FROM orders o
INNER JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
        ELSE 'Unknown'
    END
ORDER BY Average_Review_Score DESC;