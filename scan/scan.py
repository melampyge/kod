import os, re, glob, sys, string;

def run_command(command):
    result = []
    f = os.popen(command, "r")
    sys.stdout.flush()
    for l in f.xreadlines():
        result.append(l)
    return result

def twod(i): return "0"+str(i) if i < 10 else str(i)

i = int(sys.argv[1])
while True:
    print twod(i)
    run_command("scanimage --mode=Color --resolution 200 -x 215 -y 297 -d plustek:libusb:002:003 --format=tiff > " + two_digitize(i) + ".tiff")
    run_command("convert -scale %40 " + twod(i) + ".tiff " + twod(i) + ".jpg" )
    i += 1
    r = raw_input(">")
