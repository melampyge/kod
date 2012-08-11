#!/usr/bin/python
import cv
from pylab import *
sys.path.append('/home/burak/kod/CamPy')
from K import *

color = cv.RGB(0, 255, 0)

cv.NamedWindow("win")
im = cv.LoadImage("../snap-0.jpg", cv.CV_LOAD_IMAGE_COLOR)
image_size = cv.GetSize(im)
print image_size[0]
print image_size[1]

#xl = -10
#yl = -10
#zl = 200

xl = -29  # azaldikca asagi iniyor
yl = 52 # azaldikca sola gidiyor
z = 102 # azaldikca yaklasiyor   

# smack middle of cam, at the end of table
xl =  0  # azaldikca asagi iniyor
yl = 0 # azaldikca sola gidiyor
z = 180 # azaldikca yaklasiyor   
          
for x in arange(xl-10, xl+15):
    for y in arange(yl-10, yl+15):
        X = array([x, y, z])
        q = dot(K, X)
        real_q = [q[0]/q[2], q[1]/q[2]]
        i_real_q = [int(real_q[0]), int(real_q[1])]
        if i_real_q[0] < image_size[1] and i_real_q[1] < image_size[0]:
            cv.Set2D(im, i_real_q[0], i_real_q[1], color)  


cv.ShowImage("win", im);
while 1:
    k = cv.WaitKey()
        
