import os, matplotlib.pyplot as plt
import scikits.audiolab
import numpy as np
from scipy import *

plt.ion()

while (True):

    plt.clf()

    os.system("arecord -d 2 -f dat > /mnt/rd/hipy.wav")

    (snd, sampFreq, nBits) = audiolab.wavread('/mnt/rd/hipy.wav')    
    
    s1 = snd[:,0] 
    
    timeArray = np.arange(0, float(snd.shape[0]), 1) # 
    timeArray = timeArray / sampFreq
    timeArray = timeArray * 1000  #scale to milliseconds
    
    plt.plot(timeArray, s1, color='k')
    plt.ylabel('Amplitude')
    plt.xlabel('Time (ms)')
    plt.show()
    

