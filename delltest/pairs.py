# -*- coding: utf-8 -*-
import pandas
import numpy as np
import matplotlib.pyplot as plt

orders = pandas.read_csv("/home/burak/dell.csv",sep=",")
print "read"
axes = pandas.tools.plotting.scatter_matrix(orders, alpha=0.2)
plt.tight_layout()
plt.savefig('/home/burak/scatter_matrix.png')
