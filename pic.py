#!/usr/bin/env python

# Takes a picture. Press 't' to save the screenshot in my-pic-1.jpg,
# my-pic-2.jpg, etc.. Every press will increment the number.
import cv

class Capture:
    
    def save(self, pic):
        cv.SaveImage('my-pic-' + str(self.i) + '.jpg', pic)
    
    def __init__(self):
        self.i = 1
        self.capture = cv.CaptureFromCAM(0)
        cv.NamedWindow( "CamShiftDemo", 1 )

        print( "Keys:\n"
            "    ESC - quit the program\n"
            "    t - take picture\n"
            "To initialize tracking, drag across the object with the mouse\n" )


    def run(self):
        while True:
            frame = cv.QueryFrame( self.capture )
            cv.ShowImage( "CamShiftDemo", frame )

            c = cv.WaitKey(7)
            if c == 27:
                break
            elif c == ord("t"):
                frame = cv.QueryFrame( self.capture )
                self.save(frame)
                self.i += 1

if __name__=="__main__":
    demo = Capture()
    demo.run()
