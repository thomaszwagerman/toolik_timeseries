#! /usr/bin/env python

# pyallTS.py
# 1. Draws all variables in a wrf TIME_SERIES.out file
#
# Version 0.1
# Date 27 Nov 2017
# Author: jbm, edited by tz
# Latest: 10:54 28/11/17
#
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import datetime as dt
plt.style.use('seaborn-deep')

#inpath = '/scratch/local/output/toolik/default/'
#inpath2 = '/scratch/local/output/toolik/green/'

# Thomas - change the two lines below to link to where you have stored the data files.
inpath = ''
inpath2 = ''

####################
infilename1 = inpath+'tooldefault.d03.TS'
df1 = pd.read_csv(infilename1,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

infilename2 = inpath2+'toolgreen.d03.TS'
df2 = pd.read_csv(infilename2,delim_whitespace=1,skiprows=1, header = None,
                 names = ["id", "ts_hour", "id_tsloc", "ix", "iy", "t", "q",
                          "u", "v", "psfc", "glw", "gsw", "hfx", "lh",
                          "grdflx", "tsk", "tslb(1)", "rainc",
                          "rainnc", "clw"])

# Add the decimal hour data to the base datetime
# Need to get this from the namelist or wrfout files eventually.
df1['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df1['ts_hour'], unit='h'))
df2['ts_hour'] = pd.to_datetime(dt.datetime(2015,4,21)+pd.to_timedelta(df2['ts_hour'], unit='h'))

# Convert temperatures to Celcius
df1['t']= df1['t']-273.16
df1['tslb(1)']= df1['tslb(1)']-273.16
df1['tsk']= df1['tsk']-273.16

df2['t']= df2['t']-273.16
df2['tslb(1)']= df2['tslb(1)']-273.16
df2['tsk']= df2['tsk']-273.16

df1 = df1.set_index(['ts_hour'])
startTime=pd.to_datetime(df1.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df1.index[-1])

df2 = df2.set_index(['ts_hour'])
startTime=pd.to_datetime(df2.index[0])   # returns a TimeStamp
endTime=pd.to_datetime(df2.index[-1])

# Take the mean over 60 minutes ie 1H
df1=df1.resample('1H').mean()
df2=df2.resample('1H').mean()

# Plot differences in sensible heat flux
#df1['diffd-g'] = (df1['hfx']-df2['hfx'])

# Plot differences in air temperature
df1['diffd-g'] = (df1['t']-df2['t'])
#Plot differences in surface sensible heat
df1['diffd-h'] = (df1['hfx']-df2['hfx'])
#Plot differences in surface latent heat flux
df1['diffd-lh'] = (df1['lh']-df2['lh'])
#Plot differences in soil heat flux
df1['diffd-sh'] = (df1['grdflx']-df2['grdflx'])
#Plot differences in soil surface temp
df1['diffd-st'] = (df1['tslb(1)'])-df2['tslb(1)']

ax1=df1[['diffd-g']].plot()
#df1[['diffd-n']].plot(ax=ax)
#df1[['diffd-u']].plot(ax=ax)

ax1.set_xlabel("Date")
ax1.set_ylabel("Air temperature difference (oC)")
plt.savefig('Toolik_diff1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax2=df1[['diffd-h']].plot()
ax2.set_xlabel("Date")
ax2.set_ylabel("Surface Sensible Heat (W/M^2)")
plt.savefig('Toolik_diff2_21_Apr_15_diff.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax3=df1[['diffd-lh']].plot()
ax3.set_xlabel("Date")
ax3.set_ylabel("Surface Latent Heat Flux (W/M^2)")
plt.savefig('Toolik_diff3_21_Apr_15_diff.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax4=df1[['diffd-sh']].plot()
ax4.set_xlabel("Date")
ax4.set_ylabel("Soil Heat Flux")
plt.savefig('Toolik_diff4_21_Apr_15_diff.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

ax5=df1[['diffd-st']].plot()
ax5.set_xlabel("Date")
ax5.set_ylabel("Soil Top Layer Temp")
plt.savefig('Toolik_diff5_21_Apr_15_diff.png', dpi=300, bbox_inches='tight', pad_inches=0.5)

# ax1=df[['hfx','lh','grdflx']].plot()
# ax1.set_xlabel("Date")
# ax1.set_ylabel("W/m2")
# ax1.set_title('Toolik Energy Balance')
# plt.savefig('Toolik_1_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)
#
# ax2=df[['t','tslb(1)','tsk']].plot()
# ax2.set_xlabel("Date")
# ax2.set_ylabel("oC")
# ax2.set_title('Toolik Soil and Air Temperature')
# plt.savefig('Toolik_2_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)
#
#
# ax3=df[['rainc','clw']].plot()
# ax3.set_xlabel("Date")
# ax3.set_ylabel("mm")
# ax3.set_title('Toolik Rain and Cloud Water Content')
# plt.savefig('Toolik_3_21_Apr_15.png', dpi=300, bbox_inches='tight', pad_inches=0.5)


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
