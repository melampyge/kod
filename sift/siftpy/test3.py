from PIL import Image
import sys
from pylab import *
from siftpy import *

im=Image.open("../siftpp/data/img3.pgm")
a = asarray(im).flatten('C')
print a.shape
res = sift(a)
print res

out = open("img3.key", "w")
for line in res:    
    out.write(" ".join([str(x) for x in line]))
    out.write("\n")
out.close()    
