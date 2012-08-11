import sys
sys.path.append('/home/burak/devprogs/cvtypes/')
from CVtypes import cv
from pylab import *
from kalman_translate import *

green = cv.Scalar()
green.val[0] = 0
green.val[1] = 255
green.val[2] = 0

white = cv.Scalar()
white.val[0] = 255
white.val[1] = 255
white.val[2] = 255

# camera matrix
K = array([[653.52398682, 0., 326.47888184], 
           [0., 653.76440430, 259.63595581],
           [0., 0., 1.]])

#translation matrix, constant speed is assumed
#table is 180 cm long, start at 55, last frame 200, 
#speed 145frames/180cm = 1.24cm/frame
T = [[1, 0, 0, 0],
     [0, 1, 0, -1.24],
     [0, 0, 1, 0],
     [0, 0, 0, 1]]

def detect(image):
    image_size = cv.GetSize(image)
 
    # create grayscale version
    grayscale = cv.CreateImage(image_size, 8, 1)
    cv.CvtColor(image, grayscale, cv.BGR2GRAY)
    storage = cv.CreateMemStorage(0)
    cv.ClearMemStorage(storage)    
    
    im = cv.CreateImage (image_size, 8, 3)    
    status = cv.FindChessboardCorners( grayscale, (dim,dim), corners, flags = 1) 
    if status: 
        cv.DrawChessboardCorners( image, (dim,dim), corners, pattern_was_found = status, count=9)
        is_x = [p.x for p in corners]
        is_y = [p.y for p in corners]
        return is_x, is_y
    return [], []

'''
opencv has origin 0,0 at topleft.
'''
def correct_axis(point, imsize):    
    return [point[0], imsize[1]-point[1]]

if __name__ == "__main__":

    frame_no = 0
    
    # create windows
    cv.NamedWindow('Camera')
 
    # create capture device
    device = 0 # assume we want first device
    
    print sys.argv
    if len (sys.argv) == 2:
        dim = int(sys.argv[1]) 
        starting_frame = int(sys.argv[2])
        calc_frame = int(sys.argv[3]) 
        last_frame = int(sys.argv[4]) 
        capture = cv.CreateCameraCapture (device)
    else:
        capture = cv.CreateFileCapture (sys.argv [1])
        dim = int(sys.argv[2]) 
        starting_frame = int(sys.argv[3])    
        calc_frame = int(sys.argv[4]) 
        last_frame = int(sys.argv[5]) 

    print "Press ESC to exit ..."
    print "dim="+str(dim)
    pts = dim * dim
    mid = int(pts / 2)
    corners = (cv.Point2D32f * pts)() # weird ass way to create an array
    
    cv.SetCaptureProperty(capture, cv.CAP_PROP_FRAME_WIDTH, 640)
    cv.SetCaptureProperty(capture, cv.CAP_PROP_FRAME_HEIGHT, 480)    
 
    # check if capture device is OK
    if not capture:
        print "Error opening capture device"
        sys.exit(1)
        
    kalman = Kalman(T, K)
    
    while 1:        
        frame_no += 1
        print frame_no

        
        # capture the current frame
        frame = cv.QueryFrame(capture)
        if frame is None:
            break
 
        # mirror
        cv.Flip(frame, None, 1)
        
        is_x, is_y = detect(frame)                
        if (frame_no > starting_frame and len(is_x) > 0 ):             
            kalman.update(array([is_x[5], is_y[5]]))
            print kalman.mu_hat_est
            print kalman.cov_est
        
        # display webcam image
        cv.ShowImage('Camera', frame)
                
        # handle events
        k = cv.WaitKey(10)
 
        if k == 0x1b: # ESC
            print 'ESC pressed. Exiting ...'
            break
