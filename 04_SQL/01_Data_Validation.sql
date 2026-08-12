CREATE TABLE orders_staging (
    order_id NVARCHAR(50),
    customer_id NVARCHAR(50),
    order_status NVARCHAR(30),
    order_purchase_timestamp NVARCHAR(50),
    order_approved_at NVARCHAR(50),
    order_delivered_carrier_date NVARCHAR(50),
    order_delivered_customer_date NVARCHAR(50),
    order_estimated_delivery_date NVARCHAR(50)
);


BULK INSERT orders_staging
FROM 'C:\Olist_SQL\olist_orders_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);



SELECT COUNT(*) AS Total_Rows
FROM orders_staging;


SELECT TOP 10
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders_staging;




INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    order_id,
    customer_id,
    order_status,
    TRY_CONVERT(DATETIME2, NULLIF(order_purchase_timestamp, '')),
    TRY_CONVERT(DATETIME2, NULLIF(order_approved_at, '')),
    TRY_CONVERT(DATETIME2, NULLIF(order_delivered_carrier_date, '')),
    TRY_CONVERT(DATETIME2, NULLIF(order_delivered_customer_date, '')),
    TRY_CONVERT(DATETIME2, NULLIF(order_estimated_delivery_date, ''))
FROM orders_staging;

SELECT COUNT(*) AS Total_Orders
FROM orders;

SELECT TOP 10 *
FROM orders;

DROP TABLE orders_staging;

EXEC xp_fileexist 'C:\Olist_SQL\olist_customers_dataset.csv';

CREATE TABLE customers_staging (
    customer_id NVARCHAR(50),
    customer_unique_id NVARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(10)
);

BULK INSERT customers_staging
FROM 'C:\Olist_SQL\olist_customers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT COUNT(*) AS Total_Customers
FROM customers_staging;

CREATE TABLE customers (
    customer_id NVARCHAR(50) NOT NULL,
    customer_unique_id NVARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(10)
);

INSERT INTO customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM customers_staging;

SELECT COUNT(*) AS Total_Customers
FROM customers;

SELECT TOP 10 *
FROM customers;

DROP TABLE customers_staging;

EXEC xp_fileexist 'C:\Olist_SQL\olist_order_items_dataset.csv';

CREATE TABLE order_items_staging (
    order_id NVARCHAR(50),
    order_item_id INT,
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
    shipping_limit_date NVARCHAR(50),
    price DECIMAL(18,2),
    freight_value DECIMAL(18,2)
);

BULK INSERT order_items_staging
FROM 'C:\Olist_SQL\olist_order_items_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
SELECT COUNT(*) AS Total_Order_Items
FROM order_items_staging;

CREATE TABLE order_items (
    order_id NVARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
    shipping_limit_date DATETIME2,
    price DECIMAL(18,2),
    freight_value DECIMAL(18,2)
);

INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    TRY_CONVERT(DATETIME2, NULLIF(shipping_limit_date, '')),
    price,
    freight_value
FROM order_items_staging;

SELECT COUNT(*) AS Total_Order_Items
FROM order_items;

SELECT TOP 10 *
FROM order_items;

DROP TABLE order_items_staging;

EXEC xp_fileexist 'C:\Olist_SQL\olist_order_payments_dataset.csv';

CREATE TABLE order_payments_staging (
    order_id NVARCHAR(50),
    payment_sequential INT,
    payment_type NVARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(18,2)
);

BULK INSERT order_payments_staging
FROM 'C:\Olist_SQL\olist_order_payments_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT COUNT(*) AS Total_Payments
FROM order_payments_staging;

CREATE TABLE order_payments (
    order_id NVARCHAR(50) NOT NULL,
    payment_sequential INT,
    payment_type NVARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(18,2)
);

INSERT INTO order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments_staging;

SELECT COUNT(*) AS Total_Payments
FROM order_payments;

SELECT TOP 10 *
FROM order_payments;


DROP TABLE order_payments_staging;



EXEC xp_fileexist 'C:\Olist_SQL\olist_order_reviews_dataset.csv';

CREATE TABLE order_reviews_staging (
    review_id NVARCHAR(50),
    order_id NVARCHAR(50),
    review_score INT,
    review_comment_title NVARCHAR(500),
    review_comment_message NVARCHAR(MAX),
    review_creation_date NVARCHAR(50),
    review_answer_timestamp NVARCHAR(50)
);

BULK INSERT order_reviews_staging
FROM 'C:\Olist_SQL\olist_order_reviews_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

DROP TABLE IF EXISTS order_reviews_staging;

CREATE TABLE order_reviews_staging (
    review_id NVARCHAR(50),
    order_id NVARCHAR(50),
    review_score INT,
    review_comment_title NVARCHAR(500),
    review_comment_message NVARCHAR(4000),
    review_creation_date NVARCHAR(50),
    review_answer_timestamp NVARCHAR(50)
);


BULK INSERT order_reviews_staging
FROM 'C:\Olist_SQL\olist_order_reviews_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'order_reviews';

SELECT COUNT(*) AS Total_Reviews
FROM order_reviews;

SELECT TOP 10 *
FROM order_reviews;

EXEC xp_fileexist 'C:\Olist_SQL\olist_products_dataset.csv';

CREATE TABLE products_staging (
    product_id NVARCHAR(50),
    product_category_name NVARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

BULK INSERT products_staging
FROM 'C:\Olist_SQL\olist_products_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT COUNT(*) AS Total_Products
FROM products_staging;

CREATE TABLE products (
    product_id NVARCHAR(50) NOT NULL,
    product_category_name NVARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

INSERT INTO products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products_staging;

SELECT COUNT(*) AS Total_Products
FROM products;

SELECT TOP 10 *
FROM products;

DROP TABLE products_staging;

EXEC xp_fileexist 'C:\Olist_SQL\olist_sellers_dataset.csv';

CREATE TABLE sellers_staging (
    seller_id NVARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(10)
);

BULK INSERT sellers_staging
FROM 'C:\Olist_SQL\olist_sellers_dataset.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT COUNT(*) AS Total_Sellers
FROM sellers_staging;

CREATE TABLE sellers (
    seller_id NVARCHAR(50) NOT NULL,
    seller_zip_code_prefix INT,
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(10)
);

INSERT INTO sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM sellers_staging;


SELECT COUNT(*) AS Total_Sellers
FROM sellers;

SELECT TOP 10 *
FROM sellers;

DROP TABLE sellers_staging;


EXEC xp_fileexist 'C:\Olist_SQL\product_category_name_translation.csv';

CREATE TABLE category_translation_staging (
    product_category_name NVARCHAR(100),
    product_category_name_english NVARCHAR(100)
);

BULK INSERT category_translation_staging
FROM 'C:\Olist_SQL\product_category_name_translation.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT COUNT(*) AS Total_Categories
FROM category_translation_staging;

CREATE TABLE product_category_name_translation (
    product_category_name NVARCHAR(100) NOT NULL,
    product_category_name_english NVARCHAR(100) NOT NULL
);




INSERT INTO product_category_name_translation (
    product_category_name,
    product_category_name_english
)
SELECT
    product_category_name,
    product_category_name_english
FROM category_translation_staging;


SELECT COUNT(*) AS Total_Categories
FROM product_category_name_translation;

SELECT TOP 10 *
FROM product_category_name_translation;


DROP TABLE category_translation_staging;




SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;




SELECT 'customers' AS Table_Name, COUNT(*) AS Row_Count
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM order_payments

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM order_reviews

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'category_translation', COUNT(*)
FROM product_category_name_translation;