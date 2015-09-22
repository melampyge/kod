# From Quantitative Trading
import matplotlib.pylab as plt
import numpy as np
import pandas as pd

dfoih = pd.read_csv('OIH.csv',index_col='Date')
dfrkh = pd.read_csv('RKH.csv',index_col='Date')
dfrth = pd.read_csv('RTH.csv',index_col='Date')

df = dfoih.join(dfrkh['Adj Close'],rsuffix='_rkh')
df = df.join(dfrth['Adj Close'],rsuffix='_rth')
df = df.drop(['Low','Open','High','Close','Volume'],axis=1)
df = df.dropna()
df = df.sort_index()
print df.head()

df['oihxret'] = df['Adj Close'].pct_change() - 0.04/252
df['rkhxret'] = df['Adj Close_rkh'].pct_change() - 0.04/252
df['rthxret'] = df['Adj Close_rth'].pct_change() - 0.04/252

M = 252*df[['oihxret','rkhxret','rthxret']].mean()
C = 252*df[['oihxret','rkhxret','rthxret']].cov()
print M
print C

import numpy.linalg as lin
F = np.dot(lin.inv(C),M)
print F

F = F.reshape((3,1))
g = 0.04+np.dot(np.dot(F.T,C),F/2)
print g

S = np.sqrt(np.dot(np.dot(F.T,C),F))
print S
