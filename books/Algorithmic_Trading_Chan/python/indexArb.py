import matplotlib.pylab as plt
import numpy as np
import pandas as pd
import pandas as pd, zipfile

with zipfile.ZipFile('SPY3.zip', 'r') as z:
    dfspy3 =  pd.read_csv(z.open('SPY3.csv'),sep=',')
dfspy3 = dfspy3.set_index('Date')

train = dfspy3[(dfspy3.index>=20070101) & (dfspy3.index<=20071231)]
testspy3 = dfspy3[(dfspy3.index > 20071231)]
resdf = pd.DataFrame(index=dfspy3.columns)
resdf['isCoint'] = np.nan

from johansen import coint_johansen, print_johan_stats
for s in dfspy3.columns: 
   if s == 'SPY': continue
   # johansen cagrisini kullaniyoruz boylece y,x hangisi secmemiz 
   # gerekmiyor
   data = train[[s,'SPY']].dropna()
   if len(data) < 250: continue
   res = coint_johansen(data, 0, 1)
   if res.lr1[0] > res.cvt[0][0]: 
       resdf.loc[s,'isCoint'] = True
print resdf.isCoint.sum()


coint_cols = list(resdf[resdf.isCoint==True].index)
yN = train[coint_cols]
logMktVal_long = np.log(yN).sum(axis=1)
ytest = pd.concat([logMktVal_long, np.log(train.SPY)],axis=1)
res = coint_johansen(ytest, 0, 1)
print_johan_stats(res)

tmp1 = np.ones((len(testspy3),resdf.isCoint.sum()))*res.evec[0,0]
tmp2 = np.ones((len(testspy3),1))*res.evec[1,0]
weights = np.hstack((tmp1,tmp2))
yNplus = testspy3[coint_cols + ['SPY']]
logMktVal = np.sum(weights * np.log(yNplus),axis=1)
lookback=5
data_mean = pd.rolling_mean(logMktVal, window=lookback)
data_std = pd.rolling_std(logMktVal, window=lookback)
numUnits = -1*(logMktVal-data_mean) / data_std

numUnits2 = np.reshape(numUnits, (len(numUnits),1))
positions = pd.DataFrame(np.tile(numUnits2, weights.shape[1]),\
                        columns=yNplus.columns)*weights
tmp1 = np.log(yNplus)-np.log(yNplus.shift(1))
pnl = np.sum(np.array(positions.shift(1)) * np.array(tmp1), axis=1)
ret = pnl / np.sum(np.abs(positions.shift(1)),axis=1)
print 'APR', ((np.prod(1.+ret))**(252./len(ret)))-1
print 'Sharpe', np.sqrt(252.)*np.mean(ret)/np.std(ret)


plt.plot(np.cumprod(1+ret)-1)
#plt.show()

