`siftpy1` is based on the 0.8.0 version of SIFT written by Andrea
Vedaldi which is not the latest version anymore, however the new
version by Vedaldi has a lot of extra code and scripting that handled
interfacing to Octave for instance, or Windows portability; we needed
a cleaner C code that would build simply. Another reason for writing
this interface was that another Python interface to the most current
Vedaldi sift, called `pyvlfeat` failed to compile.

My version is very simple; I hacked through the `sift-driver.cpp` code
which handles mainline execution to make it think the caller is
mainline. We pass a filename to `pysift1` which is passes on to
Vedaldi's sift which reads it as though as the command was coming from
the command line. Basically this is a wrapper to command line sift
that works through dynamic libraries, so you don't have to call sift
binary through the command line.

Usage

```python
import siftpy1
df = siftpy1.sift("test.pgm",threshold=10.0)
```

The variable `df` is a Pandas dataframe that carries the SIFT
descriptors; first 4 columns are location / angle, the last 128 are
the descriptors.

### Resources

Solem, *Computer Vision with Python*

http://vlfeat.org
