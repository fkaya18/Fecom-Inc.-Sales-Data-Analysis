# Fecom-Inc.-Sales-Data-Analysis

## About Dataset
Fecom Inc. is a fictional e-commerce marketplace company based in Berlin, Germany. Between 2022 and 2024, it recorded 99,441 orders from 102,727 unique customers and tracked all commercial transactions of 3,095 sellers. This dataset contains commercial data across 338 cities in 28 countries and includes various details about customers and orders, allowing for CRM, sales opportunity, or marketing analysis. The data includes order dates, delivery dates, cart values, shipping costs, order reviews and ratings, payment methods and much more. Since the marketplace is not limited to a specific product, it features 32,951 distinct products across 72 different categories.

🗃️ Database Schema: market_place_orders
This project contains a relational database schema that models customer and order data from an e-commerce platform. The schema is built on SQL Server and consists of eight main tables along with their relationships.



🔧 Tables and Descriptions
1. geolocations
Stores geographical information based on city and postal code.
Primary Key: Composite key (postal_code, city)
Other fields: latitude, longitude, country

2. customer_list
Contains personal and demographic information about registered customers.
Primary Key: customer_id
Foreign Key: customer_postal_code, customer_city → geolocations

3. sellers_list
Contains information about sellers on the platform.
Primary Key: seller_id
Foreign Key: seller_postal_code, seller_city → geolocations

4. products
Stores information about the products sold.
Primary Key: product_id

5. orders
Each record represents a customer order.
Primary Key: order_id
Foreign Key: customer_id → customer_list

6. order_items
Stores details about products included in each order. One order can have multiple items.
Primary Key: Composite key (order_id, order_item_id)
Foreign Keys:
order_id → orders
product_id → products
seller_id → sellers_list

7. order_payments
Includes payment information for each order.
Primary Key: Composite key (order_id, payment_sequential)
Foreign Key: order_id → orders

8. order_reviews
Contains customer reviews and ratings for each order.
Primary Key: Composite key (review_id, order_id)
Foreign Key: order_id → orders

📥 Data Import
CSV files are imported into SQL Server using BULK INSERT statements. File paths refer to the data_analysis\market_place_orders\ directory within the project. The scripts use the UTF-8 character set and specify appropriate FIELDTERMINATOR values per file
