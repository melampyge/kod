# coding=utf-8
import urllib
import re
import os

infile = open("../../res/raw/hatdetaydurakutf")
outfile = open("../../res/raw/hatdetayduraknospaceutf", "w")
for line in infile.readlines():    
    if (line != "\n"):
        outfile.write(line)
        outfile.flush()
    
infile.close()
outfile.close()
