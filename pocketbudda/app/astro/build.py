import os, sys

if sys.argv[1] == 'zip':
    os.system("zip -r ~/pocketbudda.zip manifest.json icon_128.png --exclude=*.zip --exclude=pocketbudda.dat")
    
