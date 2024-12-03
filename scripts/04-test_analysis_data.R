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
cleaned_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Test data ####
# Test that the dataset has 6 columns in total
ncol(cleaned_data) == 6

# Test if there are any NA values in the dataset
sum(is.na(cleaned_data)) == 0

# Test if the value in count is always less or equal to the value in capacity
all(cleaned_data$count <= cleaned_data$capacity)

# Check the maximum capacity for simulation purposes
max(cleaned_data$capacity)

# Test if all elements in the row 'service_type' are valid. First check
# all the unique values in this row, and then check using a test again
unique_values <- unique(cleaned_data$service_type)
print(unique_values)

all(cleaned_data$service_type %in% c("Shelter", "Warming Centre",
                                     "24-Hour Respite Site", "Top Bunk Contingency Space"))

# Test if all elements in the row 'program_area' are valid. Use same procedure
# as the one above. This procedure is used because some values are not as
# presented in the Open Data Toronto because I limited the observations only to
# Downtown Toronto.
unique_values2 <- unique(cleaned_data$program_area)
print(unique_values2)

all(cleaned_data$program_area %in% c("Base Program - Refugee", "Winter Programs",
                                     "Base Shelter and Overnight Services System", 
                                     "Temporary Refugee Response"))

# Test if all elements in the row 'classification' are valid
all(cleaned_data$classification %in% c("Emergency", "Transitional"))

# Test if all elements in the row 'occupancy_rate' are valid
all(cleaned_data$occupancy_rate >= 0)
all(cleaned_data$occupancy_rate <= 100)

# Test if all other columns are valid
all(cleaned_data$capacity >= 0)
all(cleaned_data$count >= 0)