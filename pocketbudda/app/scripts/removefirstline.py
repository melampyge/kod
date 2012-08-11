import os, re, glob, sys, string;
dir = "/home/burak/kod/pocketbudda-mobile/assets"

for subdir in ['btype','chinese','lewi','spiller']:
    os.chdir(dir + "/" + subdir)
    list = glob.glob('*')
    for file in list: 
        infile = open(dir + "/" + subdir + "/" + file)
        content = infile.read()
        outfile = open("/tmp/assets/" + subdir + "/" + file, "w")

        content = re.sub(r'<head>.*?</head>',"", content)    
        outfile.write(content)
        
        outfile.close()
        infile.close()
