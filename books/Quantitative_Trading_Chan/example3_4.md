
## Sharpe

http://edge-fund.com/Lo02.pdf

http://www.rinfinance.com/agenda/2012/talk/StevenPav.pdf

```python
import pandas.io.excel as xl
ige = xl.read_excel('IGE.xls')
ige = df.sort(columns='Date')
ige['Returns'] = ige['Adj Close'].pct_change()
print len(df)
print ige.head()
```

```text
1504
           Date   Open   High    Low  Close  Volume  Adj Close   Returns
1503 2001-11-26  91.01  91.01  91.01  91.01       0      42.09       NaN
1502 2001-11-27  91.01  91.01  91.01  91.01       0      42.09  0.000000
1501 2001-11-28  91.01  91.01  91.01  91.01       0      42.09  0.000000
1500 2001-11-29  91.01  91.01  91.01  91.01       0      42.09  0.000000
1499 2001-11-30  91.32  91.32  91.32  91.32     200      42.23  0.003326
```

```python
ige['excessRet'] = ige['Returns'] - 0.04/252.
sharpeRatio = np.sqrt(252.)*ige['excessRet'].mean() / ige['excessRet'].std()
print sharpeRatio
```

```text
0.789317538345
```

```python
import pandas.io.excel as xl
spy = xl.read_excel('SPY.xls')
spy['Returns'] = spy['Adj Close'].pct_change()
spy['netRet']=(ige['Returns'] - spy['Returns'])/2;
print spy.head()
```

```text
        Date    Open    High     Low   Close    Volume  Adj Close   Returns  \
0 2001-11-26  115.75  116.34  115.07  115.93  13726000     105.52       NaN   
1 2001-11-27  115.62  116.90  114.09  115.43  19261400     105.06 -0.004359   
2 2001-11-28  114.74  115.17  113.25  113.34  20195500     103.16 -0.018085   
3 2001-11-29  113.66  114.92  113.00  114.87  16354700     104.55  0.013474   
4 2001-11-30  114.40  114.91  114.02  114.05  13680300     103.81 -0.007078   

     netRet  
0       NaN  
1  0.011869  
2 -0.014389  
3 -0.015510  
4  0.006784  
```
































