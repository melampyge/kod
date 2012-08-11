from datetime import datetime

infile = open ("spiller")
for line in infile.readlines():
    tokens = line.replace(" ","").replace("\"","").split(",")
    print tokens
    fr = datetime.strptime(tokens[0], '%Y-%m-%d').date()
    to = datetime.strptime(tokens[1], '%Y-%m-%d').date()

    test_date = datetime.strptime("1900-01-01", '%Y-%m-%d').date()
    if test_date >= fr and test_date <= to: print "arada"
    
    test_date = datetime.strptime("1920-01-01", '%Y-%m-%d').date()
    if test_date >= fr and test_date <= to: print "arada"
    
    break
