from PyQt4 import QtGui, QtCore

import sys
import Image
import ImageQt
import opencv
from opencv import highgui
from opencv.cv import *
sys.path.append('/home/burak/kod/CamPy/test')
from dotrack import dotrack
  
camera = highgui.cvCreateCameraCapture(0)

class camThread(QtCore.QThread):
    def run(self):
        while True:
            self.msleep(60)
            self.image = highgui.cvQueryFrame(camera)             
            self.image = dotrack(self.image)            
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
