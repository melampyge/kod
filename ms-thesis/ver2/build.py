import os, sys

if len(sys.argv) == 1 or sys.argv[1] == 'tex':
    os.system("pdflatex -shell-escape ms-the*.tex")
    os.system("evince ms-the*.pdf")
    exit()
    
