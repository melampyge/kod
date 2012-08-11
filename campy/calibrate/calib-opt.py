#!/usr/bin/python
from pylab import *
from scipy.optimize import fmin
from numpy.linalg import *
import sys
import cv

if __name__ == "__main__":
    
    files = ['capture-1.jpg','capture-2.jpg', 'capture-3.jpg', 'capture-4.jpg', 'capture-5.jpg', 'capture-6.jpg']
    dist = [[-300,0,1500,1],[-300,0,1200,1],[-300,0,900,1], 
            [300,0,1500,1],[300,0,1200,1],[300,0,900,1]]
    t = [0.,-300.,-600.,0.,-300.,-600.]
    dim = 3
    
    cv.NamedWindow("win")
     
    #midx = 313.
    #midy = 239.
    
    i = 0
    
    actual = zeros((len(files), 2))
    calc = zeros((len(files), 2))
    cc = zeros((len(files), 2))

    def err(w):        
        for k in arange(len(t)):
            #A = [[w[0], 0., midx],[0., w[1], midy],[0., 0., 1.]]    
            A = [[w[0], 0., w[3]],[0., w[0], w[4]],[0., 0., 1.]]    

            Rt = [[1., 0., 0., 0.],
                  [0., 1., 0., 0.],
                  [0., 0., 1., t[k]]]                

            c = dot(A, dot(Rt, dist[k])) / w[2]
            calc[k,0] = c[0] / c[2]
            calc[k,1] = c[1] / c[2]

        diff = calc - cc
        e = norm(diff)
        return e
                
    for file in files:
        filename = "../util/data/" + file
        im = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_GRAYSCALE)
        im3 = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_COLOR)
    
        status,corners = cv.FindChessboardCorners( im, (dim,dim) )
        cc[i,0] = corners[i][0]
        cc[i,1] = corners[i][1]
        
        i += 1
        
    #              fx  fy  s       
    #v = fmin(err, [200, 200, 1000],maxiter=10000, maxfun=None)
    v = fmin(err, [200, 200, 1000, 320, 220],maxiter=10000, maxfun=None)
    print v
        
        
        
