# Syncs files between coruscant /root/raw folder and local one
rsync -avzh bbayramli@dev51:/media/data/ps-ml-research /home/burak/Documents/outfit/
rsync -avzh bbayramli@dev51:/media/data/ps-app-coruscant /home/burak/Documents/outfit/
rsync -avzh bbayramli@dev51:/media/data/bbayramli/Downloads/ps-app-coruscant /home/burak/Downloads
rsync -avzh bbayramli@dev51:/media/data/bbayramli/outfittery-db.txt /home/burak/Dropbox
rsync -avzh bbayramli@dev51:/tmp/recom* /home/burak/tmp/
