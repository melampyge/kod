from datetime import datetime

def init_spiller_chinese():
  spiller_list = []  
  infile = open ("spiller")
  for line in infile.readlines():
      tokens = line.replace(" ","").replace("\"","").split(",")
      fr = datetime.strptime(tokens[0], '%Y-%m-%d').date()
      to = datetime.strptime(tokens[1], '%Y-%m-%d').date()
      spiller_list.append([fr, to, tokens[2].replace("\n","")])
  infile.close()

  chinese_list = []  
  infile = open ("chinese")
  for line in infile.readlines():
      tokens = line.replace(" ","").replace("\"","").split(",")
      fr = datetime.strptime(tokens[0], '%Y-%m-%d').date()
      to = datetime.strptime(tokens[1], '%Y-%m-%d').date()
      chinese_list.append([fr, to, tokens[2].replace("\n","")])
  infile.close()
  return spiller_list, chinese_list

lewidict = {}
infile = open("lewi.dat")
for line in infile.readlines():
  tokens = line.replace("\n","").split(" ")
  lewis = tokens[1].split(":")
  lewidict[tokens[0]] = lewis[:-1]

spiller_list, chinese_list = init_spiller_chinese()

def calculate(data, param):
    for line in data:
        if param >= line[0] and param <= line[1]: 
            return line[2]
          
outfile = open ("celebs","w")
file = open ("famousbday.txt")
for f in file.readlines():
  try:
      s = f.split(":")[2].replace("\n","")
      d = datetime.strptime(s, '%d/%m/%Y').date()
      bday =  d.strftime('%Y%m%d')
      name = f.split(":")[0].replace("\n","")
      occup = f.split(":")[1].replace("\n","")

      spiller = calculate(spiller_list, d)
      chinese = calculate(chinese_list, d)

      outfile.write(name + "|" + occup + "|" + ':'.join(lewidict[bday]) + ":" + spiller + ":" + chinese)
      outfile.write("\n")
      outfile.flush()
  except Exception, e:
      pass
  
outfile.close()                
