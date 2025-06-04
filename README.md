# Cyclistic Bike Share Case Study 
This project analyzes bike-share data from Cyclistic to identify trends in rider behavior and provide recommendations to increase membership sales.
## 📁 Project Structure
- `Cleaning.R`: Script for cleaning and preparing the data
- `Analysis.R`: Script for analysis and visualizations
- `Capstone-Project.Rmd`: Full R Markdown report
- `visuals/`: Plots and graphs used in the report

## 📊 Objective

To determine how casual riders and annual members use the service differently, and provide actionable recommendations to convert more casual riders into members.

## 🗂️ Data Source
The data used in this project was provided by **Divvy/Cyclistic** and can be downloaded from:
🔗 [https://divvy-tripdata.s3.amazonaws.com/index.html](https://divvy-tripdata.s3.amazonaws.com/index.html)
**Note:** Data files are large and not included in this repository. You can download them manually and place them in the working directory to run the scripts.

## 🧹 Data Cleaning
- Standardized column names between years
- Removed rides with missing or invalid data
- Filtered out rides with extreme durations (e.g., <1 min or >24 hrs)
- Re-coded user types to "Subscriber" and "Customer" for consistency

## 📈 Key Findings
- Subscribers ride more consistently during weekdays; casual users peak on weekends.
- Top start stations for subscribers are centered around commuting hubs.
- Casual riders use more dockless/e-bikes where available.

## 📌 Recommendations
- Target casual riders near recreational areas with discounted memberships.
- Promote membership benefits more visibly at popular casual-use stations.
- Expand e-bike availability based on casual rider demand.

## 🛠️ Tools Used
- R (tidyverse, dplyr, ggplot2, lubridate)
- RStudio
- R Markdown

