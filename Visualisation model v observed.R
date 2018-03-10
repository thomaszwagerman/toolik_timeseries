#Merging observed and default data
#Thomas Zwagerman
#Sat 10th of March
####
library(tidyr)
library(dplyr)
library(ggplot2)
library(readr)
library(gridExtra)
library(ggpubr)
library(colourpicker)
library(forecast)
getwd()
setwd("/home/thomasz/Desktop/toolik_timeseries/toolik_timeseries")

observed <- read.csv('observed_hour.csv', header = TRUE, skip = 0, sep = ",")
modeldefault <- read.csv('default_hour.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_hour.csv', header = TRUE, skip = 0, sep = ",")
evergreen <- read.csv('evergreen_hour.csv', header = TRUE, skip = 0, sep = ",")

#Checking import----
head(observed)
head(modeldefault)
head(green)
head(evergreen)

#Changing factor to date class----
observed$date_time <- as.Date(observed$date_time, format = "%Y-%m-%d")
modeldefault$ts_hour <- as.Date(modeldefault$ts_hour, format = "%Y-%m-%d")
green$ts_hour <- as.Date(green$ts_hour, format = "%Y-%m-%d")
evergreen$ts_hour <- as.Date(evergreen$ts_hour, format = "%Y-%m-%d")

class(observed$date_time)
class(modeldefault$ts_hour)
class(green$ts_hour)
class(evergreen$ts_hour)

#Colourpicker----
c("#6495ED", #blue
  "#EE2C2C", #red
  "#66CD00", #lightgreen
  "#006400" #darkgreen
  )

#Making own theme----
theme_toolik <- function(){
  theme_classic()+
  theme(axis.text.x=element_text(size=12, angle=45, vjust=1, hjust=1), #changing font size, and text at an angle
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=14, face="plain"), #changing font size of axis titles
        axis.title.y=element_text(size=14, face="plain"), #plain changes font type, could be italic
        panel.grid.major.x =element_blank(), #removed grey grid lines
        panel.grid.minor.x =element_blank(),
        panel.grid.major.y =element_blank(),
        panel.grid.minor.y =element_blank(),
        plot.margin = unit(c(1,1,1,1), units= , "cm")) + #adding 1cm margin
    theme(legend.text = element_text(size=12, face="italic"), #setting font for a legend
          legend.title = element_blank(), #removing legend title, blank
          legend.position=c(0.2, 0.9)) #setting position for legend, 0 is bottom left, 1 is top right.  
}

#First visualisation - Air Temperature, model vs observation----
ggplot() +
  geom_point(data = observed, aes(x = date_time, y = air_temp_3m, colour = "red")) +
  geom_point(data = modeldefault, aes(x = ts_hour, y = t, colour = "blue")) +
  theme_toolik()+
  scale_fill_manual(values = c("#6495ED", "#66CD00"))+ #custom colours
  scale_colour_manual(values=c("#6495ED", "#66CD00"),
                      labels=c("Observed","Modelled"))+ #adding legend labels
  ylab("Air Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#All air temperature----
ggplot() +
  geom_line(data = observed, aes(x = date_time, y = air_temp_3m, colour = "red")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = t, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = t, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#6495ED", "#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#6495ED", "#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Observed","Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Air Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#Soil surface temp----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tslb.1., colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = tslb.1., colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = tslb.1., colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Soil Surface Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#Soil heat flux temp----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = grdflx, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = grdflx, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = grdflx, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Soil Heat Flux (W/M^2)")+
  xlab("Date (in 2015)")

#Surface Sensible Heat Flux----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = hfx, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = hfx, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = hfx, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Surface Sensible Heat Flux (W/M^2)")+
  xlab("Date (in 2015)")

#Calculating RMSE----
# Function that returns Root Mean Squared Error
rmse <- function(error)
{
  sqrt(mean(error^2))
}

# Function that returns Mean Absolute Error
mae <- function(error)
{
  mean(abs(error))
}

# Calculate error
error <- observed$air_temp_3m - modeldefault$t

# Example of invocation of functions
rmse(error)
mae(error)

names(observed)
names(modeldefault)
