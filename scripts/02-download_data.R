#### Preamble ####
# Purpose: Downloads and saves the data from the corresponding Open Data Toronto
# directory
# Author: Kevin Shao
# Date: 3 December 2024
# Contact: kevin.shao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Find the corresponding Open Data Toronto dataset through
# their official website. All previous scripts must be run.
# Any other information needed? No

#### Workspace setup ####
# Download the relevant packages needed for downloading required data if
# necessary. If packages are already downloaded, comment out the following lines.
install.packages("opendatatoronto")
install.packages("readr")
install.packages("dplyr")

# Read the packages needed to download required data
library(opendatatoronto)
library(tidyverse)
library(dplyr)
library(readr)
library(arrow)

#### Download data ####
# Fetch the raw metadata package of the corresponding resource
package_mdata <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2")

# Filter out any NA values of all its columns
cleaned_mdata <- package_mdata %>%
  filter(!is.na(format) & !is.na(name) & !is.na(id) & !is.na(last_modified))

# Get the specific package wanted
chosen_package <- cleaned_mdata[3,]

# Extract the chosen package id
package_id <- chosen_package$id

# Save the data of the corresponding package id
data <- get_resource(package_id)

#### Save data ####
# Save the data into the desired file of the corresponding directory
write_parquet(data, "data/01-raw_data/raw_data.parquet")