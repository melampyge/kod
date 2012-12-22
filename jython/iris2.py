import sys
import weka.classifiers.trees.J48 as J48
import java.io.FileReader as FileReader
import java.io.File as File
import weka.core.Instances as Instances
import weka.core.converters.CSVLoader as CSVLoader
import weka.classifiers.trees.J48 as J48

file = File("/home/burak/Downloads/mahout_trunk/core/target/test-classes/iris.csv")
loader = CSVLoader()
loader.setSource(file)
data = loader.getDataSet()
data.setClassIndex(data.numAttributes() - 1)

j48 = J48()
j48.buildClassifier(data)

print j48
