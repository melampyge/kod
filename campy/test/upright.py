from mpl_toolkits.mplot3d import Axes3D
from matplotlib.collections import PolyCollection
from matplotlib.colors import colorConverter
import matplotlib.pyplot as plt
from pylab import *

fig = plt.figure()
ax = Axes3D(fig)

X = np.arange(1, 10., 1)
Y = np.arange(1, 10., 1)
X, Y = np.meshgrid(X, Y)
Z = array(X)
Z[:] = 10
ax.plot_surface(Z, X, Y, color=colorConverter.to_rgba('#E0FFFF'))

plt.show()

