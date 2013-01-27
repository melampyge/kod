#!/usr/bin/env python
import cv
import Image
import sys
import numpy as np
from siftpy import *
__scale__ = 3

def label_sift_point(image, xx, yy):
    color = cv.CV_RGB(255,255,255)
    center = (int(xx), int(yy))
    cv.Circle(image, center, cv.Round(4), color, 3, cv.CV_AA, 0)

class Capture:
    
    def save(self, pic):
        cv.SaveImage('deneme' + str(self.i) + '.jpg', pic)
    
    def __init__(self):
        self.i = 1
        self.capture = cv.CaptureFromCAM(0)
        cv.NamedWindow( "CamShiftDemo", 1 )

        print( "Keys:\n    ESC - quit the program\n" )


    def run(self):
        while True:
            frame = cv.QueryFrame( self.capture )
            image_size = cv.GetSize(frame)
            gray = cv.CreateImage ((image_size[0], image_size[1]), 8, 1)
            cv.CvtColor(frame, gray, cv.CV_BGR2GRAY )
            # scale input image for faster processing
            small_img = cv.CreateImage((cv.Round(image_size[0]/__scale__),
                                        cv.Round(image_size[1]/__scale__)), 8, 1 )
            cv.Resize(gray, small_img, cv.CV_INTER_LINEAR )
            cv.EqualizeHist( small_img, small_img )

            s_res = sift(np.array(cv.GetMat(small_img)).flatten('C'))
            n_res = np.array(s_res)
            for item in n_res:
                xx = item[0]*__scale__
                yy = item[1]*__scale__
                label_sift_point(frame, xx, yy)
            
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
