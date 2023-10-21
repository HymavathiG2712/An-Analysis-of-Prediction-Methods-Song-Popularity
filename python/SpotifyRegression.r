library(tidyverse)
library(readr)
library(scales)
library(caret)
library(stats)
library(dplyr)


# Read the CSV file into a dataframe
data <- read_csv('Spotify_data_combined.csv')
data

# Drop duplicates
data <- distinct(data)
data

# Remove the rows where "popularity" equals 0
data <- data %>% filter(popularity != 0)
data

# Replace missing values with the mean of the respective feature
data <- data %>% mutate_all(funs(ifelse(is.na(.), mean(., na.rm = TRUE), .)))
data

data$duration_ms <- data$duration_ms / 60000

# Calculate the first quartile (Q1), third quartile (Q3), and interquartile range (IQR) for 'duration_ms'
q1 <- quantile(data$duration_ms, 0.25)
q3 <- quantile(data$duration_ms, 0.75)
iqr <- q3 - q1

# Calculate the threshold
threshold <- q3 + 1.5 * iqr
threshold

# Filter the dataset to keep only the rows where 'duration_ms' is less than or equal to the threshold
data <- data[data$duration_ms <= threshold,]

# Reset the index of the filtered dataset
row.names(data) <- NULL



# Load required libraries
library(ggplot2)
library(ggcorrplot)

# Calculate the correlation matrix for continuous variables
continuous_vars <- c("popularity", "acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo", "time_signature", "valence")
corr_matrix <- cor(data[, continuous_vars])

# Plot the colorful correlation heatmap
heatmap <- ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower", 
                      lab = TRUE, lab_size = 3, method = "circle", 
                      colors = c("#FF004D", "white", "#00BDFF"), 
                      title = "Correlation Heatmap for Continuous Variables", 
                      ggtheme = theme_minimal())

print(heatmap)


# Perform one-hot encoding on the 'key', 'mode', and 'time_signature' features
data$key <- as.factor(data$key)
key_one_hot <- model.matrix(~key - 1, data = data)
key_one_hot_df <- as.data.frame(key_one_hot)

data$mode <- as.factor(data$mode)
mode_one_hot <- model.matrix(~mode - 1, data = data)
mode_one_hot_df <- as.data.frame(mode_one_hot)

data$time_signature <- as.factor(data$time_signature)
time_signature_one_hot <- model.matrix(~time_signature - 1, data = data)
time_signature_one_hot_df <- as.data.frame(time_signature_one_hot)

# Combine the one-hot encoded columns with the original dataset
data_encoded <- cbind(data, key_one_hot_df, mode_one_hot_df, time_signature_one_hot_df)

# Remove the original 'key', 'mode', and 'time_signature' columns
data_encoded <- data_encoded[, !(colnames(data_encoded) %in% c("key", "mode", "time_signature"))]

# Continuous variables including the one-hot encoded columns and 'popularity'
continuous_vars <- c("popularity", "acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo", "valence", colnames(key_one_hot_df), colnames(mode_one_hot_df), colnames(time_signature_one_hot_df))

# Scale the continuous variables
scaled_data <- scale(data_encoded[, continuous_vars])

# Convert the scaled data to a data frame and rename the columns
df_scaled_std <- as.data.frame(scaled_data)
colnames(df_scaled_std) <- continuous_vars


corr_matrix <- cor(df_scaled_std)

corr_matrix

# calculate the Spearman correlation matrix
corr_matrix <- cor(df_scaled_std, method = "spearman")

corr_matrix


# Load required libraries
library(caret)
library(rpart)

# Set the seed for reproducibility
set.seed(42)

# Split the data into training and testing sets (80% train, 20% test)
split_indices <- createDataPartition(df_scaled_std$popularity, p = 0.8, list = FALSE)
X_train <- df_scaled_std[split_indices, -1]
y_train <- df_scaled_std$popularity[split_indices]

X_test <- df_scaled_std[-split_indices, -1]
y_test <- df_scaled_std$popularity[-split_indices]

# Define the control parameters for cross-validation
control <- trainControl(method = "cv", number = 10, savePredictions = "final")

# Train the Linear Regression model with cross-validation
model_lm_cv <- train(x = X_train, y = y_train, method = "lm", trControl = control)

# Make predictions on the testing data
y_pred_lm_cv <- predict(model_lm_cv, newdata = X_test)

# Evaluate the performance of the Linear Regression model
mse_lm_cv <- mean((y_test - y_pred_lm_cv)^2)
r2_lm_cv <- 1 - (sum((y_test - y_pred_lm_cv)^2) / sum((y_test - mean(y_test))^2))
adj_r2_lm_cv <- 1 - (((1 - r2_lm_cv) * (length(y_test) - 1)) / (length(y_test) - length(X_test) - 1))

# Print the evaluation metrics for the Linear Regression model
cat("Linear Regression\n")
cat("Mean Squared Error:", mse_lm_cv, "\n")
cat("R-squared:", r2_lm_cv, "\n")
cat("Adjusted R-squared:", adj_r2_lm_cv, "\n")
cat("\n")





# Define the control parameters for cross-validation
control <- trainControl(method = "cv", number = 10, savePredictions = "final", search = "grid")

# Create a grid of tuning parameters for Ridge Regression (alpha = 0 for Ridge)
grid_ridge <- expand.grid(alpha = 0, lambda = seq(0.0001, 0.1, length.out = 20))

# Train the Ridge Regression model with cross-validation
model_ridge_cv <- train(x = X_train, y = y_train, method = "glmnet", trControl = control, tuneGrid = grid_ridge)

# Make predictions on the testing data
y_pred_ridge_cv <- predict(model_ridge_cv, newdata = X_test)

# Evaluate the performance of the Ridge Regression model
mse_ridge_cv <- mean((y_test - y_pred_ridge_cv)^2)
r2_ridge_cv <- 1 - (sum((y_test - y_pred_ridge_cv)^2) / sum((y_test - mean(y_test))^2))
adj_r2_ridge_cv <- 1 - (((1 - r2_ridge_cv) * (length(y_test) - 1)) / (length(y_test) - length(X_test) - 1))

# Print the evaluation metrics for the Ridge Regression model
cat("Ridge Regression\n")
cat("Mean Squared Error:", mse_ridge_cv, "\n")
cat("R-squared:", r2_ridge_cv, "\n")
cat("Adjusted R-squared:", adj_r2_ridge_cv, "\n")


# Install required packages
# install.packages("caret")
# install.packages("glmnet")

# Load required libraries
library(caret)
library(glmnet)

# Set the seed for reproducibility
set.seed(42)

# Define the control parameters for cross-validation
control <- trainControl(method = "cv", number = 10, savePredictions = "final", search = "grid")

# Create a grid of tuning parameters for Lasso Regression (alpha = 1 for Lasso)
grid_lasso <- expand.grid(alpha = 1, lambda = seq(0.0001, 0.1, length.out = 20))

# Convert the training data to a matrix format
X_train_matrix <- as.matrix(X_train)

# Train the Lasso Regression model with cross-validation
model_lasso_cv <- train(x = X_train_matrix, y = y_train, method = "glmnet", trControl = control, tuneGrid = grid_lasso)

# Make predictions on the testing data
y_pred_lasso_cv <- predict(model_lasso_cv, newdata = X_test)

# Evaluate the performance of the Lasso Regression model
mse_lasso_cv <- mean((y_test - y_pred_lasso_cv)^2)
r2_lasso_cv <- 1 - (sum((y_test - y_pred_lasso_cv)^2) / sum((y_test - mean(y_test))^2))
adj_r2_lasso_cv <- 1 - (((1 - r2_lasso_cv) * (length(y_test) - 1)) / (length(y_test) - length(X_test) - 1))

# Print the evaluation metrics for the Lasso Regression model
cat("Lasso Regression\n")
cat("Mean Squared Error:", mse_lasso_cv, "\n")
cat("R-squared:", r2_lasso_cv, "\n")
cat("Adjusted R-squared:", adj_r2_lasso_cv, "\n")


# Train the Decision Tree Regression model with cross-validation
model_dt_cv <- train(x = X_train, y = y_train, method = "rpart", trControl = control)

# Make predictions on the testing data
y_pred_dt_cv <- predict(model_dt_cv, newdata = X_test)

# Evaluate the performance of the Decision Tree Regression model
mse_dt_cv <- mean((y_test - y_pred_dt_cv)^2)
r2_dt_cv <- 1 - (sum((y_test - y_pred_dt_cv)^2) / sum((y_test - mean(y_test))^2))
adj_r2_dt_cv <- 1 - (((1 - r2_dt_cv) * (length(y_test) - 1)) / (length(y_test) - length(X_test) - 1))

# Print the evaluation metrics for the Decision Tree Regression model
cat("Decision Tree Regression\n")
cat("Mean Squared Error:", mse_dt_cv, "\n")
cat("R-squared:", r2_dt_cv, "\n")
cat("Adjusted R-squared:", adj_r2_dt_cv, "\n")



#1- Scatter-Plot
library(ggplot2)
continuous_vars <- c("acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo", "valence")

# Create a color vector
colors <- c("red", "blue", "green", "purple", "magenta", "cyan", "yellow", "brown", "pink", "gray", "black")

# Iterate through the continuous_vars and colors vectors
for (i in seq_along(continuous_vars)) {
  var <- continuous_vars[i]
  color <- colors[i]
  plot <- ggplot(df_scaled_std, aes_string(x = var, y = "popularity")) +
    geom_point(color = color, alpha = 0.5) +
    labs(title = paste("Scatter plot of", var, "vs Popularity"), x = var, y = "Popularity") +
    theme_minimal()
  print(plot)
}

library(ggplot2)
continuous_vars <- c("acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo", "valence")

# Create a fill color vector
fill_colors <- c("red", "blue", "green", "purple", "magenta", "cyan", "yellow", "brown", "pink", "gray", "black")

# Iterate through the continuous_vars and fill_colors vectors
for (i in seq_along(continuous_vars)) {
  var <- continuous_vars[i]
  fill_color <- fill_colors[i]
  plot <- ggplot(df_scaled_std, aes_string(x = var)) +
    geom_histogram(color = "black", fill = fill_color, bins = 30) +
    labs(title = paste("Histogram of", var), x = var, y = "Frequency") +
    theme_minimal()
  print(plot)
}


#9
library(ggplot2)
continuous_vars <- c("popularity","acousticness", "danceability", "duration_ms", "energy", "instrumentalness", "liveness", "loudness", "speechiness", "tempo", "valence")

color_palette <- c("#0073C2FF", "#EFC000FF", "#87C55FFF", "#F76C5EFF")

df_scaled_std$order_var <- 1:nrow(df_scaled_std)

for (var in continuous_vars) {
  plot <- ggplot(df_scaled_std, aes_string(x = "order_var", y = var, color = var)) +
    geom_point(alpha = 0.5) +
    scale_color_gradientn(colors = color_palette) +
    labs(title = paste("Scatter plot of", var, "over time"), x = "Time", y = var) +
    theme_minimal()
  print(plot)
}


