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

def sign(data, param): # works both for spiller and chinese
    for line in data:
        if param >= line[0] and param <= line[1]: 
            return line[2]

spiller_list, chinese_list = init_spiller_chinese()

infile = open("lewi.dat")
outfile = open ("pocketbudda.dat", "w")

for line in infile.readlines():
  tokens = line.replace("\n","").split(" ")
  lewis = tokens[1].split(":")
  s_date = tokens[0]
  date = datetime.strptime(s_date, '%Y%m%d').date()
  ls = lewis[:-1]
  spiller = sign(spiller_list, date)
  chinese = sign(chinese_list, date)
  outfile.write(s_date + " " + str(spiller) + ":" + str(chinese) +":" + ':'.join(ls))
  outfile.write("\n")
  outfile.flush()
    
outfile.close()                
