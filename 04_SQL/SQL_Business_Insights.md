# Olist E-Commerce Analytics — Business Insights from SQL Analysis

## 1. Data Validation Insights

The data validation analysis confirmed the structure, consistency, duplicates, missing values, and relationships across the major Olist datasets.

The analysis established a reliable foundation for customer, order, product, payment, review, cohort, and seller-level analysis.

**Business implication:**
Reliable data quality is essential because incorrect customer, order, or product relationships can lead to misleading revenue, retention, and performance metrics.

---

## 2. Order Analysis Insights

The order analysis shows that the business has a large customer and order base, with the majority of orders successfully reaching the delivered stage.

However, a smaller portion of orders falls into cancelled, unavailable, processing, or other non-delivered statuses.

**Business implications:**

* Order fulfillment is a major contributor to overall customer experience.
* Cancelled and unavailable orders represent potential lost revenue and customer dissatisfaction.
* Monitoring order status trends can help identify operational problems early.
* Delivery and fulfillment performance should be monitored together with customer reviews.

**Recommendation:**
Create an operational monitoring dashboard that tracks order status, cancellation, delivery performance, and customer satisfaction.

---

## 3. Customer Analysis Insights

The customer analysis identified a highly concentrated customer base.

The segmentation results showed:

* **93,099 one-time customers**
* **2,948 repeat customers**
* **49 loyal customers**

This means approximately **96.88% of customers are one-time customers**, while only **3.07% are repeat customers** and **0.05% are classified as loyal customers**.

This is one of the strongest business findings from the analysis.

**Business implication:**
The company is much stronger at **acquiring customers than retaining them**.

A large one-time customer base represents a significant opportunity. Converting even a small percentage of these customers into repeat buyers could substantially increase revenue without requiring equivalent new-customer acquisition.

**Recommendation:**

* Introduce personalized post-purchase campaigns.
* Provide category-specific recommendations.
* Offer incentives for second purchases.
* Identify customers who have not purchased recently and run reactivation campaigns.

---

## 4. Product Analysis Insights

The product analysis showed that product demand and revenue are concentrated among certain categories.

Among the analyzed categories:

* **beleza_saude** generated approximately **R$1.26M revenue**.
* **relogios_presentes** generated approximately **R$1.21M**.
* **cama_mesa_banho** generated approximately **R$1.04M**.
* **esporte_lazer** generated approximately **R$0.99M**.
* **informatica_acessorios** generated approximately **R$0.91M**.

This indicates that a relatively small group of categories contributes a significant portion of sales.

The analysis also identified high-value categories such as **pcs**, which had an average product price of approximately **R$1,098**.

**Business implication:**
Different categories contribute to the business in different ways. Some categories drive **volume**, while others drive **high transaction value**.

**Recommendation:**

* Maintain strong inventory availability for high-performing categories.
* Promote high-margin/high-value categories strategically.
* Use customer purchase history for cross-selling.
* Investigate low-performing categories before increasing inventory.

---

## 5. Payment Analysis Insights

Payment analysis should be used to understand how customers prefer to complete purchases and whether payment behavior is associated with order value.

The analysis can help identify:

* Dominant payment methods.
* Payment methods generating the highest transaction value.
* Customer preference for installments.
* Potential opportunities to improve payment convenience.

**Business implication:**
Payment flexibility can influence conversion, especially for higher-value purchases.

**Recommendation:**

* Maintain strong support for the most-used payment methods.
* Encourage suitable installment options for higher-value purchases.
* Monitor payment failures and abandoned transactions.
* Compare payment methods with customer retention and average order value.

---

## 6. Review Analysis Insights

Review analysis provides an important connection between **customer experience and operational performance**.

The seller analysis showed substantial differences in average review scores. Some sellers achieved scores above **4.8**, while several sellers had scores close to or below **3.0**.

The analysis also identified sellers receiving large numbers of one-star reviews.

**Business implication:**
Customer satisfaction is not uniform across the marketplace. Seller-level service quality can directly affect the customer experience and potentially future purchases.

**Recommendation:**

* Identify sellers with consistently low review scores.
* Investigate whether poor reviews are associated with delivery delays, product quality, or seller fulfillment.
* Recognize high-performing sellers.
* Create improvement programs for sellers with repeated negative feedback.

---

## 7. Churn & Retention Analysis Insights

Customer retention is one of the biggest challenges identified by the SQL analysis.

The overall retention results were:

| Retention Period | Returning Customers | Retention Rate |
| ---------------- | ------------------: | -------------: |
| Month 1          |                 461 |          0.48% |
| Month 3          |                 202 |          0.21% |
| Month 6          |                 133 |          0.14% |

The retention rate declines as the customer relationship progresses.

**Business implication:**
The company acquires a large number of customers, but very few customers continue purchasing.

This indicates a potential **customer retention problem rather than a pure customer acquisition problem**.

**Recommendation:**

* Focus heavily on the first 30 days after the first purchase.
* Send personalized recommendations shortly after delivery.
* Provide incentives for the second purchase.
* Build customer segments based on purchase behavior.
* Reactivate customers before they become inactive for long periods.

---

## 8. Cohort Analysis Insights

The cohort analysis shows that customer retention varies significantly between acquisition cohorts.

Some cohorts demonstrate stronger Month-1 retention than others, while later retention generally decreases substantially.

For example, several cohorts have Month-3 retention below **0.5%**, and Month-6 retention is generally even lower.

**Business implication:**
Customer acquisition alone does not guarantee long-term customer value.

Different acquisition periods may have different customer quality, marketing effectiveness, product availability, or customer experience.

**Recommendation:**

* Compare cohorts by acquisition period.
* Identify cohorts with relatively stronger retention.
* Investigate what products, channels, or experiences were associated with stronger cohorts.
* Replicate successful acquisition and engagement strategies.

---

## 9. Product & Customer Value Analysis Insights

The customer value analysis revealed a very important revenue concentration.

The customer segments generated approximately:

| Segment  | Customers |  Revenue |
| -------- | --------: | -------: |
| One-Time |    92,507 | R$12.83M |
| Repeat   |     2,865 |  R$0.73M |
| Loyal    |        48 | R$31.39K |

Repeat customers have a lower customer count but demonstrate higher purchasing frequency.

Loyal customers averaged approximately **4.96 orders per customer**, compared with approximately **2.07 orders for repeat customers** and **1 order for one-time customers**.

**Business implication:**
Customer frequency has a strong relationship with customer value.

The small repeat and loyal customer groups represent an important opportunity for increasing customer lifetime value.

**Recommendation:**

* Move one-time customers toward their second purchase.
* Move repeat customers toward loyal behavior.
* Use personalized product recommendations.
* Create loyalty benefits based on purchase frequency.
* Focus retention campaigns on customers with high previous spending.

---

## 10. Seller Performance Analysis Insights

The seller analysis identified **3,095 sellers** with total seller revenue of approximately **R$13.59M**.

Seller performance was segmented as:

| Performance       | Sellers |
| ----------------- | ------: |
| Average Performer |   2,714 |
| Needs Improvement |     342 |
| Good Performer    |      27 |
| High Performer    |      12 |

The analysis also revealed substantial differences between sellers in:

* Order volume
* Revenue
* Average order value
* Product variety
* Freight cost
* Review score
* Delivery time
* Cancellation rate

For example, some sellers had average delivery times above **20 days**, while the fastest sellers in the analyzed results averaged around **3 days**.

**Business implication:**
Seller performance is highly variable, meaning marketplace customer experience depends heavily on which seller fulfills an order.

**Recommendation:**

* Monitor seller KPIs continuously.
* Investigate sellers with long delivery times.
* Identify sellers with high cancellation rates.
* Improve performance of the 342 sellers classified as needing improvement.
* Reward high-performing sellers.
* Use seller quality metrics when designing marketplace policies.

---

# Overall Business Conclusion

The SQL analysis indicates that the biggest strategic opportunity for the business is **customer retention**.

The company has a large customer base and strong transaction activity, but only a small proportion of customers become repeat or loyal customers.

At the same time, product demand is concentrated in certain categories and seller performance varies considerably across the marketplace.

Therefore, the business should focus on four major priorities:

### 1. Improve Customer Retention

Convert one-time customers into repeat customers through personalized offers, recommendations, and post-purchase engagement.

### 2. Improve Customer Experience

Reduce delivery delays, cancellations, and poor seller performance because these factors can negatively affect customer satisfaction.

### 3. Optimize Product Strategy

Prioritize high-performing categories while identifying opportunities to improve low-performing products.

### 4. Strengthen Seller Management

Reward high-performing sellers and create improvement programs for sellers with poor delivery, cancellation, or review performance.

## Key Business Story

**The business has successfully acquired a large customer base, but the major opportunity is converting those customers into repeat buyers. Improving retention, customer experience, product recommendations, and seller quality can increase customer lifetime value and sustainable revenue without relying entirely on acquiring new customers.**
