# Fecom-Inc.-Sales-Data-Analysis

## Project Background
Fecom Inc. is a fictional e-commerce marketplace company based in Berlin, Germany. Between 2023 and 2024, it recorded 99,092 orders from 99,092 unique customers and tracked all commercial transactions of 3,068 sellers. This dataset contains commercial data across 265 cities in 27 countries and includes various details about customers and orders, allowing for CRM, sales opportunity, or marketing analysis. The data includes order dates, delivery dates, cart values, shipping costs, order reviews and ratings, payment methods and much more. Since the marketplace is not limited to a specific product, it features 32,787 distinct products across 72 different categories.This project analyzes the available data to gain insight into Fecom Inc.’s performance and includes critical insights that will contribute to the company’s improvement.

Additional information about the dataset and raw dataset can be retrieved [here](https://www.kaggle.com/datasets/cemeraan/fecom-inc-e-com-marketplace-orders-data-crm?phase=FinishSSORegistration&returnUrl=%2Fdatasets%2Fcemeraan%2Ffecom-inc-e-com-marketplace-orders-data-crm%2Fversions%2F1%3Fresource%3Ddownload&SSORegistrationToken=CfDJ8KT8tnOr7fFFm_byYmusL7gA2ZzwD8Pki8IzeQ1TU1WYFOE4ppQMlE01SJlL49iWCAaGTIiug71m4sXl616IXNx8AJ78BdGiX-mDypUIWV0YaAyi5SNpKf0R-s9lxtWJr7aNCQxJzlLsw0t7DKYcKxJbl3wqfk30zYoWILkQKD1NVvyK2moXK2F8sFkCfV0Vx9J9b7SDdwrapgB-6xD9pNxsRIwZaLSd2aKcxSXm_Pg2oGRaBnghYnSs2AjdTZy3bPbpVpSU0fGGstMpeEmqG8ljUoTgWfnRRe2EcNmdNr35LaM3xUlE85Tu1cxhczs8M_Grf-3kEbBVMm8IyDKO5Jg39xddKqap&DisplayName=Furkan+Kaya&select=Fecom+Inc+Geolocations.csv)


Insights and recommendations are provided on the following key areas: 
- 💳 **Customer Demographics and Segmentation**: A detailed breakdown of customer age and gender in relation to revenue, along with a segmentation based on spending behavior to identify high- and low-value customer groups.
- 📦 **Seller and Product Performances**: An analysis of Fecom Inc's various product lines and sellers, understanding their impact on sales and returns.
- 📦 **Payment, Delivery and Reviews**: An evaluation of transaction values and delivery times to identify patterns, delays, and their impact on customer satisfaction and operational efficiency.
- 📊 **Sales Trends Analysis**: An evaluation of historical sales patterns, focusing on Revenue, Month Over Month Change, Moving Averages.


An Interactive Power BI dashboard can be downloaded [here](https://drive.google.com/drive/folders/1zOMeSxpi79LqGce3ZOB6tDb-YG1m_edx?usp=sharing).

The SQL queries used to clean, validate and analyze the dataset can be found [here](https://github.com/fkaya18/Fecom-Inc.-Sales-Data-Analysis/blob/main/fecom_inc.sql).

All of the cleaned and newly created data that are used to analyze the dataset and create charts can be found [here](https://github.com/fkaya18/Fecom-Inc.-Sales-Data-Analysis/tree/main/cleaned_data)

## 🗃️ Database Schema
This project contains a relational database schema that models customer and order data from an e-commerce platform. The schema is built on SQL Server and consists of eight main tables along with their relationships.

![Database Schema](images/database_diagram.png)


# Executive Summary

## Overview of Findings

Fecom Inc. demonstrated strong overall performance during the May 2023 to August 2024 period, generating $15.9 million in total revenue from 99,092 orders with an average order value of $160.9. After achieving peak performance in November 2023 (7,544 orders, $1.19M revenue), the company has shown volatile monthly performance with an overall declining trend from the peak levels, with August 2024 recording 6,292 orders and $1.02M revenue. However, year-over-year analysis reveals robust fundamental growth, with August 2024 showing 50.3% increase in orders and 51.6% revenue growth compared to August 2023.

The Power BI dashboard overview pages are shown below, and the report has additional examples. You can download the full interactive dashboard [here](https://drive.google.com/drive/folders/1zOMeSxpi79LqGce3ZOB6tDb-YG1m_edx?usp=sharing).

<p align="center">
  <img src="images/sales.png" alt="Executive Summary" width="400"/>
  <img src="images/trends.png" alt="Sales Summary" width="400"/>
</p>


# Customer Demographics and Segmentation

* **Gender Distribution:** The customer base shows a slight male preference with 56.58% male customers (56,070) compared to 43.42% female customers (43,022), indicating broad market appeal across both demographics.

* **Age Demographics:** Prime purchasing demographics dominate the customer base, with the 36-45 age group representing the largest segment at 30.69% (30.4K customers), followed by the 26-35 age group at 21.46% (21.3K customers), collectively representing 52% of the total customer base.

* **Geographic Market Performance:** As a German-based company, Fecom Inc. shows strong performance across European markets with Germany maintaining the largest customer base, followed by France as the second-largest market, with significant presence in Netherlands, Belgium, Austria, and United Kingdom.

* **Customer Segmentation Success:** The tiered customer segmentation strategy demonstrates exceptional effectiveness, with a clear value progression from Bronze customers averaging $41.0 spend to Platinum+ customers reaching $3,384.3 average spend, indicating successful customer lifetime value optimization and upselling capabilities.

* **Conversion Opportunity:** The average time to first order of 72.36 days presents a significant opportunity for conversion funnel optimization to accelerate customer acquisition and reduce the lengthy decision-making cycle.

* **High-Value Customer Profile:** The top spending customer exemplifies the company's premium market positioning, with a 23-year-old male from Paris, France contributing $13,664 in total spending, demonstrating the significant revenue potential from young professional demographics in key European metropolitan markets.

* **Segment Distribution Balance:** Customer distribution across segments shows a healthy pyramid structure with Bronze representing the largest volume (43,588 customers), followed by Silver (28,530 customers) and Gold (4,880 customers), while premium segments (VIP, Platinum, Platinum+) maintain smaller but high-value customer bases totaling 2,239 customers, indicating effective customer journey progression.

* **Gender-Based Revenue Patterns:** Revenue analysis reveals distinct spending patterns across segments and gender, with Gold segment generating the highest total revenue at $6.16M, followed by Silver at $4.2M and VIP at $2.87M, while male customers consistently demonstrate higher spending volumes across most segments, particularly in mid-tier categories.

![Customers](images/customers.png)


# Sellers and Product Performance

* **Top Product Performance:** The best-selling products by volume show diverse category representation, with Bed_Bath_Table product (99a4788cb24856965) leading at 488 units sold, while Garden_Tools category dominates the list with 4 out of 7 products, indicating strong customer demand concentration in home and garden segments across different individual products.

* **Seller Revenue Concentration:** GlobalDynamics ($253.37K) and AlphaLabs ($248.76K) lead the marketplace, while emerging sellers like NovaLabs represent untapped growth potential, suggesting opportunities for seller development programs.

* **Category Growth Dynamics:** Health_Beauty shows explosive 140% growth (from $0.6M to $1.44M), while underperforming categories like Cds_Dvds_Musicals and Fashion_Childrens_Clothes indicate strategic optimization needs.

* **Geographic Expansion:** Strong European seller presence with growth opportunities in emerging markets like Sweden, Serbia, Slovenia, and Estonia for market penetration strategies.

* **Profitability Mix:** Premium categories like Computers ($1,182 average) drive profitability, while volume leaders like Bed_Bath_Table (11,107 units) and Health_Beauty (9,619 units) ensure transaction frequency and market penetration

![Sellers and Products](images/sellers_and_products.png)


# Payment, Delivery and Reviews

* **Customer Satisfaction:** Strong 4.09/5 average review score indicates high customer satisfaction, with quick 2.58-day response time to customer inquiries demonstrating excellent customer service capabilities.

* **Delivery Performance:** Exceptional 90.49% on-time delivery rate with 12.52-day average delivery time shows reliable logistics operations, though 6.59% late deliveries and 2.91% non-delivered orders present improvement opportunities.

* **Seasonal Delivery Patterns:** February shows highest delivery times (16.58 days) while August achieves fastest delivery (8.99 days), indicating seasonal capacity management challenges requiring operational optimization.

* **Delivery Quality Impact:** Review scores correlate strongly with delivery speed, dropping from 4.24 for 0-9 day deliveries to 1.77 for non-delivered orders, highlighting delivery performance as a critical satisfaction driver.

* **Order Fulfillment:** Strong order completion with 96,211 delivered orders (97.1% of total), while 580 canceled and 602 unavailable orders indicate minimal fulfillment issues.

* **Payment Method Preferences:** Credit cards dominate at 74.69% usage ($12.3M revenue), followed by debit cards at 19.90% ($2.9M), showing customer preference for traditional payment methods over alternative options like vouchers (1.61%) and prepaid cards (1.54%).

* **Delivery Status Reviews:** On-time deliveries achieve highest satisfaction (4.29 rating) compared to late deliveries (2.27) and non-delivered orders (1.77), emphasizing delivery reliability as key to customer retention.

![Payment, Delivery and Reviews](images/payment_delivery_reviews.png)


# Sales Trends 

* **Overall Performance:** Strong business performance with 99,092 total orders generating $15.94M revenue at $160.9 average order value, with peak performance on 11/24/2023 (Black Friday) achieving 1,176 orders and $179,200 revenue in a single day.

* **Seasonal Revenue Patterns:** Clear seasonality emerges with Q4 2023 showing exceptional performance (November: $1.19M), while 2024 demonstrates consistent growth with March ($1.61M) and July ($1.66M) as peak months, indicating successful business expansion.

* **Order Volume Trends:** Monthly order patterns show 2023 peak in November (7,544 orders) followed by steady 2024 performance, with March (7,211 orders) and July (6,292 orders) leading, while weekday analysis reveals Tuesday as the strongest sales day (16,199 orders).

* **Average Order Value Dynamics:** AOV demonstrates stability around $160-170 range with notable fluctuations, showing decline from $173.1 (January 2023) to $159.2 (July 2024), suggesting potential pricing pressure or customer behavior shifts requiring strategic attention.

* **Month-over-Month Growth:** Mixed MoM performance with strong revenue growth indicators in early 2024 (March: +$1.16M MoM), while later months show declining trends, indicating need for sustained growth momentum strategies.

* **Revenue Trend Analysis:** 3-month moving average shows consistent upward trajectory from $20K baseline to $40K+ levels, demonstrating strong business fundamentals and growth sustainability despite short-term fluctuations.

* **Order Count vs. Value Correlation:** Inverse relationship visible between order volume and average order value, with higher volume months (9K-11K orders) corresponding to lower AOV ($155-165), suggesting volume-driven promotional strategies impact pricing dynamics.

<p align="center">
  <img src="images/sales.png" alt="Executive Summary" width="400"/>
  <img src="images/trends.png" alt="Sales Summary" width="400"/>
</p>



# Key Insights
* **Sustained Growth:** FECOM Inc. has achieved impressive year-over-year revenue growth, approximately doubling revenue when comparing 2023 to 2024, with the first eight months of 2024 already exceeding total 2023 revenue by 20%.
* **Market Maturity:** The slowing month-over-month growth rates in 2024 suggest the company is reaching a more mature market position after rapid expansion in 2023.
* **Stabilization Phase:** Daily and monthly revenue figures in 2024 show a stabilization phase around the $1M monthly revenue mark.
* **Concerning Recent Decline:** The sharp drop visible at the end of the daily revenue chart requires immediate investigation as it could signal the beginning of a significant downturn.
* **Geographic Concentration:** Germany represents FECOM's strongest market by a significant margin, with Berlin generating the highest city-level revenue, followed by other major German urban centers.
* **Product Category Strengths:** Health & Beauty, Watches & Gifts, and home-related categories dominate sales, indicating areas of core competency that could be further leveraged.
* **Customer Demographics:** The 36-45 age bracket generates the highest revenue, with male customers slightly outspending female customers across most age segments.
* **Customer Segmentation Value Analysis:** While the Platinum segment (9.9% of customers) serves as the revenue cornerstone by generating 36.12% of total revenue ($5.76M), the ultra-premium Platinum+ tier delivers exceptional individual value ($3,384.34 per customer) despite its limited collective contribution (2.14%), highlighting the strategic importance of balancing segment-specific growth initiatives with the segment's relative size and stability characteristics.
* **Payment Preferences:** Credit cards dominate payment methods (74.7%), indicating potential opportunities to diversify payment options to attract different customer segments.
* **Delivery Performance:** While 90.5% of orders are delivered on time with high satisfaction (4.29/5), 2.9% of orders are never delivered at all, resulting in extremely low satisfaction scores (1.77/5) and representing a critical service failure point.
* **Customer Service Response Gap:** The slowest customer service response times (2.86 days) are associated with undelivered orders—precisely where faster interventions are most needed to recover customer goodwill.
* **Geographic Market Concentration:** FECOM Inc. demonstrates strong German market dominance with 7 of 8 top-selling companies originating from Germany, likely due to the company's German roots.

# Recommendations
* Implement **targeted email campaigns** and **remarketing strategies** to reduce the **72.36-day average time to first order** and accelerate conversion funnel optimization

* Develop **segment-specific loyalty programs** and incentives tailored to each customer tier (**Bronze to Platinum+**) to maximize customer lifetime value progression

* Create **specialized campaigns for young professionals** based on the highest-spending customer profile (**23-year-old male from Paris generating $13,664**) to tap into metropolitan market potential

* Expand **female-focused product categories** to increase the **43.42%** female customer base and achieve better gender balance in the marketplace

* Capitalize on **Health_Beauty category's 140% growth** by increasing product diversity and inventory in this high-performing segment

* **Restructure underperforming categories** like **Cds_Dvds_Musicals** and **Fashion_Childrens_Clothes** through product mix optimization or category consolidation

* **Expand Garden_Tools inventory** significantly as 4 out of 7 top-selling products belong to this category, indicating strong market demand

* Strengthen **premium categories like Computers** (**$1,182 average AOV**) to drive profitability while maintaining volume leaders like **Bed_Bath_Table**

* Develop **local partnerships and marketing campaigns** in **France**, **the second-largest market**, to strengthen market penetration

* Establish **regional distribution centers** across Europe to optimize delivery times and reduce operational costs

* Implement **seasonal capacity planning** to address **February's** high delivery times (**16.58 days**) and maintain **August's** efficiency (**8.99 days**)

* Reduce **late delivery rate from 6.59% to below 3%** through process improvements and logistics optimization

* **Minimize unavailable order rate of 2.91%** by implementing advanced demand forecasting systems and inventory management

* Create **seller development programs** with mentorship and growth support for emerging sellers like **NovaLabs** to expand marketplace diversity

* Design **exclusive benefits and retention programs** for **top sellers** (**GlobalDynamics $253.37K, AlphaLabs $248.76K**) to maintain marketplace leadership

* Develop **comprehensive onboarding and training programs for new sellers** to improve overall marketplace quality and performance

* Reverse **AOV decline from $173.1 to $159.2** through strategic bundle offers, cross-selling initiatives, and upselling campaigns

* **Diversify payment methods beyond credit cards (74.69% usage)** by implementing digital wallets, BNPL options, and regional payment preferences

* Deploy **dynamic pricing algorithms** based on seasonal trends and demand patterns to optimize revenue throughout the year

* Build **predictive analytics models** for customer lifetime value prediction and churn prevention to improve retention strategies

* Implement **AI-powered personalization engine** to deliver customized product recommendations based on customer behavior and preferences

* Leverage **Tuesday's peak performance (16,199 orders)** by scheduling major promotions and product launches on this high-conversion day

* Address **delivery performance correlation** with review scores (**4.24 for fast delivery vs 1.77 for non-delivery**) through logistics excellence initiatives

* Optimize **Black Friday performance** (**$179,200 revenue peak**) by preparing scalable infrastructure and inventory management for high-demand periods


# Assumptions and Caveats
The dataset description claims that there are 102,727 unique customers. However, when the dataset containing customer information was examined, 99441 unique customer ID data entries were found, and the remaining 3286 entries were removed from the dataset because they could not be matched with other datasets. Although the dataset contains sales data between 9/4/2022 and 10/17/2024, in order to obtain logical results while preparing the report, the date was pulled to 1/5/2023 and 8/31/2024 because there were too many missing date ranges, and the comments were made considering only these dates. Similar analyses to those in the reports created using Power BI were also performed in SQL Server, and the Customer_Segment and Payment_Method datasets used were created using SQL Server.
