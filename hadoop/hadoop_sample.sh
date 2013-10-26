sudo apt-get install openssh-server
sudo mkdir /app
sudo mkdir /app/hadoop
sudo mkdir /app/hadoop/tmp 
sudo chown hduser:hadoop /app/hadoop/tmp
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
ssh-keygen -t rsa
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
sudo apt-get install lzop

hadoop namenode -format

ssh localhost -l hduser \
 python /home/burak/Documents/classnotes/stat/stat_hadoop_logreg/logreg.py \
 hdfs:///user/testSet1.txt -r hadoop --step-num=1 \
 --jobconf mapred.map.tasks=2 --jobconf mapred.reduce.tasks=2

