import datetime
import pandas as pd
import pandas.io.data

# Yahoo Finance
df = pd.io.data.get_data_yahoo('XU100.IS', 
                                 start=datetime.datetime(1999, 4, 29), 
                                 end=datetime.datetime(2015, 6, 1))
df.to_csv('ise.csv')

# FRED
#jpy = pd.io.data.DataReader('DEXUSEU', 'fred')
#jpy.to_csv('/tmp/DEXJPUS.csv')

