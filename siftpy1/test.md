
```python
from PIL import Image
import sys
from pylab import *
import siftpy1
```

```python
res = siftpy1.sift("crans_1_small.pgm")
```


```python
import pandas as pd
df = pd.read_csv('/tmp/crans_1_small.key',sep=' ',header=None)
res = np.array(df[[0,1]])
im=Image.open("crans_1_small.jpg")
df.plot(kind='scatter',x=0,y=1)
plt.hold(True)
plt.imshow(im)
plt.savefig('test_01.png')
```

```python
res = siftpy1.sift("crans_2_small.pgm")
```

```python
import pandas as pd
df = pd.read_csv('/tmp/crans_2_small.key',sep=' ',header=None)
res = np.array(df[[0,1]])
im=Image.open("crans_2_small.jpg")
df.plot(kind='scatter',x=0,y=1)
plt.hold(True)
plt.imshow(im)
plt.savefig('test_02.png')
```















