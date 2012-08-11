# coding=utf-8
import urllib
import re
import os

hatdict = {}

infile = open("../../res/raw/durakhat")
outfile = open("../../res/raw/hatlar", "w")
for line in infile.readlines():    
    tokens = line.split(":")
    hatlar = tokens[1:len(tokens)]
    for hat in hatlar: 
        if hat not in hatdict:
            hatdict[hat] = True
        
for hat in hatdict.keys():
    outfile.write(hat)
    outfile.write("\n")
    outfile.flush()
    
infile.close()
outfile.close()
