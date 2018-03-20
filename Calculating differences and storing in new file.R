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
modeldefault <- modeldefault %>%
  mutate(diff_gr_t = modeldefault$t - green$t) %>%
  mutate(diff_gr_glw = modeldefault$glw - green$glw) %>%
  mutate(diff_gr_gsw = modeldefault$gsw - green$gsw) %>%
  mutate(diff_gr_hfx = modeldefault$hfx - green$hfx) %>%
  mutate(diff_gr_lh = modeldefault$lh - green$lh) %>%
  mutate(diff_gr_grdflx = modeldefault$grdflx - green$grdflx) %>%
  mutate(diff_gr_tsk = modeldefault$tsk - green$tsk) %>%
  mutate(diff_gr_tslb.1. = modeldefault$tslb.1. - green$tslb.1.) %>%
  mutate(diff_gr_rainc = modeldefault$rainc - green$rainc) %>%
  mutate(diff_gr_rainnc = modeldefault$rainnc - green$rainnc) %>%
  mutate(diff_evgr_t = modeldefault$t - evergreen$t) %>%
  mutate(diff_evgr_glw = modeldefault$glw - evergreen$glw) %>%
  mutate(diff_evgr_gsw = modeldefault$gsw - evergreen$gsw) %>%
  mutate(diff_evgr_hfx = modeldefault$hfx - evergreen$hfx) %>%
  mutate(diff_evgr_lh = modeldefault$lh - evergreen$lh) %>%
  mutate(diff_evgr_grdflx = modeldefault$grdflx - evergreen$grdflx) %>%
  mutate(diff_evgr_tsk = modeldefault$tsk - evergreen$tsk) %>%
  mutate(diff_evgr_tslb.1. = modeldefault$tslb.1. - evergreen$tslb.1.) %>%
  mutate(diff_evgr_rainc = modeldefault$rainc - evergreen$rainc) %>%
  mutate(diff_evgr_rainnc = modeldefault$rainnc - evergreen$rainnc) %>%
  mutate(diff_real_t = modeldefault$t - real$t) %>%
  mutate(diff_real_glw = modeldefault$glw - real$glw) %>%
  mutate(diff_real_gsw = modeldefault$gsw - real$gsw) %>%
  mutate(diff_real_hfx = modeldefault$hfx - real$hfx) %>%
  mutate(diff_real_lh = modeldefault$lh - real$lh) %>%
  mutate(diff_real_grdflx = modeldefault$grdflx - real$grdflx) %>%
  mutate(diff_real_tsk = modeldefault$tsk - real$tsk) %>%
  mutate(diff_real_tslb.1. = modeldefault$tslb.1. - real$tslb.1.) %>%
  mutate(diff_real_rainc = modeldefault$rainc - real$rainc) %>%
  mutate(diff_real_rainnc = modeldefault$rainnc - real$rainnc) 

#Differences hourly between default, etc.----
modeldefault_hour <- modeldefault_hour %>%
  mutate(diff_gr_t = modeldefault_hour$t - green_hour$t) %>%
  mutate(diff_gr_glw = modeldefault_hour$glw - green_hour$glw) %>%
  mutate(diff_gr_gsw = modeldefault_hour$gsw - green_hour$gsw) %>%
  mutate(diff_gr_hfx = modeldefault_hour$hfx - green_hour$hfx) %>%
  mutate(diff_gr_lh = modeldefault_hour$lh - green_hour$lh) %>%
  mutate(diff_gr_grdflx = modeldefault_hour$grdflx - green_hour$grdflx) %>%
  mutate(diff_gr_tsk = modeldefault_hour$tsk - green_hour$tsk) %>%
  mutate(diff_gr_tslb.1. = modeldefault_hour$tslb.1. - green_hour$tslb.1.) %>%
  mutate(diff_gr_rainc = modeldefault_hour$rainc - green_hour$rainc) %>%
  mutate(diff_gr_rainnc = modeldefault_hour$rainnc - green_hour$rainnc) %>%
  mutate(diff_evgr_t = modeldefault_hour$t - evergreen_hour$t) %>%
  mutate(diff_evgr_glw = modeldefault_hour$glw - evergreen_hour$glw) %>%
  mutate(diff_evgr_gsw = modeldefault_hour$gsw - evergreen_hour$gsw) %>%
  mutate(diff_evgr_hfx = modeldefault_hour$hfx - evergreen_hour$hfx) %>%
  mutate(diff_evgr_lh = modeldefault_hour$lh - evergreen_hour$lh) %>%
  mutate(diff_evgr_grdflx = modeldefault_hour$grdflx - evergreen_hour$grdflx) %>%
  mutate(diff_evgr_tsk = modeldefault_hour$tsk - evergreen_hour$tsk) %>%
  mutate(diff_evgr_tslb.1. = modeldefault_hour$tslb.1. - evergreen_hour$tslb.1.) %>%
  mutate(diff_evgr_rainc = modeldefault_hour$rainc - evergreen_hour$rainc) %>%
  mutate(diff_evgr_rainnc = modeldefault_hour$rainnc - evergreen_hour$rainnc) %>%
  mutate(diff_real_t = modeldefault_hour$t - real_hour$t) %>%
  mutate(diff_real_glw = modeldefault_hour$glw - real_hour$glw) %>%
  mutate(diff_real_gsw = modeldefault_hour$gsw - real_hour$gsw) %>%
  mutate(diff_real_hfx = modeldefault_hour$hfx - real_hour$hfx) %>%
  mutate(diff_real_lh = modeldefault_hour$lh - real_hour$lh) %>%
  mutate(diff_real_grdflx = modeldefault_hour$grdflx - real_hour$grdflx) %>%
  mutate(diff_real_tsk = modeldefault_hour$tsk - real_hour$tsk) %>%
  mutate(diff_real_tslb.1. = modeldefault_hour$tslb.1. - real_hour$tslb.1.) %>%
  mutate(diff_real_rainc = modeldefault_hour$rainc - real_hour$rainc) %>%
  mutate(diff_real_rainnc = modeldefault_hour$rainnc - real_hour$rainnc) 

#Combining----
all_differences_daily <- dplyr::select(modeldefault, ts_hour, diff_gr_t, diff_gr_glw, diff_gr_gsw, diff_gr_hfx, diff_gr_lh,
                                 diff_gr_grdflx, diff_gr_tsk, diff_gr_tslb.1., diff_gr_rainc, diff_gr_rainnc, 
                                 diff_evgr_t, diff_evgr_glw, diff_evgr_gsw, diff_evgr_hfx, diff_evgr_lh,
                                 diff_evgr_grdflx, diff_evgr_tsk, diff_evgr_tslb.1., diff_evgr_rainc, 
                                 diff_evgr_rainnc, diff_real_t, diff_real_glw, diff_real_gsw, diff_real_hfx, 
                                 diff_real_lh, diff_real_grdflx, diff_real_tsk, diff_real_tslb.1., diff_real_rainc, 
                                 diff_real_rainnc)

all_differences_hourly <- dplyr::select(modeldefault_hour, ts_hour, diff_gr_t, diff_gr_glw, diff_gr_gsw, diff_gr_hfx, diff_gr_lh,
                                        diff_gr_grdflx, diff_gr_tsk, diff_gr_tslb.1., diff_gr_rainc, diff_gr_rainnc, 
                                        diff_evgr_t, diff_evgr_glw, diff_evgr_gsw, diff_evgr_hfx, diff_evgr_lh,
                                        diff_evgr_grdflx, diff_evgr_tsk, diff_evgr_tslb.1., diff_evgr_rainc, 
                                        diff_evgr_rainnc, diff_real_t, diff_real_glw, diff_real_gsw, diff_real_hfx, 
                                        diff_real_lh, diff_real_grdflx, diff_real_tsk, diff_real_tslb.1., diff_real_rainc, 
                                        diff_real_rainnc)
head(all_differences_daily)
head(all_differences_hourly)

#Writing----
write.csv(all_differences_daily, file = "1-differences_daily.csv")
write.csv(all_differences_hourly, file = "1-differences_hourly.csv")
