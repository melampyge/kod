import os
import scikits.audiolab
import matplotlib.pyplot as plt
import numpy as np
from scipy import *

#(snd, sampFreq, nBits) = audiolab.wavread('440_sine.wav')
(snd, sampFreq, nBits) = scikits.audiolab.wavread('a.wav')

print "sampFreq="+str(sampFreq)
print "snd"+str(snd)
print nBits
print "---"

s1 = snd[:,0] 

n = len(s1) 
p = fft(s1) # take the fourier transform 

print "n="+str(n)

nUniquePts = ceil((n+1)/2.0)
p = p[0:nUniquePts]
p = abs(p)

print "nUniquePts="+str(nUniquePts)

p = p / float(n) # scale by the number of points so that
# the magnitude does not depend on the length 
# of the signal or on its sampling frequency  
p = p**2  # square it to get the power 

# multiply by two (see technical document for details)
# odd nfft excludes Nyquist point
if n % 2 > 0: # we've got odd number of points fft
    p[1:len(p)] = p[1:len(p)] * 2
else:
    p[1:len(p) -1] = p[1:len(p) - 1] * 2 # we've got even number of points fft

    freqArray = np.arange(0, nUniquePts, 1.0) * (sampFreq / n);
    plt.plot(freqArray/1000, 10*log10(p), color='k')
    plt.xlabel('Frequency (kHz)')
    plt.ylabel('Power (dB)')
    plt.show()
