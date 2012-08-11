#!/usr/bin/env python

import os
import cgi
import logging
import datetime
import wsgiref.handlers
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp
from django.utils import simplejson
      
class Food(webapp.RequestHandler):
  
  def get(self):
    f = open("food.dat")
    res = []
    for line in f.readlines():
      tokens = line.split(",")
      res.append(tokens[2].replace("'",""))
    self.response.out.write(simplejson.dumps(res))

def noc(x): return x.replace("'","")
    
class FoodCheck(webapp.RequestHandler):
  # a,ab,o,b
  # diabetesa,diabetesb,diabetesab,diabeteso
  # cancera,cancerb,cancerab,cancero
  def get(self):
    btype = self.request.get('btype')     
    food = self.request.get('food')     
    f = open("food.dat")
    res = []
    for line in f.readlines():
      tokens = line.split(",")
      if food.upper() in noc(tokens[2]):
        if btype == 'A': res.append([noc(tokens[2]), noc(tokens[3])])
        if btype == 'AB': res.append([noc(tokens[2]), noc(tokens[4])])
        if btype == 'O': res.append([noc(tokens[2]), noc(tokens[5])])
        if btype == 'B': res.append([noc(tokens[2]), noc(tokens[6])])
    self.response.out.write(res)
    
