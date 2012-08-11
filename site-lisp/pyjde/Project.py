import os, re, glob, sys, string;

class Project:

    top_dir = None
    top_src_dir = None
    lastdirname_in_topdir = None
    
    def __init__ (self, filename):
        if (filename != ""):
            self.top_dir=self.find_prj_el(self.get_dir_from_filename(filename))
            self.top_src_dir = self.get_src_dir(self.top_dir)
            # make sure to get the project name in .pyjde directory
            # so jars with same names but different directories do not get
            # mixed up
            topdirs = self.top_dir.split("/")
            self.lastdirname_in_topdir = topdirs[len(topdirs)-1]            
                    
    def get_dir_from_filename(self, filename) :
        res = re.sub("[a-zA-z]*\.java", "", filename)
        return res
        
    def find_prj_el(self, dirname) : 
        found = False
        os.chdir(dirname)
        while (found == False) :
            print os.getcwd()
            list = glob.glob('prj.el')
            print list
            if (len(list) == 1): 
                found = True
                return os.getcwd()
            if (os.getcwd() == "/"): break
            os.chdir(os.pardir)                
        raise Exception("no prj.el found")

    def get_src_dir(self, prj_el_dir) :
        f = open(prj_el_dir + "/prj.el")
        content = f.read()
        res = re.findall("sourcepath.*\"(.*?)\"", content, re.DOTALL)
        if (len(res) != 1): raise Exception("no sourcepath definition found in prj.el")
        return prj_el_dir + "/" + res[0]

    def run_find_cmd(self, keyword):   
        cmd = "find " + self.top_src_dir + " -name '*.java' | xargs grep '" + keyword + "'"
        return self.run_command(cmd)
        
    def find_all_descendants(self, filename):
        list_1 = self.run_find_cmd("extends " + filename)
        list_2 = self.run_find_cmd("implements " + filename)
        for i in list_2: 
            list_1.append(i)
        print list_1
        return list_1

    def run_command(self, command):
        result = []
        print 'Running:', command
        f = os.popen(command, "r")
        sys.stdout.flush()
        for l in f.xreadlines():
            result.append(l)        
        print "in run cmd"
        return result

    def find_file_for_thing(self, thing, file):
        f = open(file)
        content = f.read()
        regex = "import\s(.*?)\."+thing+"\s*?;"
        res = re.findall(regex, content)
        print "len(res)="+str(len(res))
        if (len(res)!=1): 
            print "no import found"
            # if not imports are found for this file, the
            # thing will be assumed to be a Java class in the
            # same directory, therefore same package. we
            # simply replace current file's class part with
            # our thing.. hmm.
            samedirfile = re.sub(r'/\w*.java$', "/"+thing+".java", file)
            if os.path.isfile(samedirfile): return samedirfile
            else:
                # there is no import, in this case try 
                # java.lang route under the jars
                jardirs = os.environ['HOME'] + "/.pyjde/" + self.lastdirname_in_topdir
                list = self.run_command("find " + jardirs + " -type d -name *.jar") 
                for dir in list: 
                    possible_file = dir.replace("\n","") + "/java/lang/" + thing + ".java"
                    print "possible file " + possible_file
                    if (os.path.isfile(possible_file)): 
                        return possible_file
                raise Exception("no imports and file is not a java.lang")
                    
        
        # found the import, now look under .pyjde directory for
        # under all jars
        file_real_path = self.top_src_dir + "/"
        package_dir = ""
        for token in res[0].split('.'):            
            if (token != ''): file_real_path += token + "/"
            if (token != ''): package_dir += token + "/"
        file_real_path += thing + ".java"
        
        if (os.path.isfile(file_real_path)):
            return file_real_path

        print file_real_path + " could not be found" 
        
        jardirs = os.environ['HOME'] + "/.pyjde/" + self.lastdirname_in_topdir
        list = self.run_command("find " + jardirs + " -type d -name *.jar") 
        for dir in list: 
            possible_file = dir.replace("\n","") + "/" + package_dir + thing + ".java"
            print possible_file
            if (os.path.isfile(possible_file)): 
                return possible_file
                                    
        raise Exception("Import is not in any jar")

    def find_declaration_type(self, thing, file, point):
        print "find_declaration_type"
        thing = thing.replace("\n","")
        thing = thing.replace(".","")
        print "thing:"+thing
        f = open(file)
        content = f.read()
        dist = 999999
        currpos = point
        currtype = ""
        reg = "([A-Z]\w*)(<.*?>)*?\s+?" + thing + "\s*?\W*?"
        print "reg="+reg
        for m in re.finditer(reg, content):
            if ((point - m.start()) < dist and m.start() < point): 
                dist = point - m.start()
                currpos = m.start()
                currtype = m.group(1)
        print "found:<"+currtype+">"
        if (currtype == "") : 
            raise Exception("Type cannot be empty");
        return currtype, currpos

    def unjar(self):        
        '''
        reads prj.el file, gets all jar file names and decompiles
        these jars under $HOME/.pyjde/projectname
        '''
        print "inside unjar"
        jardir = os.environ['HOME'] + "/.pyjde/" + self.lastdirname_in_topdir
        print jardir 
        if (os.path.isdir(jardir) == False): #HOME/.pyjde does not exists, create it
            os.mkdir(jardir)
        print self.top_src_dir
        f = open(self.top_dir + "/prj.el")
        content = f.read()

        cp = ""

        # for all jars in prj.el
        #
        jarsinprjel = re.findall("\"(.*?\.jar)\"", content, re.DOTALL)
        for jar in jarsinprjel:
            # create dir if it does not exist
            tmp = jardir + "/" + jar            
            tmp = tmp.replace("./","")
            print tmp
            if (os.path.isdir(tmp)): 
                print tmp + " path exists, no need to unjar"
                continue;
            
            self.create_full_dir(tmp)

        # form the classpath using _all_ of the jar files
        for jar in jarsinprjel:
            # if the jar is a relative path it will have a dot
            # in its file name, otherwise it will start with a /
            # if the path is relative, we need to prepend the project 
            # directory to get to it, otherwise, the jar name byitself
            # will suffice, it is already an absolute path.
            if (jar[0] == '.'):
                realjar = self.top_dir + "/" + jar 
            else:
                realjar = jar                  
            cp += realjar + ":"
                
        # now decompile every jar
        for jar in jarsinprjel:
            dest =  jardir + "/" + jar + "/ "                
            self.decompile(cp, jar, dest)

    def decompile(self, cp, realjar, dest):
        print "cp="+cp
        print "realjar="+realjar
        print "dest="+dest
        list = self.run_command("jar tvf " + realjar) # unjar to get the file list
        for cl in list:            
            clf = re.search('[A-Z]\s20\d\d\s(.*?)\.class',cl)
            if (clf != None): 
                fd = str(clf.group(1))
                if (re.search('\$',fd) == None): # if no '$' char inside
                    cltoken = re.search('/(\w*)$', fd)
                    fddir = re.sub(r'/\w*$', "/", fd) # get rid of last token (class name)
                    dir = dest + fddir # combine to get full .pyjde path
                    dir = dir.replace(" ", "") # rid of space
                    fddot = fd.replace("/", "."); # get the full class name with package
                    if (cltoken == None): 
                        continue;
                    fulljava = dir + cltoken.group(1) + ".java"
                    self.create_full_dir(dir) # create the dir   
                    print "Decompiling " + fulljava
                    decompiled = self.run_command("javap -classpath " + cp + " " + fddot) 
                    fout = open (fulljava, "w")
                    for line in decompiled:
                        fout.write(line)
                    fout.close()

    def create_full_dir(self, dir):
        ''' takes a dir name as /bla/bla/bla and creates the full dir starting
        from top.  this is done because os.mkdir or shell mkdir won't create a
        dir unless all parents are created first.
        '''
        if (dir[0] == "/"): 
            curr = "/"
            for s in dir.split("/"):
                curr += "/" + s
                if (s == ''): continue;                
                if (os.path.isdir(curr)): print curr + " path exists"
                else: 
                    print curr + " does not exist"
                    os.mkdir(curr) 
                print curr

    def find_file_for_import(self, thing):
        '''
        run the unix find command on both .pyjde and local development folders
        to find a match
        '''
        result = []
        jardir = os.environ['HOME'] + "/.pyjde/" + self.lastdirname_in_topdir
        
        list = self.run_command("find " + jardir + " -name " + thing + ".java")
        for file in list:
            found = re.search("\.jar/(.*?)\.java", file).group(1)
            found = found.replace("/",".")
            result.append(found)
            
        list = self.run_command("find " + self.top_src_dir + " -name " + thing + ".java")
        for file in list:
            found = re.search(self.top_src_dir + "(.*?)\.java", file).group(1)
            found = found.replace("/", "", 1)
            found = found.replace("/",".")
            result.append(found)
            
        return result
