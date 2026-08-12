-- Olist_Analytics;

-- =========================================================
-- 05_PAYMENT_ANALYSIS
-- =========================================================


-- Q1. What is the total payment value?
SELECT
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value
FROM order_payments;


-- Q2. How many payment transactions are recorded?
SELECT
    COUNT(*) AS Total_Payment_Transactions
FROM order_payments;


-- Q3. How many unique orders have payment records?
SELECT
    COUNT(DISTINCT order_id) AS Orders_With_Payment
FROM order_payments;


-- Q4. What are the different payment methods used by customers?
SELECT
    payment_type,
    COUNT(*) AS Payment_Transaction_Count
FROM order_payments
GROUP BY payment_type
ORDER BY Payment_Transaction_Count DESC;


-- Q5. How many orders used each payment method?
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS Order_Count
FROM order_payments
GROUP BY payment_type
ORDER BY Order_Count DESC;


-- Q6. What is the total payment value by payment method?
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value
FROM order_payments
GROUP BY payment_type
ORDER BY Total_Payment_Value DESC;


-- Q7. What is the average payment value by payment method?
SELECT
    payment_type,
    ROUND(AVG(payment_value), 2) AS Average_Payment_Value
FROM order_payments
GROUP BY payment_type
ORDER BY Average_Payment_Value DESC;


-- Q8. What percentage of total payment value comes from each payment method?
SELECT
    payment_type,
    ROUND(
        SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value)
         FROM order_payments),
        2
    ) AS Payment_Value_Percentage
FROM order_payments
GROUP BY payment_type
ORDER BY Payment_Value_Percentage DESC;


-- Q9. What is the average number of payment installments by payment method?
SELECT
    payment_type,
    ROUND(AVG(payment_installments * 1.0), 2) AS Average_Installments
FROM order_payments
GROUP BY payment_type
ORDER BY Average_Installments DESC;


-- Q10. What is the maximum number of installments used for each payment method?
SELECT
    payment_type,
    MAX(payment_installments) AS Maximum_Installments
FROM order_payments
GROUP BY payment_type
ORDER BY Maximum_Installments DESC;


-- Q11. What is the highest individual payment value?
SELECT TOP 10
    order_id,
    payment_type,
    payment_value
FROM order_payments
ORDER BY payment_value DESC;


-- Q12. What is the average payment value across all transactions?
SELECT
    ROUND(AVG(payment_value), 2) AS Average_Payment_Value
FROM order_payments;


-- Q13. What is the total payment value by number of installments?
SELECT
    payment_installments,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;


-- Q14. Which payment method is used for the highest number of orders?
SELECT TOP 1
    payment_type,
    COUNT(DISTINCT order_id) AS Order_Count
FROM order_payments
GROUP BY payment_type
ORDER BY Order_Count DESC;


-- Q15. Which payment method generates the highest total payment value?
SELECT TOP 1
    payment_type,
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value
FROM order_payments
GROUP BY payment_type
ORDER BY Total_Payment_Value DESC;


-- Q16. How many orders used more than one payment transaction?
SELECT
    COUNT(*) AS Orders_With_Multiple_Payment_Transactions
FROM
(
    SELECT
        order_id,
        COUNT(*) AS Payment_Transaction_Count
    FROM order_payments
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS MultiplePayments;


-- Q17. What percentage of orders used multiple payment transactions?
SELECT
    ROUND(
        COUNT(
            CASE
                WHEN Payment_Transaction_Count > 1 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Multiple_Payment_Order_Percentage
FROM
(
    SELECT
        order_id,
        COUNT(*) AS Payment_Transaction_Count
    FROM order_payments
    GROUP BY order_id
) AS OrderPayments;