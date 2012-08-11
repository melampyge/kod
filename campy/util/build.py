import os, sys

if sys.argv[1] == 'zip':
    os.system("zip ~/Dropbox/Public/skfiles/siftpy.zip -r ./siftpp ./siftpy --exclude=*.so --exclude=*.o --exclude=*.avi --exclude=./help/* ")
    
