import os
yourdir="/home/burak/kod/pocketbudda-mobile/res/raw"
os.chdir(yourdir)
for file  in os.listdir(yourdir):
    f = file.replace("-", "") 
    f = f.replace(".xhtml", "") 
    f = "file" + f 
    f = f.lower()
    os.rename(file , f)
