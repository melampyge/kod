# pass any directory from under your project, and this 
# script will unjar its jars for you

import re, sys, os

currdir = os.getcwd()
sys.path.append(currdir)

from Project import Project

print sys.argv[1]
a = Project(sys.argv[1])
a.unjar()
