import gtk.gdk
import PIL
import PIL.Image
import ImageOps
import re, sys, os, itertools
import threading, time, math
from opencv.cv import *
from opencv.highgui import *
from opencv.adaptors import PIL2Ipl
import numpy as np
import lk, deriv

start_x = 0
start_y = 50
size_x = 650
size_y = 480
end_x = start_x+size_x
end_y = start_y+size_y

box = (start_x, start_y, start_x+size_x, start_y+size_y)

track_x = []
track_y = []
for xx,yy in itertools.product(range(20,250,20),range(20,250,20)):
    track_x.append(xx)
    track_y.append(yy)

class Command(threading.Thread):
    def __init__(self,interval,cmd):
        threading.Thread.__init__(self)
        self.interval = interval
        self.cmd = cmd
    def run_command(self, command):
        result = []
        print 'Running:', command
        f = os.popen(command, "r")
        sys.stdout.flush()
        for l in f.xreadlines():
            result.append(l)        
    def run(self):
        if self.cmd == 'test':
            print "forward"
            self.run_command("xdotool search --name ioUrbanTerror windowactivate keydown W")
            time.sleep(self.interval)
            print "stop"
            self.run_command("xdotool search --name ioUrbanTerror windowactivate keyup W")
            time.sleep(self.interval)
            print "fire"
            self.run_command("xdotool search --name ioUrbanTerror windowactivate mousedown 1")
            time.sleep(self.interval)
            self.run_command("xdotool search --name ioUrbanTerror windowactivate mouseup 1")

w = gtk.gdk.get_default_root_window()
sz = w.get_size()

fwd = False

cvNamedWindow("fps")
cvMoveWindow("fps",650,0)

g = deriv.gauss_kern()

prev = None

frame_no = 0

color = (100,100,255)

def flip(y): return 250-y

while True:
    if math.fmod(frame_no,5) == 0:
        pb = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB,False,8,sz[0],sz[1])
        pb = pb.get_from_drawable(w,w.get_colormap(),0,0,0,0,sz[0],sz[1])
        width,height = pb.get_width(),pb.get_height()
        im = PIL.Image.fromstring("RGB",(width,height),pb.get_pixels())
        im = im.crop(box)
        im = ImageOps.grayscale(im)
        im = im.resize((250,250), PIL.Image.ANTIALIAS)
        cv_img = PIL2Ipl(im)
        if prev != None: 
            res = lk.lk(g, prev, im, track_x, track_y, 12) 
            for (i,j,u,v) in res:
                try:
                    cvLine(cv_img,(i,j),(i+int(u),j+int(v)),color)
                    cvCircle(cv_img,(i+int(u),j+int(v)),2,color)
                except Exception, e: pass
                
        prev = im.copy()

        cvShowImage("fps", cv_img)    
        '''
        if not fwd: 
            cmd = Command(2, "test")
            fwd = True
            cmd.start()
        '''
    cvWaitKey(30)
    frame_no += 1
