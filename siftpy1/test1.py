from PIL import Image
import sys
from pylab import *
from siftpy1 import *

im=Image.open("img3.pgm")
a = asarray(im).flatten('C')
print a.shape
res = sift(a)
print res

out = open("/tmp/img3.key", "w")
for line in res:    
    out.write(" ".join([str(x) for x in line]))
    out.write("\n")
out.close()    
