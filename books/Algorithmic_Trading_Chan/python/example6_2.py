# From Quantitative Trading
import matplotlib.pylab as plt
import numpy as np
import pandas as pd

df = pd.read_csv('SPY2.csv',parse_dates=True,index_col='Date')
df = df.sort_index()
df['ret'] = df['Adj Close'].pct_change()

r = df['ret'].mean()*252
s = df['ret'].std()*np.sqrt(252)
xr = r-0.04
sharpe = xr / s
kelly = xr / s**2
comp_levered_g = 0.04 + sharpe**2/2
comp_unlevered_g = r-s**2/2
print 'r', r
print 's', s
print 'artik getiri', xr
print 'sharpe orani', sharpe
print 'kelly orani', kelly
print 'biriken (kaldiracli) buyume orani', comp_levered_g
print 'biriken (kaldiracsiz) buyume orani', comp_unlevered_g
