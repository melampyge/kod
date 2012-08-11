import sys
sys.path.append('/home/burak/devprogs/cvtypes/')
sys.path.append('util')
from CVtypes import cv
from lines import Lines
from pylab import *
from fundmatrix import *
from vgg_PX_from_6pts_3img import *

green = cv.Scalar()
green.val[0] = 0
green.val[1] = 255
green.val[2] = 0

white = cv.Scalar()
white.val[0] = 255
white.val[1] = 255
white.val[2] = 255

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

def plot_kalman_line(image, fr, to):        
    image_size = cv.GetSize(image)
    grayscale = cv.CreateImage(image_size, 8, 1)
    cv.CvtColor(image, grayscale, cv.BGR2GRAY)
    storage = cv.CreateMemStorage(0)
    cv.ClearMemStorage(storage)        
    
    p1 = cv.Point(int(fr[0]), int(fr[1]))
    p2 = cv.Point(int(to[0]), int(to[1]))
    cv.Line(image, p1, p2, green)

def plot_manual_line(image, fr, to):
    image_size = cv.GetSize(image)
    grayscale = cv.CreateImage(image_size, 8, 1)
    cv.CvtColor(image, grayscale, cv.BGR2GRAY)
    storage = cv.CreateMemStorage(0)
    cv.ClearMemStorage(storage)        
    
    p1 = cv.Point(int(fr[0]), int(fr[1]))
    p2 = cv.Point(int(to[0]), int(to[1]))
    cv.Line(image, p1, p2, white)

def plot_direction_lines(image, lines):
    # plot based on purely on dictionaries
    for endkey in lines.ends.keys():
        end = lines.ends[endkey]
        key = str(end[0]) + ":" + str(end[1])
        beg = lines.beg[key]
        plot_manual_line(frame, [beg[1], beg[2]], [float(endkey.split(":")[0]), float(endkey.split(":")[1])])
    # plot based on kalman filter calculations
    for line in lines.beg.values():
        begline = array([line[1], line[2]])
        y1 = line[2]
        yfinal = line[0].mu_hat[0]
        slope = line[0].mu_hat[1]
        x = line[1] + abs(y1-yfinal) * math.cos(math.atan(slope))
        endline = array([x, yfinal])
        plot_kalman_line(image, begline, endline)                        

def correct_axis(point, imsize):    
    return [point[0], imsize[1]-point[1]]

'''
We will always expect the first element in the corner array coming from 
chessboard function to have the top-leftmost item there. This is easy to check, 
if the topleft item arr[0] is pixelwise "below" arr[N-1], then reverse the array. 
opencv has origin 0,0 at topleft. 
'''
def reverse_corners_if_necessary(is_x, is_y):
    if is_y[0] < is_y[-1]:
        is_x.reverse()
        is_y.reverse()

def get_line_xy_from_dict_kalman(dict_value):
    begline = array([dict_value[1], dict_value[2]])
    y1 = dict_value[2]
    yfinal = dict_value[0].mu_hat[0]
    slope = dict_value[0].mu_hat[1]
    x = dict_value[1] + abs(y1-yfinal) * math.cos(math.atan(slope))
    endline = array([x, yfinal])
    return begline, endline    

def mid_points(corners1, corners2):
    return (corners1 + corners2) / 2

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
        # no argument on the command line, try to use the camera
        capture = cv.CreateCameraCapture (device)
    else:
        # we have an argument on the command line,
        # we can assume this is a file name, so open it
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

    was_x = None
    was_y = None
    
    lines = Lines()

    while 1:        
        frame_no += 1
        print frame_no

        if (frame_no == calc_frame):

            x1 = ones((6,3))
            x2 = ones((6,3))
            x3 = ones((6,3))
            imsize = [cv.GetSize(frame).width, cv.GetSize(frame).height]
            for kk in arange(6):
                begps, endps = get_line_xy_from_dict_kalman(lines.beg.values()[kk])
                midps = mid_points(begps, endps)
                x1[kk, 0] = correct_axis(begps, imsize)[0]
                x1[kk, 1] = correct_axis(begps, imsize)[1]
                x2[kk, 0] = correct_axis(midps, imsize)[0]
                x2[kk, 1] = correct_axis(midps, imsize)[1]
                x3[kk, 0] = correct_axis(endps, imsize)[0]
                x3[kk, 1] = correct_axis(endps, imsize)[1]

            print "x1 x2 x3"
            print x1, x2, x3

            XX = vgg_PX_from_6pts_3img(x1, x2, x3)
            print XX                        
            print XX[:,0]/XX[:,3], XX[:,1]/XX[:,3], XX[:,2]/XX[:,3]

        
        # capture the current frame
        frame = cv.QueryFrame(capture)
        if frame is None:
            break
 
        # mirror
        #cv.Flip(frame, None, 1)
        
        is_x, is_y = detect(frame)
        if len(is_x) > 0: reverse_corners_if_necessary(is_x, is_y)
                
        if (frame_no > starting_frame and len(is_x) > 0 ): 
            
            # is this the first time we detect something? if yes, "was" stuff
            # is empty, we need to fill them. otherwise, we have "was" and "is", 
            # we can move on to calculation
            if (was_x == None and was_y == None):
                was_x = is_x; was_y = is_y 
                continue
            else: 
                lines.process(was_x, was_y, is_x, is_y)
                plot_direction_lines(frame, lines)
                was_x = is_x; was_y = is_y 
                                 
        # display webcam image
        cv.ShowImage('Camera', frame)
                
        # handle events
        k = cv.WaitKey(10)
 
        if k == 0x1b: # ESC
            print 'ESC pressed. Exiting ...'
            break
