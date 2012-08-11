import os, sys

if sys.argv[1] == 'zip':    
    cmd = "zip ~/Dropbox/Public/skfiles/siftpy.zip * -r --exclude=*/*/*.o  --exclude=*/*.so  " 
    os.system(cmd)
