import pandas as pd, datetime
import pandas.io.data as web

# Stocks
start=datetime.datetime(2013, 1, 1)
end=datetime.datetime(2015, 9, 30)
s = web.DataReader("MSFT", 'yahoo', start, end)
print s

# Options

from pandas.io.data import Options

aapl = Options('AAPL',"yahoo")
df = aapl.get_options_data()
print df.head()

# FRED

jpy = web.DataReader('DEXUSEU', 'fred')
print jpy
