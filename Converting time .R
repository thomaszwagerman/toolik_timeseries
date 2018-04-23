#Converting Time of Observed data to match WRFout time 
#Thomas Zwagerman
#06/02/2018

#Loading in packages
library(tidyr)
library(dplyr)

#Set Working Directory and load .csv
setwd("/home/thomasz/Desktop/toolik_timeseries/toolik_timeseries")
toolik <- read.csv('1-hour_data.csv', header = TRUE, skip = 0, sep = ",")

#Making all hours 4 digits
toolik$hour <-  sprintf('%04d',toolik$hour)

#Formatting into time
toolik$hour <- format(strptime(toolik$hour, format = "%H%M"), format = "%H:%M")

#Making date into a date category
toolik$date <- as.Date(paste(toolik$date), format = "%Y-%m-%d")

#Merging date + hour
toolik$date_time <- paste(toolik$date, toolik$hour)
toolik$date_time <- format(strptime(toolik$date_time, format = "%Y-%m-%d %H:%M"), format = "%Y-%m-%d %H:%M:%S")
toolik$date_time <- as.POSIXct(toolik$date_time, format = "%Y-%m-%d %H:%M:%S")

#Making new csv
toolik_clean <- dplyr::select(toolik, date_time, air_temp_3m)
write.csv(toolik_clean, file = "3-hour_converted.csv")


