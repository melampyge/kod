from datetime import datetime
import sys
sys.path.append('..')
import calculate

file = open ("famousbday.txt")
outfile = open("celeb_life_goal.txt","w")
for f in file.readlines():
  try:
    s = f.split(":")[2].replace("\n","")
    d = datetime.strptime(s, '%d/%m/%Y').date()
    bday =  d.strftime('%Y%m%d')

    name = f.split(":")[0].replace("\n","")
    occup = f.split(":")[1].replace("\n","")
    res = calculate.calculate_millman(bday)
    outfile.write(name + ":" + occup + ":" + res[0])
    outfile.write("\n")
    outfile.flush()
  except Exception, e:    
    pass
  
outfile.close()
