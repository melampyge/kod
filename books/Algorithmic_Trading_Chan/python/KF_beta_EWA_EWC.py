# the only part I am bugged about is Sharpe ratio is different and I
# had to use dropna to get this

import matplotlib.pylab as plt
import numpy as np
import pandas as pd
ewdf = pd.read_csv('ETF.csv')

x = ewdf[['ewa']].copy()
y = ewdf[['ewc']].copy()

x['intercept'] = 1.
print x.head()

x = np.array(x)
y = np.array(y)
delta=0.0001;

yhat = np.ones(len(y))*np.nan
e = np.ones(len(y))*np.nan
Q = np.ones(len(y))*np.nan
R = np.zeros((2,2))
P = np.zeros((2,2))

beta = np.zeros((2,len(y)))*np.nan

Vw=delta/(1-delta)*np.eye(2)

Ve=0.0001
beta[:, 0]=0.

for t in range(len(y)):
    if (t > 0):
        beta[:, t]=beta[:, t-1]
        R=P+Vw

    yhat[t]=np.dot(x[t, :],beta[:, t])
    tmp1 = np.dot(x[t, :],R)
    tmp2 = x[t, :].T
    Q[t] = np.dot(tmp1,tmp2) + Ve

    e[t]=y[t]-yhat[t]

    K=np.dot(R,x[t, :]).T / Q[t]

    #print R;print x[t, :].T;print Q[t];print 'K',K;print;print
    
    beta[:, t]=beta[:, t]+K*e[t]

    P=R-np.dot(np.dot(K,x[t, :]),R)

    #if t==2: 
print beta[0, :].T

plt.plot(beta[0, :].T)
plt.savefig('/tmp/beta0.png')
plt.hold(False)
plt.plot(beta[1, :].T)
plt.savefig('/tmp/beta1.png')


cols = ['ewa','ewc']
y2 = ewdf[cols]

longsEntry=e < -np.sqrt(Q)
longsExit=e > -np.sqrt(Q)

shortsEntry=e > np.sqrt(Q)
shortsExit=e < np.sqrt(Q)

numUnitsLong = pd.Series([np.nan for i in range(len(ewdf))])
numUnitsShort = pd.Series([np.nan for i in range(len(ewdf))])

numUnitsLong[0]=0.
numUnitsLong[longsEntry]=1
numUnitsLong[longsExit]=0
numUnitsLong = numUnitsLong.fillna(method='ffill')

numUnitsShort[0]=0.
numUnitsShort[shortsEntry]=-1
numUnitsShort[shortsExit]=0
numUnitsShort = numUnitsShort.fillna(method='ffill')

ewdf['numUnits']=numUnitsLong+numUnitsShort

tmp1 = np.tile(np.matrix(ewdf.numUnits).T, len(cols))
tmp2 = np.tile(np.matrix(-beta[0, :]).T, len(cols))

positions = np.array(tmp1) * np.array(tmp2) * np.array(ewdf[cols])
positions = pd.DataFrame(positions)

tmp1 = np.array(positions.shift(1))
tmp2 = np.array(y2-y2.shift(1))
tmp3 = np.array(y2.shift(1))
pnl = np.sum(tmp1 * tmp2 / tmp3,axis=1)
ret = pnl / np.sum(np.abs(positions.shift(1)),axis=1)
#ret = ret.fillna(0)
ret = ret.dropna()
print 'APR', ((np.prod(1.+ret))**(252./len(ret)))-1
print 'Sharpe', np.sqrt(252.)*np.mean(ret)/np.std(ret)

