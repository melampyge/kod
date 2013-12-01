#
# Starting from any file, goes up in directory finds the .git
# directory location, from there executes the git show command. 
# Comes pretty handy to compare two or more versions of the same file 
# by naked eye. 
#

from Pymacs import lisp
import re, sys, os
import glob, string

def show_version(num):
    print "Getting this version ago:" + str(num)
    dot_git_dir = find_dot_git()
    os.chdir(dot_git_dir)
    
    fname=lisp.buffer_file_name()
    
    # subtract the .git location from the beginning part of the 
    # full path because git show does not like it
    print "fname="+fname
    print "dot_git_dir="+dot_git_dir
    suitable_dir_for_git_show = re.sub(dot_git_dir, "", fname)
    print suitable_dir_for_git_show

    # also get rid of the first / 
    suitable_dir_for_git_show = re.sub("^/", "", suitable_dir_for_git_show)
    print suitable_dir_for_git_show
    
    cmd = "git show master~" + str(num) + ":" + suitable_dir_for_git_show
    print cmd
    
    list = run_command(cmd)
    
    lisp.switch_to_buffer_other_window(cmd)
    for item in list:
        lisp.insert(item)
            
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


def run_command(command):
    result = []
    print 'Running:', command
    f = os.popen(command, "r")
    sys.stdout.flush()
    for l in f.xreadlines():
        result.append(l)        
    return result
