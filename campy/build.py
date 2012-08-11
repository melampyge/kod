import os, sys

if sys.argv[1] == 'zip':
    os.system("zip ~/Dropbox/campy-backup.zip -r * --exclude=*.so --exclude=*.o --exclude=*.avi --exclude=./help/* ")
    
