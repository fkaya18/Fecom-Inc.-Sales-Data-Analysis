--Creating Database
CREATE DATABASE market_place_orders;
USE market_place_orders;

--Creating Tables
CREATE TABLE geolocations( 
	postal_code VARCHAR(32),
	latitude DECIMAL(10, 4),
	longitude DECIMAL(10, 4),
	city VARCHAR(64),
	country VARCHAR(64),
	PRIMARY KEY (postal_code, city)
);

CREATE TABLE customer_list (
	customer_id VARCHAR(32) NOT NULL PRIMARY KEY,
	subscriber_id VARCHAR(32),
	subscribe_date DATE,
	first_order_date DATE,
	customer_postal_code VARCHAR(32),
	customer_city VARCHAR(64),
	customer_country VARCHAR(64),
	customer_country_code VARCHAR(5),
	age INT,
	gender VARCHAR(32),
	FOREIGN KEY (customer_postal_code, customer_city)
        REFERENCES geolocations (postal_code, city)
);

CREATE TABLE sellers_list(
	seller_id VARCHAR(32) PRIMARY KEY,
	seller_name VARCHAR(64),
	seller_postal_code VARCHAR(32),
	seller_city VARCHAR(64),
	seller_country_code VARCHAR(5),
	seller_country VARCHAR(64),
	FOREIGN KEY (seller_postal_code, seller_city)
	REFERENCES geolocations(postal_code, city)
);

CREATE TABLE products(
	product_id VARCHAR(32) PRIMARY KEY,
	product_category VARCHAR(64),
	product_weight_gr INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT,
);

CREATE TABLE orders(
	order_id VARCHAR(32) PRIMARY KEY,
	customer_id VARCHAR(32),
	order_status VARCHAR(32),
	order_purchase_date DATETIME2(0),
	order_approved_at DATETIME2(0),
	order_delivered_carrier_date DATETIME2(0),
	order_delivered_customer_date DATETIME2(0),
	order_estimated_delivery_date DATETIME2(0),
	FOREIGN KEY (customer_id) REFERENCES customer_list(customer_id)
);

CREATE TABLE order_items (
	order_id VARCHAR(32),
	order_item_id VARCHAR(32),
	product_id VARCHAR(32),
	seller_id VARCHAR(32),
	shipping_limit_date DATE,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2),
	PRIMARY KEY(order_id, order_item_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (seller_id) REFERENCES sellers_list(seller_id)
);

CREATE TABLE order_payments (
	order_id VARCHAR(32),
	payment_sequential INT,
	payment_type VARCHAR(32),
	payment_installments INT,
	payment_value DECIMAL(10,2),
	PRIMARY KEY (order_id, payment_sequential),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_reviews(
	review_id VARCHAR(64),
	order_id VARCHAR(32),
	review_score INT,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date DATE,
	review_answer_date DATETIME2(0),
	PRIMARY KEY(review_id, order_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

--Importing Data Into Tables
BULK INSERT geolocations
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_geolocations.csv'
WITH (
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'  -- UTF-8
);

BULK INSERT customer_list
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_customer_list.csv'
WITH (
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'  
);

BULK INSERT sellers_list 
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_sellers_list.csv'
WITH (
	FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001' 
);

BULK INSERT products 
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_products.csv'
WITH (
	FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT orders 
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_orders.csv'
WITH (
	FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT order_items
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_order_items.csv'
WITH (
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT order_payments
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_order_payments.csv'
WITH (
	FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);
BULK INSERT order_reviews
FROM 'C:\Users\Furkan\data_analysis\market_place_orders\fecom_inc_order_reviews_edited.csv'
WITH (
	FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

--Checking tables
SELECT *
FROM geolocations;

SELECT *
FROM customer_list;

SELECT *
FROM sellers_list;

SELECT * 
FROM products;

SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT *
FROM order_payments;

SELECT *
FROM order_reviews;

--Total Revenue
SELECT 
	SUM(payment_value) AS total_revenue
FROM order_payments;

--Average Income per Sale
SELECT 
	AVG(payment_value) AS avg_income_per_sale
FROM order_payments;

--Average Income per Customer
SELECT AVG(total_income) AS avg_income_per_customer
FROM(
	SELECT 
	c.customer_id,
	SUM(op.payment_value) AS total_income
	FROM customer_list AS c
	INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
	INNER JOIN order_payments AS op
	ON o.order_id = op.order_id
	GROUP BY c.customer_id) sub;


--Seller Performance based on Revenue
SELECT 
    TOP 10
    s.seller_name,
    s.seller_city,
    s.seller_country,
    COUNT(*) AS total_products_sold,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM order_items AS oi
INNER JOIN sellers_list AS s 
    ON oi.seller_id = s.seller_id
GROUP BY 
    s.seller_name, s.seller_city, s.seller_country
ORDER BY total_revenue DESC;


--Product Category Performance Based on Total Revenue
SELECT TOP 10
	p.product_category,
	COUNT(*) AS total_products_sold,
	SUM(oi.price) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
ON p.product_id = oi.product_id
GROUP BY p.product_category
ORDER BY total_revenue DESC;

--Product Category Performance Based on Total Products Sold
SELECT TOP 10
	p.product_category,
	COUNT(*) AS total_products_sold,
	SUM(oi.price) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
ON p.product_id = oi.product_id
GROUP BY p.product_category
ORDER BY total_products_sold DESC;

--Average Delivery Day Calculation
SELECT 
	AVG(DATEDIFF(DAY, order_purchase_date, order_delivered_customer_date)) AS avg_delivery_days
FROM orders;

--Average Review Score
SELECT 
	AVG(review_score) AS avg_review_score
FROM order_reviews;

--Orders with Review Score of 1 and Their Comments
SELECT
  order_id,
  review_score,
  review_comment_title,
  review_comment_message,
  review_creation_date
FROM order_reviews
WHERE review_score = 1
AND (review_comment_title IS NOT NULL OR review_comment_message IS NOT NULL)
ORDER BY review_creation_date DESC;


--Orders With Late Delivery and Love Rating and Comments
SELECT 
	o.order_id,
	r.review_score,
	r.review_comment_title,
	r.review_comment_message
FROM orders AS o
INNER JOIN order_reviews AS r
ON o.order_id = r.order_id
WHERE order_delivered_customer_date > order_estimated_delivery_date
AND r.review_score <= 2
AND (r.review_comment_title IS NOT NULL OR r.review_comment_message IS NOT NULL);

--Payment Type Analysis
SELECT 
	payment_type,
	COUNT(DISTINCT orders.order_id) AS times_used,
	SUM(payment_value) AS total_revenue
FROM order_payments
INNER JOIN orders
ON order_payments.order_id = orders.order_id
GROUP BY payment_type
ORDER BY total_revenue DESC;


--True Payment Type Analysis
WITH multiple_payment_orders AS (
    SELECT 
        order_id
    FROM order_payments
    GROUP BY order_id
    HAVING COUNT(DISTINCT payment_type) > 1
),
single_payment_orders AS (
    SELECT 
        order_id
    FROM order_payments
    GROUP BY order_id
    HAVING COUNT(DISTINCT payment_type) = 1
)

-- Orders with multiple payment methods
SELECT 
    op.order_id,
    STUFF((
        SELECT ', ' + op2.payment_type
        FROM order_payments AS op2
        WHERE op2.order_id = op.order_id
        GROUP BY op2.payment_type
        FOR XML PATH('')
    ), 1, 2, '') AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN multiple_payment_orders AS mpo
    ON op.order_id = mpo.order_id
GROUP BY op.order_id
UNION ALL
-- Orders with single payment method
SELECT 
    op.order_id,
    op.payment_type AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN single_payment_orders AS spo
    ON op.order_id = spo.order_id
GROUP BY op.order_id, op.payment_type
ORDER BY total_payment_value DESC;



--Total Number of Late Deliveries
WITH late_deliveries AS(
	SELECT
		order_id,
		order_estimated_delivery_date,
		order_delivered_customer_date,
		DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) AS days_late
	FROM orders
	WHERE DATEDIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) > 0
)

SELECT 
	COUNT(*) AS number_of_late_deliveries
FROM late_deliveries;

--City Based Income Distribution
SELECT TOP 10
	c.customer_city,
	c.customer_country,
	SUM(op.payment_value) AS total_revenue
	FROM order_payments AS op
	INNER JOIN orders AS o
	ON op.order_id = o.order_id
	INNER JOIN customer_list AS c
	ON c.customer_id = o.customer_id
	GROUP BY c.customer_city, c.customer_country
	ORDER BY total_revenue DESC;

--Country Based Income Distribution
SELECT TOP 10
	c.customer_country,
	SUM(op.payment_value) AS total_revenue
FROM customer_list AS c
INNER JOIN orders AS o
ON o.customer_id = c.customer_id
INNER JOIN order_payments AS op
ON op.order_id = o.order_id
GROUP BY customer_country
ORDER BY total_revenue DESC;

--Number of orders with multiple payment records
SELECT COUNT(DISTINCT order_id) AS multi_payment_orders
FROM order_payments
WHERE order_id IN(
	SELECT order_id
	FROM order_payments 
	GROUP BY order_id 
	HAVING COUNT(*) > 1);

--Top Spending Customers
SELECT TOP 10
	c.customer_id,
	c.customer_city,
	c.customer_country,
	c.gender,
	c.age,
	o.order_id,
	SUM(op.payment_value) AS total_revenue
FROM orders AS o
INNER JOIN customer_list AS c
ON o.customer_id = c.customer_id
INNER JOIN order_payments AS op
ON o.order_id = op.order_id
GROUP BY c.customer_id, c.customer_city, c.customer_country, c.gender, c.age, o.order_id
ORDER BY total_revenue DESC;


--Average Delivery Days by Seller
SELECT 
	s.seller_name,
	s.seller_city,
	s.seller_country,
	AVG(DATEDIFF(DAY, o.order_purchase_date, o.order_delivered_customer_date)) AS avg_delivery_days
FROM orders AS o
INNER JOIN order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN sellers_list AS s
ON oi.seller_id = s.seller_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY s.seller_name, s.seller_city, s.seller_country
ORDER BY avg_delivery_days;


--Category Based Average Rating
SELECT 
	p.product_category,
	AVG(review_score) AS avg_rating
FROM products AS p
INNER JOIN order_items AS oi
ON p.product_id = oi.product_id
INNER JOIN order_reviews as r
ON oi.order_id = r.order_id
GROUP BY product_category
ORDER BY avg_rating;

-- Monthly Sales Performance with Cumulative Revenue
SELECT
	CAST(DATETRUNC(MONTH, order_purchase_date) AS DATE) AS month,
	COUNT(DISTINCT orders.order_id) AS total_orders,
	SUM(payment_value) AS total_revenue,
	SUM(SUM(payment_value)) OVER(ORDER BY CAST(DATETRUNC(MONTH, order_purchase_date) AS DATE)) AS running_total_revenue
FROM orders
INNER JOIN order_payments
ON orders.order_id = order_payments.order_id
GROUP BY CAST(DATETRUNC(MONTH, order_purchase_date) AS DATE)
ORDER BY month;

-- Yearly Sales Performance with Cumulative Revenue
SELECT 
	CAST(DATETRUNC(YEAR, order_purchase_date) AS DATE) AS year,
	COUNT(DISTINCT orders.order_id) AS total_orders,
	SUM(payment_value) AS total_revenue,
	SUM(SUM(payment_value)) OVER(ORDER BY CAST(DATETRUNC(YEAR, order_purchase_date) AS DATE)) AS running_total_revenue
FROM orders
INNER JOIN order_payments
ON orders.order_id = order_payments.order_id
GROUP BY CAST(DATETRUNC(YEAR, order_purchase_date) AS DATE)
ORDER BY year;

-- Monthly Revenue and Change from Previous Month
SELECT 
	DATEFROMPARTS(YEAR(order_purchase_date), MONTH(order_purchase_date), 1) AS month,
	SUM(payment_value) AS total_revenue,
	LAG(SUM(payment_value)) OVER(ORDER BY DATEFROMPARTS(YEAR(order_purchase_date), MONTH(order_purchase_date), 1)) AS prev_month_revenue,
	SUM(payment_value) - LAG(SUM(payment_value)) OVER(ORDER BY DATEFROMPARTS(YEAR(order_purchase_date), MONTH(order_purchase_date), 1)) AS monthly_revenue_change
FROM orders
INNER JOIN order_payments
ON orders.order_id = order_payments.order_id
GROUP BY DATEFROMPARTS(YEAR(order_purchase_date), MONTH(order_purchase_date), 1)
ORDER BY month;

--Monthly Revenue Trend by Country
SELECT 
    cl.customer_country,
    DATEFROMPARTS(YEAR(o.order_purchase_date), MONTH(o.order_purchase_date), 1) AS month,
    SUM(op.payment_value) AS revenue,

	SUM(SUM(op.payment_value)) OVER(
		PARTITION BY cl.customer_country 
		ORDER BY DATEFROMPARTS(YEAR(o.order_purchase_date), MONTH(o.order_purchase_date), 1)) 
		AS running_total_revenue,

    LAG(SUM(op.payment_value)) OVER (
        PARTITION BY cl.customer_country
        ORDER BY DATEFROMPARTS(YEAR(o.order_purchase_date), MONTH(o.order_purchase_date), 1)
    ) AS previous_month_revenue,
    
    SUM(op.payment_value) -
    LAG(SUM(op.payment_value)) OVER (
        PARTITION BY cl.customer_country
        ORDER BY DATEFROMPARTS(YEAR(o.order_purchase_date), MONTH(o.order_purchase_date), 1)
    ) AS revenue_change
FROM orders AS o
JOIN order_payments AS op
ON o.order_id = op.order_id
JOIN customer_list AS cl 
ON o.customer_id = cl.customer_id
GROUP BY 
    cl.customer_country,
    DATEFROMPARTS(YEAR(o.order_purchase_date), MONTH(o.order_purchase_date), 1)
ORDER BY 
    cl.customer_country,
    month;


--Average Time from Subscription to First Order
SELECT
AVG(days_before_first_order) AS avg_days_before_order
FROM(
SELECT 
subscribe_date,
first_order_date,
DATEDIFF(DAY, subscribe_date, first_order_date) AS days_before_first_order
FROM customer_list) sub;


-- Total Revenue by Customer Gender
SELECT 
	c.gender,
	SUM(op.payment_value) AS total_revenue
FROM customer_list AS c
INNER JOIN orders AS o
ON o.customer_id = c.customer_id
INNER JOIN order_payments AS op
ON op.order_id = o.order_id
GROUP BY c.gender
ORDER BY total_revenue DESC;


WITH product_ranking AS(
	SELECT 
		p.product_category,
		oi.product_id,
		AVG(oi.price) AS avg_price,
		DENSE_RANK() OVER (
			PARTITION BY p.product_category
			ORDER BY AVG(oi.price) DESC
		) AS price_rank
	FROM order_items AS oi
	JOIN products AS p ON oi.product_id = p.product_id
	WHERE product_category != '#N/A'
	GROUP BY p.product_category, oi.product_id
)

SELECT 
	product_category,
	product_id,
	avg_price,
	price_rank
FROM product_ranking
WHERE price_rank = 1
ORDER BY product_category




WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        SUM(op.payment_value) AS revenue
    FROM customer_list AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_payments AS op
        ON o.order_id = op.order_id
    GROUP BY c.customer_id
),
percentiles AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) OVER () AS p25,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) OVER () AS p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) OVER () AS p75,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY revenue) OVER () AS p90,
		PERCENTILE_CONT(0.999) WITHIN GROUP (ORDER BY revenue) OVER () AS p999
    FROM customer_revenue
)
SELECT 
    cr.customer_id,
    cr.revenue,
    CASE
		WHEN cr.revenue >= p999 THEN 'Platinum+'
        WHEN cr.revenue >= p90 THEN 'Platinum'
        WHEN cr.revenue >= p75 THEN 'VIP'
        WHEN cr.revenue >= p50 THEN 'Gold'
        WHEN cr.revenue >= p25 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_segment
FROM customer_revenue cr
CROSS JOIN (SELECT DISTINCT p25, p50, p75, p90, p999 FROM percentiles) p
ORDER BY cr.revenue DESC;

