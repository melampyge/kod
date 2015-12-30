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
    content = content.replace("AIC","WWXXD3")
    content = content.replace("\sigma","WWXXD4")
    content = content.replace("estimator","WWXXD5")
    content = content.replace("\frac","WWXXD6")
    content = content.replace("entegral","didibin")
    content = content.replace(" ise","WWXXD7")
    result = to_tr(content)
    result = result.replace("WWXXD1","verisi")
    result = result.replace("WWXXD2","Calculus")
    result = result.replace("WWXXD3","AIC")
    result = result.replace("WWXXD4","\sigma")
    result = result.replace("WWXXD5","estimator")
    result = result.replace("WWXXD6","\frac")
    result = result.replace("didibin","entegral")
    result = result.replace("WWXXD7"," ise" )
    lisp.delete_region(block_begin, block_end)
    lisp.insert(result)
    lisp.goto_char(remember_where)
            
interactions[convert] = ''
