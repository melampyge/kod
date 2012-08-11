import math
from pylab import *


'''
rope 27 cm off ground

measurements taken starting at 20 cm

pt lower right, 7 cm x 7 cm off center
pt lower left, 5.5 cm x 4.5 off center
Point (119 156)
Point (489 196)

Point (164 121)
Point (408 168)

Point (184 96)
Point (371 121)

Point (205 69)
Point (357 82)

Point (212 55)
Point (340 69)

Point (220 62)
Point (332 70)
'''

def d2r(t):
   r=(pi*t)/180
   return r

def r2d(r):
    t=(180*r)/pi
    return t

def norm(v1): return dot(v1, v1)

def angle(u1, u2): return arccos((dot(transpose(u1), u2) / (norm(u1)*norm(u2))))

# intrinsic matrix for my camera
A = [[710.83966064, 0., 352.25411987],[0., 689.31268311, 241.31982422],[0, 0, 1]]

a11 = dot(A, transpose([100, 100, 100]))
#a12 =  dot(a11, A) 
print a11

a21 = dot(A, transpose([200, 20, 200]))
#a22 =  dot(a21, A) 
print a21

