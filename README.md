# Real-Estate-Energy-Performance-Dashboard
This project developed a prototype energy dashboard using **Tableau** to visualise and analyse energy consumption data for a large property portfolio. **Python** was used for property coordinate mapping, and for data creation, cleaning and manipulation

# 📊 Property Portfolio Energy Analysis and Dashboard

![03 AEGP Story](https://github.com/user-attachments/assets/482d32ef-8190-49a0-bc71-e16ef1194814)

This project developed an interactive energy dashboard to visualise and analyse energy consumption data for a real estate investment company's property portfolio. Due to the developmental stage of the properties, Python was used to generate dummy data for the project. Python was also used to detect and log co-ordinates of properties using the Computer Vision library. The prototype dashboard aims to provide actionable insights into potential energy usage patterns, identify areas for energy efficiency improvements, and support informed decision-making regarding energy management.

You can view the interactive version on [Tableau](https://public.tableau.com/app/profile/jp.kelly8457/viz/AEPGDevelopment/AEGPStory).

## Key Technologies

* **Python:** Used for scripting and mapping property coordinates based on development plans. Employed for data cleaning, manipulation, statistical analysis, and the generation of dummy energy consumption data.
* **Tableau:** Utilised to create the interactive dashboard and visualisations for effective data exploration and communication.

## Project Overview

1.  **Data Acquisition/Generation and Preparation:**
    * Since real-world energy consumption data was not yet available, Python scripts werre used to generate dummy data based on estimated energy usage patterns and property characteristics (one for daily usage, one for hourly).
    * Python scripts were developed to process property location data, extracting coordinates and sizes from development plans.
    * Python was used to clean, transform, and aggregate both the dummy energy data and the property data, ensuring data quality and consistency.

2.  **Coordinate Mapping (Python):**
    * Python was used to automate the process of extracting property coordinates from image-based development plans.
    * This involved image processing techniques and geometric calculations to accurately locate and size properties.
    * The output was a dataset containing property IDs, coordinates (x, y), and sizes, which was then integrated with the generated energy consumption data.

3.  **Data Analysis and Visualisation (Tableau):**
    * Tableau was used to perform exploratory data analysis on the dummy data, identify potential trends, and calculate relevant energy performance indicators.
    * Tableau was employed to design and develop the interactive dashboard.
    * The dashboard features visualisations such as:
        * Interactive maps showing property locations and estimated energy consumption.
        * Charts displaying estimated energy consumption by property type, location, and time period.
        * Heatmaps comparing property energy use for different energy solutions (standard central heating vs infrared heating).
        * Filtering and drill-down capabilities to explore data in detail.

## Project Structure
Some pages are still under construction.

```
Real-Estate-Energy-Performance-Dashboard/
├── data/
│   ├── raw_data/                               # Original development plans (e.g., images)
│   └── processed_data/                         # Cleaned and transformed data ready for Tableau
│       └── daily_energy_usage.csv              # Dummy data generated by R
|       └── hourly_energy_usage.csv             # Dummy data generated by R
│       └── detected_house_coordinates.csv      # Data on property coordinates and sizes
├── scripts/ 
│   │── coordinate_plotting.py                       # Python script for coordinate mapping
│   |── create_energy_data.R                    # R scripts for data cleaning, analysis, and dummy data generation
├── tableau/                                    # Tableau workbook and data extracts
│   └── AEPG-Development.twbx
├── docs/                                       # Documentation (e.g., data dictionary, methodology for dummy data generation)
│   ├── data_dictionary.md
│   └── dummy_data_generation_methodology.md
└── README.md                                   # This file
```
