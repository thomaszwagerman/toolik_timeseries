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


####################
infilename = inpath+'tooldefault.d03.TS'
df = pd.read_csv(infilename,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])
# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.
df['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df['ts_hour'], unit='h'))

# Convert temperatures to Celcius
df['t']= df['t']-273.16
df['tslb(1)']= df['tslb(1)']-273.16
df['tsk']= df['tsk']-273.16

df = df.set_index(['ts_hour'])
startTime=pd.to_datetime(df.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df.index[-1])

# Take the mean over 30 minutes ie 30T
df=df.resample('1D').mean()

ax1=df[['hfx','lh','grdflx']].plot() #plots surface sensible heat, latent heat, ground flux
ax1.set_xlabel("Date")
ax1.set_ylabel("$W/m^2$")
ax1.set_title('Toolik Energy Balance')
plt.savefig('Toolik_1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax2=df[['t','tslb(1)','tsk']].plot() #plots 2m temperature, top soil layer temp, skin temperature
ax2.set_xlabel("Date")
ax2.set_ylabel("$^oC$")
ax2.set_title('Toolik Soil and Air Temperature')
plt.savefig('Toolik_2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)


ax3=df[['rainc','rainnc','clw']].plot() #plots rainfall from cumulus, total column integrated water vapor and cloud var.
ax3.set_xlabel("Date")
ax3.set_ylabel("mm")
ax3.set_title('Toolik Rain and Cloud Water Content')
plt.savefig('Toolik_3_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax4 = df[['psfc']].plot()
ax4.set_xlabel("Date")
ax4.set_ylabel("Pa")
ax4.set_title("Toolik Surface Pressure")
plt.savefig('Toolik_4_21_Apr_15', dpi=300,bbox_inches='tight', pad_inches=0.5)

print df
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
