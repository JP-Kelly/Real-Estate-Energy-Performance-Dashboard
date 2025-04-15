rm(list=ls())

# Load necessary libraries
library(dplyr)
library(lubridate)
library(readr)
library(purrr)

# Set file path
property_file <- "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/detected_houses_coordinates_masked.csv"

# Load the properties data
properties <- read_csv(property_file)

# Define constants
start_date <- as.Date("2025-01-01")
end_date <- as.Date("2026-12-31")

# Define typical UK energy costs (values can be adjusted)
gas_price_per_kwh <- 0.04      # in £ per kWh
electricity_price_per_kwh <- 0.15 # in £ per kWh
infrared_price_per_kwh <- 0.10 # assumed lower cost for infrared in £ per kWh

# Define carbon emissions factors (in kg CO2 per kWh)
carbon_factor_gas <- 0.184     # kg CO2 per kWh for natural gas
carbon_factor_electricity <- 0.233 # kg CO2 per kWh for electricity
carbon_factor_infrared <- 0.10 # assumed lower emissions for infrared heating

# Define seasonal usage multipliers for gas and electricity (higher in winter)
seasonal_multiplier <- function(date) {
  month <- month(date)
  if (month %in% c(12, 1, 2)) {
    return(1.5) # winter
  } else if (month %in% c(3, 4, 10, 11)) {
    return(1.2) # shoulder months
  } else {
    return(0.8) # summer
  }
}

# Set base daily usage in kWh by property size
base_gas_usage <- c("small" = 20, "medium" = 30, "large" = 40)
base_electricity_usage <- c("small" = 10, "medium" = 15, "large" = 20)
base_infrared_usage <- c("small" = 7, "medium" = 10, "large" = 14) # lower usage for infrared

# Generate the energy usage data
set.seed(42) # for reproducibility

# Use pmap_dfr to create rows for each property
energy_usage <- pmap_dfr(properties, function(property_id, x, y, size) {
  days <- seq.Date(start_date, end_date, by = "day")
  
  # Apply seasonal multiplier to each day
  seasonal_factors <- sapply(days, seasonal_multiplier)
  
  # Generate daily data with seasonality
  daily_data <- tibble(
    property_id = property_id,
    date = days,
    gas_usage_kwh = base_gas_usage[size] * seasonal_factors * runif(length(days), 0.9, 1.1),
    electricity_usage_kwh = base_electricity_usage[size] * seasonal_factors * runif(length(days), 0.9, 1.1),
    infrared_usage_kwh = base_infrared_usage[size] * seasonal_factors * runif(length(days), 0.9, 1.1)
  )
  
  # Calculate costs and individual carbon emissions
  daily_data <- daily_data %>%
    mutate(
      gas_cost = gas_usage_kwh * gas_price_per_kwh,
      electricity_cost = electricity_usage_kwh * electricity_price_per_kwh,
      infrared_cost = infrared_usage_kwh * infrared_price_per_kwh,
      
      # Calculate separate carbon emissions for gas, electricity, and infrared usage
      carbon_emissions_gas = gas_usage_kwh * carbon_factor_gas,
      carbon_emissions_electricity = electricity_usage_kwh * carbon_factor_electricity,
      carbon_emissions_infra = infrared_usage_kwh * carbon_factor_infrared
    )
  
  return(daily_data)
})

# Save the generated data to a CSV file
write_csv(energy_usage, "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage.csv")

# Output completion message
cat("Dummy energy usage dataset created and saved successfully.")

# Streamline data by removing excessive values after decimal place #

# Load necessary library
library(dplyr)
library(readr)

# Define file path for the saved data file
file_path <- "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage.csv"

# Read, round, and save
energy_usage_condensed <- read_csv(file_path) %>%
  mutate(
    gas_cost = round(gas_cost, 2),
    electricity_cost = round(electricity_cost, 2),
    infrared_cost = round(infrared_cost, 2),
    carbon_emissions_gas = round(carbon_emissions_gas, 2),
    carbon_emissions_electricity = round(carbon_emissions_electricity, 2),
    carbon_emissions_infra = round(carbon_emissions_infra, 2),
    gas_usage_kwh = round(gas_usage_kwh, 2),
    electricity_usage_kwh = round(electricity_usage_kwh, 2),
    infrared_usage_kwh = round(infrared_usage_kwh, 2)
  )

# Save the rounded data back to CSV
write_csv(energy_usage_condensed, "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage_condensed.csv")

### Randomise data a bit more ###

# Load necessary libraries
library(dplyr)

# Read in the existing dataset
data <- read.csv("/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage.csv")

# Set a seed for reproducibility
set.seed(42)

# Function to add more varied noise based on the season
add_noise <- function(value, season_factor, base_offset = 1) {
  value * (base_offset + rnorm(1, mean = 0, sd = season_factor))
}

# Define seasonal factors and offsets for greater variability
winter_sd <- 0.2  # Winter: slight variation
spring_sd <- 0.3  # Spring
summer_sd <- 0.35 # Summer: more variation in usage reduction
fall_sd <- 0.25   # Fall

# Apply noise and rounding, introducing larger gaps between gas and infrared values
data <- data %>%
  mutate(
    # Extract month to apply seasonal variation
    month = as.numeric(format(as.Date(date), "%m")),
    
    # Randomize gas usage with seasonal factors and round to 2 decimals
    gas_usage_kwh = round(ifelse(month %in% c(12, 1, 2), add_noise(gas_usage_kwh, winter_sd, 1.05),
                                 ifelse(month %in% c(3, 4, 5), add_noise(gas_usage_kwh, spring_sd, 1.1),
                                        ifelse(month %in% c(6, 7, 8), add_noise(gas_usage_kwh, summer_sd, 1.15),
                                               add_noise(gas_usage_kwh, fall_sd, 1.08)))), 2),
    
    # Randomize electricity usage with seasonal factors and round to 2 decimals
    electricity_usage_kwh = round(ifelse(month %in% c(12, 1, 2), add_noise(electricity_usage_kwh, winter_sd, 1.02),
                                         ifelse(month %in% c(3, 4, 5), add_noise(electricity_usage_kwh, spring_sd, 1.05),
                                                ifelse(month %in% c(6, 7, 8), add_noise(electricity_usage_kwh, summer_sd, 1.07),
                                                       add_noise(electricity_usage_kwh, fall_sd, 1.03)))), 2),
    
    # Lower infrared usage relative to gas, with additional variability
    infrared_usage_kwh = round(ifelse(month %in% c(12, 1, 2), add_noise(infrared_usage_kwh, winter_sd, 0.6),
                                      ifelse(month %in% c(3, 4, 5), add_noise(infrared_usage_kwh, spring_sd, 0.65),
                                             ifelse(month %in% c(6, 7, 8), add_noise(infrared_usage_kwh, summer_sd, 0.7),
                                                    add_noise(infrared_usage_kwh, fall_sd, 0.63)))), 2),
    
    # Calculate costs with larger gaps between gas, electricity, and infrared
    gas_cost = round(gas_usage_kwh * 0.05, 2),  # Gas cost factor
    electricity_cost = round(electricity_usage_kwh * 0.15, 2),  # Electricity cost factor
    infrared_cost = round(infrared_usage_kwh * 0.08, 2),  # Infrared cost factor
    
    # Calculate emissions for gas, electricity, and infrared
    carbon_emissions_gas = round(gas_usage_kwh * 0.184, 2),  # kgCO2e per kWh
    carbon_emissions_electricity = round(electricity_usage_kwh * 0.233, 2),  # kgCO2e per kWh
    carbon_emissions_infra = round(infrared_usage_kwh * 0.1, 2)  # Lower kgCO2e per kWh for infrared
  ) %>%
  select(-month)  # Remove the month column as it's not needed in the final data

# Write the modified data to a new CSV
write.csv(data, "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage.csv", row.names = FALSE)

print("Randomized dataset saved as detected_houses_coordinates_masked_randomized.csv")


### More randomised data (to make it from scratch instead of method above) ###

# Load necessary libraries
library(dplyr)
library(lubridate)

# Read in properties data
properties <- read.csv("/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/detected_houses_coordinates_masked.csv")

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
write.csv(energy_data, "/Users/uawf001/Dropbox (Personal)/Data Viz Projects/AEPG Development/Python Script for Map Analysis/daily_energy_usage.csv", row.names = FALSE)

print("Newly randomized dataset with pronounced seasonal adjustments saved as daily_energy_usage_two.csv")