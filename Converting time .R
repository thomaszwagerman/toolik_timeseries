
#timeseries package
library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)
library(gridExtra)
library(ggpubr)
library(colourpicker)
getwd()
setwd("/home/thomasz/Desktop/toolik_timeseries/toolik_timeseries")

toolik <- read.csv('3-hour_data.csv', header = TRUE, skip = 0, sep = ",")
head(toolik)

#Making all hours 4 digits
toolik$hour <-  sprintf('%04d',toolik$hour)


class(toolik$hour)
#Formatting into time
toolik$hour <- format(strptime(toolik$hour, format = "%H%M"), format = "%H:%M")
head(toolik)

class(toolik$date)
head(toolik$date)
#Making date into a date category
toolik$date <- as.Date(paste(toolik$date), format = "%Y-%m-%d")

#Merging date + hour
toolik$date_time <- paste(toolik$date, toolik$hour)
head(toolik$date_time)
toolik$date_time <- format(strptime(toolik$date_time, format = "%Y-%m-%d %H:%M"), format = "%Y-%m-%d %H:%M:%S")
head(toolik$date_time)
toolik$date_time <- as.POSIXct(toolik$date_time, format = "%Y-%m-%d %H:%M:%S")
head(toolik)

#Making new csv
toolik_clean <- dplyr::select(toolik, date_time, soil1_moss, soil1_5cm, soil1_10cm, soil1_20cm, soil1_50cm, soil1_100cm,
                              soil1_150cm)
head(toolik_clean)
names(toolik_clean)
write.csv(toolik_clean, file = "3-hour_converted.csv")


