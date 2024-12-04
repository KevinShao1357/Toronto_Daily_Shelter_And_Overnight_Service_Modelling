#### Preamble ####
# Purpose: Tests the cleaned data
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have a cleaned data that is processed and saved properly. All
# previous scripts must be run.
# Any other information needed? No

#### Workspace setup ####
# Read the packages needed to download required data
library(tidyverse)

# Read the dataset and save it into cleaned_data
cleaned_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Test data ####
# Test that the dataset has 6 columns in total
test_that("Testing number of columns of simulated data", {
  expect_equal(ncol(cleaned_data), 6)
})

# Test if there are any NA values in the dataset
test_that("Testing if there are NA values", {
  expect_equal(all(is.na(cleaned_data)), FALSE)
})

# Test if the value in count is always less or equal to the value in capacity
test_that("Count is always less than or equal to capacity", {
  expect_true(all(cleaned_data$count <= cleaned_data$capacity))
})

# Check if all elements in the row 'service_type' are included in the ideal set
# of types.
service_types = c("Shelter", "Warming Centre", "24-Hour Respite Site", 
                  "Top Bunk Contingency Space")

test_that("All service types are valid", {
  expect_true(all(cleaned_data$service_type %in% service_types))
})

# Test if all elements in the row 'program_area' are included in the ideal set
# of types.
program_areas = c("Base Program - Refugee", "Winter Programs",
                  "Base Shelter and Overnight Services System", 
                  "Temporary Refugee Response")

test_that("All program areas are valid", {
  expect_true(all(cleaned_data$program_area %in% program_areas))
})

# Test if all elements in the row 'classification' are valid
valid_classifcations = c("Emergency", "Transitional")

test_that("All classifications are valid", {
  expect_true(all(cleaned_data$classification %in% valid_classifcations))
})

# Test if all elements in the row 'occupancy_rate' are valid
test_that("Occupancy rate greater or equal to 0", {
  expect_true(all(cleaned_data$occupancy_rate >= 0))
})

test_that("Occupancy rate less or equal to 100", {
  expect_true(all(cleaned_data$occupancy_rate <= 100))
})

# Test if all other columns are valid
test_that("Capacity greater or equal to zero", {
  expect_true(all(cleaned_data$capacity >= 0))
})

test_that("Count greater or equal to zero", {
  expect_true(all(cleaned_data$count >= 0))
})
