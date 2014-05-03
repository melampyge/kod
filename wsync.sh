# Syncs files between coruscant /root/raw folder and local one
if [ $1 = "pull" ]
    then
    rsync -avzh bbayramli@dev51:/media/data/ps-ml-research /home/burak/Documents/outfit/
    rsync -avzh bbayramli@dev51:/media/data/ps-app-coruscant /home/burak/Documents/outfit/
    rsync -avzh bbayramli@dev51:/media/data/bbayramli/outfittery-db.txt /home/burak/Dropbox
    rsync -avzh bbayramli@dev51:/media/data/bbayramli/lando /home/burak/
fi
