import datetime
import pandas as pd
import pandas.io.data

# Yahoo Finance
#s = pd.io.data.get_data_yahoo('MSFT', 
#                               start=datetime.datetime(2013, 1, 1), 
#                               end=datetime.datetime(2015, 9, 30))
#s.to_csv('/tmp/msft.csv')

# FRED
jpy = pd.io.data.DataReader('DEXUSEU', 'fred')
jpy.to_csv('/tmp/DEXJPUS.csv')

