# Install needed packages only if not already installed
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("lubridate")) install.packages("lubridate")
if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
# Load libraries
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
# options(repos = c(CRAN = "https://cloud.r-project.org"))
div19_df <- read_csv("Divvy_Trips_2019_Q1 - Divvy_Trips_2019_Q1.csv")
div20_df <- read_csv("Divvy_Trips_2020_Q1 - Divvy_Trips_2020_Q1.csv")

# rename(dataset_name, new_column_name = old_col_name)
# Standardize 2019 dataframe
div19_df <- rename(div19_df, start_station_name = from_station_name, end_station_name = to_station_name, start_station_id = from_station_id, end_station_id = to_station_id, ride_id = trip_id) 
# Standardize 2020 dataframe
div20_df <- rename(div20_df, start_time=started_at, end_time=ended_at)
# Standardize usertype column so that its values are either subscriber or customer for the 2020 dataset.
div20_df <- div20_df %>% 
  rename(usertype = member_casual) %>% 
  mutate(usertype = case_when(
    usertype == "member" ~ "Subscriber",
    usertype == "casual" ~ "Customer"))
#so we must convert them to datetime. Must use dplyr and lubridate.
#Because div_19 trip duration is in seconds, div20 must be the same
div20_df <- div20_df %>% 
  mutate(
    start_time = ymd_hms(start_time),
    end_time = ymd_hms(end_time),
    tripduration = as.numeric(end_time - start_time)
  )
#I filter data that is valid store it into the original variable
div19_df <- div19_df %>%
  filter(tripduration > 0 & tripduration < 86400) #filter rides < 24 hours, or > 0
div20_df <- div20_df %>%
  filter(tripduration > 0 & tripduration < 86400) #filter rides < 24 hours, or > 0
div19_df <- div19_df %>% 
  filter(!is.na(start_station_name)& !is.na(end_station_name))
div20_df <- div20_df %>% 
  filter(!is.na(start_station_name)& !is.na(end_station_name))
# Check if any usertypes are missing, and exclude them 
div19_df <- div19_df %>% 
  filter(!is.na(usertype))
div20_df <- div20_df %>% 
  filter(!is.na(usertype))

