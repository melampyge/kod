import datetime
import pandas as pd
import pandas.io.data

# Yahoo Finance
#aapl = pd.io.data.get_data_yahoo('MSFT', 
#                                 start=datetime.datetime(2006, 10, 1), 
#                                 end=datetime.datetime(2015, 6, 1))
#aapl.to_csv('/tmp/aapl_ohlc.csv')

# FRED
jpy = pd.io.data.DataReader('DEXUSEU', 'fred')
jpy.to_csv('/tmp/DEXJPUS.csv')

