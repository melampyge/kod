#sh $HOME/bin/run_dell.sh part.sql > $HOME/dell.csv

#head -1 $HOME/dell.csv > $HOME/dell2.csv
#sed -n 2,30000p $HOME/dell.csv >> $HOME/dell2.csv

#head -1 $HOME/dell.csv > $HOME/dell-validate.csv
#sed -n 30000,60000p $HOME/dell.csv >> $HOME/dell-validate.csv

#R -f pred.R
R -f predglm.R
#R -f prednn.R
