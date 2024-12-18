# =============================================================
# LSTM for Time-Series Forecasting
# Author: Usama Yasir Khan
# Date: 2024-12-18
# Purpose: Forecast sales using LSTM neural networks in R
# =============================================================

# Load Required Libraries
library(keras)
library(tensorflow)
library(dplyr)
library(ggplot2)
library(lubridate)

# -------------------------------------------------------------
# 1. Load and Preprocess the Data
# -------------------------------------------------------------

# Load and clean the data
data <- readxl::read_excel("Online Retail.xlsx") %>%
  clean_names() %>%
  drop_na(quantity, unit_price) %>%
  filter(quantity > 0, unit_price > 0) %>%
  mutate(total_revenue = quantity * unit_price,
         invoice_date = as.POSIXct(invoice_date))

# Inspect data
head(data)

# Ensure the data has two columns: 'ds' (date) and 'y' (target variable)
data <- data %>%
  mutate(ds = as.Date(invoice_date), y = total_revenue) %>%
  group_by(ds) %>%
  summarize(y = sum(y))

# Plot the raw data
ggplot(data, aes(x = ds, y = y)) +
  geom_line(color = "blue") +
  labs(title = "Daily Sales Data", x = "Date", y = "Revenue")

# -------------------------------------------------------------
# 2. Prepare Data for LSTM
# -------------------------------------------------------------

# Normalize data between 0 and 1
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

data$y <- normalize(data$y)

# Convert data to time series
sequence_length <- 30  # Number of time steps to look back
data_matrix <- as.matrix(data$y)

# Function to create sequences
create_sequences <- function(data, seq_length) {
  X <- list()
  y <- list()
  for (i in 1:(length(data) - seq_length)) {
    X[[i]] <- data[i:(i + seq_length - 1)]
    y[[i]] <- data[i + seq_length]
  }
  return(list(X = array(unlist(X), dim = c(length(X), seq_length, 1)),
              y = array(unlist(y), dim = c(length(y), 1))))
}

# Generate sequences
sequences <- create_sequences(data_matrix, sequence_length)
X <- sequences$X
y <- sequences$y

# Split data into train and test sets
train_size <- floor(0.8 * dim(X)[1])
X_train <- X[1:train_size, , ]
y_train <- y[1:train_size]
X_test <- X[(train_size + 1):dim(X)[1], , ]
y_test <- y[(train_size + 1):dim(y)[1]]

# -------------------------------------------------------------
# 3. Build the LSTM Model
# -------------------------------------------------------------

# Initialize a sequential model
model <- keras_model_sequential() %>%
  layer_lstm(units = 50, input_shape = c(sequence_length, 1), return_sequences = FALSE) %>%
  layer_dense(units = 1)

# Compile the model
model %>% compile(
  loss = 'mse',
  optimizer = optimizer_adam(learning_rate = 0.001),
  metrics = list('mae')
)

# Model Summary
summary(model)

# -------------------------------------------------------------
# 4. Train the Model
# -------------------------------------------------------------

# Train the model
history <- model %>% fit(
  x = X_train, y = y_train,
  epochs = 50,
  batch_size = 16,
  validation_split = 0.1,
  verbose = 1
)

# Plot training history
plot(history)

# -------------------------------------------------------------
# 5. Evaluate and Predict
# -------------------------------------------------------------

# Evaluate on test set
model %>% evaluate(X_test, y_test)

# Generate predictions
predictions <- model %>% predict(X_test)

# Denormalize data
denormalize <- function(x, min_val, max_val) {
  x * (max_val - min_val) + min_val
}

min_val <- min(data$y)
max_val <- max(data$y)

predictions_denorm <- denormalize(predictions, min_val, max_val)
y_test_denorm <- denormalize(y_test, min_val, max_val)

# -------------------------------------------------------------
# 6. Visualization
# -------------------------------------------------------------

# Combine actual and predicted values
results <- data.frame(
  Date = data$ds[(train_size + sequence_length + 1):nrow(data)],
  Actual = y_test_denorm,
  Predicted = predictions_denorm
)

# Plot actual vs predicted
ggplot(results, aes(x = Date)) +
  geom_line(aes(y = Actual), color = "blue", size = 1) +
  geom_line(aes(y = Predicted), color = "red", size = 1) +
  labs(title = "LSTM Forecast: Actual vs Predicted",
       x = "Date", y = "Revenue") +
  theme_minimal()

# -------------------------------------------------------------
# End of Script
# -------------------------------------------------------------
