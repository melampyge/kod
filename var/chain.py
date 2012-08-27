import scipy.linalg as lin
import numpy

P = numpy.array([[0.7,0.2,0.1],
                 [0.,0.5,0.5],
                 [0,0.9,0.1]])

T = P
for i in range(20): T = numpy.dot(T,T)
print T

V,D = lin.eig(P.T)
print "V", V
print "D", D

p = D[:,1]
print p / numpy.sum(p)

