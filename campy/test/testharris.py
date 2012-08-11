import Image
import os
import sys
#sys.path.append('/home/burak/devprogs/cvtypes/')
#from CVtypes import cv

def analyzeImage(f,name):

      im=Image.open(f)
      try:
            gray = cv.CreateImage (cvSize (im.size[0], im.size[1]), 8, 1)
            edge1 = cv.CreateImage (cvSize (im.size[0], im.size[1]), 32, 1)

            for h in range(im.size[1]):
                  for w in range(im.size[0]):
                        p=im.getpixel((w,h))
                        if(type(p)==type(1)):
                              gray[h][w] = im.getpixel((w,h))
                        else:
                              gray[h][w] = im.getpixel((w,h))[0]

            cv.CornerHarris(gray, edge1, 15, 5, 0.008)

            cv.NamedWindow("win2")
            cv.ShowImage("win2", edge1)
            cv.WaitKey()
            f.close()
            
      except Exception,e:
            print e
            print 'ERROR: problem handling '+ name


f = open(sys.argv[1],'r')
analyzeImage(f,sys.argv[1])
