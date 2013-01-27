from PIL import Image
import sys
import cv
from pylab import *
from siftpy import *
import copy
__start__ = 44
__scale__ = 1
            
def label_sift_point(image, xx, yy, label):
    line_type = cv.CV_AA  # change it to 8 to see non-antialiased graphics
    pt1 = cv.Point (int(xx-6), int(yy+8))
    font = cv.InitFont (cv.CV_FONT_HERSHEY_SIMPLEX, 1.0, 0.1, 0, 1, cv.CV_AA)
    cvPutText (image, label, pt1, font, cv.CV_RGB(255,255,0))

def is_point_in_region(point):
    if (point[0] > 150 and point[0] < 500 and point[1] > 50): return False
    return True
    
if __name__ == "__main__":
        
    snap_no = 0
    print "Press ESC to quit, 't' to take a picture (image will be " 
    print "saved in a snap.jpg file"

    # create windows
    cv.NamedWindow('Camera', cv.CV_WINDOW_AUTOSIZE)
 
    # create capture device
    device = 0 # assume we want first device

    capture = cv.CreateFileCapture ("/home/burak/Dropbox/Public/skfiles/campy/chessb-left.avi")
    #capture = cvCreateCameraCapture (0)
    
    cv.SetCaptureProperty(capture, cv.CV_CAP_PROP_FRAME_WIDTH, 640)
    cv.SetCaptureProperty(capture, cv.CV_CAP_PROP_FRAME_HEIGHT, 480)    
    
    # check if capture device is OK
    if not capture:
        print "Error opening capture device"
        sys.exit(1)
        
    # fast forward
    frame_no = 0
    while (frame_no < __start__):
        frame = cv.QueryFrame(capture)
        frame_no += 1
    
    while 1:
        
        # capture the current frame
        frame = cv.QueryFrame(capture)
        if frame:

            print "------"
            
            gray = cv.CreateImage ((frame.width, frame.height), 8, 1)
            cv.CvtColor( frame, gray, cv.CV_BGR2GRAY )

            # scale input image for faster processing
            small_img = cv.CreateImage((cv.Round(frame.width/__scale__),
                                        cv.Round(frame.height/__scale__)), 8, 1 )
            cv.Resize(gray, small_img, cv.CV_INTER_LINEAR )
            cv.EqualizeHist( small_img, small_img )
            pi = Image.fromstring("L", cv.GetSize(small_img), small_img.tostring())            
            s_res = sift(ravel(cv.PIL2NumPy(pi)))
            n_res = array(s_res)


            for item in n_res:
                xx = item[0]*__scale__
                yy = item[1]*__scale__
                pt = (int(xx), int(yy))
                if is_point_in_region(pt):            
                    cv.Circle( frame, pt, 8, cv.CV_RGB(100,100,255), 0, cv.CV_AA, 0 ) 

            # display webcam image
            cv.ShowImage('Camera', frame)                     

            frame_no += 1
        
        # handle events        
        k = cv.WaitKey(40) 
        #k = cvWaitKey() 
        if k == "t":            
            cv.SaveImage('snap-' + str(snap_no) + '.jpg', frame)
            snap_no += 1
        if k == 27: # ESC
            print 'ESC pressed. Exiting ...'
            break            
       
