library("GGally")
data <- read.csv ("/home/burak/dell.csv",header=TRUE,sep=",")
attach(data)
ggpairs(data, diag=list(continuous="density", discrete="bar"), axisLabels="show")
