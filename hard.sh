# Lists hardware specs 

echo "" > /tmp/hard.out

uname -a >> /tmp/hard.out

lshw >> /tmp/hard.out

dmidecode >> /tmp/hard.out

lshw -class disk -class storage  >> /tmp/hard.out

lspci -vnn | grep VGA -A 12   >> /tmp/hard.out

