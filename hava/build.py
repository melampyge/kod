import os, sys

if sys.argv[1] == 'zip':
    os.system("zip ~/Dropbox/hava-backup.zip -r * --exclude=.git/* --exclude=./android/bin/* ")
    
