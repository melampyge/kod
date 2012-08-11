import sys

from opencv import cv
from opencv import highgui

MAX_COUNT = 100
image = None
pt = None

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
            for i in xrange(5): # paint 5x5 green dot at this location
                for j in xrange(5):                    
                    if (p.x < cv.cvGetSize(image).width-5 and p.y < cv.cvGetSize(image).height-5):
                        cv.cvSet2D(image, int(p.y)+i, int(p.x)+j, color)                                    
                        
        # we can now display the image
        highgui.cvShowImage ('Harris Corner', image)
        
        # handle events
        c = highgui.cvWaitKey (10)

