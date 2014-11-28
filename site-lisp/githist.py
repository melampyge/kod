#
# Starting from any file, goes up in directory finds the .git
# directory location, from there executes the git show command. 
# Comes pretty handy to compare two or more versions of the same file 
# by naked eye. 
#

from Pymacs import lisp
import re, sys, os
import glob, string

def run_command(command):
    result = []
    print 'Running:', command
    f = os.popen(command, "r")
    sys.stdout.flush()
    for l in f.xreadlines():
        result.append(l)        
    return result

def branch():
    '''
    run shell command and return the output as list
    '''
    f = os.popen("git branch", "r")
    return re.findall('\\*\s(\w+)',f.read().strip())[0]

def show_version(num):
    print "Getting this version ago:" + str(num)
    dot_git_dir = find_dot_git()
    os.chdir(dot_git_dir)
    
    fname=lisp.buffer_file_name()
    
    # subtract the .git location from the beginning part of the 
    # full path because git show does not like it
    suitable_dir_for_git_show = re.sub(dot_git_dir, "", fname)

    # also get rid of the first / 
    suitable_dir_for_git_show = re.sub("^/", "", suitable_dir_for_git_show)
    
    cmd = "git show %s~%d:%s" % (branch(), num, suitable_dir_for_git_show)
    
    res = run_command(cmd)    
    lisp.switch_to_buffer_other_window(cmd)
    for item in res: lisp.insert(item)
            
def find_dot_git() :     
    fname=lisp.buffer_file_name()
    dirname = re.sub("\/\w*?\.*\w*?$", "", fname)
    print "Dir:"+dirname

    found = False
    os.chdir(dirname)
    while (True) :
        dirname = os.getcwd()
        print "Trying " + dirname + "/.git"
        if (os.path.isdir(dirname + "/.git")): return dirname
        if (os.getcwd() == "/"): 
            raise Exception("no .git found")
        os.chdir(os.pardir) 

