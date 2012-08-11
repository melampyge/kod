import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as si
from PIL import Image
import numpy.linalg as lin
import itertools
import deriv

def lk(g, im1, im2, i_s, j_s, window_size):
    fx, fy, ft = deriv.deriv(im1, im2, g)
    halfWindow = np.floor(window_size/2)
    res = []
    for i,j in itertools.izip(i_s,j_s):
        curFx = fx[i-halfWindow-1:i+halfWindow, 
                   j-halfWindow-1:j+halfWindow]
        curFy = fy[i-halfWindow-1:i+halfWindow, 
                   j-halfWindow-1:j+halfWindow]
        curFt = ft[i-halfWindow-1:i+halfWindow, 
                   j-halfWindow-1:j+halfWindow]
        curFx = curFx.T
        curFy = curFy.T
        curFt = curFt.T

        curFx = curFx.flatten(order='F') 
        curFy = curFy.flatten(order='F') 
        curFt = -curFt.flatten(order='F') 

        A = np.vstack((curFx, curFy)).T
        U = np.dot(np.dot(lin.pinv(np.dot(A.T,A)),A.T),curFt)
        res.append((i,j,U[0],U[1]))
    return res
        
if __name__ == "__main__":      
    x=165
    y=95
    win=50
    im1 = np.asarray(Image.open('flow1-bw-0.png'))
    print im1.shape
    #im2 = np.asarray(Image.open('flow2-bw-0.png'))
    #im2 = np.asarray(Image.open('upright.png'))
    im2 = np.asarray(Image.open('dleft.png'))
    print im2.shape
    u, v = lk(im1, im2, x, y, win)
    print u, v
    plt.imshow(im1, cmap='gray')
    plt.hold(True)
    plt.plot(x,y,'+r');
    plt.plot(x+u*3,y+v*3,'og')
    plt.show()
