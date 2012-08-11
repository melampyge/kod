#!/usr/bin/env python

import os
import cgi
import logging
import wsgiref.handlers
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

class LoadPage(webapp.RequestHandler):
  
  def get(self):
    p = self.request.get('p')         
    path = os.path.join(os.path.dirname(__file__), p+'.html')
    self.response.out.write(template.render(path, None))    
    
    
