## SIFTPY1

Siftpy1 is based on the 0.8.0 version of SIFT written by Andrea
Vedaldi. This version is not the latest version anymore, however the
new version by Vedaldi has a lot of extra (that was unnecessary for
us) code and scripting that handled interfacing to Octave for
instance, or Windows portability; we needed the cleanest C code that
we could use. Another reason for writing this interface is another
Python interface to the most current Vedaldi sift code failed to
compile.

My version is very simple; I hacked through the sift-driver code which
handles mainline execution to make it think the caller is mainline. We
pass a filename to pysift1 which is passes on sift which reads it as
though as the command was coming from the command line.

Usage

```python
import siftpy1
res = siftpy1.sift("test.pgm",threshold=10.0)
```

The variables `res` is a Pandas dataframe that carries the SIFT
descriptors; first 4 columns are location / angle, the last 128 are
the descriptors.

I added a matcher utility that I took from Solem's book. 

### Resources

Solem, *Computer Vision with Python*

http://vlfeat.org
