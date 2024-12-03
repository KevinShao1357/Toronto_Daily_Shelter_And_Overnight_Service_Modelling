#### Preamble ####
# Purpose: Tests the simulated data in the previous script.
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: All previous scripts must be run.
# Any other information needed? None

#### Workspace setup ####
# Read the packages needed to download required data
library(tidyverse)
library(arrow)

# Read the dataset and save it into cleaned_data
simulated_data <- read_parquet("data/00-simulated_data/simulated_data.parquet")

#### Test data ####
# Test that the dataset has 6 columns in total
ncol(simulated_data) == 6

# Test if there are any NA values in the dataset
sum(is.na(simulated_data)) == 0

# Test if the value in count is always less or equal to the value in capacity
all(simulated_data$count <= simulated_data$capacity)

# Check if all elements in the row 'service_type' are included in the ideal set
# of types.
all(simulated_data$service_type %in% c("Shelter", "Warming Centre",
                                     "24-Hour Respite Site", "Top Bunk Contingency Space"))

# Test if all elements in the row 'program_area' are included in the ideal set
# of types.
all(simulated_data$program_area %in% c("Base Program - Refugee", "Winter Programs",
                                     "Base Shelter and Overnight Services System", 
                                     "Temporary Refugee Response"))

# Test if all elements in the row 'classification' are valid
all(simulated_data$classification %in% c("Emergency", "Transitional"))

# Test if all elements in the row 'occupancy_rate' are valid
all(simulated_data$occupancy_rate >= 0)
all(simulated_data$occupancy_rate <= 100)

# Test if all other columns are valid
all(simulated_data$capacity >= 0)
all(simulated_data$count >= 0)

