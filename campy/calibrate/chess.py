#!/usr/bin/python
import sys
import cv

if __name__ == "__main__":
    cv.NamedWindow("win")
    filename = sys.argv[1]
    im = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_GRAYSCALE)
    im3 = cv.LoadImage(filename, cv.CV_LOAD_IMAGE_COLOR)

    dim = int(sys.argv[2])
    status,corners = cv.FindChessboardCorners( im, (dim,dim) )
    print corners
    
    print len(corners)
    
    cv.DrawChessboardCorners( im3, (dim,dim), corners, status)
    
    cv.ShowImage("win", im3);

    cv.WaitKey()
