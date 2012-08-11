import re, sys, os

ardajardir = os.environ['HOME'] + "/.pyjde/test"
if (os.path.isdir(ardajardir)):
    os.system("rm -rf " + ardajardir)

currdir = os.getcwd()
print currdir

sys.path.append(currdir)
from Project import Project
from Class import Class

a = Project("")

print a.get_dir_from_filename("/home/burak/Test.java")

os.system('mkdir /tmp/test')
os.system('mkdir /tmp/test/bla')
os.system('mkdir /tmp/test/bla/bla')
cmd = 'echo "sourcepath \\"asdasf\\"\" > /tmp/test/prj.el'
os.system(cmd)

print a.find_prj_el("/tmp/test/bla/bla")

try:
    print a.find_prj_el("/tmp")
except Exception:
    print "exception raised"

print a.get_src_dir(currdir + "/./test")

t = Project(currdir + "/./test")
print "top src dir " + t.top_src_dir
print t.find_all_descendants("A")

print t.run_command('ls')

t = Project(currdir + "/./test")
print "top src dir " + t.top_src_dir
print t.find_file_for_thing("C", currdir + "/test/test/bla/B.java")

t = Project(currdir + "/./test")
print "top src dir " + t.top_src_dir
type, pos = t.find_declaration_type("anani", currdir + "/test/test/bla/B.java", 423)

os.system("cp " + currdir + "/test/lib/commons-logging.jar /tmp/")
t = Project(currdir + "/./test")
print t.top_src_dir
t.unjar()

t = Project(currdir + "/./test")
print "top src dir " + t.top_src_dir
print t.find_file_for_thing("D", currdir + "/test/test/bla/B.java")

s = "/home/burak/kod/pocketbudda/src/java/com/pocketbudda/UserHandlerBean.java"
print re.sub(r'/\w*.java$',"/UserDao"+".java", s)

t = Project(currdir + "/./test")
s = t.find_file_for_thing("C", currdir + "/test/test/bla/B.java")
c = Class(t, s)
print c.list_all_public()

'''
# TBD activate after unjar is done
t = Project(currdir + "/./test")
s = t.find_file_for_thing("ARDAGoForward", currdir + "/test/test/bla/B.java")
c = Class(t, s)
print c.list_all_public()
'''

teststr = "   Person user;\n   " 
thing = "user"
for m in re.finditer("([A-Z]\w*?)\s"+thing+"\s*?[;=]", teststr): print m.group(1)

res = re.search('(ers.*?u)', teststr)
print res.group(1)
if (res): print "match 1"

res = re.search('(lakdsfkas.*?u)', teststr)
if (res): 
    print "match 2"
else: 
    print "no match 2"    
   
teststr = " StoreClient<String, String> facebookPbUsers ;"
print teststr
thing = "facebookPbUsers"
m = re.search("([A-Z]\w*?)[<\s].*\s" + thing + "\s*?[);=]", teststr)
if (m): print m.group(1)

t = Project(currdir + "/./test")
print "top src dir " + t.top_src_dir
type, pos = t.find_declaration_type("anani", currdir + "/test/test/bla/B.java", 423)
print res
assert (type == 'C')

t = Project("")
res = t.get_dir_from_filename("/asdf/asdf/asdf/asdf.java")
assert (res == "/asdf/asdf/asdf/")

clf = re.search('200\d\s(.*?)\.class', '2308 Tue May 09 23:08:14 EEST 2006 org/apache/commons/logging/impl/WeakHashtable$Referenced.class')
if (clf != None):
    print "clf="+str(clf.groups())


