# Entity Relationship Diagram (ER Diagram)

## Overview

The Olist E-commerce database consists of multiple related tables connected through primary keys and foreign keys. The relationships represent the complete customer journey, from placing an order to receiving products and providing feedback.

---

## Database Structure

```text
                              Customers
                                  |
                                  |
                            customer_id
                                  |
                                  |
                                  ↓
                              Orders
                                  |
                                  |
                              order_id
                                  |
        ┌─────────────────────────┼──────────────────────────┐
        |                         |                          |
        ↓                         ↓                          ↓
  Order Items              Order Payments            Order Reviews
        |
        |
   ┌────┴────┐
   ↓         ↓
Products   Sellers
   |
   |
product_category_name
   |
   ↓
Product Category
Translation


Customers
    |
customer_zip_code_prefix
    |
    ↓
Geolocation


Sellers
    |
seller_zip_code_prefix
    |
    ↓
Geolocation
```

---

## Main Entities

### Customers

Primary Key:

* customer_id

Purpose:

* Stores customer information and location details.

---

### Orders

Primary Key:

* order_id

Foreign Key:

* customer_id

Purpose:

* Stores order lifecycle information.

---

### Order Items

Primary Key:

* order_id + order_item_id

Foreign Keys:

* order_id
* product_id
* seller_id

Purpose:

* Stores products included in each order.

---

### Order Payments

Primary Key:

* order_id + payment_sequential

Foreign Key:

* order_id

Purpose:

* Stores payment information.

---

### Order Reviews

Primary Key:

* review_id

Foreign Key:

* order_id

Purpose:

* Stores customer feedback and ratings.

---

### Products

Primary Key:

* product_id

Purpose:

* Stores product information.

---

### Sellers

Primary Key:

* seller_id

Purpose:

* Stores seller information.

---

### Product Category Translation

Primary Key:

* product_category_name

Purpose:

* Converts Portuguese category names into English.

---

### Geolocation

Key:

* geolocation_zip_code_prefix

Purpose:

* Provides geographical details for customers and sellers.

---

## Business Value of ER Diagram

The ER diagram helps analysts:

* Understand database structure.
* Identify correct JOIN conditions.
* Avoid duplicate counting during analysis.
* Build accurate SQL queries.
* Create reliable dashboards and reports.
