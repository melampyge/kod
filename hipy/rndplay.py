# Plays mp3 files found under sys.argv[1] one by one, randomly. 
# Meant to simulate a radio.
import glob, os, random, sys
import threading
import select

while True:
    print "Music Dir", sys.argv[1]
    list = glob.glob(sys.argv[1])
    print '\n'
    idx = int(random.random() * len(list))
    print "# of songs", len(list), 
    "song idx selected", idx, 
    "song", list[idx]
    print '\n'
    os.system("mplayer '%s'" % list[idx] )
    print "Delete? (Press d for delete)..."
    k=""
    def input():
        global k
        i = 0
        while i < 1:
            i = i + 1
            r,w,x = select.select([sys.stdin.fileno()],[],[],2)
            if len(r) != 0:
                k  =sys.stdin.readline()


    T = threading.Thread(target=input)
    T.setDaemon(1)
    T.start()
    T.join(int(sys.argv[2])) # wait for [arg] seconds
    print ">>>>>>>>>" + k
    if 'd' in k:
        print "deleting ===================> " +  list[idx]
        cmd = "rm '%s'" % list[idx]
        os.system(cmd)

