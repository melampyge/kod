import pandas.io.excel as x

df = x.read_excel('p4v2013.xls')

df.to_csv('polity4v2013out.csv')
