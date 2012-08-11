#!/usr/bin/env python
import cv

class Capture:
    
    def save(self, pic):
        cv.SaveImage('deneme' + str(self.i) + '.jpg', pic)
    
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
