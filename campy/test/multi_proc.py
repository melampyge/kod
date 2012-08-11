from multiprocessing import Process
from pylab import *
import time

def f(name):
    while 1: 
        print 'hello', name
        for i in range(10000):
            y = cos(i)

if __name__ == '__main__':
    p1 = Process(target=f, args=('first',))
    p1.start()
    p2 = Process(target=f, args=('second',))
    p2.start()
