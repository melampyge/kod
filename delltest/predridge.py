# -*- coding: utf-8 -*-
from statsmodels.formula.api import ols
from sklearn.linear_model import Ridge
import numpy as np
import pandas

orders = pandas.read_csv("/home/burak/dell-train.csv",sep=",")
train = orders[['total_total_amount','income','netamount','day', 'month','per_customer_count','day_of_week','frequency','totalamount','rank','cat_freq']]
last_value = orders[['last_visit']].as_matrix()
clf = Ridge(alpha=1.0)
print clf.fit(train, last_value) 

orders = pandas.read_csv("/home/burak/dell-validate.csv",sep=",")
validate = orders[['total_total_amount','income','netamount','day', 'month','per_customer_count','day_of_week','frequency','totalamount','rank','cat_freq']]
pred = clf.predict(validate)
last_value = orders[['last_visit']].as_matrix()

print np.sum(np.abs(pred-last_value)) / len(last_value)

