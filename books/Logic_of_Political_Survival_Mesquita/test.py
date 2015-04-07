import pandas.io.excel as x
df = x.read_excel('/home/burak/Downloads/CNTSDATA.xls')
df.to_csv('/tmp/CNTSDATA.csv',encoding='utf-8')
