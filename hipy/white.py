import numpy as np
from scikits.audiolab import play
# output one second of stereo gaussian white noise at 48000 hz
data = np.random.randn(2, 480000)
play(0.001 * data)
    
