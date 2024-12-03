#### Preamble ####
# Purpose: Simulates the dataset provided by Open Data Toronto about Daily Shelter
# and Overnight Service Occupancy and Capacity with only necessary columns
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed. 
# Any other information needed? None


#### Workspace setup ####
# Download the relevant packages needed for downloading required data if
# necessary. If packages are already downloaded, comment out the following lines.
install.packages("tidyverse")

# Load the necessary packages and ensure reproducibility
library(tidyverse)
set.seed(853)

#### Simulate data ####
# (We should check the cleaned dataset first here, so run the clean_data
# and test_analysis_data here first, so we can determine the set of values that
# can be reached for each necessary variable)

# We first simulate 2000 observations, then only save the valid ones.
# Here, we will assume all probabilities to be equal for convenience.

# Simulate the program_model column, which is either 'Emergency' or 'Transitional'
Col_ProgramModel <- sample(c("Emergency", "Transitional"), size = 2000, replace = TRUE)

# Simulate the occupancy_rate column
Col_OccupancyRate <- runif(2000, min = 0, max = 100)

# Simulate the count and capacity respectively. We already checked the maximum
# of the capacity as 150 for all satisfied shelters, and for each observation,
# the count should be less or equal to the capacity.
Col_Count <- sample(-1:151, size = 2000, replace = TRUE)
Col_Capacity <- sample(-1:151, size = 2000, replace = TRUE)

# Simulate the final program_area and service_type columns.
Col_ProgramArea <- sample(c("Base Program - Refugee", "Winter Programs",
                            "Base Shelter and Overnight Services System", "Temporary Refugee Response"),
                          size = 2000, replace = TRUE)
Col_ServiceType <- sample(c("Shelter", "Warming Centre", "24-Hour Respite Site",
                            "Top Bunk Contingency Space"), size = 2000, 
                          replace = TRUE)

# Combine them into one data frame
simulated_data <- data.frame(service_type = Col_ServiceType,
                             program_area = Col_ProgramArea,
                             count = Col_Count,
                             classification = Col_ProgramModel,
                             capacity = Col_Capacity,
                             occupancy_rate = Col_OccupancyRate)

# Filter the data frame so that it ignores any observations where 
# count is greater than capacity
simulated_data <- simulated_data[simulated_data$count <= simulated_data$capacity, ]

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
