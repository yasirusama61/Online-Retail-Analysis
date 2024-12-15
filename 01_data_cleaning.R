# ----------------------------------------------------------------------------------
# Script Name: 01_data_cleaning.R
# Purpose: This script performs data cleaning and preprocessing for the Online Retail dataset.
#          It includes handling missing values, filtering invalid rows, and creating 
#          new features to prepare the dataset for further analysis.
# Author: Usama Yasir Khan
# Date: 2024-12-15
# ----------------------------------------------------------------------------------

# Load required libraries
library(tidyverse)
library(janitor)
library(lubridate)
library(readxl)

# Description: Load the raw dataset from the data folder
data <- read_excel("data/online_retail.xlsx")
cat("Dataset Overview:")
print(head(data))

# Step 1: Clean Column Names
# Description: Standardize column names for consistency
data <- clean_names(data)
cat("\nColumn Names After Cleaning:\n")
print(colnames(data))

# Step 2: Handle Missing Values
# Description: Remove rows with missing customer IDs to ensure valid transactional data
cat("\nHandling Missing Values...\n")
data <- data %>%
  drop_na(customer_id)

# Step 3: Filter Invalid Rows
# Description: Exclude rows with negative or zero quantities and unit prices
cat("\nFiltering Invalid Rows...\n")
data <- data %>%
  filter(quantity > 0, unit_price > 0)

# Step 4: Add New Features
# Description: Calculate the total revenue for each transaction and parse date-time fields
cat("\nAdding 'total_revenue' Column...\n")
data <- data %>%
  mutate(total_revenue = quantity * unit_price)  # Compute total revenue

cat("\nConverting 'invoice_date' to Date-Time Format...\n")
data <- data %>%
  mutate(invoice_date = as_datetime(invoice_date))

# Step 5: Export Cleaned Data
# Description: Save the cleaned dataset for future use in analysis and modeling
cat("\nExporting Cleaned Data...\n")
write_csv(data, "data/cleaned_data.csv")
cat("\nCleaned data saved as 'cleaned_data.csv'.\n")

# Summary of Cleaned Data
cat("\nSummary of Cleaned Data:\n")
print(summary(data))

# Final Note
cat("\nData Cleaning Completed! The dataset is now ready for analysis.\n")

# ----------------------------------------------------------------------------------
