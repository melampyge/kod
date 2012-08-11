from svm import *

labels = [0, 1, 1, 2]
samples = [[0, 0], [0, 1], [1, 0], [1, 1]]
problem = svm_problem(labels, samples);
size = len(samples)

kernels = [LINEAR, POLY, RBF]
kname = ['linear','polynomial','rbf']

param = svm_parameter(C = 10,nr_weight = 2,weight_label = [1,0],weight = [10,1])
param.kernel_type = kernels[0]
model = svm_model(problem,param)
prediction = model.predict([0, 1])
probability = model.predict_probability

print prediction
