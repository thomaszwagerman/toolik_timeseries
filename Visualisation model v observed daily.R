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

observed <- read.csv('observed_daily.csv', header = TRUE, skip = 0, sep = ",")
soiltemp <- read.csv('default_3daily.csv', header = TRUE, skip = 0, sep = ",")
modeldefault <- read.csv('default_daily.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_daily.csv', header = TRUE, skip = 0, sep = ",")
evergreen <- read.csv('evergreen_daily.csv', header = TRUE, skip = 0, sep = ",")
real <- read.csv('realistic_daily.csv', header = TRUE, skip = 0, sep = ",")
differences <- read.csv('1-differences_daily.csv', header = TRUE, skip = 0, sep = ",")

#Checking import----
head(observed)
head(soiltemp)
head(modeldefault)
head(green)
head(evergreen)
head(real)
head(differences)

#Changing factor to date class----
observed$date_time <- as.Date(observed$date_time, format = "%Y-%m-%d")
soiltemp$date_time <- as.Date(observed$date_time, format = "%Y-%m-%d")
modeldefault$ts_hour <- as.Date(modeldefault$ts_hour, format = "%Y-%m-%d")
green$ts_hour <- as.Date(green$ts_hour, format = "%Y-%m-%d")
evergreen$ts_hour <- as.Date(evergreen$ts_hour, format = "%Y-%m-%d")
real$ts_hour <- as.Date(real$ts_hour, format = "%Y-%m-%d")
differences$ts_hour <- as.Date(differences$ts_hour, format = "%Y-%m-%d")

class(observed$date_time)
class(soiltemp$date_time)
class(modeldefault$ts_hour)
class(green$ts_hour)
class(evergreen$ts_hour)
class(real$ts_hour)
class(differences$ts_hour)

#Colourpicker----
c("#6495ED", #blue
  "#EE2C2C", #red
  "#66CD00", #lightgreen
  "#006400", #darkgreen
  "#FF7F00" #orange)

#Making own theme----
#Comparison theme----
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

#Difference theme
theme_difference <- function(){
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
          legend.position=c(0.3, 0.2)) #setting position for legend, 0 is bottom left, 1 is top right.  
}
names(green)

#First visualisation - Air Temperature, model vs observation----
air_temp_daily <- ggplot() +
  geom_point(data = observed, aes(x = date_time, y = air_temp_3m, colour = "blue")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "red")) +
  geom_line(data = real, aes(x = ts_hour, y = t, colour = "orange")) +
  geom_line(data = green, aes(x = ts_hour, y = t, colour = "green")) +
  theme_toolik()+
  scale_fill_manual(values = c("blue" = "#6495ED","red"= "#F00000","orange"= "#FF7F00", "green" = "#66CD00"))+ #custom colours
  scale_colour_manual(values=c("blue" ="#6495ED","red"= "#F00000","orange"= "#FF7F00", "green" = "#66CD00"),
                      labels=c("blue" = "Observed","red" = "Default","orange"= "Real","green"="Green"))+ #adding legend labels
  ylab("Air Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

ggsave(air_temp_daily, file = "air_temp_daily.png", width = 8, height =6)


#Without Williamson----
ggplot() +
  geom_point(data = observed, aes(x = date_time, y = air_temp_3m, colour = "blue")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "red")) +
  #geom_line(data = real, aes(x = ts_hour, y = t, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#6495ED", "#66CD00"))+ #custom colours
  scale_colour_manual(values=c("#6495ED", "#66CD00"),
                      labels=c("Observed","Modelled"))+ #adding legend labels
  ylab("Air Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#All air temperature----
ggplot() +
  geom_line(data = observed, aes(x = date_time, y = air_temp_3m, colour = "blue")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "red")) +
  geom_line(data = green, aes(x = ts_hour, y = t, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = t, colour = "darkgreen")) +
  geom_line(data = real, aes(x = ts_hour, y = t, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#6495ED", "#EE2C2C", "#66CD00", "#006400", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#6495ED", "#EE2C2C", "#66CD00", "#006400", "#FF7F00"),
                      labels=c("Observed","Default", "Green", "Evergreen", "Real"))+ #adding legend labels
  ylab("Air Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")

#All soil (observed) temperature----
ggplot() +
  geom_point(data = soiltemp, aes(x = date_time, y = soil1_moss, colour = "#6495ED")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tslb.1., colour = "#EE2C2C")) +
  geom_point(data = soiltemp, aes(x = date_time, y = soil1_5cm, colour = "#66CD00")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tsk, colour = "#006400")) +
  theme_toolik()+
  scale_fill_manual(values = c("#6495ED", "#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#6495ED", "#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Modelled Skin Temperature","Observed Top Soil Layer", "Observed_5_cm", "Modelled Top Layer"))+ #adding legend labels
  ylab("Soil Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")

#Soil surface temp----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tslb.1., colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = tslb.1., colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = tslb.1., colour = "darkgreen")) +
  geom_line(data = real, aes(x = ts_hour, y = tslb.1., colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400", "#FF7F00"),
                      labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
  ylab("Soil Surface Temperature "*" in"~degree*C)+
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

#Surface Latent Heat Flux----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = lh, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = lh, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = lh, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Surface Sensible Heat Flux (W/M^2)")+
  xlab("Date (in 2015)")
#Downward Longwave Radiation----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = glw, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = glw, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = glw, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Downward Longwave Radiation (W/M^2)")+
  xlab("Date (in 2015)")
#Net Shortwave radiation flux at the ground----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = gsw, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = gsw, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = gsw, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Net Shortwave Radiation Flux (W/M^2)")+
  xlab("Date (in 2015)")
#Skin temperature----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tsk, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = tsk, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = tsk, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Skin Temperature"*"in"~degree*C)+
  xlab("Date (in 2015)")
#Rainfall from cumulus scheme----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = rainc, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = rainc, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = rainc, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Rainfall (mm)")+
  xlab("Date (in 2015)")

#Rainfall from explicit scheme----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = rainnc, colour = "blue")) +
  geom_line(data = green, aes(x = ts_hour, y = rainnc, colour = "green")) +
  geom_line(data = evergreen, aes(x = ts_hour, y = rainnc, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#EE2C2C", "#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#EE2C2C", "#66CD00", "#006400"),
                      labels=c("Default", "Green", "Evergreen"))+ #adding legend labels
  ylab("Rainfall (mm)")+
  xlab("Date (in 2015)")

#Differences from default in t----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_t, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_t, colour = "red")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_real_t, colour = "orange")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400", "#FF7F00"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default",
                               "Difference between Realistic and Default"))+ #adding legend labels
  ylab("Air Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#Differences from default in soil surface temperature----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_tslb.1., colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_tslb.1., colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Soil Surface Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#Difference from default in soil heat flux temp----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_grdflx, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_grdflx, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Soil Surface Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")

#Differences from default in surface sensible heat flux----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_hfx, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_hfx, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Surface Sensible Heat Flux in W/M")+
  xlab("Date (in 2015)")
#Differences from default in surface latent heat flux----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_lh, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_lh, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Surface Latent Heat Flux in W/M^2")+
  xlab("Date (in 2015)")
#Differences from default in downward longwave radiation----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_glw, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_glw, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Downward Longwave Radiation in W/M^2")+
  xlab("Date (in 2015)")
#Differences from default in net shortwave radiation flux at the ground----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_gsw, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_gsw, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Net Shortwave Radiation Flux in W/M^2")+
  xlab("Date (in 2015)")
#Differences from default in skin temperature----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_tsk, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_tsk, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Skin Temperature "*"in"~degree*C)+
  xlab("Date (in 2015)")
#Differences from default in rainfall from cumulus scheme----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_rainc, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_rainc, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Rainfall (mm)")+
  xlab("Date (in 2015)")
#Differences from default in rainfall from explicit scheme----
ggplot() +
  geom_line(data = differences, aes(x = ts_hour, y = diff_gr_rainnc, colour = "blue")) +
  geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_rainnc, colour = "red")) +
  theme_difference()+
  scale_fill_manual(values = c("#66CD00", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#006400"),
                      labels=c("Difference between Green and Default", 
                               "Difference between Evergreen and Default"))+ #adding legend labels
  ylab("Rainfall (mm)")+
  xlab("Date (in 2015)")
#Calculating RMSE----
#Function that returns Root Mean Squared Error----
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
error_daily <- observed_daily$air_temp_3m - modeldefault_daily$t
errorgreen_daily <- observed_daily$air_temp_3m - green_daily$t
errorreal_daily <- observed_daily$air_temp_3m - real_daily$t

# Example of invocation of functions
rmse(error)
rmse(errorgreen)
rmse(errorreal)
mae(error)

names(observed)
names(modeldefault)

#Williamson et al. vs Green----
#Air Temperature----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = t, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = t, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Air Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")

#Soil surface temperature----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = tslb.1., colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = tslb.1., colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Soil Surface Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")
#Soil heat flux temperature----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = grdflx, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = grdflx, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Soil Heat Flux in W/M2")+
  xlab("Date (in 2015)")
#Surface sensible heat flux----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = hfx, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = hfx, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Surface Sensible heat flux in W/M2")+
  xlab("Date (in 2015)")
#Surface latent heat flux----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = lh, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = lh, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Surface latent heat flux in W/M2")+
  xlab("Date (in 2015)")
#Downward longwave radiation----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = glw, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = glw, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Downward Longwave Radiation in W/m2")+
  xlab("Date (in 2015)")
#Net Shortwave Radiation Flux----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = gsw, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = gsw, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Net Shortwave Radiation Flux in W/M2")+
  xlab("Date (in 2015)")
#Skin temperature----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = tsk, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = tsk, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Skin  Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")
#Rainfall from cumulus scheme----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = rainc, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = rainc, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Rainfall from cumulus scheme in mm")+
  xlab("Date (in 2015)")
#Rainfall from explicit scheme----
ggplot() +
  geom_line(data = green, aes(x = ts_hour, y = rainnc, colour = "green")) +
  geom_line(data = real, aes(x = ts_hour, y = rainnc, colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#FF7F00"),
                      labels=c("Green","Williamson et al. 2016"))+ #adding legend labels
  ylab("Rainfall from explicit scheme")+
  xlab("Date (in 2015)")


#Multiple variables on same plot----
#Temperature based----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "green")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tsk, colour = "blue")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = tslb.1., colour = "orange")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#6495ED", "#FF7F00"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#6495ED", "#FF7F00"),
                      labels=c("Air Temperature","Skin Temperature","Soil Surface Temperature"))+ #adding legend labels
  ylab("Temperature "*" in"~degree*C)+
  xlab("Date (in 2015)")
#Radiation based----
ggplot() +
  geom_line(data = modeldefault, aes(x = ts_hour, y = grdflx, colour = "green")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = hfx, colour = "blue")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = lh, colour = "orange")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = glw, colour = "red")) +
  geom_line(data = modeldefault, aes(x = ts_hour, y = gsw, colour = "darkgreen")) +
  theme_toolik()+
  scale_fill_manual(values = c("#66CD00", "#6495ED", "#FF7F00", "#EE2C2C", "#006400"))+ #custom colours
  scale_colour_manual(values=c("#66CD00", "#6495ED", "#FF7F00", "#EE2C2C", "#006400"),
                      labels=c("Soil Heat Flux","Surface Sensible Heat Flux","Surface Latent Heat flux",
                               "Downward Longwave Radiation", "Net Shortwave Radiation Flux"))+ #adding legend labels
  ylab("Radiation in W/M2")+
  xlab("Date (in 2015)")
