# Creates an hourly dummy dataset for a sample of three properties

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import math

# Read in properties data and filter to the first three properties
properties = pd.read_csv("path to co-ordinates data file goes here")  # Replace with your actual path
properties = properties.iloc[0:3]

# Set seed for reproducibility
np.random.seed(42)


# Function to generate hourly data with seasonal and daily fluctuations
def generate_hourly_energy_data(property_id, size):
    """
    Generates hourly energy data with seasonal and daily fluctuations.

    Args:
        property_id (int): The unique identifier for the property.
        size (str): The size category of the property ('small', 'medium', or 'large').

    Returns:
        pandas.DataFrame: A DataFrame containing hourly energy data.
    """

    # Define baseline usage depending on property size
    if size == "small":
        gas_baseline = 20
        elec_baseline = 15
        infrared_baseline = 10
    elif size == "medium":
        gas_baseline = 30
        elec_baseline = 22
        infrared_baseline = 15
    elif size == "large":
        gas_baseline = 40
        elec_baseline = 30
        infrared_baseline = 20
    else:
        raise ValueError(f"Invalid property size: {size}")

    # Generate dates and hours for one year
    start_date = datetime(2024, 1, 1, 0, 0, 0)  # Year, Month, Day, Hour, Min, Sec
    end_date = datetime(2024, 12, 31, 23, 0, 0)
    dates = [start_date + timedelta(hours=i) for i in range(int((end_date - start_date).total_seconds() / 3600) + 1)]  # List of datetime objects

    num_hours = len(dates)

    # Define seasonal and daily adjustments
    seasonal_adjustment = 1 + 0.3 * np.sin(2 * math.pi * (np.array([(d.timetuple().tm_yday - 80) for d in dates]) / 365))  # Day of year
    daily_variation = 1 + 0.1 * np.sin(2 * math.pi * np.array([d.hour for d in dates]) / 24)  # Hour of day

    # Generate temperature data (higher in summer, lower in winter)
    day_of_year = np.array([d.timetuple().tm_yday for d in dates])
    temperature = np.round(18 + 5 * np.sin(2 * math.pi * (day_of_year - 172) / 365) + np.random.normal(0, 1, num_hours), 2)

    # Energy usage with random daily variations and seasonal fluctuations
    gas_usage_kwh = np.round(gas_baseline * seasonal_adjustment * daily_variation + np.random.normal(0, 1.5, num_hours), 2)
    electricity_usage_kwh = np.round(elec_baseline * seasonal_adjustment * daily_variation + np.random.normal(0, 1.2, num_hours), 2)
    infrared_usage_kwh = np.round(infrared_baseline * seasonal_adjustment * daily_variation + np.random.normal(0, 1, num_hours), 2)

    data = pd.DataFrame(
        {
            "date": dates,
            "property_id": property_id,
            "gas_usage_kwh": gas_usage_kwh,
            "electricity_usage_kwh": electricity_usage_kwh,
            "infrared_usage_kwh": infrared_usage_kwh,
            "temperature": temperature,
        }
    )

    # Calculate costs and emissions
    data["gas_cost"] = np.round(data["gas_usage_kwh"] * 0.05, 2)
    data["electricity_cost"] = np.round(data["electricity_usage_kwh"] * 0.15, 2)
    data["infrared_cost"] = np.round(data["infrared_usage_kwh"] * 0.08, 2)
    data["carbon_emissions_gas"] = np.round(data["gas_usage_kwh"] * 0.184, 2)
    data["carbon_emissions_electricity"] = np.round(data["electricity_usage_kwh"] * 0.233, 2)
    data["carbon_emissions_infra"] = np.round(data["infrared_usage_kwh"] * 0.1, 2)

    return data


# Generate data for the first three properties and bind rows together
hourly_energy_data_list = []
for index, row in properties.iterrows():
    hourly_energy_data_list.append(generate_hourly_energy_data(row["property_id"], row["size"]))
hourly_energy_data = pd.concat(hourly_energy_data_list, ignore_index=True)

# Save the generated dataset to CSV
hourly_energy_data.to_csv("path and filename goes here", index=False)  # Replace with your desired path and filename

print("Hourly energy dataset with temperature saved as hourly_energy_usage.csv")
