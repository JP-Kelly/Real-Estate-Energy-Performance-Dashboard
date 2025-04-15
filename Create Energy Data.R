# This R script will generate a dummy energy dataset, taking into account seasonal variations in energy usage and different property sizes

# Clear environment
rm(list=ls())


# Load necessary libraries
library(dplyr)
library(lubridate)

# Read in properties data
properties <- read.csv("path to co-ordinates data file goes here")

# Set a seed for reproducibility
set.seed(42)

# Define function to simulate daily energy usage with precise monthly adjustments
generate_energy_data <- function(property_id, size) {
  
  # Define seasonal baselines based on property size
  gas_baseline <- case_when(
    size == "small" ~ 20,
    size == "medium" ~ 30,
    size == "large" ~ 40
  )
  elec_baseline <- case_when(
    size == "small" ~ 15,
    size == "medium" ~ 22,
    size == "large" ~ 30
  )
  infrared_baseline <- case_when(
    size == "small" ~ 10,
    size == "medium" ~ 15,
    size == "large" ~ 20
  )
  
  # Daily usage rates with monthly adjustments
  dates <- seq.Date(as.Date("2024-01-01"), as.Date("2025-12-31"), by = "day")
  month <- month(dates)
  
  # Define scaling factors for each month to simulate seasonal changes
  # Increase winter month scaling factors and decrease summer month scaling factors
  month_scaling <- c(
    1.5, # Jan - Higher usage in winter
    1.4, # Feb
    1.2, # Mar
    1.0, # Apr
    0.8, # May
    0.7, # Jun - Lower usage in summer
    0.6, # Jul
    0.7, # Aug
    0.8, # Sep
    1.0, # Oct
    1.2, # Nov
    1.4  # Dec - Higher usage in winter
  )
  
  # Apply monthly scaling to baseline usage
  data <- data.frame(
    date = dates,
    property_id = property_id,
    gas_usage_kwh = round(gas_baseline * month_scaling[month] + rnorm(length(dates), 0, 2), 2),
    electricity_usage_kwh = round(elec_baseline * month_scaling[month] + rnorm(length(dates), 0, 1.5), 2),
    infrared_usage_kwh = round(infrared_baseline * month_scaling[month] + rnorm(length(dates), 0, 1), 2)
  )
  
  # Calculate costs based on usage
  data <- data %>%
    mutate(
      gas_cost = round(gas_usage_kwh * 0.05, 2),
      electricity_cost = round(electricity_usage_kwh * 0.15, 2),
      infrared_cost = round(infrared_usage_kwh * 0.08, 2),
      # Calculate carbon emissions per type
      carbon_emissions_gas = round(gas_usage_kwh * 0.184, 2),
      carbon_emissions_electricity = round(electricity_usage_kwh * 0.233, 2),
      carbon_emissions_infra = round(infrared_usage_kwh * 0.1, 2)
    )
  
  return(data)
}

# Generate data for each property
energy_data <- do.call(rbind, lapply(1:nrow(properties), function(i) {
  generate_energy_data(properties$property_id[i], properties$size[i])
}))

# Save the generated data to a new CSV file
write.csv(energy_data, "path and filename goes here", row.names = FALSE)

print("Newly randomized dataset with pronounced seasonal adjustments saved as daily_energy_usage.csv")
