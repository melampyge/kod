import os, re, glob, sys, string;
dir = "/home/burak/kod/pocketbudda-mobile/app/mweb"

for subdir in ['btype','chinese','lewi','spiller']:
    os.chdir(dir + "/" + subdir)
    list = glob.glob('*')
    for file in list: 
        infile = open(dir + "/" + subdir + "/" + file)
        outfile = open("/tmp/mweb/" + subdir + "/" + file, "w")
        
        content = infile.read()
        content = "<meta name=\"viewport\" content=\"user-scalable=no, width=device-width\" />\n" + content
        outfile.write(content)
                
        outfile.close()
        infile.close()
