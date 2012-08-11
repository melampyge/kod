from mpl_toolkits.mplot3d import Axes3D
from pylab import *

fig=plt.figure()
ax = Axes3D(fig)


p = [[10],[10],[10], [1]]
ax.plot(p[0], p[1], p[2], 'o')

T = [[1, 0, 0, 0],
     [0, 1, 0, 0],
     [0, 0, 1, -10],
     [0, 0, 0, 1]]

print p
p = dot(T, p)
print p
ax.plot(p[0], p[1], p[2], 'x')

plt.show()

