#### Preamble ####
# Purpose: Perform the necessary data cleaning process for downloaded raw dataset
# Author: Kevin Shao
# Date: 3 November 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Have the chosen raw dataset downloaded
# Any other information needed? No

#### Workspace setup ####
# Download the relevant packages needed for downloading required data if
# necessary. If packages are already downloaded, comment out the following lines.
install.packages("janitor")

# Read the packages needed to download required data
library(tidyverse)
library(janitor)

#### Clean data ####
# Read the raw data file and save it to raw_data
raw_data <- read_csv(file = "data/raw_data.csv", show_col_types = FALSE)

# Clean names in the dataset
cleaned_data <- clean_names(raw_data)

# Choose the columns needed
cleaned_data <-
  cleaned_data |>
  select(
    x_id,
    occupancy_date,
    location_city,
    sector,
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
    location = location_city,
    classification = program_model,
    count = service_user_count,
    capacity = capacity_actual_bed,
    occupancy_rate = occupancy_rate_beds
  )

# Ignore all na values of all columns
cleaned_data <-
  na.omit(cleaned_data)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data.csv")

