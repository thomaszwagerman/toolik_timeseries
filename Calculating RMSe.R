#Calculating RMSE
#Thomas Zwagerman
#10/03/2018

library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)
library(gridExtra)
library(ggpubr)
library(colourpicker)
library(forecast)
setwd("/home/thomasz/Desktop/toolik_timeseries/toolik_timeseries")

#Reading in .csv's
#Hourly
observed <- read.csv('observed_hourly.csv', header = TRUE, skip = 0, sep = ",")
modeldefault <- read.csv('default_hourly.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_hourly.csv', header = TRUE, skip = 0, sep = ",")
real <- read.csv('realistic_hourly.csv', header = TRUE, skip = 0, sep = ",")

#Daily
observed_daily <- read.csv('observed_daily.csv', header = TRUE, skip = 0, sep = ",")
modeldefault_daily <- read.csv('default_daily.csv', header = TRUE, skip = 0, sep = ",")
green_daily <- read.csv('green_daily.csv', header = TRUE, skip = 0, sep = ",")
real_daily <- read.csv('realistic_daily.csv', header = TRUE, skip = 0, sep = ",")

#Changing factor to date class----
observed$date_time <- as.POSIXct(observed$date_time, format = "%Y-%m-%d %H:%M:%S")
modeldefault$ts_hour <- as.POSIXct(modeldefault$ts_hour, format = "%Y-%m-%d %H:%M:%S")
green$ts_hour <- as.POSIXct(green$ts_hour, format = "%Y-%m-%d %H:%M:%S")
real$ts_hour <- as.POSIXct(real$ts_hour, format = "%Y-%m-%d %H:%M:%S")

#Calculating RMSE----
# Function that returns Root Mean Squared Error----
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# Calculating error----
#Daily
error_daily <- observed_daily$air_temp_3m - modeldefault_daily$t
errorgreen_daily <- observed_daily$air_temp_3m - green_daily$t
errorreal_daily <- observed_daily$air_temp_3m - real_daily$t

#Hourly
error <- observed$air_temp_3m - modeldefault$t
errorgreen <- observed$air_temp_3m - green$t
errorreal <- observed$air_temp_3m - real$t

#Printing results----
#Daily
rmse(error_daily)
rmse(errorgreen_daily)
rmse(errorreal_daily)

#Hourly
rmse(error)
rmse(errorgreen)
rmse(errorreal)

