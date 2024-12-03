#### Preamble ####
# Purpose: Construct a multivariate linear regression model using the cleaned dataset
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the chosen raw dataset downloaded. All previous scripts 
# must be run.
# Any other information needed? No


#### Workspace setup ####
library(tidyverse)
library(readr)
library(dplyr)
library(janitor)
library(ggplot2)
library(arrow)

#### Read data ####
# Read the saved parquet file
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####
# Construct a multivariate linear regression model
model <- lm(count ~ service_type + program_area + classification + capacity +
              occupancy_rate, data = analysis_data)

# Present the summary statistics of this model
summary(model)

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
# scattered), and almost satisfies homoscedasticity (There is only a very faint
# fan shape).
# Now let's construct a qq plot

# Create dataframe for residuals
residuals_df <- data.frame(
  res2 = res,
  theoretical = qnorm(ppoints(length(res)))
)

# Graph the QQ Plot
ggplot(residuals_df, aes(x = theoretical, y = res2)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Q-Q Plot of Residuals",
       x = "Theoretical Quantiles",
       y = "Sample Quantiles")

# The QQ Plot is also satisfied since residuals align along the diagonal
# Since all linear assumptions are satisfied, we save the model into an RDS file

#### Save model ####
saveRDS(
  model2,
  file = "models/linear_regression_model.rds"
)


