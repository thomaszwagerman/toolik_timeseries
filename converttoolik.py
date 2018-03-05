#! /usr/bin/env python

# converttoolik.py
# 1. Attempt to convert toolik observational data into usable timeseries
#
# Version 0.1
# Date 05 March 2018
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
inpath = ''

####################
infilename = inpath+'1-hour_data.csv'
df = pd.read_csv(infilename,skiprows=1, sep = ',', header = None,
                 names = ["date", "hour", "air_temp_3m", "lw_dn_avg", "lw_up_avg", "sw_dn_avg", "sw_up_avg"])
# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.

df['hour'] = pd.to_datetime(dt.datetime(2015,04,21)+pd.to_timedelta(df['hour'], unit='h'))

df = df.set_index(['date'])
startTime=pd.to_datetime(df.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df.index[-1])

ax1=df[['lw_dn_avg','sw_dn_avg']].plot() #plots surface sensible heat, latent heat, ground flux
ax1.set_xlabel("Date")
ax1.set_ylabel("$W/m^2$")
ax1.set_title('Toolik Station Energy Balance')
plt.savefig('Toolik_obs1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax2=df[['air_temp_3m']].plot() #plots surface sensible heat, latent heat, ground flux
ax2.set_xlabel("Date")
ax2.set_ylabel("$^oC$")
ax2.set_title('Toolik Station temperature')
plt.savefig('Toolik_obs2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)
print df
