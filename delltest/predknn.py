# -*- coding: utf-8 -*-
from sklearn import neighbors
from patsy import dmatrix
import numpy as np
from pandas import *

__day__ = 130

cols = """
0 + month + day + day_of_week + rank + categoryname + time_on_site +
per_customer_count + income + season + cat_freq + creditcardtype
"""

orders = read_csv("/home/burak/dell-train.csv",sep=",")
train = dmatrix(cols,orders)
print train.shape
last_value = orders[['last_visit']].as_matrix()[:,0] > __day__

print len(last_value[last_value==True])
print len(last_value[last_value==False])

knn = neighbors.KNeighborsClassifier(n_neighbors=10)
knn.fit(train,last_value)

orders = read_csv("/home/burak/dell-validate.csv",sep=",")
validate = dmatrix(cols,orders)
print validate.shape
last_value = orders[['last_visit']].as_matrix()[:,0] > __day__

pred = knn.predict(validate)

success = 0
for i,x in enumerate(pred):
    if x==0 and last_value[i]==False: success += 1
    if x==1 and last_value[i]==True: success += 1

print success / float(len(pred)) * 100

