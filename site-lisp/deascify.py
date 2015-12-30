from Pymacs import lisp
import re, sys, time, os
interactions = {}
from turkish.deasciifier import Deasciifier

def get_block_content(start_tag, end_tag):
    remember_where = lisp.point()
    block_begin = lisp.search_backward(start_tag)
    block_end = lisp.search_forward(end_tag)
    block_end = lisp.search_forward(end_tag)
    content = lisp.buffer_substring(block_begin, block_end)
    lisp.goto_char(remember_where)
    return block_begin, block_end, content

def to_tr(s):    
    tokens = re.split("(\\$.*?\\$)",s)
    res = []
    for x in tokens:
        if x[0]=='$' and x[-1] == '$': res.append(x); continue
        dea = Deasciifier(x)
        x = dea.convert_to_turkish()
        res.append(x)
    return ''.join(res)
    
def convert():
    remember_where = lisp.point()
    block_begin, block_end, content = get_block_content("\n\n","\n\n")
    content = content.replace("verisi","WWXXD1")
    content = content.replace("Calculus","WWXXD2")
    result = to_tr(content)
    result = result.replace("WWXXD1","verisi")
    result = result.replace("WWXXD2","Calculus")
    lisp.delete_region(block_begin, block_end)
    lisp.insert(result)
    lisp.goto_char(remember_where)
            
interactions[convert] = ''
