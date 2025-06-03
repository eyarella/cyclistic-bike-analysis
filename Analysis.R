

subs20 <- div20_df %>% filter(usertype == "Subscriber")
subs19 <- div19_df %>%  filter(usertype == "Subscriber")
cust20 <- div20_df %>% filter(usertype == "Customer")
cust19 <- div19_df %>% filter(usertype == "Customer")

meansubs20 <- mean(subs20$tripduration)
mediansubs20 <- median(subs20$tripduration)
meancust20 <- mean(cust20$tripduration)
mediancust20 <- median(cust20$tripduration)
meansubs19 <- mean(subs19$tripduration)
mediansubs19 <- median(subs19$tripduration)
meancust19 <- mean(cust19$tripduration)
mediancust19 <- median(cust19$tripduration)

SummaryStats <- data.frame(
  usertype = c("Subscriber", "Subscriber", "Customer", "Customer","Subscriber", "Subscriber", "Customer", "Customer"),
  statistic = c("Mean", "Median","Mean", "Median","Mean", "Median","Mean", "Median"),
  Year = c("2019", "2019", "2019", "2019", "2020","2020","2020","2020"),
  Ride_Duration = c(meansubs19, mediansubs19, meancust19, mediancust19,meansubs20, mediansubs20, meancust20, mediancust20)
)
SummaryStats

# Visualize ride distribution for both years
G_RideDistr2019_sec <-ggplot(div20_df,aes(x=tripduration,fill=usertype))+
  geom_histogram(binwidth=5,position="identity",alpha=0.6) +
  scale_x_continuous(limits=c(0,3600))+
  labs(title="Ride Duration Distribution (2020)",
       x = "Duration (seconds)",
       y = "Count") +
  theme_minimal()
G_RideDistr2019_sec
# Visualize ride distribution for 2020
G_RideDistr2020<-ggplot(div20_df,aes(x=tripduration/60,fill=usertype))+
  geom_histogram(binwidth=5,position="identity",alpha=0.6) +
  scale_x_continuous(limits=c(0,120))+
  labs(title="Ride Duration Distribution (2020)",
       x = "Duration (minutes)",
       y = "Count") +
  theme_minimal()
G_RideDistr2020
# Visualize ride distribution for 2019
G_RideDistr2019<- ggplot(div19_df,aes(x=tripduration/60,fill=usertype))+
  geom_histogram(binwidth=5,position="identity",alpha=0.6) +
  scale_x_continuous(limits=c(0,120))+
  labs(title="Ride Duration Distribution (2019)",
       x = "Duration (minutes)",
       y = "Count") +
  theme_minimal()
G_RideDistr2019
# add new columns to 2020 and 2019 data frame for day of the week, and hour of the day
div20_df <- div20_df %>% 
  mutate(
    day_of_week = wday(start_time, label = TRUE, abbr = FALSE),
    hour_of_day = hour(start_time)
  )
div19_df <- div19_df %>% 
  mutate(
    day_of_week = wday(start_time, label = TRUE, abbr = FALSE),
    hour_of_day = hour(start_time)
    )
    
# Make histogram to analyze time patterns for 2020
G_RidesbyWeek20 <- ggplot(div20_df, aes(x = day_of_week, fill = usertype)) +
  geom_bar() +
  labs(
    title = "Number of Rides by Day of Week 2020",
    x = "Day",
    y = "Count"
  ) +
  theme_minimal()
# print(G_RidesbyWeek20)
# Make a histogram to analyze time patterns for 2019
G_RidesbyWeek19 <- ggplot(div19_df,aes(x=day_of_week,fill=usertype))+
  geom_bar() +
  labs(title="Number of Rides by Day of Week 2019",
       x = "Day",
       y = "Count") +
  theme_minimal()
G_RidesbyWeek19
#I want to combine the data from the two years to make a comprehensive bar graph.
#select needed columns, usertype and day_of_week, from both 2019 and 2020. 
df19_sel <- div19_df %>% 
  select(day_of_week, hour_of_day, usertype) %>% 
  mutate(year="2019")
df20_sel <- div20_df %>% 
  select(day_of_week, hour_of_day, usertype) %>% 
  mutate("2020")
#combine the data 
combined_df <- bind_rows(df20_sel,df19_sel)
#Day of Week and User Type Bar Graph
G_RidesbyWeek <- ggplot(combined_df, aes(x = day_of_week, fill = usertype)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Rides by Day of Week and User Type",
    x = "Day of Week",
    y = "Number of Rides",
    fill = "User Type"
  ) +
  theme_minimal()
G_RidesbyWeek
#Hour of Day and User Type Bar Graph}
G_RidesbyHour <-ggplot(combined_df, aes(x = hour_of_day, fill = usertype)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Number of Rides by Day of Week and User Type",
    x = "Hour of Day (Military Time)",
    y = "Number of Rides",
    fill = "User Type"
  ) +
  theme_minimal()
G_RidesbyHour

popular_starts_20<- div20_df %>%
  group_by(usertype, start_station_name) %>%
  summarise(ride_count = n()) %>%
  arrange(usertype, desc(ride_count)) %>%
  slice_head(n = 5)  # Top 5 per usertype
popular_starts_19<- div19_df %>%
  group_by(usertype, start_station_name) %>%
  summarise(ride_count = n()) %>%
  arrange(usertype, desc(ride_count)) %>%
  slice_head(n = 5)  # Top 5 per usertype
#combining both
popular_starts_combined <- bind_rows(popular_starts_19, popular_starts_20)
# different approach
combined_starts <- bind_rows(
  div19_df %>% select(usertype,start_station_name),
  div20_df %>% select(usertype,start_station_name)
)
combined_ends <- bind_rows(
  div19_df %>% select(usertype,end_station_name),
  div20_df %>% select(usertype,end_station_name)
)
# count total rides per station and usertype 
pop_combined_starts <- combined_starts %>% 
  group_by(usertype,start_station_name) %>% 
  summarise(ride_count=n()) %>% 
  arrange(usertype,desc(ride_count)) %>% 
  slice_head(n=10)
pop_combined_ends <- combined_ends %>% 
  group_by(usertype,end_station_name) %>% 
  summarise(ride_count=n()) %>% 
  arrange(usertype,desc(ride_count)) %>% 
  slice_head(n=10)
# Popular Start Stations Bar Graph
G_StartStations <- ggplot(pop_combined_starts,aes(x=reorder(start_station_name,-ride_count),y=ride_count,fill=usertype))+
  geom_bar(stat="identity",position="dodge")+
  labs(
    title="Top 10 Most Popular Start stations by Usertype (2019 and 2020)",
    x = "Start Station",
    y = "Total Ride Count") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45,hjust=1))
G_StartStations
# Popular End Stations Bar Graph}
G_EndStations <- ggplot(pop_combined_ends,aes(x=reorder(end_station_name,-ride_count),y=ride_count,fill=usertype))+
  geom_bar(stat="identity",position="dodge")+
  labs(
    title="Top 10 Most Popular End stations by Usertype (2019 and 2020)",
    x = "End Station",
    y = "Total Ride Count") +
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45,hjust=1))
G_EndStations
# Trip Frequency: Group by user, count rides to see how often each type uses the service
total_rides20 <- div20_df %>%
  group_by(usertype) %>%
  summarise(total_rides = n())
total_rides19<- div19_df %>%
  group_by(usertype) %>%
  summarise(total_rides = n())
total_rides_comb <- bind_rows(total_rides19,total_rides20)
library(scales)
# Total Rides Graph
G_TotalRides<- ggplot(total_rides_comb,aes(x=usertype,y=total_rides,fill=usertype))+
  geom_bar(stat="identity")+
  scale_y_continuous(labels=label_comma()) +
  labs(title="Total Rides by Usertype",
       x = "User Type",
       y = "Total Rides")+
  theme_minimal()
G_TotalRides

