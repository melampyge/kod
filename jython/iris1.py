import sys
import weka.classifiers.trees.J48 as J48
import java.io.FileReader as FileReader
import weka.core.Instances as Instances
import weka.core.converters.CSVLoader as CSVLoader
import weka.classifiers.trees.J48 as J48

file = FileReader("/home/burak/Downloads/weka-3-6-8/data/iris.arff")
data = Instances(file)
data.setClassIndex(data.numAttributes() - 1)

j48 = J48()
j48.buildClassifier(data)

print j48
