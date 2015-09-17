import statsmodels.tsa.stattools as st
import matplotlib.pylab as plt
import numpy as np
import pandas as pd

df_caus = pd.read_csv('DEXCAUS.csv',parse_dates=True)
df_caus = df_caus[df_caus['DATE'] >= '2007-07-22']
df_caus = df_caus[df_caus['DATE'] <= '2012-03-28']
df_caus = df_caus[df_caus['VALUE'] != '.']
df_caus['VALUE'] = df_caus['VALUE'].astype(float)
plt.hold(False)
df_caus['VALUE'].plot()
plt.show()
print st.adfuller(df_caus['VALUE'],maxlag=1)

import hurst as h
print 'H doviz kuru', h.hurst(df_caus['VALUE'])

from arch.unitroot import VarianceRatio
vr = VarianceRatio(np.log(df_caus['VALUE']), 12)
print(vr.summary().as_text())
