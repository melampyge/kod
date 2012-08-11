import os, sys

wav = sys.argv[1]

output = os.popen('arecord -d 1 -f dat').read() 
outfile = open(wav + ".wav", "w")
outfile.write(output)

