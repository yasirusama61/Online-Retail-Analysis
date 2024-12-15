# 🌟 Online Retail Analysis 📊
![R Version](https://img.shields.io/badge/R-v4.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Project-Active-brightgreen.svg)
![Contributions](https://img.shields.io/badge/Contributions-Welcome-orange.svg)

> Unlock valuable insights and improve decision-making with advanced data analysis and predictive modeling using the **Online Retail Dataset**.  

---

## 🚀 Project Overview  
This project demonstrates an end-to-end data science workflow using the **Online Retail Dataset**. From cleaning messy data to forecasting sales and segmenting customers, the project combines statistical analysis, machine learning, and visualization to deliver actionable insights.

---

## 🎯 Objectives
- 🔍 **Data Cleaning**: Prepare raw data for reliable analysis.  
- 📈 **EDA**: Identify trends in sales and customer behavior.  
- 📊 **Forecasting**: Predict future sales with time-series models.  
- 🛒 **Customer Segmentation**: Classify customers based on purchase behavior.  
- 📊 **Interactive Dashboard**: Visualize trends and predictions with Shiny.  

---

## 📂 Dataset Information
**Source**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail)  
**Content**:
- 🧾 `InvoiceNo`: Unique transaction code.  
- 📦 `StockCode`: Product identifier.  
- 📝 `Description`: Product description.  
- 🔢 `Quantity`: Number of products purchased.  
- 📅 `InvoiceDate`: Date and time of transaction.  
- 💰 `UnitPrice`: Price per unit of product.  
- 🆔 `CustomerID`: Unique customer ID.  
- 🌍 `Country`: Customer location.

---

## 🛠️ Tools and Technologies
| **Category**         | **Tools Used**                                     |
|-----------------------|---------------------------------------------------|
| **Languages**         | ![R](https://img.shields.io/badge/-R-blue?logo=r) |
| **Visualization**     | `ggplot2`, `plotly`, `shiny`                      |
| **Data Wrangling**    | `dplyr`, `janitor`, `tidyverse`, `lubridate`      |
| **Forecasting**       | `forecast`, `prophet`                             |
| **Customer Analysis** | `caret`, `cluster`, `factoextra`                  |

---

## 🔧 Project Workflow  
1. **Data Cleaning**  
   - Handle missing values and invalid data.  
   - Generate new features like total revenue.  

2. **Exploratory Data Analysis (EDA)**  
   - Visualize trends, top products, and country-wise sales.  

3. **Sales Forecasting**  
   - Use ARIMA and Prophet for predicting future revenue.  

4. **Customer Segmentation**  
   - Perform RFM analysis to classify customers into loyalty tiers.  

5. **Interactive Dashboard (Optional)**  
   - Build a Shiny app to showcase key insights dynamically.

---

## **3. Exploratory Data Analysis (EDA)** 📊

Exploratory Data Analysis (EDA) was conducted to uncover insights into sales performance, top products, and revenue trends over time.

---

### **3.1 Top 10 Countries by Revenue**
The chart below highlights the top-performing countries by total revenue, with the **United Kingdom** contributing the most significantly.

![Top 10 Countries by Revenue](plots/top_countries_revenue.png)

---

### **3.2 Top 10 Products by Total Revenue**
The following plot shows the **top 10 products** that generated the highest revenue.  
The product **"REGENCY CAKESTAND 3 TIER"** dominates as the top-selling item.

![Top 10 Products by Total Revenue](plots/top_products_revenue.png)

---

### **3.3 Monthly Revenue Trends**
This time-series plot displays the **monthly revenue trends** throughout the year.  
There is a noticeable **increase in revenue** during the last quarter, followed by a steep drop, likely indicating incomplete December data.

![Monthly Revenue Trends](plots/monthly_revenue_trends.png)

---

### **3.4 Distribution of Recency (Customer Segmentation)**
The distribution of **recency** – days since a customer's last purchase – shows important insights into customer activity.

![Distribution of Recency](plots/recency_distribution.png)

**Key Insights**:
1. **Majority of Customers are Inactive**:
   - A significant portion of customers have not made a purchase in a long time, indicating potential churn.

2. **Skewed Distribution**:
   - Most customers have high recency values (inactive), while very few have low recency values (recent activity).

3. **Retention Opportunity**:
   - Customers with high recency values can be targeted with **re-engagement campaigns** to revive interest.
   - Recent customers should be incentivized to ensure continued loyalty.

---

### **Summary of EDA**:
- The **United Kingdom** is the top-performing country by revenue.
- **"REGENCY CAKESTAND 3 TIER"** is the best-selling product.
- There’s a sharp revenue increase in the last quarter of the year.
- Recency analysis reveals opportunities to improve **customer retention** by targeting inactive customers.

---

## 💻 Installation and Usage
1. **Clone the repository**:
   ```bash
   git clone https://github.com/yasirusama61/online-retail-analysis.git

2. **Install required R packages**:
   ```bash
   install.packages(c("tidyverse", "janitor", "lubridate", "ggplot2", "readxl", "forecast", "prophet"))

3. **Run the scripts**:
   Navigate to the notebooks/ folder to execute individual analysis steps.
   For the Shiny dashboard, open and run shiny_dashboard/app.R.
