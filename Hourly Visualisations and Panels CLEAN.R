#Visualisation Model v Observed Hourly
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

observed <- read.csv('observed_hourly.csv', header = TRUE, skip = 0, sep = ",")
soiltemp <- read.csv('default_3hourly.csv', header = TRUE, skip = 0, sep = ",")
modeldefault <- read.csv('default_hourly.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_hourly.csv', header = TRUE, skip = 0, sep = ",")
evergreen <- read.csv('evergreen_hourly.csv', header = TRUE, skip = 0, sep = ",")
real <- read.csv('realistic_hourly.csv', header = TRUE, skip = 0, sep = ",")
differences <- read.csv('1-differences_hourly.csv', header = TRUE, skip = 0, sep = ",")

#Changing factor to date class----
observed$date_time <- as.POSIXct(observed$date_time, format = "%Y-%m-%d %H:%M:%S")
soiltemp$date_time <- as.POSIXct(soiltemp$date_time, format = "%Y-%m-%d %H:%M:%S")
modeldefault$ts_hour <- as.POSIXct(modeldefault$ts_hour, format = "%Y-%m-%d %H:%M:%S")
green$ts_hour <- as.POSIXct(green$ts_hour, format = "%Y-%m-%d %H:%M:%S")
evergreen$ts_hour <- as.POSIXct(evergreen$ts_hour, format = "%Y-%m-%d %H:%M:%S")
real$ts_hour <- as.POSIXct(real$ts_hour, format = "%Y-%m-%d %H:%M:%S")
differences$ts_hour <- as.POSIXct(differences$ts_hour, format = "%Y-%m-%d %H:%M:%S")

#Making own theme----
#Comparison theme
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
          legend.position=c(0.3, 0.8)) #setting position for legend, 0 is bottom left, 1 is top right.  
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
    theme(legend.text = element_text(size=9, face="italic"), #setting font for a legend
          legend.title = element_blank(), #removing legend title, blank
          legend.position= c(0.4, 0.9)) #setting position for legend, 0 is bottom left, 1 is top right.  
}

theme_nolegend <- function(){
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
    theme(legend.position= "none") #setting position for legend, 0 is bottom left, 1 is top right.  
}

#Visualisation output----
#Air temperature----
air_temp <- (ggplot() +
               geom_line(data = modeldefault, aes(x = ts_hour, y = t, colour = "a")) +
               geom_line(data = green, aes(x = ts_hour, y = t, colour = "b")) +
               geom_line(data = evergreen, aes(x = ts_hour, y = t, colour = "c")) +
               geom_line(data = real, aes(x = ts_hour, y = t, colour = "d")) +
               scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
               theme_toolik()+
               scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
               scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                   labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
               ylab("Air Temperature "*" in"~degree*C)+
               xlab("Date (in 2015)"))
air_temp

#Soil surface temp----
surface_temp <- (ggplot() +
                   geom_line(data = modeldefault, aes(x = ts_hour, y = tslb.1., colour = "a")) +
                   geom_line(data = green, aes(x = ts_hour, y = tslb.1., colour = "b")) +
                   geom_line(data = evergreen, aes(x = ts_hour, y = tslb.1., colour = "c")) +
                   geom_line(data = real, aes(x = ts_hour, y = tslb.1., colour = "d")) +
                   scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                   theme_toolik()+
                   scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
                   scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                       labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
                   ylab("Soil Surface Temperature "*" in"~degree*C)+
                   xlab("Date (in 2015)"))

#Soil heat flux ----
surface_flux <- (ggplot() +
                   geom_line(data = modeldefault, aes(x = ts_hour, y = grdflx, colour = "a")) +
                   geom_line(data = green, aes(x = ts_hour, y = grdflx, colour = "b")) +
                   geom_line(data = evergreen, aes(x = ts_hour, y = grdflx, colour = "c")) +
                   geom_line(data = real, aes(x = ts_hour, y = grdflx, colour = "d")) +
                   scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                   theme_nolegend()+
                   scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
                   scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                       labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
                   ylab(bquote('Radiation in' ~W/M^-2))+
                   xlab("Date (in 2015)"))

#Surface Sensible Heat Flux----
sens_heat <- (ggplot() +
                geom_line(data = modeldefault, aes(x = ts_hour, y = hfx, colour = "a")) +
                geom_line(data = green, aes(x = ts_hour, y = hfx, colour = "b")) +
                geom_line(data = evergreen, aes(x = ts_hour, y = hfx, colour = "c")) +
                geom_line(data = real, aes(x = ts_hour, y = hfx, colour = "d")) +
                scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                theme_toolik()+
                scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
                scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                    labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
                ylab(bquote('Radiation in' ~W/M^-2))+
                xlab("Date (in 2015)"))

#Surface Latent Heat Flux----
lat_heat <- (ggplot() +
               geom_line(data = modeldefault, aes(x = ts_hour, y = lh, colour = "a")) +
               geom_line(data = green, aes(x = ts_hour, y = lh, colour = "b")) +
               geom_line(data = evergreen, aes(x = ts_hour, y = lh, colour = "c")) +
               geom_line(data = real, aes(x = ts_hour, y = lh, colour = "d")) +
               scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
               theme_nolegend()+
               scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
               scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                   labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
               ylab(bquote('Radiation in' ~W/M^-2))+
               xlab("Date (in 2015)"))

#Downward Longwave Radiation----
long_rad <- (ggplot() +
               geom_line(data = modeldefault, aes(x = ts_hour, y = glw, colour = "a")) +
               geom_line(data = green, aes(x = ts_hour, y = glw, colour = "b")) +
               geom_line(data = evergreen, aes(x = ts_hour, y = glw, colour = "c")) +
               geom_line(data = real, aes(x = ts_hour, y = glw, colour = "d")) +
               scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
               theme_nolegend()+
               scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
               scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
               ylab('Radiation in' ~W/M^-2)+
               xlab("Date (in 2015)"))

#Net Shortwave radiation flux at the ground----
short_rad <- (ggplot() +
                geom_line(data = modeldefault, aes(x = ts_hour, y = gsw, colour = "a")) +
                geom_line(data = green, aes(x = ts_hour, y = gsw, colour = "b")) +
                geom_line(data = evergreen, aes(x = ts_hour, y = gsw, colour = "c")) +
                geom_line(data = real, aes(x = ts_hour, y = gsw, colour = "d")) +
                scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                theme_toolik()+
                scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
                scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                    labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
                ylab('Radiation in' ~W/M^-2)+
                xlab("Date (in 2015)"))

#Skin temperature----
skin_temp <- (ggplot() +
                geom_line(data = modeldefault, aes(x = ts_hour, y = tsk, colour = "a")) +
                geom_line(data = green, aes(x = ts_hour, y = tsk, colour = "b")) +
                geom_line(data = evergreen, aes(x = ts_hour, y = tsk, colour = "c")) +
                geom_line(data = real, aes(x = ts_hour, y = tsk, colour = "d")) +
                scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                theme_nolegend()+
                scale_fill_manual(values = c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"))+ #custom colours
                scale_colour_manual(values=c("a" = "#EE2C2C","b" = "#66CD00", "c" = "#006400","d"= "#FF7F00"),
                                    labels=c("Default", "Green", "Evergreen", "Real"))+ #adding legend labels
                ylab("Skin Temperature"*"in"~degree*C)+
                xlab("Date (in 2015)"))

#Plotting differences----
#Air temperature----
air_temp_diff <- (ggplot() +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_gr_t, colour = "a")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_t, colour = "b")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_real_t, colour = "c")) +
                    scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                    theme_difference()+
                    scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                    scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                        labels=c("Difference between Green and Default", 
                                                 "Difference between Evergreen and Default",
                                                 "Difference between Real and Default"))+ #adding legend labels
                    ylab("Air Temperature "*"in"~degree*C)+
                    xlab("Date (in 2015)"))

air_temp_diff
#Differences from default in soil surface temperature----
surface_temp_diff <- (ggplot() +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_gr_tslb.1., colour = "a")) +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_tslb.1., colour = "b")) +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_real_tslb.1., colour = "c")) +
                        scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                        theme_difference()+
                        scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                        scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                            labels=c("Difference between Green and Default", 
                                                     "Difference between Evergreen and Default",
                                                     "Difference between Real and Default"))+ #adding legend labels
                        ylab("Soil Surface Temperature "*"in"~degree*C)+
                        xlab("Date (in 2015)"))

#Difference from default in soil heat flux temp----
surface_flux_diff <- (ggplot() +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_gr_grdflx, colour = "a")) +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_grdflx, colour = "b")) +
                        geom_line(data = differences, aes(x = ts_hour, y = diff_real_grdflx, colour = "c")) +
                        scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                        theme_nolegend()+
                        scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                        scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                            labels=c("Difference between Green and Default", 
                                                     "Difference between Evergreen and Default",
                                                     "Difference between Real and Default"))+ #adding legend labels
                        ylab(bquote('Radiation in' ~W/M^-2))+
                        xlab("Date (in 2015)"))

#Differences from default in surface sensible heat flux----
sens_heat_diff <- (ggplot() +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_gr_hfx, colour = "a")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_hfx, colour = "b")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_real_hfx, colour = "c")) +
                     scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                     theme_nolegend()+
                     scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                     scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                         labels=c("Difference between Green and Default", 
                                                  "Difference between Evergreen and Default",
                                                  "Difference between Real and Default"))+ #adding legend labels
                     ylab(bquote('Radiation in' ~W/M^-2))+
                     xlab("Date (in 2015)"))

#Differences from default in surface latent heat flux----
lat_heat_diff <- (ggplot() +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_gr_lh, colour = "a")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_lh, colour = "b")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_real_lh, colour = "c")) +
                    scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                    theme_difference()+
                    scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                    scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                        labels=c("Difference between Green and Default", 
                                                 "Difference between Evergreen and Default",
                                                 "Difference between Real and Default"))+ #adding legend labels
                    ylab(bquote('Radiation in' ~W/M^-2))+
                    xlab("Date (in 2015)"))

#Differences from default in downward longwave radiation----
long_rad_diff <- (ggplot() +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_gr_glw, colour = "a")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_glw, colour = "b")) +
                    geom_line(data = differences, aes(x = ts_hour, y = diff_real_glw, colour = "c")) +
                    scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                    theme_nolegend()+
                    scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                    scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                        labels=c("As above", 
                                                 "As above",
                                                 "As above"))+ #adding legend labels
                    ylab('Radiation in' ~W/M^-2)+
                    xlab("Date (in 2015)"))

#Differences from default in net shortwave radiation flux at the ground----
short_rad_diff <- (ggplot() +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_gr_gsw, colour = "a")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_gsw, colour = "b")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_real_gsw, colour = "c")) +
                     scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                     theme_difference()+
                     scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                     scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                         labels=c("Difference between Green and Default", 
                                                  "Difference between Evergreen and Default",
                                                  "Difference between Real and Default"))+ #adding legend labels
                     ylab('Radiation in' ~W/M^-2)+
                     xlab("Date (in 2015)"))

#Differences from default in skin temperature----
skin_temp_diff <- (ggplot() +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_gr_tsk, colour = "a")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_evgr_tsk, colour = "b")) +
                     geom_line(data = differences, aes(x = ts_hour, y = diff_real_tsk, colour = "c")) +
                     scale_x_datetime(date_labels = "%D", date_breaks = "3 day")+
                     theme_nolegend()+
                     scale_fill_manual(values = c("a" = "#66CD00","b"="#006400","c"="#F77F00"))+ #custom colours
                     scale_colour_manual(values=c("a" = "#66CD00","b"= "#006400","c"= "#F77F00"),
                                         labels=c("Difference between Green and Default", 
                                                  "Difference between Evergreen and Default",
                                                  "Difference between Real and Default"))+ #adding legend labels
                     ylab("Skin Temperature "*"in"~degree*C)+
                     xlab("Date (in 2015)"))

#Panels ----
panel <- grid.arrange(air_temp + ggtitle("(a) Air Temperature") + 
                        theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                      air_temp_diff + ggtitle("(b) Air Temperature Differences") +
                        theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                      skin_temp + ggtitle("(c) Skin Temperature") + 
                        theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                      skin_temp_diff + ggtitle("(d) Skin Temperature Differences") +
                        theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")))

panel_surface <-grid.arrange(surface_temp + ggtitle("(a) Surface Temperature") + 
                            theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                          surface_temp_diff + ggtitle("(b) Surface Temperature Differences") +
                            theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                          surface_flux + ggtitle("(c) Soil Heat Flux") +
                            theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                          surface_flux_diff + ggtitle("(d) Soil Heat Flux Differences") +
                            theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")))

panel_senslat <- grid.arrange(sens_heat + ggtitle("(a) Surface Sensible Heat Flux") + 
                                theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                              sens_heat_diff + ggtitle("(b) Surface Sensible Heat Flux Differences") +
                                theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                              lat_heat + ggtitle("(c) Surface Latent Heat Flux") + 
                                theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                              lat_heat_diff + ggtitle("(d) Surface Latent Heat Flux Differences") +
                                theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")))

panel_shortlong <- grid.arrange(short_rad + ggtitle("(a) Shortwave Radiation") + 
                                  theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                                short_rad_diff + ggtitle("(b) Shortwave Radiation Differences") +
                                  theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                                long_rad + ggtitle("(c) Longwave Radiation") + 
                                  theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")),
                                long_rad_diff + ggtitle("(d) Longwave Radiation Differences") +
                                  theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = "cm")))

ggsave(panel, file = "air_temp_panel.png", width = 10, height =8)
ggsave(panel_surface, file = "surface_temp_panel.png", width = 10, height = 8)
ggsave(panel_senslat, file = "senslat_flux_panel.png", width = 10, height = 8)
ggsave(panel_shortlong, file = "shortlong_rad_panel.png", width = 10, height = 8)

