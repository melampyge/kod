#!/usr/bin/env python

import cgi
import logging
import wsgiref.handlers
from google.appengine.ext import webapp
from forums import *
from celeb import *
from page import *
from reading import *
from home import *
from food import *
from google.appengine.api import memcache
    
logging.getLogger().setLevel(logging.DEBUG)

application = webapp.WSGIApplication([
  ('/', Home),
  ('/admin_update_33', AdminUpdate),
  ('/celeb', Celeb),
  ('/celeb_life_goal', CelebLifeGoal),
  ('/post_comment', PostComment),
  ('/read_comments', ReadComments),
  ('/page', LoadPage),
  ('/reading', Reading),
  ('/food_names', Food),
  ('/check_food_btype', FoodCheck),
  ('/get_reading_ajax', ReadingAjax),
  ('/get_reading_ajax_multi', ReadingMultiAjax),
  ('/detail', Detail),
  ('/ext', ExtHome),
  ('/mweb', MobileHome),
  ('/mobile/', MobileHome),
  ('/mobile/index.html', MobileHome),
  ('/evaluate_mbti', MbtiAjax),
], debug=True)

def main():
  wsgiref.handlers.CGIHandler().run(application)

if __name__ == '__main__':
  main()
