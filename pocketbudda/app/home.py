#!/usr/bin/env python

import os
import cgi
import logging
import wsgiref.handlers
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp

class Home(webapp.RequestHandler):  
  def get(self):
    self.redirect("/mweb/index.html")
    
class ExtHome(webapp.RequestHandler):  
  def get(self):
    self.redirect("/page?p=home")

class MobileHome(webapp.RequestHandler):  
  def get(self):
    self.redirect("/mweb/index.html")

