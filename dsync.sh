disk="New Volume"
#disk="17EA-3758"
echo "Copying files to /media/$disk/archive"
rsync  --size-only -P -avzh /home/burak/kod "/media/$disk/archive" --exclude .git
rsync  --size-only -P -avzh /home/burak/Documents/kitaplar "/media/$disk/archive"
rsync  -P -avzh /home/burak/Documents/classnotes "/media/$disk/archive" --exclude .git
rsync  --size-only -P -avzh /home/burak/Dropbox "/media/$disk/archive" 
rsync  -P -avzh /home/skorsky/mindmeld "/media/$disk/archive"  --exclude .git
