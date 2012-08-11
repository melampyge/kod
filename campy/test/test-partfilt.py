from pylab import *

def resample(weights):
   n = len(weights)
   indices = []
   C = [0.] + [sum(weights[:i+1]) for i in range(n)]
   u0, j = random(), 0
   for u in [(u0+i)/n for i in range(n)]:
     while u > C[j]:
       j+=1
     indices.append(j-1)
   return indices

x = array([10, 20, 30, 40, 50, 60])
weights = [0.05, 0.4, 0.1, 0.3, 0.1, 0.05]

u0, j = random(), 0
n = len(weights)
print [(u0+i)/n for i in range(n)]

print resample(weights)
