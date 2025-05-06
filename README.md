# Fecom-Inc.-Sales-Data-Analysis

## Project Background
Fecom Inc. is a fictional e-commerce marketplace company based in Berlin, Germany. Between 2022 and 2024, it recorded 99,441 orders from 102,727 unique customers and tracked all commercial transactions of 3,095 sellers. This dataset contains commercial data across 338 cities in 28 countries and includes various details about customers and orders, allowing for CRM, sales opportunity, or marketing analysis. The data includes order dates, delivery dates, cart values, shipping costs, order reviews and ratings, payment methods and much more. Since the marketplace is not limited to a specific product, it features 32,951 distinct products across 72 different categories.This project analyzes the available data to gain insight into Fecom Inc.’s performance and includes critical insights that will contribute to the company’s improvement.

Insights and recommendations are provided on the following key areas: 
- 📊 **Sales Trends Analysis**: Evaluation of historical sales patterns, focusing on Revenue, Month Over Month Change, Moving Averages, and 6-Month Revenue Forecast.
- 📦 **Product Level Performance**: An analysis of Fecom Inc's various product lines, understanding their impact on sales and returns.
- 💳 **Customer Segmentation**: A revenue-based classification of customers to identify high-value segments and optimize targeted sales strategies.
- 🌍 **Regional Comparisons**: An evaluation of sales and orders by region.

An Interactive Power BI dashboard can be downloaded [here](https://drive.google.com/drive/folders/1zOMeSxpi79LqGce3ZOB6tDb-YG1m_edx?usp=sharing).

The SQL queries used to prepare and analyze the data can be found [here](https://github.com/fkaya18/Fecom-Inc.-Sales-Data-Analysis/blob/main/fecom_inc_SQLQuery.sql).

## 🗃️ Database Schema
This project contains a relational database schema that models customer and order data from an e-commerce platform. The schema is built on SQL Server and consists of eight main tables along with their relationships.

![Database Schema](fecom_inc_database_diagram.png)

## Important Note:
The dataset description claims that there are 102,727 unique customers. However, when the customer_list csv file was examined, it was seen that there were 99,441 unique customers and the customer_ids of the rest were empty. In addition, this data was removed from the dataset cluster because it did not match any table.

# Executive Summary


## Data Analysis
🧠 SQL-Based Analysis

A variety of business insights were derived using SQL queries on the cleaned datasets. The analysis focused on identifying customer loyalty patterns, measuring seller performance, and evaluating delivery efficiency by comparing estimated and actual delivery times. Additionally, product categories were ranked based on sales and revenue, while the distribution of payment methods was examined to understand customer preferences. The relationship between customer reviews and ratings was also explored, along with return behaviors across categories. Finally, regional revenue distributions were calculated to highlight city-level income contributions. These findings were later visualized in Power BI through interactive dashboards to support data-driven decision-making.
