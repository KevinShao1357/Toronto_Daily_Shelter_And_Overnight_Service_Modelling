#### Preamble ####
# Purpose: Construct a multivariate linear regression model using the cleaned dataset
# Author: Kevin Shao
# Date: 14 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the chosen raw dataset downloaded. All previous scripts 
# must be run.
# Any other information needed? No


#### Workspace setup ####
# Download the relevant packages if necessary. If packages are already 
# downloaded, comment out the following lines.
install.packages("tidyverse")
install.packages("readr")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("arrow")
install.packages("MASS")
install.packages("car")

# Read the necessary packages
library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
library(arrow)
library(MASS)
library(car)

#### Read data ####
# Read the saved parquet file
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
# Construct a multivariate linear regression model
model <- lm(count ~ service_type + program_area + classification + capacity +
              occupancy_rate, data = analysis_data)

# Present the summary statistics of this model
summary(model)

# First calculate residuals for first model
res_first <- residuals(model)

# Also create fitted values for first model
fit_first <- fitted(model)

# Create dataframe for first model
data_first <- data.frame(
  res = res_first,
  fitted = fit_first
)

# Since occupancy rate is equal to count dived by capacity, it is likely to make
# the model more ideal if we add an interaction term between occupancy rate and
# capacity, so let's try.
model2 <- lm(count ~ service_type + program_area + classification + capacity +
               occupancy_rate + capacity:occupancy_rate, data = analysis_data)

# Present the summary statistics of this model
summary(model2)

# Compare the p-value and r-squared of the two models
# We can see that the p-value for both are very low (close to 0), and the r-squared
# for both are close to 1, so both models are very valid. But we also see the second
# model has a lower standard error, so we use the second model with the
# interaction term

# We then check the linear assumptions of our new second model
# First plot a residual versus fitted model
# Calculate residuals
res <- residuals(model2)

# Create fitted values
fit <- fitted(model2)

# Create a data frame that incorporates residuals and fitted values
data <- data.frame(
  residuals = res,
  fitted = fit
)

# Graph the Residuals plot (Residuals VS Fitted). Note that this is a 
# scatter plot
ggplot(data, aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +  # Reference line at 0
  labs(title = "Residual Plot",
       x = "Fitted Values",
       y = "Residuals") +
  theme_minimal()

# The residuals do randomly scatter around 0, so it satisfies linearity (randomly
# scattered), but it violates homoscedasticity, so we log the response variable and try again
model3 <- lm(log(count) ~ service_type + program_area + classification + capacity +
              occupancy_rate + capacity:occupancy_rate, data = analysis_data)

# Graph the residual plot again with the revised model
res3 <- residuals(model3)
fit3 <- fitted(model3)

data3 <- data.frame(
  residuals = res3,
  fitted = fit3
)

ggplot(data3, aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +  # Reference line at 0
  labs(title = "Residual Plot",
       x = "Fitted Values",
       y = "Residuals") +
  theme_minimal()

# Linearity assumption is still violated (since we see a clear pattern), and 
# homoscedasticity also still violated. Therefore, the logged model has no 
# improvement, so we now need to compare the original and the pre-logged model

# Create dataframe of residuals for the first and pre-logged models
residuals_df2 <- data.frame(
  res = res,
  theoretical = qnorm(ppoints(length(res)))
)

residuals_df_first <- data.frame(
  res = res_first,
  theoretical = qnorm(ppoints(length(res_first)))
)
# We graph the qq plot for both the original and pre-logged models
ggplot(residuals_df2, aes(sample = res)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "QQ Plot of Residuals",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

ggplot(residuals_df_first, aes(sample = res_first)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "QQ Plot for Residuals",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

# The two qq plots are both bad-performing, but since there is a logical
# relationship between capacity and occupancy rate, we still choose the
# pre-logged model (preserving the interaction term)

# Now we proceed with the box-cox transformation to get the ideal transformation]
# on the response variable

# Perform box-cox transformation 
boxcox_result <- boxcox(model2, lambda = seq(-2, 2, by = 0.1))

# Find the optimal lambda
optimal_lambda <- boxcox_result$x[which.max(boxcox_result$y)]

# Transform Y and refit the model
if (optimal_lambda == 0) {
  analysis_data$count_transformed <- log(analysis_data$count)
} else {
  analysis_data$count_transformed <- (analysis_data$count^optimal_lambda - 1) / optimal_lambda
}

# Refit the model with the transformed Y
new_model <- lm(count_transformed ~ service_type + program_area + classification + capacity +
                  occupancy_rate + capacity:occupancy_rate, data = analysis_data)

# Get the new model's residuals and fitted values, combine them into a dataframe
# and then create a residuals versus fitted plot
res_new <- residuals(new_model)
fit_new <- fitted(new_model)

data_new <- data.frame(
  residuals = res_new,
  fitted = fit_new
)

ggplot(data_new, aes(x = fitted, y = residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +  # Reference line at 0
  labs(title = "Residual Plot",
       x = "Fitted Values",
       y = "Residuals") +
  theme_minimal()

# First create a new dataframe for residuals of the new model, and then get
# the new model's QQ plot
residuals_df_new <- data.frame(
  res = res_new,
  theoretical = qnorm(ppoints(length(res_new))
  )
)

ggplot(residuals_df_new, aes(sample = res_new)) +
  stat_qq() +
  stat_qq_line(color = "red") +
  labs(title = "QQ Plot of Residuals",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

# From the graphs of the qq plot and residuals versus fitted plot,
# the qq plot is now better, at least only having heavy tails at both ends,
# but most of the data points following the trend marked by the red line now,
# although it still suggests possible violations of normality of errors, implicating
# the possbility of existing outliers at both ends. However, the residuals
# versus fitted plot suggests even stronger heteroscedasticity, and suggests
# we may need to add polynomial terms and delete some influential points, but 
# the larger possibility is that we should use another model, such as nonlinear
# regression models, machine learning methods. We can also make use of
# generalized additive models (GAMs) or random forests, but these models are over
# the scope of my current knowledge, so we just stop here and save the current model.

#### Save model ####
# Now we save this model
saveRDS(
  new_model,
  file = "models/linear_regression_model.rds"
)