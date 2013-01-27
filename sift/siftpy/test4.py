import Image
import sys
import numpy as np
from siftpy import *
import cv
__scale__ = 3
                
if __name__ == "__main__":
    
    # create windows
    cv.NamedWindow('Camera')
 
    # create capture device
    device = 0 # assume we want first device

    capture = cv.CreateFileCapture ("/home/burak/Dropbox/Public/skfiles/campy/chessb-left.avi")
    #capture = cv.CreateCameraCapture (0)
    
    cv.SetCaptureProperty(capture, cv.CV_CAP_PROP_FRAME_WIDTH, 640)
    cv.SetCaptureProperty(capture, cv.CV_CAP_PROP_FRAME_HEIGHT, 480)    
    
    # capture the current frame
    frame = cv.QueryFrame(capture)
    image_size = cv.GetSize(frame)
    gray = cv.CreateImage (image_size, 8, 1)  
    cv.CvtColor(frame, gray, cv.CV_BGR2GRAY )
    small_img = cv.CreateImage((cv.Round(image_size[0]/__scale__),
                                cv.Round(image_size[1]/__scale__)), 8, 1 )
    cv.Resize(gray, small_img, cv.CV_INTER_LINEAR )
    cv.EqualizeHist( small_img, small_img )
    arr = np.fromstring( small_img.tostring())
    s_res = sift(arr.flatten('C'))

    sys.exit(0)
        
