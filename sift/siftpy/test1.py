import Image
import sys
import numpy as np
from siftpy import *
import cv
import copy
__start__ = 44
__scale__ = 3
            
def label_sift_point(image, xx, yy, label):
    line_type = cv.CV_AA  # change it to 8 to see non-antialiased graphics
    pt1 = cv.cvPoint (int(xx-6), int(yy+8))
    font = cv.cvInitFont (CV_FONT_HERSHEY_SIMPLEX, 1.0, 0.1, 0, 1, CV_AA)
    cvPutText (image, label, pt1, font, CV_RGB(255,255,0))

def is_point_in_region(point):
    if (point[0] > 150 and point[0] < 400 and point[1] > 100): return False
    return True
    
if __name__ == "__main__":
    
    tree = {}
    
    snap_no = 0
    print "Press ESC to quit, 't' to take a picture (image will be " 
    print "saved in a snap.jpg file"

    # create windows
    cv.NamedWindow('Camera')
 
    # create capture device
    device = 0 # assume we want first device

    capture = cv.CreateFileCapture ("/home/burak/Dropbox/Public/skfiles/campy/chessb-left.avi")
    #capture = cv.CreateCameraCapture (0)
    
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
            
    while True:
        
        # capture the current frame
        frame = cv.QueryFrame(capture)
        image_size = cv.GetSize(frame)
        print image_size
        gray = cv.CreateImage (image_size, 8, 1)
        cv.CvtColor(frame, gray, cv.CV_BGR2GRAY )
                
        # scale input image for faster processing
        small_img = cv.CreateImage((cv.Round(image_size[0]/__scale__),
                                    cv.Round(image_size[1]/__scale__)), 8, 1 )
        cv.Resize(gray, small_img, cv.CV_INTER_LINEAR )
        cv.EqualizeHist( small_img, small_img )
        arr = np.fromstring( small_img.tostring())                        
        s_res = sift(arr.flatten('C'))
        #s_res = sift(np.asarray(small_img).flatten('C'))

        n_res = np.array(s_res)
        
        #if frame_no == __start__ or mod(frame_no, 6) == 0:
        if frame_no == __start__:
            for idx, item in enumerate(n_res):
                tree[str(idx)] = (item[0:2], item[4:-1])            
            frame_no += 1
            continue
                
        tree_copy = copy.copy(tree)
                
        for item in n_res:
            xx = item[0]*__scale__
            yy = item[1]*__scale__
            pt = (int(xx), int(yy))
            if is_point_in_region(pt):            
                best = 999999999.
                bkey = None
                for key in tree_copy.keys():
                    d = sum(abs(diff(tree_copy[key][1] - item[4:-1])))
                    if d < best:
                        bkey = key; best = d 
                dist1 = [xx, yy] - tree_copy[bkey][0]
                dist = sqrt(dist1[0]**2 + dist1[1]**2)

                if dist > 100 or not bkey: continue
                
                tree[bkey][0][0] = xx
                tree[bkey][0][1] = yy
                cvCircle( frame, pt, 8, CV_RGB(100,100,255), 0, CV_AA, 0 ) 
                label_sift_point(frame, xx, yy, bkey)                
                del tree_copy[bkey]
        
        # display webcam image
        #cv.ShowImage('Camera', frame)                     
        cv.ShowImage('Camera', small_img)
        
        frame_no += 1
        
        # handle events        
        k = cv.WaitKey(40) 
        #k = cvWaitKey() 
        if k == "t":            
            cv.SaveImage('snap-' + str(snap_no) + '.jpg', frame)
            snap_no += 1
        if k == "": # ESC
            print 'ESC pressed. Exiting ...'
            break            
       
