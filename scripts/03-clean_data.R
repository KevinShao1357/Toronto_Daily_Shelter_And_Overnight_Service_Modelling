#### Preamble ####
# Purpose: Perform the necessary data cleaning process for downloaded raw dataset
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the chosen raw dataset downloaded. All previous scripts 
# must be runn.
# Any other information needed? No

#### Workspace setup ####
# Download the relevant packages needed for downloading required data if
# necessary. If packages are already downloaded, comment out the following lines.
install.packages("janitor")

# Read the packages needed to download required data
library(tidyverse)
library(janitor)
library(arrow)

#### Clean data ####
# Read the raw data file and save it to raw_data
raw_data <- read_csv(file = "data/01-raw_data/raw_data.csv", show_col_types = FALSE)

# Clean names in the dataset
cleaned_data <- clean_names(raw_data)

# Count the number of shelters for each sector
count1 <- sum(cleaned_data$sector == "Men")
count2 <- sum(cleaned_data$sector == "Women")
count3 <- sum(cleaned_data$sector == "Mixed Adult")
count4 <- sum(cleaned_data$sector == "Youth")
count5 <- sum(cleaned_data$sector == "Families")

# Downtown Toronto is the largest city in GTA(Greater Toronto Area), so we only choose
# observations which have city as Toronto for convenience and greater accuracy
cleaned_data <- cleaned_data[cleaned_data$location_city == "Toronto", ]

# The 'Mixed Adult' shelter is most popular, so we only leave the mixed adult shelter.
# Leaving only one sector of shelter will make our final model more accurate
cleaned_data <- cleaned_data[cleaned_data$sector == "Mixed Adult", ]

# Choose the columns needed
cleaned_data <-
  cleaned_data |>
  select(
    x_id,
    occupancy_date,
    overnight_service_type,
    program_area,
    program_model,
    service_user_count,
    capacity_actual_bed,
    occupancy_rate_beds
  )

# Make names easier to understand
cleaned_data <-
  cleaned_data |>
  rename(
    id = x_id,
    date = occupancy_date,
    service_type = overnight_service_type,
    classification = program_model,
    count = service_user_count,
    capacity = capacity_actual_bed,
    occupancy_rate = occupancy_rate_beds
  )

# Ignore all na values of all columns
cleaned_data <-
  na.omit(cleaned_data)

# Delete all values in column occupancy_rate that are not valid, since it must
# be between 0 and 100 to be valid. We ignore all extreme cases.
cleaned_data <- cleaned_data[cleaned_data$occupancy_rate <= 100, ]
cleaned_data <- cleaned_data[cleaned_data$occupancy_rate >= 0, ]

# Check if there are any duplicates of id in our dataset, basically see if there
# are any identical elements or not
any(duplicated(cleaned_data$id))

# There are no duplicates, so we can now delete the id column of the dataset
cleaned_data <-
  cleaned_data |>
  select(
    date,
    service_type,
    program_area,
    classification,
    count,
    capacity,
    occupancy_rate
  )

# The date variable here is only to check whether there is a valid date for each
# row, and so since we already checked this, we can now ignore the date variable
cleaned_data <-
  cleaned_data |>
  select(
    service_type,
    program_area,
    classification,
    count,
    capacity,
    occupancy_rate
  )

#### Save data ####
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")