import cv
 
if __name__ == '__main__':
    file = "/home/burak/Dropbox/Public/skfiles/campy/chessb-right.avi"
    cv.NamedWindow("Example2", cv.CV_WINDOW_AUTOSIZE)
    capture = cv.CreateFileCapture(file)
    #capture = cvCreateCameraCapture (0)
    loop = True
    while(loop):
        frame = cv.QueryFrame(capture)
        if (frame == None): break
        cv.ShowImage("Example2", frame)
        char = cv.WaitKey(33)
        if (char != -1):
            if (ord(char) == 27):
                loop = False 
                cv.DestroyWindow("Example2")
