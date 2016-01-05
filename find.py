# -*- coding: utf-8 -*-
# Usage:
# find . -name '*.tex' -exec python $HOME/kod/find.py '[string]'  {} \;
import sys
if sys.argv[1] in open(sys.argv[2]).read(): print sys.argv[2]
