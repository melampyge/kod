
```python
import pandas as pd
import pandas.io.excel as xl
ige = xl.read_excel('IGE.xls',index_col='Date')
ige = ige.sort_index()
ige['Returns'] = ige['Adj Close'].pct_change()
ige['excessRet'] = ige['Returns'] - 0.04/252.
sharpeRatio = np.sqrt(252.)*ige['excessRet'].mean() / ige['excessRet'].std()
print sharpeRatio
```

```text
0.789317538345
```

```python
import pandas.io.excel as xl
spy = xl.read_excel('SPY.xls',index_col='Date')
spy = spy.sort_index()
spy['Returns'] = spy['Adj Close'].pct_change()
spy['netRet']=(ige['Returns'] - spy['Returns'])/2.;
spy['cumret']=(1+spy['netRet']).cumprod()-1.0
print spy.head()
from scipy import io as spio
spio.savemat('spy_tmp', {'a': np.array(spy['cumret'])})
```

```text
              Open    High     Low   Close    Volume  Adj Close   Returns  \
Date                                                                        
2001-11-26  115.75  116.34  115.07  115.93  13726000     105.52       NaN   
2001-11-27  115.62  116.90  114.09  115.43  19261400     105.06 -0.004359   
2001-11-28  114.74  115.17  113.25  113.34  20195500     103.16 -0.018085   
2001-11-29  113.66  114.92  113.00  114.87  16354700     104.55  0.013474   
2001-11-30  114.40  114.91  114.02  114.05  13680300     103.81 -0.007078   

              netRet    cumret  
Date                            
2001-11-26       NaN       NaN  
2001-11-27  0.002180  0.002180  
2001-11-28  0.009042  0.011242  
2001-11-29 -0.006737  0.004429  
2001-11-30  0.005202  0.009654  
```

```python
spy['cumret'].plot()
plt.hold(False)
plt.savefig('example3_4_01.png')
```

![](example3_4_01.png)


## Max Drawdown

http://stackoverflow.com/questions/21058333/compute-rolling-maximum-drawdown-of-pandas-series

```python
def max_dd(ser):
    # max dd
    max2here = pd.expanding_max(ser)
    dd2here = ser - max2here
    # max dd duration
    ser2 = ser.fillna(method='bfill')
    i = np.argmax(np.maximum.accumulate(ser2) - ser2)
    j =   np.argmax(ser2[:i])
    return dd2here.min(),i-j,i,j
mdd,dur,i,j = max_dd(spy['cumret'])
print mdd,dur,i,j
```

```text
-0.136442445781 82 days 00:00:00 2006-10-04 00:00:00 2006-07-14 00:00:00
```

```python
spy = spy.fillna(method='bfill')
arr = np.array(spy['cumret'])
i = np.argmax(np.maximum.accumulate(arr) - arr)
j = np.argmax(arr[:i])
plt.hold(False)
plt.plot(arr)
plt.hold(True)
plt.plot([i, j], [arr[i], arr[j]], 'o', color='Red', markersize=10)
plt.savefig('example3_4_03.png')
plt.hold(False)
```

```python
print arr[i],arr[j],(arr[j]-arr[i]),i,j,i-j
```

```text
0.295382591617 0.431825037398 0.136442445781 1223 1166 57
```






## RANDOM DATA

```python
n = 1000
xs = np.random.randn(n).cumsum()
i = np.argmax(np.maximum.accumulate(xs) - xs) # end of the period
j = np.argmax(xs[:i]) # start of period
plt.plot(xs)
plt.hold(True)
plt.plot([i, j], [xs[i], xs[j]], 'o', color='Red', markersize=10)
plt.savefig('example3_4_02.png')
plt.hold(False)
```

![](example3_4_02.png)


























