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
    lisp.message(content)
    lisp.goto_char(remember_where)
    return block_begin, block_end, content

def convert():
    block_begin, block_end, content = get_block_content("\n\n","\n\n")
    #s = u"Bogurtuler opucukler."
    #dea = Deasciifier(s)
    #result = dea.convert_to_turkish()
    lisp.message(content)
    #lisp.insert(content)
            
interactions[convert] = ''
