# Fecom-Inc.-Sales-Data-Analysis

## Project Background
Fecom Inc. is a fictional e-commerce marketplace company based in Berlin, Germany. Between 2022 and 2024, it recorded 99,441 orders from 102,727 unique customers and tracked all commercial transactions of 3,095 sellers. This dataset contains commercial data across 338 cities in 28 countries and includes various details about customers and orders, allowing for CRM, sales opportunity, or marketing analysis. The data includes order dates, delivery dates, cart values, shipping costs, order reviews and ratings, payment methods and much more. Since the marketplace is not limited to a specific product, it features 32,951 distinct products across 72 different categories.This project analyzes the available data to gain insight into Fecom Inc.’s performance and includes critical insights that will contribute to the company’s improvement.

Insights and recommendations are provided on the following key areas: 
- 📊 **Sales Trends Analysis**: An evaluation of historical sales patterns, focusing on Revenue, Month Over Month Change, Moving Averages, and 6-Month Revenue Forecast.
- 📦 **Product Level Performance**: An analysis of Fecom Inc's various product lines, understanding their impact on sales and returns.
- 💳 **Customer Demographics**: An analysis of customer income distribution across age groups and gender to uncover demographic trends in revenue generation.
- 🌍 **Regional Comparisons**: An evaluation of sales and orders by customer region.

An Interactive Power BI dashboard can be downloaded [here](https://drive.google.com/drive/folders/1zOMeSxpi79LqGce3ZOB6tDb-YG1m_edx?usp=sharing).

The SQL queries used to prepare and analyze the data can be found [here](https://github.com/fkaya18/Fecom-Inc.-Sales-Data-Analysis/blob/main/fecom_inc_SQLQuery.sql).

## 🗃️ Database Schema
This project contains a relational database schema that models customer and order data from an e-commerce platform. The schema is built on SQL Server and consists of eight main tables along with their relationships.

![Database Schema](fecom_inc_database_diagram.png)

## Important Note:
The dataset description claims that there are 102,727 unique customers. However, when the customer_list csv file was examined, it was seen that there were 99,441 unique customers and the customer_ids of the rest were empty. In addition, this entries were removed from the dataset because they did not match any table.

# Executive Summary
After a significant growth period through 2023, FECOM Inc. has experienced revenue stabilization with some fluctuations in 2024. The dashboard shows monthly revenue consistently reaching around $1M in 2024, representing substantial growth from early 2023 levels when monthly revenue was below $0.5M. Notably, in just the first eight months of 2024, FECOM Inc. has already generated 20% more revenue than in the entire 2023 fiscal year, highlighting the company's remarkable expansion. The month-over-month revenue changes show volatility, with strong positive growth in early 2023 followed by more modest or occasionally negative growth in 2024, suggesting the company has reached a more mature market position.

# Sales Trends

## Revenue Comparison (2023 vs. 2024)
In 2023, revenue started around $200K in January and steadily increased throughout the year, reaching approximately $800K by December. In comparison, 2024 shows consistently higher revenue, maintaining levels between $900K and $1.1M across all months, representing approximately a 100% increase from the previous year's corresponding months.

## Month-over-Month Revenue Change
Early 2023 saw exceptional momentum with growth exceeding 100% in February, followed by consistently positive but gradually decreasing growth rates as the year progressed. By late 2023, this momentum began to slow, with November-December 2023 recording negative growth. The pattern continued into 2024, where the company experienced more modest growth percentages and occasional slight declines, clearly signaling a transition from rapid expansion to market stabilization as the business matured and established its revenue baseline.

## Daily Revenue Trend with Moving Averages
The trend shows a clear upward trend from early 2023 through early 2024, with revenue spikes becoming more pronounced and reaching as high as $180K on peak in November 24th. Both the 3-month and 6-month moving averages demonstrate steady growth throughout 2023, eventually stabilizing around $35-40K daily revenue in 2024. However, a concerning sharp decline is visible at the end of the reporting period in July 2024, warranting immediate investigation to determine whether this represents a temporary anomaly or the beginning of a more significant downturn in business performance.

## Monthly Revenue with 6-Month Forecast
The monthly revenue forecast model projects continued positive growth for FECOM over the next six months, with revenue potentially reaching approximately $1.5M by early 2025. This optimistic outlook is tempered by the widening confidence interval (shown as a purple shaded area) that expands significantly toward the end of the forecast period, indicating increasing uncertainty in these projections as they extend further into the future. Despite recent fluctuations in monthly performance, the overall trajectory suggests the company has potential for continued growth, though leadership should closely monitor performance against these projections to validate the forecast model and adjust strategies accordingly as new data becomes available.

## Data Analysis
🧠 SQL-Based Analysis

A variety of business insights were derived using SQL queries on the cleaned datasets. The analysis focused on identifying customer loyalty patterns, measuring seller performance, and evaluating delivery efficiency by comparing estimated and actual delivery times. Additionally, product categories were ranked based on sales and revenue, while the distribution of payment methods was examined to understand customer preferences. The relationship between customer reviews and ratings was also explored, along with return behaviors across categories. Finally, regional revenue distributions were calculated to highlight city-level income contributions. These findings were later visualized in Power BI through interactive dashboards to support data-driven decision-making.
