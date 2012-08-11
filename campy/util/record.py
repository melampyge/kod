from opencv import cv
from opencv import highgui

if __name__ == '__main__':
    
    MPEG1VIDEO = 0x314D4950
    highgui.cvNamedWindow ('Camera', highgui.CV_WINDOW_AUTOSIZE)
    highgui.cvMoveWindow ('Camera', 10, 10)

    capture = highgui.cvCreateCameraCapture (0)

    frame = highgui.cvQueryFrame (capture)
    frame_size = cv.cvGetSize (frame)
    fps = 30
    writer = highgui.cvCreateVideoWriter ("output.mpg", MPEG1VIDEO,
                                          fps, frame_size, True)
    if not writer:
        print "Error opening writer"
        sys.exit (1)
       
    while 1:
        frame = highgui.cvQueryFrame (capture)
        if frame is None:
            break
        highgui.cvWriteFrame (writer, frame)
        highgui.cvShowImage ('Camera', frame)
        k = highgui.cvWaitKey (5)
        if k % 0x100 == 27:
            break

    highgui.cvReleaseVideoWriter (writer)
