
## Sharpe

http://edge-fund.com/Lo02.pdf

```python
import pandas.io.excel as xl
df = xl.read_excel('IGE.xls')
df = df.sort(columns='Date')
df['Returns'] = df['Adj Close'].pct_change()
print len(df)
print df.head()
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
df['excessRet'] = df['Returns'] - 0.04 /252.
sharpeRatio = np.sqrt(252.)*df['excessRet'].mean() / df['excessRet'].std()
print sharpeRatio
```

```text
0.789317538345
```































