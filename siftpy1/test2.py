from PIL import Image
import sys
from pylab import *
from siftpy1 import *

im=Image.open("/home/burak/Desktop/crans_1_small.jpg")
im = im.resize((800,640))
a = asarray(im).flatten('C')
print a.shape
res = sift(a)
print res

