# -*- coding: utf-8 -*-
from sklearn import neighbors
from patsy import dmatrix
import numpy as np
from pandas import *

__day__ = 130

cols = """
0 + month + day + day_of_week + rank + categoryname + income + season
+ cat_freq + creditcardtype
"""

orders = read_csv("/home/burak/dell-train.csv",sep=",")
train = dmatrix(cols,orders)
last_value = orders[['last_visit']].as_matrix()[:,0] > __day__

print len(last_value[last_value==True])
print len(last_value[last_value==False])

knn = neighbors.KNeighborsClassifier(n_neighbors=10)
knn.fit(train,last_value)

orders = read_csv("/home/burak/dell-validate.csv",sep=",")
validate = dmatrix(cols,orders)
last_value = orders[['last_visit']].as_matrix()[:,0] > __day__

pred = knn.predict(validate)

success = sum(pred[last_value==True] == 1) + \
          sum(pred[last_value==False] == 0)
print success / float(len(pred)) * 100

