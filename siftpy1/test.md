
```python
from PIL import Image
import siftpy1
df1 = siftpy1.sift("crans_1_small.pgm",threshold=5)
print len(df1)
```

```text
2196
```


```python
import pandas as pd
im=Image.open("crans_1_small.jpg")
df1.plot(kind='scatter',x=0,y=1)
plt.hold(True)
plt.imshow(im)
plt.savefig('test_01.png')
```







