#!/usr/bin/env python

import cgi
import logging
import wsgiref.handlers
import datetime
from google.appengine.ext import webapp
import calculate
from django.utils import simplejson

class Celeb(webapp.RequestHandler):  
  def get(self):
    d = self.request.get('astro')
    celebbday = datetime.datetime.strptime(d, '%d/%m/%Y').date().strftime('%Y%m%d')
    [cellewis, celspiller, celchinese, celmillman] = calculate.calculate(celebbday)
    res = []
    infile = open("celebs")   
    for line in infile.readlines():
      resline = []
      tokens = line.split("|")
      name = tokens[0]
      resline.append(name)
      occup = tokens[1]
      resline.append(occup)
      tokens = tokens[2].split(":")
      if celspiller in tokens: resline.append(celspiller)
      if celchinese in tokens: resline.append(celchinese)
      for lewi in cellewis:
        if lewi in tokens: resline.append(lewi)
      if len(resline) > 5: # to avoid unnecessary sorting later
        res.append(resline)
      
    # sort according to list size, negative is taken
    # so that the sorting is descending
    #res.sort(lambda x, y: cmp(-len(x), -len(y))) 
    res = res[0:100]    
    self.response.out.write(simplejson.dumps(res))
    
class CelebLifeGoal(webapp.RequestHandler):  
  def get(self):
    d = self.request.get('astro')
    filter = self.request.get('filter')
    celebbday = datetime.datetime.strptime(d, '%d/%m/%Y').date().strftime('%Y%m%d')
    [cellewis, celspiller, celchinese, celmillman] = calculate.calculate(celebbday)
    res = []
    infile = open("celeb_life_goal.txt")   
    for line in infile.readlines():
      try:
        tokens = line.split(":")
        if filter == '':
          if celmillman[0] == tokens[2].replace("\n",""):
            res.append([tokens[0], tokens[1]])
        else:
          #logging.debug(tokens[1])
          if (filter.lower() in tokens[1].lower()) and (celmillman[0] == tokens[2].replace("\n","")):
            res.append([tokens[0], tokens[1]])
      except Exception, e:
        pass

    self.response.out.write(simplejson.dumps(res))
