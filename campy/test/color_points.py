from opencv import cv

def color_points(image, points):        
    color = cv.CV_RGB(0, 255, 0)
    for l in xrange(len(points[0])):
        p = points[0][l]
        for i in xrange(5): # paint 5x5 green dot at this location
            for j in xrange(5):                    
                if (p.x < cv.cvGetSize(image).width-5 and p.y < cv.cvGetSize(image).height-5):
                    cv.cvSet2D(image, int(p.y)+i, int(p.x)+j, color)

