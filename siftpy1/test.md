
```python
from PIL import Image
import siftpy1
```

```python
res = siftpy1.sift("crans_1_small.pgm",threshold=2)
```

```python
print len(res)
```

```text
800
```


```python
import pandas as pd
im=Image.open("crans_1_small.jpg")
res.plot(kind='scatter',x=0,y=1)
plt.hold(True)
plt.imshow(im)
plt.savefig('test_01.png')
```







