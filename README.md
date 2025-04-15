# Real-Estate-Energy-Performance-Dashboard
This project developed a prototype energy dashboard using Tableau to visualise and analyse energy consumption data for a large property portfolio. Python was used for property coordinate mapping, and R was used for data cleaning and manipulation

# 📊 Property Portfolio Energy Analysis and Dashboard

![03 AEGP Story](https://github.com/user-attachments/assets/482d32ef-8190-49a0-bc71-e16ef1194814)

This project developed an interactive energy dashboard to visualise and analyse energy consumption data for a real estate investment company's property portfolio. Due to the developmental stage of the properties, R was used to generate dummy data for the project. Python was used to detect and log co-ordinates of properties using the Computer Vision library. The prototype dashboard aims to provide actionable insights into potential energy usage patterns, identify areas for energy efficiency improvements, and support informed decision-making regarding energy management.

## Key Technologies

* **Python:** Used for scripting and mapping property coordinates based on development plans.
* **R:** Employed for data cleaning, manipulation, statistical analysis, and the generation of dummy energy consumption data.
* **Tableau:** Utilized to create the interactive dashboard and visualisations for effective data exploration and communication.

## Project Overview

1.  **Data Acquisition/Generation and Preparation:**
    * Since real-world energy consumption data was not yet available, R scripts were used to generate dummy data based on estimated energy usage patterns and property characteristics.
    * Python scripts were developed to process property location data, extracting coordinates and sizes from development plans.
    * R scripts were used to clean, transform, and aggregate both the dummy energy data and the property data, ensuring data quality and consistency.

2.  **Coordinate Mapping (Python):**
    * Python was used to automate the process of extracting property coordinates from image-based development plans.
    * This involved image processing techniques and geometric calculations to accurately locate and size properties.
    * The output was a dataset containing property IDs, coordinates (x, y), and sizes, which was then integrated with the generated energy consumption data.

3.  **Data Analysis and Visualisation (R & Tableau):**
    * R was used to perform exploratory data analysis on the dummy data, identify potential trends, and calculate relevant energy performance indicators.
    * Tableau was employed to design and develop the interactive dashboard.
    * The dashboard features visualisations such as:
        * Interactive maps showing property locations and estimated energy consumption.
        * Charts displaying estimated energy consumption by property type, location, and time period.
        * Heatmaps comparing property energy use for different energy solutions (standard central heating vs infrared heating).
        * Filtering and drill-down capabilities to explore data in detail.

## Project Structure

```
Real-Estate-Energy-Performance-Dashboard/
├── data/
│   ├── raw_data/                  # Original development plans (e.g., images)
│   └── processed_data/            # Cleaned and transformed data ready for Tableau
│       └── dummy_energy_data.csv  # Dummy data generated by R
│       └── property_data.csv      # Data on property coordinates and sizes
├── scripts/
│   ├── python/                    # Python scripts for coordinate mapping
│   │   └── coordinate_mapping.py
│   └── r/                         # R scripts for data cleaning, analysis, and dummy data generation
│       └── data_generation_cleaning_analysis.R
├── tableau/                       # Tableau workbook and data extracts
│   └── energy_dashboard.twbx
├── docs/                          # Documentation (e.g., data dictionary, methodology for dummy data generation)
│   ├── data_dictionary.md
│   └── dummy_data_generation_methodology.md
└── README.md                      # This file
```
