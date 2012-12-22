CLASSPATH=`find $HOME/.m2/ -name *.jar`
export CLASSPATH=`echo $CLASSPATH | sed 's/jar\s/jar\:/g'`
jython test.py
