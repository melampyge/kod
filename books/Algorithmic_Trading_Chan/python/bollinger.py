import statsmodels.tsa.stattools as st
import matplotlib.pylab as plt
import numpy as np
import pandas as pd

df['hedgeRatio'] = pd.read_csv('hedge.csv')['hedgeRatio']
yport = np.ones(df[cols].shape); yport[:,0] = -df['hedgeRatio']
yport = yport * df[cols]
# altta sum() kullanmadik cunku nan + deger = deger sonucu cikiyordu
yport = yport['GLD'] + yport['USO'] 
data_mean = pd.rolling_mean(yport, window=20)
data_std = pd.rolling_std(yport, window=20)
zScore=(yport-data_mean)/data_std

entryZscore=1.
exitZscore=0

longsEntry=zScore < -entryZscore
longsExit=zScore > -exitZscore
shortsEntry=zScore > entryZscore
shortsExit=zScore < exitZscore

numUnitsLong = pd.Series([np.nan for i in range(len(df))])
numUnitsShort = pd.Series([np.nan for i in range(len(df))])
numUnitsLong[0] = 0.
numUnitsShort[0] = 0.

numUnitsLong[longsEntry] = 1.0
numUnitsLong[longsExit] = 0.0
numUnitsLong = numUnitsLong.fillna(method='ffill')

numUnitsShort[shortsEntry] = -1.0
numUnitsShort[shortsExit] = 0.0
numUnitsShort = numUnitsShort.fillna(method='ffill')
df['numUnits'] = numUnitsShort + numUnitsLong

tmp1 = np.ones(df[cols].shape) * np.array([df['numUnits']]).T
tmp2 = np.ones(df[cols].shape); tmp2[:, 0] = -df['hedgeRatio']
positions = pd.DataFrame(tmp1 * tmp2 * df[cols]).fillna(0)
pnl = positions.shift(1) * (df[cols] - df[cols].shift(1))  / df[cols].shift(1)
pnl = pnl.sum(axis=1)
ret=pnl / np.sum(np.abs(positions.shift(1)),axis=1)
print 'APR', ((np.prod(1.+ret))**(252./len(ret)))-1
print 'Sharpe', np.sqrt(252.)*np.mean(ret)/np.std(ret)
