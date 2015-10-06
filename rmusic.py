import os, random, glob

dir = "/tmp/music/"

ms = glob.glob("/home/burak/Music/*.mp3")
idxs = range(len(ms))
print len(ms)

cc = [ms[random.choice(idxs)] for i in range(100)]

for c in cc:
    cmd = 'cp \"%s\" %s' % (c,dir)
    os.system(cmd)
    print cmd
