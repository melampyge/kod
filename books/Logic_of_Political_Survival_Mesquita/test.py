import pandas.io.excel as x
df = x.read_excel('/home/burak/Downloads/ddrevisited_data_v1.xls')
df.to_csv('/tmp/out.csv',encoding='utf-8')
