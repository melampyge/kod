from Pymacs import lisp, Let
import re, sys, os

sys.path.append('/usr/share/emacs/23/site-lisp')

interactions = {}

from Project import Project
from Class import Class

# for thing-at-point. by seperating out the end / beginning of thing to sets, we
# allowed the parametrization of thing-at-point function. This function can now
# simply ask if it is looking at a delimiter by using "token in set" call of
# Python. 
RIGHT1 = set([' ', ';', '/', '.', '<'])
LEFT1 = set([' ', '.'])
RIGHT2 = set(['\n'])
LEFT2 = set(['\n'])
RIGHT3 = set([' ', '.', ')'])
LEFT3 = set([' ', '('])
RIGHT4 = set([')'])
LEFT4 = set(['.'])

def goto_definition():
    """
    go to definition/declaration of the pointer we are looking at
    """
    fname=lisp.buffer_file_name()
    a = Project(fname)
    thing, start = thing_at_point(RIGHT1, LEFT1)
    lisp.message(thing)
    pos = lisp.point()
    type, pos = a.find_declaration_type(thing, fname, pos)
    lisp.goto_char(pos)

def find_file_at_symbol():
    """
    finds file at point
    """
    fname=lisp.buffer_file_name()
    a = Project(fname)
    thing, start = thing_at_point(RIGHT1, LEFT1)
    file = a.find_file_for_thing(thing, fname)    
    lisp.message(file)
    lisp.find_file(file)

def ready_output():
    """
    finds pyjde output buffer kills it and starts a new one
    """
    lisp.switch_to_buffer_other_window("*PyJde*")
        
def find_descendants(): 
    """
    retrieves descendants of class at point by running a Unix find. 
    simple huh?
    """
    fname=lisp.buffer_file_name()
    a = Project(fname)
    thing, start = thing_at_point(RIGHT1, LEFT1)
    descs = a.find_all_descendants(thing)
    ready_output()
    
    for item in descs:
        lisp.insert(item)

def thing_at_point(right_set, left_set):
    """
    Mine is a lot better than the emacs thingy which does not
    'get' types with generics
    """
    curridx = lisp.point()

    curr=''
    while (curr in right_set) == False:
        curr = lisp.buffer_substring(curridx, curridx+1)
        curridx += 1
    start = curridx-1
        
    curridx = lisp.point()
    curr=''
    while (curr in left_set) == False:
        curr = lisp.buffer_substring(curridx-1, curridx)
        curridx -= 1
    end = curridx+1
        
    s = lisp.buffer_substring(start, end)
    return s, end

def thing_at_point_regex(right, left):
    """
    Mine is a lot better than the emacs thingy which does not
    'get' types with generics
    """
    curridx = lisp.point()

    curr=''
    while (re.search(right, curr) ) == None:
        curr = lisp.buffer_substring(curridx, curridx+1)
        curridx += 1
    start = curridx-1
        
    curridx = lisp.point()
    curr=''
    while (re.search(left, curr) ) == None:
        curr = lisp.buffer_substring(curridx-1, curridx)
        curridx -= 1
    end = curridx+1
        
    s = lisp.buffer_substring(start, end)
    return s, end

def pick_method():
    '''
    pick the whole line from the list of function calls (completions)
    '''
    print "in pick method"
    thing, start = thing_at_point(RIGHT2, LEFT2)
    prev_buffer = os.environ['BUFFER']
    print "-"+prev_buffer+"-"
    lisp.kill_buffer(lisp.get_buffer("*PyJde*"))
    lisp.switch_to_buffer(prev_buffer)
    lisp.insert(thing)
    pos = lisp.point()
    print "pos="+(str(pos-1))
    lisp.goto_char(pos-1)
    lisp.delete_other_windows()
    
def find_public_methods(): 
    """
    retrieves all public methods of class
    """
    try:        
        fname=lisp.buffer_file_name()
        print "remember:" + lisp.buffer_name()
        os.environ['BUFFER'] = lisp.buffer_name()

        project = Project(fname)

        thing, start = thing_at_point(RIGHT3, LEFT3)
        thing = thing.replace(".","")
        print "thing:"+thing

        pos = lisp.point()
        type, foundpos = project.find_declaration_type(thing, fname, pos)

        typefile = project.find_file_for_thing(type, fname)
        c = Class(project, typefile)
        public_methods = c.list_all_public() 

        if (len(public_methods) == 0): 
            lisp.message("No public methods found")
        else:
            ready_output()    
            lisp.insert("\n")
            for item in public_methods:
                lisp.insert(item)
                lisp.insert("\n")
    except Exception, e:
        lisp.message(e)
                        
def param_highlight_begin():
    thing, start = thing_at_point(RIGHT4, LEFT4)
    print "thing:"+thing
    print "base:"+str(start)
    for m in re.finditer("((final\s)*\w*?\s\w*?)(,|\Z)", thing):
        print "begin found start: "+str(m.start())
        print "begin found start sum: "+str(start+m.start())
        return start+m.start()
        
def param_highlight_end():
    thing, start = thing_at_point(RIGHT4, LEFT4)
    print "thing:"+thing
    print "base:"+str(start)
    for m in re.finditer("((final\s)*\w*?\s\w*?)(,|\Z)", thing):
        print "end: "+str(start+m.end()-1)
        return start+m.end()-1    

def put_import (fname, imp):
    print "in put_import"
    print fname
    print imp    
    content = lisp.buffer_substring(1, lisp.point())
    print content
    for m in re.finditer("(import\s.*?);", content):
        print "mgroup="+m.group(1)
        print imp
        if (re.search(imp, m.group(1))):
            lisp.message("Already imported")
            return
    insert_where = re.search("import\s.*;", content).span()[1]
    lisp.goto_char(insert_where + 1)
    lisp.insert("\nimport " + imp + ";")
        
def find_imports():
    print "test hello"    
    
    fname=lisp.buffer_file_name()
    print "remember:" + lisp.buffer_name()
    os.environ['BUFFER'] = lisp.buffer_name()
        
    remember_where = lisp.point()
    try:        
        fname=lisp.buffer_file_name()
        project = Project(fname)
        thing, start = thing_at_point_regex("\W", "\W")
        print "thing:"+thing
        imports = project.find_file_for_import(thing)
        if (len(imports) > 1):
            ready_output()    
            lisp.insert("\n")
            for item in imports:
                lisp.insert(item)
                lisp.insert("\n")
        elif (len(imports) == 1): 
            put_import(fname, imports[0])
        elif (len(imports) == 0): 
            lisp.message("No import found for " + imports[0])

        lisp.goto_char(remember_where)
        
    except Exception, e:
        lisp.message(e)
        
def pick_import():
    '''
    pick the whole line from the list of imports
    '''
    print "in pick import"
    thing, start = thing_at_point_regex("\n", "\n")
    prev_buffer = os.environ['BUFFER']
    print "-"+prev_buffer+"-"
    lisp.kill_buffer(lisp.get_buffer("*PyJde*"))
    lisp.switch_to_buffer(prev_buffer)

    remember_where = lisp.point()
    content = lisp.buffer_substring(1, lisp.point())    
    insert_where = re.search("package\s.*;", content).span()[1]
    lisp.goto_char(insert_where + 1)
    lisp.insert("\n\nimport " + thing + ";")
    lisp.message(thing + " is imported")
    lisp.goto_char(remember_where)

    lisp.delete_other_windows()
    
def test():
    print "hello"
    find_imports()
