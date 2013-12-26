import ncut, numpy as np
from scipy.misc import imresize
from PIL import Image

im = np.array(Image.open('C-uniform03.ppm'))
m,n = im.shape[:2]
# resize image to (wid,wid)
wid = 50
rim = imresize(im,(wid,wid),interp='bilinear')
rim = np.array(rim,'f')
# create normalized cut matrix
A = ncut.ncut_graph_matrix(rim,sigma_d=1,sigma_g=1e-2)
