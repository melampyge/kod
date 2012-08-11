from pylab import *
from opencv import cv
from opencv import highgui
import sys

MAX_COUNT = 1
image = None
pt = None

invC = inv(array([[627.95196533, 0, 300.02764893],
               [0, 628.34637451, 261.79141235],
               [0, 0, 1]]))

if __name__ == '__main__':

    device = 0
    capture = highgui.cvCreateCameraCapture (device)
    if not capture:
        print "Error opening capture device"
        sys.exit (1)
        
    highgui.cvNamedWindow ('Harris Corner', highgui.CV_WINDOW_AUTOSIZE)

    while 1:
        # 1. capture the current image
        frame = highgui.cvQueryFrame (capture)
        if frame is None:
            # no image captured... end the processing
            break

        if image is None:
            # create the images we need
            image = cv.cvCreateImage (cv.cvGetSize (frame), 8, 3)
            image.origin = frame.origin
            grey = cv.cvCreateImage (cv.cvGetSize (frame), 8, 1)
            points = [[], []]

        # copy the frame, so we can draw on it
        cv.cvCopy (frame, image)

        # create a grey version of the image
        cv.cvCvtColor (image, grey, cv.CV_BGR2GRAY)

        # create the wanted images
        eig = cv.cvCreateImage (cv.cvGetSize (grey), 32, 1)
        temp = cv.cvCreateImage (cv.cvGetSize (grey), 32, 1)

        # the default parameters
        quality = 0.01
        min_distance = 30

        # search the good points
        points [1] = cv.cvGoodFeaturesToTrack (
            grey, eig, temp,
            MAX_COUNT,
            quality, min_distance, None, 3, 0, 0.04)
                
        color = cv.CV_RGB(0, 255, 0)
        
        for l in xrange(len(points[1])):
            p = points[1][l]
            xx = array([p.x, p.y, 1])
            print xx
            print invC
            print dot(invC, xx)
            print p
            
            for i in xrange(5): # paint 5x5 green dot at this location
                for j in xrange(5):                    
                    if (p.x < cv.cvGetSize(image).width-5 and p.y < cv.cvGetSize(image).height-5):
                        cv.cvSet2D(image, int(p.y)+i, int(p.x)+j, color)
                        
                        
        # we can now display the image
        highgui.cvShowImage ('Harris Corner', image)
        
        # handle events
        c = highgui.cvWaitKey (10)

'''
[20.000000 313.000000]
[-0.44593801  0.08149739  1.        ]


[[ 0.00159248  0.         -0.47778758]
 [ 0.          0.00159148 -0.41663551]
 [ 0.          0.          1.        ]]

 [  16.  371.    1.]

[-0.45230792  0.17380316  1.        ]


'''
