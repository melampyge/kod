from PIL import Image
from numpy import *
import sift

sift.process_image('box.pgm', 'basmati.key')
l1,d1 = sift.read_features_from_file('basmati.key')
im = array(Image.open('box.pgm'))
sift.plot_features(im,l1)
