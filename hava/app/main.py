#!/usr/bin/env python

import cgi
import logging
import wsgiref.handlers
from google.appengine.ext import webapp
from django.utils import simplejson
from google.appengine.api import memcache
import scraper
    
logging.getLogger().setLevel(logging.DEBUG)

class Main(webapp.RequestHandler):  
  def get(self):
    self.redirect("/mweb/index.html")
    
class GetData(webapp.RequestHandler):  
  def get(self):
    sehir = self.request.get('sehir')
    if memcache.get(sehir) == None:      
      s = scraper.Scraper()
      res = s.hava_sehir(sehir)
      logging.debug(res)
      memcache.set(key=sehir, value=res, time=3600)
    self.response.out.write(simplejson.dumps(memcache.get(sehir)))
  
application = webapp.WSGIApplication([
  ('/', Main),
  ('/get_data', GetData),
], debug=True)

def main():
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
