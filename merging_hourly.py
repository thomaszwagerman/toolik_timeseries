#! /usr/bin/env python

# pyallTS.py
# 1. Draws all variables in a wrf TIME_SERIES.out file
#
# Version 0.1
# Date 27 Nov 2017
# Author: jbm, edited by t
# Latest Edit: 02/02/18
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
inpath3 = ''
inpath4 = ''
inpath5 = ''
inpath6 = ''

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

infilename3 = inpath3+'toolgreen.d03.TS'
df3 = pd.read_csv(infilename3,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

infilename4 = inpath4+'tooleverg.d03.TS'
df4 = pd.read_csv(infilename4,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

infilename5 = inpath5+'3-hour_converted.csv'
df5 = pd.read_csv(infilename5, skiprows=1, sep = ',', header = None,
                 names = ["date_time", "soil1_moss", "soil1_5cm", "soil1_10cm", "soil1_20cm",
                 "soil1_50cm", "soil1_100cm","soil1_150cm"])

infilename6 = inpath6+'toolreal.d03.TS'
df6 = pd.read_csv(infilename6,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.
df1['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df1['ts_hour'], unit='h'))
df2 = df2.set_index(pd.DatetimeIndex(df2['date_time']))
df3['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df3['ts_hour'], unit='h'))
df4['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df4['ts_hour'], unit='h'))
df5 = df5.set_index(pd.DatetimeIndex(df5['date_time']))
df6['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df6['ts_hour'], unit='h'))

# Convert temperatures to Celcius
df1['t']= df1['t']-273.16
df1['tslb(1)']= df1['tslb(1)']-273.16
df1['tsk']= df1['tsk']-273.16

df3['t']= df3['t']-273.16
df3['tslb(1)']= df3['tslb(1)']-273.16
df3['tsk']= df3['tsk']-273.16

df4['t']= df4['t']-273.16
df4['tslb(1)']= df4['tslb(1)']-273.16
df4['tsk']= df4['tsk']-273.16

df6['t']= df6['t']-273.16
df6['tslb(1)']= df6['tslb(1)']-273.16
df6['tsk']= df6['tsk']-273.16

df1 = df1.set_index(['ts_hour'])
startTime=pd.to_datetime(df1.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df1.index[-1])

df3 = df3.set_index(['ts_hour'])
startTime=pd.to_datetime(df3.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df3.index[-1])

df4 = df4.set_index(['ts_hour'])
startTime=pd.to_datetime(df4.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df4.index[-1])

df6 = df6.set_index(['ts_hour'])
startTime=pd.to_datetime(df4.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df4.index[-1])

# Take the mean over 30 minutes ie 30T
df1=df1.resample('1H').mean()
df2=df2.resample('1H').mean()
df3=df3.resample('1H').mean()
df4=df4.resample('1H').mean()
df5=df5.resample('1H').mean()
df6=df6.resample('1H').mean()

#Writing new csv
df1.to_csv('default_hourly.csv')
df2.to_csv('observed_hourly.csv')
df3.to_csv('green_hourly.csv')
df4.to_csv('evergreen_hourly.csv')
df5.to_csv('default_3hourly.csv')
df6.to_csv('realistic_hourly.csv')
