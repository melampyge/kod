from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

from models import *
import Cookie
import re
import base64
import os
import logging
from django.utils import simplejson

class PostComment(webapp.RequestHandler):
    
  def post(self):    
    text = self.request.get('text')    
    text = re.sub(r'<.*?>',"", text) # no html allowed
    # check for spam
    tokens = re.split("\s", text)
    file = open ("bad-words.txt")
    bad_words = file.read().split("\n")
    for word in tokens:
      if word in bad_words: 
        return
    p = Post(message=text)
    p.put()

    
class ReadComments(webapp.RequestHandler):
  
  def get(self):    
    page = int(self.request.get('page'))
    user_id = self.request.get('user_id')        
    page_size = 5
    q = Post.all()
    q.order("-date")
    posts = q.fetch(page_size, page*page_size)
    out = ""
    matches = []
    for post in posts:
      out += "<li>" + post.message + "</li>"      
    self.response.out.write(out)
                            
    
class AdminUpdate(webapp.RequestHandler):
  
  def get(self):    
    users = AppUser.all().fetch(9)
    for user in users:
      tmp = user.chinese
      user.chinese = user.spiller
      user.spiller = tmp
      user.put()
    print "done"
