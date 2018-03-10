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
#startTime2=pd.to_datetime(df2.index[0])   # returns a TimeStamp
#endTime2=pd.to_datetime(df2.index[-1])

# Take the mean over 30 minutes ie 30T
df1=df1.resample('1D').mean()
df2=df2.resample('1D').mean()

df1.to_csv('default_hour.csv')
df2.to_csv('observed_hour.csv')
#frames = [df1, df2]
#results = pd.concat(frames)
#print results
