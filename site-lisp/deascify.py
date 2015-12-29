from Pymacs import lisp
import re, sys, time, os
interactions = {}
from turkish.deasciifier import Deasciifier

def convert():
    remember_where = lisp.point()
    s = u"Bogurtuler opucukler."
    dea = Deasciifier(s)
    result = dea.convert_to_turkish()
    lisp.message(result)
            
interactions[convert] = ''
