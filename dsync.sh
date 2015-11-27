DISK="burak/New Volume"
if [ $1 == "b" ]; then
    DISK="burak/17EA-3758"
fi
echo "Copying files to /media/$DISK/archive"
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/Documents/kitaplar "/media/$DISK/archive"
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/kod "/media/$DISK/archive" 
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/Documents/classnotes "/media/$DISK/archive" 
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/Documents/emacs-ipython "/media/$DISK/archive" 
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/skorsky/mindmeld "/media/$DISK/archive" 
rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/Dropbox "/media/$DISK/archive" 
#rsync  --safe-links -W --size-only  --delete-after -P -avzh /home/burak/Music "/media/$DISK/archive" 
