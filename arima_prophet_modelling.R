# Time-Series Modeling Script
# Author: Usama Yasir Khan
# Description: This script covers time-series modeling using Prophet, ARIMA, and other techniques for forecasting sales data. It includes data preparation, exploratory data analysis (EDA), and model evaluation.
# Date: 2024-12-21

# --- Content Overview ---
# 1. Load Libraries and Data
# 2. Data Preparation
# 3. Exploratory Data Analysis (EDA)
# 4. Prophet Modeling
# 5. ARIMA Modeling
# 6. Model Evaluation
# 7. Forecast Visualization

# --- 1. Load Libraries and Data ---

# Load necessary libraries
library(tidyverse)
library(lubridate)
library(prophet)
library(forecast)
library(ggplot2)

# Load the dataset
data <- read.csv("online_retail.csv")  # Replace with your dataset path

# --- 2. Data Preparation ---

# Convert invoice date to date format and calculate total revenue
data <- data %>%
  mutate(invoice_date = as.Date(invoice_date),
         total_revenue = quantity * unit_price) %>%
  filter(quantity > 0, unit_price > 0) %>%
  select(invoice_date, total_revenue) %>%
  group_by(invoice_date) %>%
  summarize(total_revenue = sum(total_revenue)) %>%
  ungroup()

# Prepare Prophet-formatted data
prophet_data <- data %>%
  rename(ds = invoice_date, y = total_revenue)

# --- 3. Exploratory Data Analysis (EDA) ---

# Plot time-series data
ggplot(data, aes(x = invoice_date, y = total_revenue)) +
  geom_line(color = "blue") +
  labs(title = "Daily Revenue Over Time", x = "Date", y = "Revenue") +
  theme_minimal()

# --- 4. Prophet Modeling ---

# Split data into training and testing sets
train <- prophet_data[1:floor(0.8 * nrow(prophet_data)), ]
test <- prophet_data[(floor(0.8 * nrow(prophet_data)) + 1):nrow(prophet_data), ]

# Fit Prophet model
prophet_model <- prophet()
prophet_model <- fit.prophet(prophet_model, train)

# Make future dataframe and predictions
future <- make_future_dataframe(prophet_model, periods = nrow(test))
forecast <- predict(prophet_model, future)

# Plot forecast
plot(prophet_model, forecast)

# Plot components
prophet_plot_components(prophet_model, forecast)

# --- 5. ARIMA Modeling ---

# Prepare time-series object
ts_data <- ts(data$total_revenue, frequency = 7)  # Daily data with weekly seasonality

# Fit ARIMA model
arima_model <- auto.arima(ts_data)

# Forecast with ARIMA
arima_forecast <- forecast(arima_model, h = nrow(test))

# Plot ARIMA forecast
autoplot(arima_forecast) +
  labs(title = "ARIMA Forecast", x = "Time", y = "Revenue") +
  theme_minimal()

# --- 6. Model Evaluation ---

# Prophet evaluation
prophet_predictions <- forecast$yhat[(nrow(train) + 1):nrow(forecast)]
prophet_actuals <- test$y
prophet_mae <- mean(abs(prophet_predictions - prophet_actuals))
prophet_rmse <- sqrt(mean((prophet_predictions - prophet_actuals)^2))

# ARIMA evaluation
arima_predictions <- as.numeric(arima_forecast$mean)
arima_actuals <- test$total_revenue
arima_mae <- mean(abs(arima_predictions - arima_actuals))
arima_rmse <- sqrt(mean((arima_predictions - arima_actuals)^2))

# Print evaluation metrics
cat("Prophet MAE:", prophet_mae, "\n")
cat("Prophet RMSE:", prophet_rmse, "\n")
cat("ARIMA MAE:", arima_mae, "\n")
cat("ARIMA RMSE:", arima_rmse, "\n")

# --- 7. Forecast Visualization ---

# Combine Prophet and ARIMA results for comparison
results <- data.frame(
  Date = test$ds,
  Actual = prophet_actuals,
  Prophet_Prediction = prophet_predictions,
  ARIMA_Prediction = arima_predictions
)

# Plot comparison
ggplot(results, aes(x = Date)) +
  geom_line(aes(y = Actual, color = "Actual")) +
  geom_line(aes(y = Prophet_Prediction, color = "Prophet")) +
  geom_line(aes(y = ARIMA_Prediction, color = "ARIMA")) +
  labs(title = "Actual vs Predictions", x = "Date", y = "Revenue") +
  theme_minimal()

# End of Script
