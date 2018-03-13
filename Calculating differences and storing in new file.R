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

observed <- read.csv('observed_hour.csv', header = TRUE, skip = 0, sep = ",")
modeldefault <- read.csv('default_hour.csv', header = TRUE, skip = 0, sep = ",")
green <- read.csv('green_hour.csv', header = TRUE, skip = 0, sep = ",")
evergreen <- read.csv('evergreen_hour.csv', header = TRUE, skip = 0, sep = ",")

#Differences between default, green and evergreen
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
  mutate(diff_evgr_rainnc = modeldefault$rainnc - evergreen$rainnc)

all_differences <- dplyr::select(modeldefault, ts_hour, diff_gr_t, diff_gr_glw, diff_gr_gsw, diff_gr_hfx, diff_gr_lh,
                                 diff_gr_grdflx, diff_gr_tsk, diff_gr_tslb.1., diff_gr_rainc, diff_gr_rainnc, 
                                 diff_evgr_t, diff_evgr_glw, diff_evgr_gsw, diff_evgr_hfx, diff_evgr_lh,
                                 diff_evgr_grdflx, diff_evgr_tsk, diff_evgr_tslb.1., diff_evgr_rainc, diff_evgr_rainnc)
head(all_differences)
write.csv(all_differences, file = "1-differences.csv")
