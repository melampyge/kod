import os, sys

if sys.argv[1] == 'deploy':
    os.system("python /home/burak/Downloads/google_appengine/appcfg.py update /home/burak/kod/pocketbudda/app")

