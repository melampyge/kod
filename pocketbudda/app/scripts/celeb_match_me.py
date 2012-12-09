import sys
from datetime import datetime
sys.path.append('..')
import calculate

file = open ("../famousbday.txt")
for f in file.readlines():
  s = f.split(":")[2].replace("\n","")
  name = f.split(":")[0].replace("\n","")
  occup = f.split(":")[1].replace("\n","")    
  try:
    d = datetime.strptime(s, '%d/%m/%Y').date()
    res =  calculate.calculate(d.strftime('%Y%m%d'))
    if "mathematician" in occup: 
      if "194" in res[0]:
        print name, res, occup, d
      #if res[0][0] == '22' and res[3][0] == '303':
      #  print name, res, occup, d
  except Exception, e:
    pass

