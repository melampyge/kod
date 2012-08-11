import os, sys, glob
from scipy import *

def trim(x) : return abs(x)[0:(len(x) // 2)]

def filter(x):
    res = []
    threshold = max(x) / 100
    for i in x:
        if i > threshold: 
            res.append(i)
    return res

list = glob.glob('*.wav')

dd = []

for wav in list: 
    data = fromfile(file=wav, dtype=uint16, count=-1, sep='')
    res = filter(trim(fft(data)))
    dd.append(res)
    print res
    
