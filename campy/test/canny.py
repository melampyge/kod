from PyQt4 import QtGui, QtCore

import Image
import ImageQt
import opencv
from opencv import highgui
from opencv.cv import *

def DoCanny(img, lowThresh, highThresh, aperature):  
    gray = cvCreateImage(cvSize(cvGetSize(img).width, cvGetSize(img).height), IPL_DEPTH_8U, 1)  
    cvCvtColor(img,gray,CV_BGR2GRAY)        
    if (gray.nChannels != 1):  
        return False        
    out = cvCreateImage(cvSize(cvGetSize(gray).width, cvGetSize(gray).height), IPL_DEPTH_8U, 1)  
    cvCanny(gray, out, lowThresh, highThresh, aperature)  
    return out  
  

camera = highgui.cvCreateCameraCapture(0)

class camThread(QtCore.QThread):
    def run(self):
        while True:
            self.msleep(60)
            self.image = highgui.cvQueryFrame(camera)             
            self.image = DoCanny(self.image, 70.0, 140.0, 3)            
            self.emit(QtCore.SIGNAL("image"), (self.image))

class camoruxWindow(QtGui.QMainWindow):
    def __init__(self):
        QtGui.QMainWindow.__init__(self)
        self.resize(650, 450)
        self.camThread = camThread()
        self.showLabel = QtGui.QLabel(self)
        self.showLabel.resize(640, 480)
        self.connect(self.camThread, QtCore.SIGNAL("image"), self.showImage)
        self.camThread.start()

    def showImage(self, image):
        self.image = ImageQt.ImageQt(opencv.adaptors.Ipl2PIL(image).transpose(Image.FLIP_LEFT_RIGHT))
        self.showLabel.setPixmap(QtGui.QPixmap.fromImage(self.image))                    
        
app = QtGui.QApplication([])
mw = camoruxWindow()
mw.show()
app.exec_()
