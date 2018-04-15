#Creating differences dataframe
#Thomas Zwagerman
#08/02/2018

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
modeldefault <- read.csv('default_daily.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_daily.csv', header = TRUE, skip = 0, sep = ",")
evergreen <- read.csv('evergreen_daily.csv', header = TRUE, skip = 0, sep = ",")
real <- read.csv('realistic_daily.csv', header = TRUE, skip = 0, sep = ",")
head(real)

observed_hour <- read.csv('observed_hourly.csv', header = TRUE, skip = 0, sep = ",")
modeldefault_hour <- read.csv('default_hourly.csv', header = TRUE, skip = 0, sep = ",")
green_hour <- read.csv('green_hourly.csv', header = TRUE, skip = 0, sep = ",")
evergreen_hour <- read.csv('evergreen_hourly.csv', header = TRUE, skip = 0, sep = ",")
real_hour <- read.csv('realistic_hourly.csv', header = TRUE, skip = 0, sep = ",")

#Differences between default, green and evergreen daily----
modeldefault_hour <- modeldefault_hour %>%
  mutate(diff_gr_t = green_hour$t - modeldefault_hour$t) %>%
  mutate(diff_gr_glw = green_hour$glw - modeldefault_hour$glw) %>%
  mutate(diff_gr_gsw = green_hour$gsw - modeldefault_hour$gsw) %>%
  mutate(diff_gr_hfx = green_hour$hfx - modeldefault_hour$hfx) %>%
  mutate(diff_gr_lh = green_hour$lh - modeldefault_hour$lh) %>%
  mutate(diff_gr_grdflx = green_hour$grdflx - modeldefault_hour$grdflx) %>%
  mutate(diff_gr_tsk = green_hour$tsk - modeldefault_hour$tsk) %>%
  mutate(diff_gr_tslb.1. = green_hour$tslb.1. - modeldefault_hour$tslb.1.) %>%
  mutate(diff_gr_rainc = green_hour$rainc - modeldefault_hour$rainc) %>%
  mutate(diff_gr_rainnc = green_hour$rainnc - modeldefault_hour$rainnc) %>%
  mutate(diff_evgr_t = evergreen_hour$t - modeldefault_hour$t) %>%
  mutate(diff_evgr_glw = evergreen_hour$glw - modeldefault_hour$glw) %>%
  mutate(diff_evgr_gsw = evergreen_hour$gsw - modeldefault_hour$gsw) %>%
  mutate(diff_evgr_hfx = evergreen_hour$hfx - modeldefault_hour$hfx) %>%
  mutate(diff_evgr_lh = evergreen_hour$lh - modeldefault_hour$lh) %>%
  mutate(diff_evgr_grdflx = evergreen_hour$grdflx - modeldefault_hour$grdflx) %>%
  mutate(diff_evgr_tsk = evergreen_hour$tsk - modeldefault_hour$tsk) %>%
  mutate(diff_evgr_tslb.1. = evergreen_hour$tslb.1. - modeldefault_hour$tslb.1.) %>%
  mutate(diff_evgr_rainc = evergreen_hour$rainc - modeldefault_hour$rainc) %>%
  mutate(diff_evgr_rainnc = evergreen_hour$rainnc - modeldefault_hour$rainnc) %>%
  mutate(diff_real_t = real_hour$t - modeldefault_hour$t) %>%
  mutate(diff_real_glw = real_hour$glw - modeldefault_hour$glw) %>%
  mutate(diff_real_gsw = real_hour$gsw - modeldefault_hour$gsw) %>%
  mutate(diff_real_hfx = real_hour$hfx - modeldefault_hour$hfx) %>%
  mutate(diff_real_lh = real_hour$lh - modeldefault_hour$lh) %>%
  mutate(diff_real_grdflx = real_hour$grdflx - modeldefault_hour$grdflx) %>%
  mutate(diff_real_tsk = real_hour$tsk - modeldefault_hour$tsk) %>%
  mutate(diff_real_tslb.1. = real_hour$tslb.1. - modeldefault_hour$tslb.1.) %>%
  mutate(diff_real_rainc = real_hour$rainc - modeldefault_hour$rainc) %>%
  mutate(diff_real_rainnc = real_hour$rainnc - modeldefault_hour$rainnc) 


#Combining----
all_differences_hourly <- dplyr::select(modeldefault_hour, ts_hour, diff_gr_t, diff_gr_glw, diff_gr_gsw, diff_gr_hfx, diff_gr_lh,
                                        diff_gr_grdflx, diff_gr_tsk, diff_gr_tslb.1., diff_gr_rainc, diff_gr_rainnc, 
                                        diff_evgr_t, diff_evgr_glw, diff_evgr_gsw, diff_evgr_hfx, diff_evgr_lh,
                                        diff_evgr_grdflx, diff_evgr_tsk, diff_evgr_tslb.1., diff_evgr_rainc, 
                                        diff_evgr_rainnc, diff_real_t, diff_real_glw, diff_real_gsw, diff_real_hfx, 
                                        diff_real_lh, diff_real_grdflx, diff_real_tsk, diff_real_tslb.1., diff_real_rainc, 
                                        diff_real_rainnc)
head(all_differences_hourly)

#Writing----
write.csv(all_differences_hourly, file = "1-differences_hourly.csv")
