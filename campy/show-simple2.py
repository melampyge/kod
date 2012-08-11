from opencv.cv import *
from opencv.highgui import *
 
if __name__ == '__main__':
    file = "/home/burak/Dropbox/Public/skfiles/campy/chessb-right.avi"
    cvNamedWindow("Example2", CV_WINDOW_AUTOSIZE)
    capture = cvCreateFileCapture(file)
    #capture = cvCreateCameraCapture (0)
    loop = True
    while(loop):
        frame = cvQueryFrame(capture)
        if (frame == None): break
        cvShowImage("Example2", frame)
        char = cvWaitKey(33)
        if (char != -1):
            if (ord(char) == 27):
                loop = False 
                cvDestroyWindow("Example2")
