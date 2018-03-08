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
                 names = ["date", "hour", "air_temp_3m", "lw_dn_avg",
                          "lw_up_avg", "sw_dn_avg", "sw_up_avg"])

df = df.set_index(['date'])

df1 = df.loc['2015-04-21':'2015-05-19']

# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.

#Attempts to convert 'date_time' into yy:mm:dd hh:mm:ss
#df['date'] = pd.to_datetime(dt.datetime(2015,04,21)+pd.to_timedelta(df['date_hour'], unit='h'))
#df = pd.to_datetime(df['date'] + df['hour'])
#df = df.apply(lambda r : pd.datetime.combine(r['date'], r['hour']))
#df=df.resample('1h').mean()

#Attempts to return as a 60m timestamp
#df = df.set_index(['date'])
#startTime=pd.to_datetime(df.index[0])   # returns a TimeStamp
#endTime=pd.to_datetime(df.index[-1])
#Convert to a 60 minute frequency
#df['date_hour'] = df.asfreq('1h', method = 'pad')

ax1=df1[['lw_dn_avg','sw_dn_avg']].plot() #plots shortwave and latent heat,
ax1.set_xlabel("Date")
ax1.set_ylabel("$W/m^2$")
ax1.set_title('Toolik Station Energy Balance')
plt.savefig('Toolik_obse1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax2=df1[['air_temp_3m']].plot() #plots temperature at 3_m (2_m is not available)
ax2.set_xlabel("Date")
ax2.set_ylabel("$^oC$")
ax2.set_title('Toolik Station temperature')
plt.savefig('Toolik_obse2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

print df
