#sh $HOME/bin/run_dell.sh data.sql > $HOME/dell.csv
#R -f conv.R

head -1 $HOME/dell.csv > $HOME/dell-train.csv
sed -n 2,50000p $HOME/dell.csv >> $HOME/dell-train.csv
head -1 $HOME/dell.csv > $HOME/dell-validate.csv
sed -n 50000,60000p $HOME/dell.csv >> $HOME/dell-validate.csv

#R -f pred.R
#R -f predglm.R
#R -f prednn.R
#python predridge.py
python predknn.py
