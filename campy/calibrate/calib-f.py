#!/usr/bin/python
from pylab import *
import sys
import cv

if __name__ == "__main__":
    
    files = ['capture-1.jpg','capture-2.jpg', 'capture-3.jpg', 'capture-4.jpg', 'capture-5.jpg', 'capture-6.jpg']
    dist = [[-300,0,1500,1],[-300,0,1200,1],[-300,0,900,1], 
            [300,0,1500,1],[300,0,1200,1],[300,0,900,1]]
    t = [0.,-300.,-600.,0.,-300.,-600.]
    dim = 3
    
    cv.NamedWindow("win")

    fx = 317.29 # milimeters
    fy = 317.29 # milimeters

    s = 1056.49

    midx = 297.
    midy = 254.
             
    A = [[fx, 0., midx],[0., fy, midy],[0., 0., 1.]]    
    
    i = 0
    for file in files:
        filename = "../util/data/" + file
        im = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_GRAYSCALE)
        im3 = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_COLOR)
    
        status,corners = cv.FindChessboardCorners( im, (dim,dim) )
        #cv.DrawChessboardCorners( im3, (dim,dim), corners, status)
    
        X = dist[i]
        
        Rt = [[1., 0., 0., 0.],
              [0., 1., 0., 0.],
              [0., 0., 1., t[i]]]
                
        c = dot(A, dot(Rt, X)) / s 
        print "---------------"
        print "calc: "
        print c[0] / c[2], c[1] / c[2]
        print "real: " 
        print corners[5][0], corners[5][1]
        
        i += 1
        
        #cv.ShowImage("win", im3);
        #cv.WaitKey()
