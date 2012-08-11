import os, re, glob, sys, string;

class Class: 

    project = None
    file = None
    
    def __init__ (self, project, file):
        self.project = project
        self.file = file
        print "self.file="+self.file
        print "self.project.top_dir=" + self.project.top_dir
        
    def list_all_public(self):
        result = []
        f = open(self.file)
        content = f.read()
        for m in re.finditer("public.*?\s([a-z]\w*\(.*?\))\s*?[t{;]", content):
            result.append(m.group(1))
        return result

    
