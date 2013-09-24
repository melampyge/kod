import os, sys

if sys.argv[1] == 'deploy':
    os.system("python /home/burak/Downloads/google_appengine/appcfg.py update /home/burak/kod/pocketbudda/app")
elif sys.argv[1] == 'zip':
    os.system("zip %s/Dropbox/Public/pocketbudda.zip -r * ." % os.environ['HOME'])

