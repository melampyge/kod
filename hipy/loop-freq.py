import os, matplotlib.pyplot as plt
import scikits.audiolab
import numpy as np
from scipy import *

plt.ion()

while (True):

    plt.clf()

    os.system("arecord -d 1 -f dat > /mnt/rd/hipy.wav")

    (snd, sampFreq, nBits) = audiolab.wavread('/mnt/rd/hipy.wav')    
    
    s1 = snd[:,0] 
    
    timeArray = np.arange(0, float(snd.shape[0]), 1) # 
    timeArray = timeArray / sampFreq
    timeArray = timeArray * 1000  #scale to milliseconds
    
    '''
    plt.plot(timeArray, s1, color='k')
    plt.ylabel('Amplitude')
    plt.xlabel('Time (ms)')
    plt.show()
    '''
    
    n = len(s1) 
    p = fft(s1) # take the fourier transform 

    nUniquePts = ceil((n+1)/2.0)
    p = p[0:nUniquePts]
    p = abs(p)

    p = p / float(n) # scale by the number of points so that
                     # the magnitude does not depend on the length 
                     # of the signal or on its sampling frequency  
    p = p**2  # square it to get the power 

    if n % 2 > 0: # we've got odd number of points fft
        p[1:len(p)] = p[1:len(p)] * 2
    else:
        p[1:len(p) -1] = p[1:len(p) - 1] * 2 # we've got even number of points fft

    freqArray = np.arange(0, nUniquePts, 1.0) * (sampFreq / n);
    plt.plot(freqArray/1000, 10*log10(p), color='k')
    plt.xlabel('Frequency (kHz)')
    plt.ylabel('Power (dB)')        
    plt.show()

