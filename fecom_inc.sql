CREATE DATABASE FECOM;

USE FECOM;


SELECT *
FROM customer_list
WHERE Customer_Trx_ID IS NULL;

DELETE 
FROM customer_list
WHERE Customer_Trx_ID IS NULL;

SELECT *
FROM customer_list;


SELECT *
FROM orders
WHERE Customer_Trx_ID IN (
	SELECT Customer_Trx_ID
	FROM customer_list);

SELECT *
FROM orders

DELETE 
FROM orders
WHERE Order_Purchase_Timestamp < '2023-01-01' OR Order_Purchase_Timestamp > '2024-08-31'


DELETE FROM order_items
WHERE Order_ID NOT IN (
	SELECT 
		Order_ID 
	FROM orders);

DELETE FROM order_payments
WHERE Order_ID NOT IN (
	SELECT 
		Order_ID 
	FROM orders);

DELETE FROM order_reviews
WHERE Order_ID NOT IN (
	SELECT 
		Order_ID 
	FROM orders);



DELETE FROM sellers_list
WHERE Seller_ID IN (
    SELECT s.Seller_ID
    FROM sellers_list s
    WHERE NOT EXISTS (
        SELECT 1
        FROM order_items oi
        INNER JOIN orders o ON oi.Order_ID = o.Order_ID
        WHERE oi.Seller_ID = s.Seller_ID
          AND o.Order_Purchase_Timestamp >= CAST('2023-01-01' AS DATETIME2)
          AND o.Order_Purchase_Timestamp <= CAST('2024-08-31' AS DATETIME2)
    )
);


DELETE FROM products
WHERE Product_ID IN (
    SELECT p.Product_ID
    FROM products p
    WHERE NOT EXISTS (
        SELECT 1
        FROM order_items oi
        INNER JOIN orders o ON oi.Order_ID = o.Order_ID
        WHERE oi.Product_ID = p.Product_ID
          AND o.Order_Purchase_Timestamp >= CAST('2023-01-01' AS DATETIME2)
          AND o.Order_Purchase_Timestamp <= CAST('2024-08-31' AS DATETIME2)
    )
);


ALTER TABLE products
DROP COLUMN product_weight_gr, product_length_cm, product_height_cm, product_width_cm;


WITH customer_info AS (
SELECT 
	o.Customer_Trx_ID,
	o.Order_Purchase_Timestamp,
	SUM(op.Payment_Value) AS payment

FROM orders AS o
INNER JOIN order_payments AS op
ON o.Order_ID = op.Order_ID
GROUP BY o.Customer_Trx_ID, o.Order_Purchase_Timestamp
)

SELECT 
	MIN(Order_Purchase_Timestamp) AS min_order_date,
	MAX(Order_Purchase_Timestamp) AS max_order_date,
	MIN(payment) AS min_payment,
	AVG(payment) AS avg_payment,
	MAX(payment) AS max_payment,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment) AS p25,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY payment) AS p50,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment) AS p75
FROM customer_info;



WITH customer_info AS (
	SELECT 
		o.Customer_Trx_ID,
		o.Order_Purchase_Timestamp,
		SUM(op.Payment_Value) AS payment
	FROM orders AS o
	INNER JOIN order_payments AS op
		ON o.Order_ID = op.Order_ID
	GROUP BY o.Customer_Trx_ID, o.Order_Purchase_Timestamp
),
percentiles AS (
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment) OVER () AS p25,
		PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY payment) OVER () AS p50,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment) OVER () AS p75,
		PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY payment) OVER () AS p95,
		PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY payment) OVER () AS p99,
		PERCENTILE_CONT(0.999) WITHIN GROUP (ORDER BY payment) OVER () AS p999
	FROM customer_info
)

SELECT 
	(SELECT MIN(Order_Purchase_Timestamp) FROM customer_info) AS min_order_date,
	(SELECT MAX(Order_Purchase_Timestamp) FROM customer_info) AS max_order_date,
	(SELECT MIN(payment) FROM customer_info) AS min_payment,
	(SELECT AVG(payment) FROM customer_info) AS avg_payment,
	(SELECT MAX(payment) FROM customer_info) AS max_payment,
	p.p25,
	p.p50,
	p.p75,
	p.p95,
	p.p99,
	p.p999
FROM (SELECT DISTINCT p25, p50, p75, p95, p99, p999 FROM percentiles) AS p;






WITH customer_spending AS (
    SELECT 
        o.Customer_Trx_ID,
        o.Order_Purchase_Timestamp AS order_date,
        SUM(op.Payment_Value) AS total_spending,
        -- 2024-08-31 referans tarihi olarak kullanýyoruz
        DATEDIFF(day, o.Order_Purchase_Timestamp, '2024-08-31') AS days_from_order_to_end,
        YEAR(o.Order_Purchase_Timestamp) AS order_year,
        MONTH(o.Order_Purchase_Timestamp) AS order_month
    FROM orders AS o
    INNER JOIN order_payments AS op ON o.Order_ID = op.Order_ID
    GROUP BY o.Customer_Trx_ID, o.Order_Purchase_Timestamp
),
customer_segments AS (
    SELECT 
        Customer_Trx_ID,
        order_date,
        total_spending,
        days_from_order_to_end,
        order_year,
        order_month,
        CASE 
            -- Platinum+ (En seçkin müþteriler - ~%1)
            -- En yüksek harcama yapanlar (p999 üzeri)
            WHEN total_spending >= 2400 
            THEN 'Platinum+'
            
            -- Platinum (Çok yüksek deðerli müþteriler - ~%4)
            -- p99 üzeri harcayanlar
            WHEN total_spending >= 1000 
            THEN 'Platinum'
            
            -- VIP (Yüksek deðerli müþteriler - ~%10)
            -- p95 üzeri harcayanlar veya son dönemde yüksek harcama yapanlar
            WHEN total_spending >= 450 
                 OR (total_spending >= 350 AND days_from_order_to_end <= 180) -- Son 6 ayda yüksek harcama
            THEN 'VIP'
            
            -- Gold (Ýyi müþteriler - ~%20)
            -- p75 üzeri harcayanlar veya son dönemde orta-yüksek harcama yapanlar
            WHEN total_spending >= 180 
                 OR (total_spending >= 140 AND days_from_order_to_end <= 120) -- Son 4 ayda iyi harcama
                 OR (total_spending >= 120 AND order_year = 2024) -- 2024'te orta harcama yapanlar
            THEN 'Gold'
            
            -- Silver (Orta segment müþteriler - ~%30)
            -- p25 üzeri harcayanlar veya yakýn zamanda alýþveriþ yapanlar
            WHEN total_spending >= 60 
                 OR (total_spending >= 40 AND days_from_order_to_end <= 90) -- Son 3 ayda alýþveriþ yapanlar
                 OR (order_year = 2024 AND order_month >= 6) -- 2024 ikinci yarýsýnda alýþveriþ yapanlar
            THEN 'Silver'
            
            -- Bronze (Yeni veya düþük harcamalý müþteriler - ~%35)
            ELSE 'Bronze'
        END AS customer_segment
    FROM customer_spending
)
SELECT 
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    MIN(total_spending) AS min_spending,
    AVG(total_spending) AS avg_spending,
    MAX(total_spending) AS max_spending,
    AVG(CAST(days_from_order_to_end AS FLOAT)) AS avg_days_from_order,
    COUNT(CASE WHEN order_year = 2024 THEN 1 END) AS customers_2024,
    COUNT(CASE WHEN order_year = 2023 THEN 1 END) AS customers_2023
FROM customer_segments
GROUP BY customer_segment
ORDER BY 
    CASE customer_segment
        WHEN 'Platinum+' THEN 1
        WHEN 'Platinum' THEN 2
        WHEN 'VIP' THEN 3
        WHEN 'Gold' THEN 4
        WHEN 'Silver' THEN 5
        WHEN 'Bronze' THEN 6
    END;



WITH customer_spending AS (
    SELECT 
        o.Customer_Trx_ID,
        o.Order_Purchase_Timestamp AS order_date,
        SUM(op.Payment_Value) AS payment,
        -- 2024-08-31 referans tarihi olarak kullanýyoruz
        DATEDIFF(day, o.Order_Purchase_Timestamp, '2024-08-31') AS days_from_order_to_end,
        YEAR(o.Order_Purchase_Timestamp) AS order_year,
        MONTH(o.Order_Purchase_Timestamp) AS order_month
    FROM orders AS o
    INNER JOIN order_payments AS op ON o.Order_ID = op.Order_ID
    GROUP BY o.Customer_Trx_ID, o.Order_Purchase_Timestamp
),
customer_segments AS (
    SELECT 
        Customer_Trx_ID,
        order_date,
        payment,
        days_from_order_to_end,
        order_year,
        order_month,
        CASE 
            -- Platinum+ (En seçkin müþteriler - ~%1)
            -- En yüksek harcama yapanlar (p999 üzeri)
            WHEN payment >= 2400 
            THEN 'Platinum+'
            
            -- Platinum (Çok yüksek deðerli müþteriler - ~%4)
            -- p99 üzeri harcayanlar
            WHEN payment >= 1000 
            THEN 'Platinum'
            
            -- VIP (Yüksek deðerli müþteriler - ~%10)
            -- p95 üzeri harcayanlar veya son dönemde yüksek harcama yapanlar
            WHEN payment >= 450 
                 OR (payment >= 350 AND days_from_order_to_end <= 180) -- Son 6 ayda yüksek harcama
            THEN 'VIP'
            
            -- Gold (Ýyi müþteriler - ~%20)
            -- p75 üzeri harcayanlar veya son dönemde orta-yüksek harcama yapanlar
            WHEN payment >= 180 
                 OR (payment >= 140 AND days_from_order_to_end <= 120) -- Son 4 ayda iyi harcama
                 OR (payment >= 120 AND order_year = 2024) -- 2024'te orta harcama yapanlar
            THEN 'Gold'
            
            -- Silver (Orta segment müþteriler - ~%30)
            -- p25 üzeri harcayanlar veya yakýn zamanda alýþveriþ yapanlar
            WHEN payment >= 60 
                 OR (payment >= 40 AND days_from_order_to_end <= 90) -- Son 3 ayda alýþveriþ yapanlar
                 OR (order_year = 2024 AND order_month >= 6) -- 2024 ikinci yarýsýnda alýþveriþ yapanlar
            THEN 'Silver'
            
            -- Bronze (Yeni veya düþük harcamalý müþteriler - ~%35)
            ELSE 'Bronze'
        END AS segment
    FROM customer_spending
)
SELECT 
    Customer_Trx_ID,
    segment,
    payment,
    CASE 
        WHEN segment = 'Platinum+' THEN 1
        WHEN segment = 'Platinum' THEN 2
        WHEN segment = 'VIP' THEN 3
        WHEN segment = 'Gold' THEN 4
        WHEN segment = 'Silver' THEN 5
        WHEN segment = 'Bronze' THEN 6
    END AS segment_order
FROM customer_segments
ORDER BY segment_order, payment DESC;




-- Müþteri Segmentasyon Tablosunu Oluþtur
CREATE TABLE customer_segmentation (
    Customer_Trx_ID NVARCHAR(50),
    segment NVARCHAR(50),
    payment FLOAT,
    segment_order INT
);

-- Tabloyu verilerle doldur
WITH customer_spending AS (
    SELECT 
        o.Customer_Trx_ID,
        o.Order_Purchase_Timestamp AS order_date,
        SUM(op.Payment_Value) AS payment,
        -- 2024-08-31 referans tarihi olarak kullanýyoruz
        DATEDIFF(day, o.Order_Purchase_Timestamp, '2024-08-31') AS days_from_order_to_end,
        YEAR(o.Order_Purchase_Timestamp) AS order_year,
        MONTH(o.Order_Purchase_Timestamp) AS order_month
    FROM orders AS o
    INNER JOIN order_payments AS op ON o.Order_ID = op.Order_ID
    GROUP BY o.Customer_Trx_ID, o.Order_Purchase_Timestamp
),
customer_segments AS (
    SELECT 
        Customer_Trx_ID,
        order_date,
        payment,
        days_from_order_to_end,
        order_year,
        order_month,
        CASE 
            -- Platinum+ (En seçkin müþteriler - ~%1)
            -- En yüksek harcama yapanlar (p999 üzeri)
            WHEN payment >= 2400 
            THEN 'Platinum+'
            
            -- Platinum (Çok yüksek deðerli müþteriler - ~%4)
            -- p99 üzeri harcayanlar
            WHEN payment >= 1000 
            THEN 'Platinum'
            
            -- VIP (Yüksek deðerli müþteriler - ~%10)
            -- p95 üzeri harcayanlar veya son dönemde yüksek harcama yapanlar
            WHEN payment >= 450 
                 OR (payment >= 350 AND days_from_order_to_end <= 180) -- Son 6 ayda yüksek harcama
            THEN 'VIP'
            
            -- Gold (Ýyi müþteriler - ~%20)
            -- p75 üzeri harcayanlar veya son dönemde orta-yüksek harcama yapanlar
            WHEN payment >= 180 
                 OR (payment >= 140 AND days_from_order_to_end <= 120) -- Son 4 ayda iyi harcama
                 OR (payment >= 120 AND order_year = 2024) -- 2024'te orta harcama yapanlar
            THEN 'Gold'
            
            -- Silver (Orta segment müþteriler - ~%30)
            -- p25 üzeri harcayanlar veya yakýn zamanda alýþveriþ yapanlar
            WHEN payment >= 60 
                 OR (payment >= 40 AND days_from_order_to_end <= 90) -- Son 3 ayda alýþveriþ yapanlar
            THEN 'Silver'
            
            -- Bronze (Yeni veya düþük harcamalý müþteriler - ~%35)
            ELSE 'Bronze'
        END AS segment
    FROM customer_spending
)
INSERT INTO Customer_Segmentation (Customer_Trx_ID, segment, payment, segment_order)
SELECT 
    Customer_Trx_ID,
    segment,
    payment,
    CASE 
        WHEN segment = 'Bronze' THEN 1
		WHEN segment = 'Silver' THEN 2
		WHEN segment = 'Gold' THEN 3
		WHEN segment = 'VIP' THEN 4
		WHEN segment = 'Platinum' THEN 5
		WHEN segment = 'Platinum+' THEN 6
    END AS segment_order
FROM customer_segments;

-- Oluþturulan tabloyu kontrol et
SELECT * 
FROM customer_segmentation 
ORDER BY payment;

-- Segment daðýlýmýný görüntüle
SELECT 
    segment,
    segment_order,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    MIN(payment) AS min_payment,
    AVG(payment) AS avg_payment,
    MAX(payment) AS max_payment
FROM Customer_Segmentation
GROUP BY segment, segment_order
ORDER BY segment_order;


SELECT 
	Customer_Trx_ID,
	SUM(Payment_Value) AS payment
FROM orders
INNER JOIN order_payments
ON orders.Order_ID = order_payments.Order_ID
GROUP BY Customer_Trx_ID
ORDER  BY payment;






--True Payment Type Analysis
WITH multiple_payment_orders AS (
    SELECT 
        Order_ID
    FROM order_payments
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT payment_type) > 1
),
single_payment_orders AS (
    SELECT 
        Order_ID
    FROM order_payments
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT payment_type) = 1
)

-- Orders with multiple payment methods
SELECT 
    op.Order_ID,
    STUFF((
        SELECT ', ' + op2.payment_type
        FROM order_payments AS op2
        WHERE op2.Order_ID = op.Order_ID
        GROUP BY op2.payment_type
        FOR XML PATH('')
    ), 1, 2, '') AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN multiple_payment_orders AS mpo
    ON op.Order_ID = mpo.Order_ID
GROUP BY op.Order_ID
UNION ALL
-- Orders with single payment method
SELECT 
    op.Order_ID,
    op.payment_type AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN single_payment_orders AS spo
    ON op.Order_ID = spo.Order_ID
GROUP BY op.Order_ID, op.payment_type
ORDER BY total_payment_value DESC;


CREATE TABLE payment_methods (
    Order_ID NVARCHAR(50),
    payment_methods NVARCHAR(50),
    total_payment_value FLOAT 
);


WITH multiple_payment_orders AS (
    SELECT 
        Order_ID
    FROM order_payments
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT payment_type) > 1
),
single_payment_orders AS (
    SELECT 
        Order_ID
    FROM order_payments
    GROUP BY Order_ID
    HAVING COUNT(DISTINCT payment_type) = 1
)

INSERT INTO payment_methods (Order_ID, payment_methods, total_payment_value)
-- Orders with multiple payment methods
SELECT 
    op.Order_ID,
    STUFF((
        SELECT ', ' + op2.payment_type
        FROM order_payments AS op2
        WHERE op2.Order_ID = op.Order_ID
        GROUP BY op2.payment_type
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN multiple_payment_orders AS mpo
    ON op.Order_ID = mpo.Order_ID
GROUP BY op.Order_ID

UNION ALL

-- Orders with single payment method
SELECT 
    op.Order_ID,
    op.payment_type AS payment_methods,
    SUM(op.payment_value) AS total_payment_value
FROM order_payments AS op
INNER JOIN single_payment_orders AS spo
    ON op.Order_ID = spo.Order_ID
GROUP BY op.Order_ID, op.payment_type;


ALTER TABLE customer_list
ADD Age_Category NVARCHAR(50); 

ALTER TABLE customer_list
ADD Age_Category_Order INT;

UPDATE customer_list
SET Age_Category = CASE 
    WHEN Age < 26 THEN '18-25'
    WHEN Age < 36 THEN '26-35'
    WHEN Age < 46 THEN '36-45'
    WHEN Age < 56 THEN '46-55'
    WHEN Age < 66 THEN '56-65'
    ELSE '65+'
END;

UPDATE customer_list
SET Age_Category_Order = CASE
	WHEN Age_Category = '18-25' THEN 1
	WHEN Age_Category = '26-35' THEN 2
	WHEN Age_Category = '36-45' THEN 3
	WHEN Age_Category = '46-55' THEN 4
	WHEN Age_Category = '56-65' THEN 5
	ELSE 6
END;


SELECT *
FROM customer_list;

SELECT *
FROM customer_segmentation;

SELECT *
FROM geolocations;

SELECT *
FROM order_items;

SELECT *
FROM order_payments;

SELECT *
FROM order_reviews;

SELECT *
FROM orders;

SELECT *
FROM payment_methods;

SELECT *
FROM products;

SELECT *
FROM sellers_list;
