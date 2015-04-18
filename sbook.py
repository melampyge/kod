import os, re, glob, sys, string;
        
def two_digitize(i):
    if i < 10: return "0" + str(i)
    return str(i)

def run_command(command):
    result = []
    f = os.popen(command, "r")
    sys.stdout.flush()
    for l in f.xreadlines():
        result.append(l)
    return result

run_command("convert -unsharp 1.5x1.2+1.0+0.10 -crop 300x300+10+0 01.tiff /tmp/gray.tiff")
run_command("convert -monochrome /tmp/gray.tiff /tmp/mono.tiff")
run_command("cjb2 -clean /tmp/mono.tiff /home/burak/book.djvu")

for a in range(30):
    i = a + 1
    file1 = str(two_digitize(i)) + ".tiff"
    print file1
    run_command("convert -unsharp 1.5x1.2+1.0+0.10  " + str(file1) + " /tmp/gray.tiff")
    run_command("convert -monochrome /tmp/gray.tiff /tmp/mono.tiff")
    run_command("cjb2 -clean /tmp/mono.tiff /tmp/page.djvu")
    run_command("djvm -i /home/burak/book.djvu /tmp/page.djvu")

