import pandas as pd
import numpy as np
from datetime import date, timedelta
import calendar

# Read in properties data
properties = pd.read_csv("path to co-ordinates data file goes here")  # Replace with your actual path

# Set a seed for reproducibility
np.random.seed(42)


def generate_energy_data(property_id, size):
    """
    Simulates daily energy usage with monthly adjustments based on property size.

    Args:
        property_id (int): The unique identifier for the property.
        size (str): The size category of the property ('small', 'medium', or 'large').

    Returns:
        pandas.DataFrame: A DataFrame containing simulated energy data.
    """

    # Define seasonal baselines based on property size
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
        raise ValueError(f"Invalid property size: {size}")  # Handle invalid sizes

    # Daily usage rates with monthly adjustments
    start_date = date(2024, 1, 1)
    end_date = date(2025, 12, 31)
    dates = [start_date + timedelta(days=i) for i in range((end_date - start_date).days + 1)]

    # Define scaling factors for each month to simulate seasonal changes
    month_scaling = [
        1.5,  # Jan - Higher usage in winter
        1.4,  # Feb
        1.2,  # Mar
        1.0,  # Apr
        0.8,  # May
        0.7,  # Jun - Lower usage in summer
        0.6,  # Jul
        0.7,  # Aug
        0.8,  # Sep
        1.0,  # Oct
        1.2,  # Nov
        1.4,  # Dec - Higher usage in winter
    ]

    # Get month numbers (1-12) for dates
    months = [d.month for d in dates]

    # Apply monthly scaling to baseline usage
    gas_usage_kwh = np.round(
        gas_baseline * np.array([month_scaling[m - 1] for m in months]) + np.random.normal(0, 2, len(dates)), 2
    )  # m-1 because Python list indices start at 0
    electricity_usage_kwh = np.round(
        elec_baseline * np.array([month_scaling[m - 1] for m in months]) + np.random.normal(0, 1.5, len(dates)), 2
    )
    infrared_usage_kwh = np.round(
        infrared_baseline * np.array([month_scaling[m - 1] for m in months]) + np.random.normal(0, 1, len(dates)), 2
    )

    data = pd.DataFrame(
        {
            "date": dates,
            "property_id": property_id,
            "gas_usage_kwh": gas_usage_kwh,
            "electricity_usage_kwh": electricity_usage_kwh,
            "infrared_usage_kwh": infrared_usage_kwh,
        }
    )

    # Calculate costs based on usage
    data["gas_cost"] = np.round(data["gas_usage_kwh"] * 0.05, 2)
    data["electricity_cost"] = np.round(data["electricity_usage_kwh"] * 0.15, 2)
    data["infrared_cost"] = np.round(data["infrared_usage_kwh"] * 0.08, 2)

    # Calculate carbon emissions per type
    data["carbon_emissions_gas"] = np.round(data["gas_usage_kwh"] * 0.184, 2)
    data["carbon_emissions_electricity"] = np.round(data["electricity_usage_kwh"] * 0.233, 2)
    data["carbon_emissions_infra"] = np.round(data["infrared_usage_kwh"] * 0.1, 2)

    return data


# Generate data for each property
energy_data_list = []
for index, row in properties.iterrows():
    energy_data_list.append(generate_energy_data(row["property_id"], row["size"]))
energy_data = pd.concat(energy_data_list, ignore_index=True)

# Save the generated data to a new CSV file
energy_data.to_csv("path and filename goes here", index=False)  # Replace with your desired path and filename

print("Newly randomized dataset with pronounced seasonal adjustments saved as daily_energy_usage.csv")
