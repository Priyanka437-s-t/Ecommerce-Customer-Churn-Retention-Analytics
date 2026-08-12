-- Olist_Analytics;

-- =========================================================
-- 08_COHORT_ANALYSIS
-- =========================================================


-- Q1. How many customers were acquired in each month?
WITH CustomerFirstPurchase AS
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
    MONTH(First_Purchase_Date) AS Acquisition_Month,
    COUNT(*) AS New_Customers
FROM CustomerFirstPurchase
GROUP BY
    YEAR(First_Purchase_Date),
    MONTH(First_Purchase_Date)
ORDER BY
    Acquisition_Year,
    Acquisition_Month;


-- Q2. How many customers belong to each acquisition cohort?
WITH CustomerFirstPurchase AS
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
    FORMAT(First_Purchase_Date, 'yyyy-MM') AS Cohort_Month,
    COUNT(*) AS Cohort_Customers
FROM CustomerFirstPurchase
GROUP BY
    FORMAT(First_Purchase_Date, 'yyyy-MM')
ORDER BY
    Cohort_Month;


-- Q3. How many customers made another purchase after their first purchase?
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


-- Q4. What percentage of each cohort became repeat customers?
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
CustomerOrders AS
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
    MONTH(f.First_Purchase_Date) AS Acquisition_Month,
    COUNT(*) AS Total_Customers,
    SUM(
        CASE
            WHEN o.Order_Count >= 2 THEN 1
            ELSE 0
        END
    ) AS Repeat_Customers,
    ROUND(
        SUM(
            CASE
                WHEN o.Order_Count >= 2 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate
FROM CustomerFirstPurchase f
INNER JOIN CustomerOrders o
    ON f.customer_unique_id = o.customer_unique_id
GROUP BY
    YEAR(f.First_Purchase_Date),
    MONTH(f.First_Purchase_Date)
ORDER BY
    Acquisition_Year,
    Acquisition_Month;


-- Q5. How many customers made purchases in each calendar month?
WITH CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    Purchase_Month,
    COUNT(DISTINCT customer_unique_id) AS Active_Customers
FROM CustomerPurchases
GROUP BY Purchase_Month
ORDER BY Purchase_Month;


-- Q6. What is the monthly repeat purchase rate?
WITH CustomerMonthlyOrders AS
(
    SELECT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        )
)
SELECT
    Purchase_Month,
    COUNT(*) AS Active_Customers,
    COUNT(
        CASE
            WHEN Order_Count >= 2 THEN 1
        END
    ) AS Customers_With_Multiple_Orders,
    ROUND(
        COUNT(
            CASE
                WHEN Order_Count >= 2 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Monthly_Repeat_Rate
FROM CustomerMonthlyOrders
GROUP BY Purchase_Month
ORDER BY Purchase_Month;


-- Q7. How many customers returned in the month after their first purchase?
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
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
),
FirstPurchaseMonth AS
(
    SELECT
        customer_unique_id,
        DATEFROMPARTS(
            YEAR(First_Purchase_Date),
            MONTH(First_Purchase_Date),
            1
        ) AS Cohort_Month
    FROM CustomerFirstPurchase
)
SELECT
    f.Cohort_Month,
    COUNT(DISTINCT f.customer_unique_id) AS Cohort_Customers,
    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 1
            THEN f.customer_unique_id
        END
    ) AS Month_1_Returning_Customers
FROM FirstPurchaseMonth f
LEFT JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id
GROUP BY f.Cohort_Month
ORDER BY f.Cohort_Month;


-- Q8. What is the month-1 retention rate for each cohort?
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
FirstPurchaseMonth AS
(
    SELECT
        customer_unique_id,
        DATEFROMPARTS(
            YEAR(First_Purchase_Date),
            MONTH(First_Purchase_Date),
            1
        ) AS Cohort_Month
    FROM CustomerFirstPurchase
),
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    f.Cohort_Month,
    COUNT(DISTINCT f.customer_unique_id) AS Cohort_Customers,
    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 1
            THEN f.customer_unique_id
        END
    ) AS Month_1_Returning_Customers,
    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 1
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_1_Retention_Rate
FROM FirstPurchaseMonth f
LEFT JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id
GROUP BY f.Cohort_Month
ORDER BY f.Cohort_Month;


-- Q9. What is the month-3 retention rate for each cohort?
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
FirstPurchaseMonth AS
(
    SELECT
        customer_unique_id,
        DATEFROMPARTS(
            YEAR(First_Purchase_Date),
            MONTH(First_Purchase_Date),
            1
        ) AS Cohort_Month
    FROM CustomerFirstPurchase
),
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    f.Cohort_Month,
    COUNT(DISTINCT f.customer_unique_id) AS Cohort_Customers,
    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 3
            THEN f.customer_unique_id
        END
    ) AS Month_3_Returning_Customers,
    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 3
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_3_Retention_Rate
FROM FirstPurchaseMonth f
LEFT JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id
GROUP BY f.Cohort_Month
ORDER BY f.Cohort_Month;


-- Q10. What is the month-6 retention rate for each cohort?
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
FirstPurchaseMonth AS
(
    SELECT
        customer_unique_id,
        DATEFROMPARTS(
            YEAR(First_Purchase_Date),
            MONTH(First_Purchase_Date),
            1
        ) AS Cohort_Month
    FROM CustomerFirstPurchase
),
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    f.Cohort_Month,
    COUNT(DISTINCT f.customer_unique_id) AS Cohort_Customers,
    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 6
            THEN f.customer_unique_id
        END
    ) AS Month_6_Returning_Customers,
    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 6
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_6_Retention_Rate
FROM FirstPurchaseMonth f
LEFT JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id
GROUP BY f.Cohort_Month
ORDER BY f.Cohort_Month;


-- Q11. What is the overall retention rate after 1, 3 and 6 months?
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
FirstPurchaseMonth AS
(
    SELECT
        customer_unique_id,
        DATEFROMPARTS(
            YEAR(First_Purchase_Date),
            MONTH(First_Purchase_Date),
            1
        ) AS Cohort_Month
    FROM CustomerFirstPurchase
),
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    COUNT(DISTINCT f.customer_unique_id) AS Total_Customers,

    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 1
            THEN f.customer_unique_id
        END
    ) AS Month_1_Returning_Customers,

    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 3
            THEN f.customer_unique_id
        END
    ) AS Month_3_Returning_Customers,

    COUNT(
        DISTINCT
        CASE
            WHEN DATEDIFF(
                MONTH,
                f.Cohort_Month,
                p.Purchase_Month
            ) = 6
            THEN f.customer_unique_id
        END
    ) AS Month_6_Returning_Customers,

    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 1
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_1_Retention_Rate,

    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 3
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_3_Retention_Rate,

    ROUND(
        COUNT(
            DISTINCT
            CASE
                WHEN DATEDIFF(
                    MONTH,
                    f.Cohort_Month,
                    p.Purchase_Month
                ) = 6
                THEN f.customer_unique_id
            END
        ) * 100.0
        / COUNT(DISTINCT f.customer_unique_id),
        2
    ) AS Month_6_Retention_Rate
FROM FirstPurchaseMonth f
LEFT JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id;


-- Q12. Which acquisition cohorts have the highest repeat customer rate?
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
CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT TOP 10
    FORMAT(f.First_Purchase_Date, 'yyyy-MM') AS Cohort_Month,
    COUNT(*) AS Total_Customers,
    SUM(
        CASE
            WHEN o.Order_Count >= 2 THEN 1
            ELSE 0
        END
    ) AS Repeat_Customers,
    ROUND(
        SUM(
            CASE
                WHEN o.Order_Count >= 2 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate
FROM CustomerFirstPurchase f
INNER JOIN CustomerOrders o
    ON f.customer_unique_id = o.customer_unique_id
GROUP BY
    FORMAT(f.First_Purchase_Date, 'yyyy-MM')
ORDER BY Repeat_Customer_Rate DESC;


-- Q13. Which acquisition cohorts have the lowest repeat customer rate?
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
CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS Order_Count
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT TOP 10
    FORMAT(f.First_Purchase_Date, 'yyyy-MM') AS Cohort_Month,
    COUNT(*) AS Total_Customers,
    SUM(
        CASE
            WHEN o.Order_Count >= 2 THEN 1
            ELSE 0
        END
    ) AS Repeat_Customers,
    ROUND(
        SUM(
            CASE
                WHEN o.Order_Count >= 2 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate
FROM CustomerFirstPurchase f
INNER JOIN CustomerOrders o
    ON f.customer_unique_id = o.customer_unique_id
GROUP BY
    FORMAT(f.First_Purchase_Date, 'yyyy-MM')
ORDER BY Repeat_Customer_Rate ASC;


-- Q14. What is the number of active customers by cohort month?
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
CustomerPurchases AS
(
    SELECT DISTINCT
        c.customer_unique_id,
        DATEFROMPARTS(
            YEAR(o.order_purchase_timestamp),
            MONTH(o.order_purchase_timestamp),
            1
        ) AS Purchase_Month
    FROM orders o
    INNER JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT
    FORMAT(f.First_Purchase_Date, 'yyyy-MM') AS Cohort_Month,
    COUNT(DISTINCT p.customer_unique_id) AS Active_Customers
FROM CustomerFirstPurchase f
INNER JOIN CustomerPurchases p
    ON f.customer_unique_id = p.customer_unique_id
GROUP BY
    FORMAT(f.First_Purchase_Date, 'yyyy-MM')
ORDER BY
    Cohort_Month;