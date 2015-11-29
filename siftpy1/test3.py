from PIL import Image
import sys
from pylab import *
from siftpy1 import *

#im=Image.open("crans_1_small.jpg")
im=Image.open("crans_1_small.pgm")
#im = im.resize((800,640))
a = asarray(im).flatten('C')
res = sift(a)
sifts = [x[0:2] for x in res]

for x in sifts: plt.plot(x[0],x[1],'o'); plt.hold(True)
plt.hold(True)
plt.imshow(im)
plt.savefig('test_01.png')
