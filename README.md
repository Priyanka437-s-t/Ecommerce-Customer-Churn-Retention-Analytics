# Olist E-Commerce Analytics

## 📌 Project Overview

This project is an end-to-end **E-Commerce Data Analytics project** based on the Brazilian Olist e-commerce dataset.

The objective is to analyze sales performance, customer behavior, product performance, seller performance, order status, payment methods, and delivery performance using **Excel, SQL, Python, and Power BI**.

The project follows a complete analytics workflow from **data preparation and exploratory analysis to dashboard development and business recommendations**.

---

## 🎯 Business Problem

An e-commerce business generates large amounts of data across customers, orders, products, sellers, payments, reviews, and delivery operations.

The business needs to understand:

* How sales are performing
* Which product categories and products generate the most revenue
* How customers behave after their first purchase
* How sellers perform
* Which payment methods customers prefer
* How orders are distributed across different statuses
* How delivery performance affects customer experience
* Where opportunities exist to improve revenue and customer retention

---

## 🎯 Business Objectives

* Analyze overall e-commerce sales performance.
* Measure revenue, orders, customers, and average order value.
* Analyze customer retention and repeat purchasing behavior.
* Identify top-performing products and product categories.
* Evaluate seller sales and order performance.
* Analyze payment-method preferences.
* Analyze order-status distribution.
* Evaluate delivery performance and customer reviews.
* Generate actionable business insights and recommendations.

---

## 🛠️ Tools & Technologies

* **Excel** — Data analysis, PivotTables, formulas, KPI analysis and exploratory analysis
* **SQL** — Data querying, joins, aggregations, CTEs, subqueries and analytical queries
* **Python** — Data cleaning, exploratory data analysis and visualization
* **Pandas** — Data manipulation and analysis
* **Matplotlib** — Data visualization
* **Power BI** — Data modeling, DAX, interactive dashboards and visualization
* **GitHub** — Project documentation and portfolio management

---

## 📊 Dataset

The project uses the **Brazilian Olist E-Commerce Dataset**, containing information about:

* Customers
* Orders
* Order Items
* Payments
* Reviews
* Products
* Sellers
* Product Categories
* Product Category Translation
* Geolocation

The dataset contains approximately:

* **99K orders**
* **96K customers**
* **3K sellers**
* **33K products**
* **74 product categories**

---

## 🔄 Project Workflow

```text
Raw Dataset
     ↓
Data Cleaning & Preparation
     ↓
Excel Analysis
     ↓
SQL Analysis
     ↓
Python EDA
     ↓
Power BI Data Modeling
     ↓
DAX Measures & KPIs
     ↓
Interactive Dashboard
     ↓
Business Insights
     ↓
Recommendations
```

---

# 📗 Excel Analysis

Excel was used for initial data exploration, KPI analysis, PivotTables, formulas, and business analysis.

### Analysis performed

* Order status analysis
* Monthly order trends
* Payment method analysis
* Product category analysis
* KPI creation
* PivotTable analysis
* Conditional formatting
* Lookup/formula-based analysis

---

# 🗄️ SQL Analysis

SQL was used to perform structured data analysis and answer business questions.

### SQL concepts used

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* Aggregate functions
* INNER JOIN
* LEFT JOIN
* Self Join
* Subqueries
* CTEs
* Window functions
* ROW_NUMBER
* RANK
* DENSE_RANK
* LAG
* LEAD
* CASE statements

### Business analysis areas

* Sales analysis
* Customer analysis
* Product analysis
* Seller analysis
* Order analysis
* Payment analysis
* Ranking and comparative analysis

---

# 🐍 Python EDA

Python was used for data cleaning, transformation, exploratory data analysis, and visualization.

### Libraries

```python
pandas
matplotlib
```

### EDA Process

* Data loading
* Dataset inspection
* Shape and data-type analysis
* Missing-value analysis
* Duplicate-value analysis
* Data cleaning
* Feature creation
* Sales analysis
* Customer analysis
* Product analysis
* Country analysis
* Trend analysis
* Customer segmentation
* KPI analysis
* Business insight generation

---

# 📊 Power BI Dashboard

The Power BI report contains **5 analytical dashboard pages**.

## Page 1 — Executive / Sales Overview

### KPIs

* Total Revenue — **16.01M**
* Total Orders — **99,441**
* Total Customers — **96,096**
* Average Order Value — **160.99**

### Analysis

* Monthly revenue trend
* Category revenue performance
* Overall sales performance

---

## Page 2 — Customer Analysis

### KPIs

* Total Customers — **96,096**
* Repeat Customers — **~3K**
* Repeat Customer Rate — **3.12%**
* Average Customer Revenue — **166.59**

### Analysis

* Customer type analysis
* Repeat vs one-time customers
* Customer revenue performance
* Customer behavior trends

---

## Page 3 — Product Performance

### KPIs

* Total Products — **~33K**
* Total Product Sales — **13.59M**
* Average Product Price — **120.65**
* Total Categories — **74**

### Analysis

* Top 10 product categories by sales
* Top 10 products by sales

---

## Page 4 — Seller Performance

### KPIs

* Total Sellers — **3,095**
* Average Seller Sales — **~4.39K**
* Top Seller Sales — **229.47K**
* Average Orders per Seller — **32.13**

### Analysis

* Top 10 sellers by sales
* Top 10 sellers by number of orders

---

## Page 5 — Order & Payment Analysis

### KPIs

* Total Orders — **99,441**
* Average Order Value — **160.99**
* Total Payment Value
* Average Payment per Order — **160.99**

### Analysis

* Orders by payment method
* Order status distribution

---

# 📈 Key Business Insights

### 1. Customer Retention Opportunity

The repeat customer rate is only **3.12%**, while approximately **93K customers are one-time buyers**.

This indicates a significant opportunity to improve customer retention and encourage second purchases.

### 2. Leading Product Categories

**Watches & Gifts** generated approximately **2.21M** in revenue, followed closely by **Health & Beauty** at approximately **2.16M**.

Together, these two categories generated approximately **4.37M** in revenue.

### 3. High-Performing Sellers

The highest-performing seller generated approximately **229.47K** in sales, compared with average seller sales of approximately **4.39K**.

This indicates significant variation in seller performance.

### 4. Customer Value

Average customer revenue was approximately **166.59**, providing a useful baseline for monitoring customer value and evaluating future retention initiatives.

### 5. Order & Payment Performance

The average payment per order is approximately **160.99**, consistent with the calculated average order value.

Payment-method and order-status analysis can help identify customer preferences and potential operational issues.

---

# 💡 Business Recommendations

### Improve Customer Retention

* Introduce loyalty programs.
* Provide personalized offers after the first purchase.
* Encourage second purchases through targeted campaigns.
* Segment customers based on purchasing behavior.

### Strengthen High-Performing Categories

* Maintain sufficient inventory for high-performing categories.
* Identify the products responsible for category-level performance.
* Use targeted promotions and cross-selling.

### Improve Seller Performance

* Identify practices used by high-performing sellers.
* Provide seller incentives.
* Monitor seller-level sales and order volumes.
* Investigate consistently low-performing sellers.

### Improve Order Operations

* Monitor canceled and unavailable orders.
* Analyze operational causes of unsuccessful orders.
* Track delivery performance regularly.

### Optimize Payment Experience

* Monitor customer payment preferences.
* Ensure a smooth checkout experience.
* Analyze payment behavior alongside order performance.

---

# 📁 Repository Structure

```text
Olist-Ecommerce-Analytics/
│
├── 01_Dataset/
│
├── 02_Excel_Analysis/
│   └── Olist_Excel_Analysis.xlsx
│
├── 03_SQL_Analysis/
│   └── Olist_SQL_Analysis.sql
│
├── 04_Python_EDA/
│   └── Olist_EDA.ipynb
│
├── 05_PowerBI/
│   └── Olist_Ecommerce_Analytics.pbix
│
├── 06_Business_Insights/
│   └── Olist_Business_Insights.docx
│
├── 07_Dashboard_Screenshots/
│   ├── Page1_Executive_Overview.png
│   ├── Page2_Customer_Analysis.png
│   ├── Page3_Product_Performance.png
│   ├── Page4_Seller_Performance.png
│   └── Page5_Order_Payment_Analysis.png
│
├── README.md
└── .gitignore
```

---

# 📸 Dashboard Preview

The Power BI report contains five interactive analytical pages covering:

1. Executive Sales Overview
2. Customer Analysis
3. Product Performance
4. Seller Performance
5. Order & Payment Analysis

Dashboard screenshots are available in:

```text
07_Dashboard_Screenshots/
```

---

# 🚀 Key Skills Demonstrated

* Data Cleaning
* Exploratory Data Analysis
* SQL Analytics
* Excel Analytics
* Data Modeling
* DAX
* KPI Development
* Power BI Dashboard Development
* Customer Analytics
* Product Analytics
* Seller Analytics
* Business Intelligence
* Business Insight Generation
* Data Storytelling

---

# 🔮 Future Improvements

* Develop predictive customer churn analysis.
* Build customer lifetime value models.
* Add seller segmentation.
* Develop product recommendation analysis.
* Add advanced delivery-performance analysis.
* Implement automated dashboard refresh.
* Explore machine-learning-based customer segmentation.

---

## 👩‍💻 Project Summary

This project demonstrates an end-to-end approach to solving an e-commerce analytics problem using **Excel, SQL, Python, and Power BI**.

The analysis transforms raw transactional data into meaningful KPIs, interactive dashboards, business insights, and actionable recommendations that can support **customer retention, product strategy, seller management, and operational decision-making**.
