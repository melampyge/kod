import os, re, glob, sys, string;

def run_command(command):
    '''
    run shell command and return the output as list
    '''
    result = []
    f = os.popen(command, "r")
    sys.stdout.flush()
    for l in f.xreadlines():
        result.append(l)
    return result

def detect():
    '''
    detect the scanner type, in format such as 001:003
    '''
    cmd = run_command("scanimage -L")
    s = ""
    for x in cmd: s += x 
    return re.search('(\d+:\d+)',s).group(1)

def two_digitize(i):
    '''
    turn single digit into two character digit
    '''
    if i < 10: return "0" + str(i)
    return str(i)

i = 0 # by default start with page 0
if len(sys.argv) > 1: i = int(sys.argv[1])

# detect device
device = detect()

while True:
    print two_digitize(i)
    run_command("scanimage --mode=Gray --resolution 200 -x 215 -y 297 -d plustek:libusb:%s --format=tiff > %s.tiff" % (device,two_digitize(i)))
    run_command("convert -scale %40 " + two_digitize(i) + ".tiff " + two_digitize(i) + ".jpg" )
    i += 1
    r = raw_input(">")
