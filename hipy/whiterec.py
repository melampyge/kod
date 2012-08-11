from scikits.audiolab import Format, Sndfile
import numpy as np
filename = 'foo.wav'
data = 0.001 * np.random.randn(48000, 2)
format = Format('wav')
f = Sndfile(filename, 'w', format, 2, 48000)
for i in range(60*3):
    f.write_frames(data)
f.close()
