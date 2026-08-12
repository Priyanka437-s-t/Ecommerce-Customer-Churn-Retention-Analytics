# Data Dictionary

## 1. Customers Table

### Table Name

`olist_customers_dataset`

### Purpose

The Customers table stores information about each customer who has placed an order on the e-commerce platform. It contains customer identifiers and location details, enabling analysis of customer distribution across different cities and states.

### Primary Key

* **customer_id** – Unique identifier for each customer record.

### Foreign Key

* No foreign keys are present in this table.
* The **customer_id** is referenced in the **Orders** table to associate customers with their orders.

### Columns

* **customer_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for each customer record.

* **customer_unique_id**

  * Data Type: VARCHAR
  * Description: Unique identifier representing the actual customer across multiple purchases.

* **customer_zip_code_prefix**

  * Data Type: INTEGER
  * Description: First five digits of the customer's ZIP code.

* **customer_city**

  * Data Type: VARCHAR
  * Description: City where the customer resides.

* **customer_state**

  * Data Type: VARCHAR
  * Description: State where the customer resides.

### Business Importance

This table helps answer questions such as:

* How many unique customers does the company have?
* Which cities and states have the highest number of customers?
* Which regions generate the highest revenue?
* Which customers make repeat purchases?
* How are customers distributed geographically?


## 2. Orders Table

### Table Name

`olist_orders_dataset`

### Purpose

The Orders table stores information about every order placed on the e-commerce platform. It tracks the complete order lifecycle, including purchase, approval, shipping, delivery, and customer delivery status. This table acts as the central table that connects customers, products, payments, and reviews.

### Primary Key

* **order_id** – Unique identifier for each order.

### Foreign Key

* **customer_id** – References the **Customers** table to identify which customer placed the order.

### Columns

* **order_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for each order.

* **customer_id**

  * Data Type: VARCHAR
  * Description: Identifies the customer who placed the order.

* **order_status**

  * Data Type: VARCHAR
  * Description: Current status of the order (e.g., delivered, shipped, canceled).

* **order_purchase_timestamp**

  * Data Type: DATETIME
  * Description: Date and time when the customer placed the order.

* **order_approved_at**

  * Data Type: DATETIME
  * Description: Date and time when the order payment was approved.

* **order_delivered_carrier_date**

  * Data Type: DATETIME
  * Description: Date and time when the order was handed over to the shipping carrier.

* **order_delivered_customer_date**

  * Data Type: DATETIME
  * Description: Date and time when the customer received the order.

* **order_estimated_delivery_date**

  * Data Type: DATETIME
  * Description: Estimated delivery date promised to the customer.

### Business Importance

This table helps answer questions such as:

* How many orders were placed?
* How many orders were successfully delivered?
* How many orders were canceled?
* What is the average delivery time?
* Are deliveries completed before the estimated delivery date?
* How do order trends change over time?
* Does delivery performance influence customer satisfaction?

## 3. Order Items Table

### Table Name

`olist_order_items_dataset`

### Purpose

The Order Items table stores detailed information about the products included in each order. It connects orders with products and sellers, making it possible to analyze product sales, seller performance, pricing, and shipping costs.

### Primary Key

* **Composite Key**

  * **order_id**
  * **order_item_id**

### Foreign Keys

* **order_id** – References the **Orders** table.
* **product_id** – References the **Products** table.
* **seller_id** – References the **Sellers** table.

### Columns

* **order_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for the order.

* **order_item_id**

  * Data Type: INTEGER
  * Description: Sequential number of the item within the order.

* **product_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for the purchased product.

* **seller_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for the seller who sold the product.

* **shipping_limit_date**

  * Data Type: DATETIME
  * Description: Deadline by which the seller should ship the product.

* **price**

  * Data Type: DECIMAL
  * Description: Price of the purchased product.

* **freight_value**

  * Data Type: DECIMAL
  * Description: Shipping cost charged for the product.

### Business Importance

This table helps answer questions such as:

* Which products are sold the most?
* Which sellers generate the highest sales?
* What is the average product price?
* What is the average shipping cost?
* Which product categories generate the highest revenue?
* Which sellers contribute the most to overall business performance?


## 4. Order Payments Table

### Table Name

`olist_order_payments_dataset`

### Purpose

The Order Payments table stores payment information for each order. It records the payment method, number of installments, and the total amount paid by the customer. This table is essential for analyzing revenue, customer payment preferences, and payment behavior.

### Primary Key

* **Composite Key**

  * **order_id**
  * **payment_sequential**

### Foreign Keys

* **order_id** – References the **Orders** table.

### Columns

* **order_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for the order.

* **payment_sequential**

  * Data Type: INTEGER
  * Description: Sequence number of the payment for an order. Some orders may have multiple payment records.

* **payment_type**

  * Data Type: VARCHAR
  * Description: Payment method used by the customer (e.g., credit card, debit card, voucher, boleto).

* **payment_installments**

  * Data Type: INTEGER
  * Description: Number of installments chosen for the payment.

* **payment_value**

  * Data Type: DECIMAL
  * Description: Total amount paid for the order.

### Business Importance

This table helps answer questions such as:

* What is the total revenue generated?
* Which payment methods are most commonly used?
* Do customers prefer paying in installments?
* What is the average payment value per order?
* Does the payment method influence customer purchasing behavior?


## 5. Order Reviews Table

### Table Name

`olist_order_reviews_dataset`

### Purpose

The Order Reviews table stores customer feedback for completed orders. It includes review ratings, review comments, and timestamps. This table helps measure customer satisfaction and analyze how factors such as delivery performance and order experience influence customer reviews.

### Primary Key

* **review_id** – Unique identifier for each review.

### Foreign Keys

* **order_id** – References the **Orders** table.

### Columns

* **review_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for each customer review.

* **order_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for the order associated with the review.

* **review_score**

  * Data Type: INTEGER
  * Description: Customer rating for the order (1 to 5).

* **review_comment_title**

  * Data Type: TEXT
  * Description: Title of the customer's review (may contain missing values).

* **review_comment_message**

  * Data Type: TEXT
  * Description: Detailed review message provided by the customer (may contain missing values).

* **review_creation_date**

  * Data Type: DATETIME
  * Description: Date when the customer created the review.

* **review_answer_timestamp**

  * Data Type: DATETIME
  * Description: Date and time when the review was recorded in the system.

### Business Importance

This table helps answer questions such as:

* What is the average customer review score?
* How many customers gave positive or negative ratings?
* Does delivery performance affect customer satisfaction?
* What factors contribute to low review scores?
* How can the company improve the overall customer experience?


## 6. Products Table

### Table Name

`olist_products_dataset`

### Purpose

The Products table stores information about the products available on the e-commerce platform. It contains product characteristics such as category, dimensions, and weight. This table helps analyze product performance, category trends, and customer purchasing patterns.

### Primary Key

* **product_id** – Unique identifier for each product.

### Foreign Keys

* No direct foreign keys are present in this table.
* The **product_id** is referenced by the **Order Items** table to identify which products were purchased.

### Columns

* **product_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for each product.

* **product_category_name**

  * Data Type: VARCHAR
  * Description: Category name of the product in Portuguese.

* **product_name_length**

  * Data Type: INTEGER
  * Description: Number of characters in the product name.

* **product_description_length**

  * Data Type: INTEGER
  * Description: Number of characters in the product description.

* **product_photos_qty**

  * Data Type: INTEGER
  * Description: Number of photos available for the product.

* **product_weight_g**

  * Data Type: INTEGER
  * Description: Product weight in grams.

* **product_length_cm**

  * Data Type: INTEGER
  * Description: Product length in centimeters.

* **product_height_cm**

  * Data Type: INTEGER
  * Description: Product height in centimeters.

* **product_width_cm**

  * Data Type: INTEGER
  * Description: Product width in centimeters.

### Business Importance

This table helps answer questions such as:

* Which product categories generate the highest revenue?
* Which products are purchased most frequently?
* Which categories have the highest customer demand?
* How do product characteristics affect sales performance?
* Which products should be promoted to increase repeat purchases?


## 7. Sellers Table

### Table Name

`olist_sellers_dataset`

### Purpose

The Sellers table stores information about sellers registered on the e-commerce marketplace. It contains seller location details and helps analyze seller performance, regional distribution, and marketplace operations.

### Primary Key

* **seller_id** – Unique identifier for each seller.

### Foreign Keys

* No direct foreign keys are present in this table.
* The **seller_id** is referenced in the **Order Items** table to identify which seller provided each product.

### Columns

* **seller_id**

  * Data Type: VARCHAR
  * Description: Unique identifier for each seller.

* **seller_zip_code_prefix**

  * Data Type: INTEGER
  * Description: First five digits of the seller's ZIP code.

* **seller_city**

  * Data Type: VARCHAR
  * Description: City where the seller is located.

* **seller_state**

  * Data Type: VARCHAR
  * Description: State where the seller is located.

### Business Importance

This table helps answer questions such as:

* Which sellers generate the highest sales?
* Which sellers contribute the most revenue?
* How are sellers distributed across different regions?
* Which sellers have better operational performance?
* How does seller performance affect customer experience?


## 8. Geolocation Table

### Table Name

`olist_geolocation_dataset`

### Purpose

The Geolocation table stores geographical information related to ZIP code prefixes in Brazil. It contains location details such as latitude, longitude, city, and state. This table helps perform geographic analysis of customers and sellers.

### Primary Key

* No single primary key is defined in this table.
* The combination of ZIP code prefix and location details can be used to identify geographical areas.

### Foreign Keys

* **geolocation_zip_code_prefix** connects with:

  * `customer_zip_code_prefix` in the Customers table.
  * `seller_zip_code_prefix` in the Sellers table.

### Columns

* **geolocation_zip_code_prefix**

  * Data Type: INTEGER
  * Description: First five digits of the ZIP code representing a geographic area.

* **geolocation_lat**

  * Data Type: DECIMAL
  * Description: Latitude coordinate of the location.

* **geolocation_lng**

  * Data Type: DECIMAL
  * Description: Longitude coordinate of the location.

* **geolocation_city**

  * Data Type: VARCHAR
  * Description: City name associated with the ZIP code.

* **geolocation_state**

  * Data Type: VARCHAR
  * Description: State name associated with the ZIP code.

### Business Importance

This table helps answer questions such as:

* Which regions generate the highest number of customers?
* Which states contribute the most revenue?
* Where are sellers concentrated?
* Which regions have delivery challenges?
* How does geographic location influence customer behavior?


## 9. Product Category Translation Table

### Table Name

`product_category_name_translation`

### Purpose

The Product Category Translation table provides English translations for product category names that are originally stored in Portuguese. It helps make product analysis easier by converting category names into a language that is more understandable for business reporting and dashboards.

### Primary Key

* **product_category_name**

  * Unique identifier for each product category name.

### Foreign Keys

* **product_category_name** connects with:

  * `product_category_name` in the Products table.

### Columns

* **product_category_name**

  * Data Type: VARCHAR
  * Description: Product category name in Portuguese.

* **product_category_name_english**

  * Data Type: VARCHAR
  * Description: Translated product category name in English.

### Business Importance

This table helps answer questions such as:

* Which product categories generate the highest revenue?
* Which categories have the highest order volume?
* Which categories are preferred by repeat customers?
* How can product performance be presented clearly in dashboards?
