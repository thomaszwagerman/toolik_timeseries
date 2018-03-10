#! /usr/bin/env python

# pyallTS.py
# 1. Draws all variables in a wrf TIME_SERIES.out file
#
# Version 0.1
# Date 27 Nov 2017
# Author: jbm, edited by tz
# Latest: 10:54 28/11/17
#
# This is the line I need in Terminal:
# thomasz@ThomasZ:~/Desktop/toolik_timeseries/toolik_timeseries$ python pyallTS.py

import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import datetime as dt
plt.style.use('seaborn-deep')
inpath = ''
inpath2 = ''


####################
infilename1 = inpath+'tooldefault.d03.TS'
df1 = pd.read_csv(infilename1,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

infilename2 = inpath2+'1-hour_converted.csv'
df2 = pd.read_csv(infilename2,skiprows=1, sep = ',', header = None,
                 names = ["date_time", "air_temp_3m", "lw_dn_avg", "lw_up_avg", "sw_dn_avg", "sw_up_avg"])

#df2 = df2.loc['2015-04-21':'2015-05-19']

# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.
df1['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df1['ts_hour'], unit='h'))
df2 = df2.set_index(pd.DatetimeIndex(df2['date_time']))
#df2['date'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df2['date'], unit='h'))

# Convert temperatures to Celcius
df1['t']= df1['t']-273.16
df1['tslb(1)']= df1['tslb(1)']-273.16
df1['tsk']= df1['tsk']-273.16

df1 = df1.set_index(['ts_hour'])
startTime1=pd.to_datetime(df1.index[0])   # returns a TimeStamp
endTime1=pd.to_datetime(df1.index[-1])

#df2 = df2.set_index(['date_time'])
startTime2=pd.to_datetime(df2.index[0])   # returns a TimeStamp
endTime2=pd.to_datetime(df2.index[-1])

# Take the mean over 30 minutes ie 30T
df1=df1.resample('1D').mean()
df2=df2.resample('1D').mean()

ax1=df1[['hfx','lh','grdflx']].plot() #plots surface sensible heat, latent heat, ground flux
ax1.set_xlabel("Date")
ax1.set_ylabel("$W/m^2$")
ax1.set_title('Toolik Energy Balance')
plt.savefig('Toolik_1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax2=df1[['t','tslb(1)','tsk']].plot() #plots 2m temperature, top soil layer temp, skin temperature
ax2.set_xlabel("Date")
ax2.set_ylabel("$^oC$")
ax2.set_title('Toolik Soil and Air Temperature')
plt.savefig('Toolik_2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax3=df1[['rainc','rainnc','clw']].plot() #plots rainfall from cumulus, total column integrated water vapor and cloud var.
ax3.set_xlabel("Date")
ax3.set_ylabel("mm")
ax3.set_title('Toolik Rain and Cloud Water Content')
plt.savefig('Toolik_3_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax4 = df1[['psfc']].plot()
ax4.set_xlabel("Date")
ax4.set_ylabel("Pa")
ax4.set_title("Toolik Surface Pressure")
plt.savefig('Toolik_4_21_Apr_15', dpi=300,bbox_inches='tight', pad_inches=0.5)

ax5=df2[['lw_dn_avg','sw_dn_avg']].plot() #plots shortwave and latent heat,
ax5.set_xlabel("Date")
ax5.set_ylabel("$W/m^2$")
ax5.set_title('Toolik Station Energy Balance')
plt.savefig('Toolik_obs1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax6=df2[['air_temp_3m']].plot() #plots temperature at 3_m (2_m is not available)
ax6.set_xlabel("Date")
ax6.set_ylabel("$^oC$")
ax6.set_xlim([startTime2, endTime2])
ax6.set_title('Toolik Station temperature')
plt.savefig('Toolik_obs2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax7=df2[['lw_up_avg','sw_up_avg']].plot() #plots shortwave and latent heat,
ax7.set_xlabel("Date")
ax7.set_ylabel("$W/m^2$")
ax7.set_title('Toolik Station Energy Balance')
plt.savefig('Toolik_obs3_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

print df2
########## Contents of TS file ########################
#id:          grid ID
#ts_hour:     forecast time in hours
#id_tsloc:    time series ID
#ix,iy:       grid location (nearest grid to the station)
#t:           2 m Temperature (K)
#q:           2 m vapor mixing ratio (kg/kg)
#u:           10 m U wind (earth-relative)
#v:           10 m V wind (earth-relative)
#psfc:        surface pressure (Pa)
#glw:         downward longwave radiation flux at the ground (W/m^2, downward is positive)
#gsw:         net shortwave radiation flux at the ground (W/m^2, downward is positive)
#hfx:         surface sensible heat flux (W/m^2, upward is positive)
#lh:          surface latent heat flux (W/m^2, upward is positive)
#grdflx:      soil heat flux (W/m^2, upward is positive)
#tsk:         skin temperature (K)
#tslb(1):     top soil layer temperature (K)
#rainc:       rainfall from a cumulus scheme (mm)
#rainnc:      rainfall from an explicit scheme (mm)
#clw:         total column-integrated water vapor and cloud variables
