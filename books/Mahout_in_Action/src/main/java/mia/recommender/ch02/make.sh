CP=$HOME/Downloads/mahout/core/target/mahout-core-0.8-SNAPSHOT.jar:$HOME/.m2/repository/org/slf4j/slf4j-jcl/1.6.0/slf4j-jcl-1.6.0.jar!/org/slf4j/impl/StaticLoggerBinder.class
javac -cp $CP RecommenderIntro.java
java -cp $CP:. RecommenderIntro
