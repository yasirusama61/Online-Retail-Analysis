# ===========================================================
# Exploratory Data Analysis (EDA) Script for Online Retail Data
# Author: Usama Yasir Khan
# Date: 2024-12-16
# Description: 
# This script performs data cleaning, feature engineering, and 
# exploratory data analysis (EDA) on the Online Retail Dataset. 
# It includes visualizations such as revenue trends, top products,
# customer segmentation, and more.
# ===========================================================

# Load Required Libraries
library(tidyverse)    # Data manipulation and visualization
library(lubridate)    # Date-time manipulation
library(janitor)      # Data cleaning
library(ggplot2)      # Plotting
library(scales)       # Scaling for plots
library(cluster)      # Clustering
library(forecast)     # Time-series forecasting
library(plotly)       # Interactive plots
library(maps)         # Geographic mapping

# ===========================================================
# 1. Load and Clean the Data
# ===========================================================
# Read the Online Retail Dataset
data <- readxl::read_excel("Online_Retail.xlsx")

# Data Cleaning
data <- data %>%
  clean_names() %>%                             # Clean column names
  drop_na(customer_id, description) %>%         # Remove rows with missing customer_id or description
  filter(quantity > 0, unit_price > 0) %>%      # Remove rows with negative or zero values
  mutate(total_revenue = quantity * unit_price, # Add Total Revenue column
         invoice_date = as.POSIXct(invoice_date)) # Convert InvoiceDate to POSIXct

# Summary of Cleaned Data
summary(data)

# ===========================================================
# 2. Revenue and Sales Trends
# ===========================================================
# Monthly Revenue Trends
monthly_revenue <- data %>%
  mutate(month = floor_date(invoice_date, "month")) %>%
  group_by(month) %>%
  summarize(total_revenue = sum(total_revenue))

# Plot Monthly Revenue Trends
ggplot(monthly_revenue, aes(x = month, y = total_revenue)) +
  geom_line(color = "blue", size = 1) +
  labs(title = "Monthly Revenue Trends", x = "Month", y = "Total Revenue") +
  theme_minimal()

# Hourly Sales Trends
data_hourly <- data %>%
  mutate(hour = hour(invoice_date)) %>%
  group_by(hour) %>%
  summarize(total_revenue = sum(total_revenue))

# Plot Hourly Sales Trends
ggplot(data_hourly, aes(x = hour, y = total_revenue)) +
  geom_line(color = "blue", size = 1) +
  labs(title = "Sales Trends by Hour of Day", x = "Hour of Day", y = "Total Revenue") +
  theme_minimal()

# ===========================================================
# 3. Top Products and Countries
# ===========================================================
# Top 10 Products by Revenue
top_products <- data %>%
  group_by(description) %>%
  summarize(total_revenue = sum(total_revenue)) %>%
  arrange(desc(total_revenue)) %>%
  slice_head(n = 10)

# Plot Top Products by Revenue
ggplot(top_products, aes(x = reorder(description, total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Top 10 Products by Revenue", x = "Product Description", y = "Total Revenue") +
  theme_minimal()

# Top 10 Countries by Revenue
top_countries <- data %>%
  group_by(country) %>%
  summarize(total_revenue = sum(total_revenue)) %>%
  arrange(desc(total_revenue)) %>%
  slice_head(n = 10)

# Plot Top Countries by Revenue
ggplot(top_countries, aes(x = reorder(country, total_revenue), y = total_revenue)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  coord_flip() +
  labs(title = "Top 10 Countries by Revenue", x = "Country", y = "Total Revenue") +
  theme_minimal()

# ===========================================================
# 4. Customer Segmentation Using RFM
# ===========================================================
# Compute RFM (Recency, Frequency, Monetary)
rfm_data <- data %>%
  group_by(customer_id) %>%
  summarize(recency = as.numeric(Sys.Date() - max(invoice_date)),
            frequency = n_distinct(invoice_no),
            monetary = sum(total_revenue))

# Apply K-Means Clustering
set.seed(123)
rfm_clusters <- kmeans(rfm_data[, c("recency", "frequency", "monetary")], centers = 4)

# Add Cluster Labels
rfm_data$cluster <- as.factor(rfm_clusters$cluster)

# Plot Customer Segmentation
ggplot(rfm_data, aes(x = recency, y = monetary, color = cluster)) +
  geom_point(alpha = 0.7) +
  labs(title = "Customer Segmentation using K-Means",
       x = "Recency (Days Since Last Purchase)",
       y = "Monetary Value") +
  theme_minimal()

# ===========================================================
# 5. Geographic Revenue Distribution
# ===========================================================
# Summarize Revenue by Country
geo_data <- data %>%
  group_by(country) %>%
  summarize(total_revenue = sum(total_revenue))

# Map Revenue Distribution
world_map <- map_data("world")

ggplot() +
  geom_map(data = world_map, map = world_map,
           aes(map_id = region), fill = "grey", color = "white") +
  geom_map(data = geo_data, map = world_map,
           aes(map_id = country, fill = total_revenue)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Revenue") +
  labs(title = "Revenue Distribution by Country") +
  theme_minimal()

# ===========================================================
# 6. Conclusion
# ===========================================================
# This script successfully explores and visualizes:
# - Sales trends (monthly and hourly)
# - Top products and countries by revenue
# - Customer segmentation using RFM analysis
# - Geographic distribution of revenue
# The findings provide key insights into customer behavior, product performance,
# and revenue distribution, laying the groundwork for predictive modeling.
