import sys
sys.path.append('/home/burak/devprogs/cvtypes/')
from CVtypes import cv

color = cv.RGB(0, 255, 0)

def save(pic, num):
    cv.SaveImage('capture-' + str(num) + '.jpg', pic)
    num += 1

def color_point(image, p):        
    for i in xrange(5): # paint 5x5 green dot at this location
        for j in xrange(5):                    
            cv.Set2D(image, int(p[1])+i, int(p[0])+j, color)

def detect(image):
    image_size = cv.GetSize(image)
 
    # create grayscale version
    grayscale = cv.CreateImage(image_size, 8, 1)
    cv.CvtColor(image, grayscale, cv.BGR2GRAY)
    storage = cv.CreateMemStorage(0)
    cv.ClearMemStorage(storage)    
    
    im = cv.CreateImage (image_size, 8, 3)    
    status = cv.FindChessboardCorners( grayscale, (dim,dim), corners, flags = 1) 
    color_point(image, [320, 240])
    if status: 
        cv.DrawChessboardCorners( image, (dim,dim), corners, pattern_was_found = status, count=9)
        print corners[5]
        print "---------------"
        
if __name__ == "__main__":
  
    # create windows
    cv.NamedWindow('Camera')
 
    # create capture device
    device = 0 # assume we want first device
    if len (sys.argv) == 2:
        dim = int(sys.argv[1]) 
        # no argument on the command line, try to use the camera
        capture = cv.CreateCameraCapture (device)
    else:
        dim = int(sys.argv[2]) 
        # we have an argument on the command line,
        # we can assume this is a file name, so open it
        capture = cv.CreateFileCapture (sys.argv [1])            

    print "Press ESC to exit ..."
    print "dim="+str(dim)
    pts = dim * dim
    corners = (cv.Point2D32f * pts)()
    
    cv.SetCaptureProperty(capture, cv.CAP_PROP_FRAME_WIDTH, 640)
    cv.SetCaptureProperty(capture, cv.CAP_PROP_FRAME_HEIGHT, 480)    
 
    # check if capture device is OK
    if not capture:
        print "Error opening capture device"
        sys.exit(1)
        
    num = 1
    while 1:
        # do forever
 
        # capture the current frame
        frame = cv.QueryFrame(capture)
        
        # handle events
        k = cv.WaitKey(10)
 
        if k == 0x1b: # ESC
            print 'ESC pressed. Exiting ...'
            break
        elif k == 116:
            save(frame, num)
            num += 1
        
        if frame is None:
            break
 
        # mirror
        cv.Flip(frame, None, 1)
        
        detect(frame)
 
        # display webcam image
        cv.ShowImage('Camera', frame)
 

