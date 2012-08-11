import Image
from numpy import *
import ImageQt
import opencv
from opencv import adaptors
from opencv.cv import *

def dotrack(img): 
    res = adaptors.Ipl2NumPy(img)
    return img

def color_green(img, x, y):
    cvSet2D(img, x, y, mark_color)
    
