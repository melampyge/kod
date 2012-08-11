#!/usr/bin/env python
import os
import cgi
import logging
import datetime
import wsgiref.handlers
from google.appengine.ext.webapp import template
from google.appengine.ext import webapp
from django.utils import simplejson
import calculate
import pickle
      
def convertSpiller(spiller):
  if (spiller == 'Aquarius'): return 'Less Spotlight';
  if (spiller == 'Aries'): return 'Me First';
  if (spiller == 'Cancer'): return 'Ex-Manager';
  if (spiller == 'Capricorn'): return 'Responsible One';
  if (spiller == 'Gemini'): return 'Can Be Wrong';
  if (spiller == 'Leo'): return 'Center Stage';
  if (spiller == 'Libra'): return 'Diplomat';
  if (spiller == 'Pisces'): return 'No Need For Perfection';
  if (spiller == 'Sagittarius'): return 'Just Do It';
  if (spiller == 'Scorpio'): return 'Comfort Zone';
  if (spiller == 'Taurus'): return 'Independent';
  if (spiller == 'Virgo'): return 'Not A Victim';    
      
class Reading(webapp.RequestHandler):
  
  def get(self):
    d = self.request.get('d')     
    btype = self.request.get('btype') 

    try:
      lewis, spiller, chinese, millman = calculate.calculate(d)
      
      lewi_summary = self.get_lewi(lewis[0])
      spiller_summary = self.get_spiller(spiller)
      chinese_summary = self.get_chinese(chinese)
      millman_summary = self.get_millman(millman[0])
      mbti_summary = self.get_mbti()

      cycle, now_year, str_d = calculate.calculate_cycle(d)

      mb_astro_res = calculate.calculate_mbti_full([lewis, spiller, chinese, millman])
      logging.debug(mb_astro_res)
      
      path = os.path.join(os.path.dirname(__file__), 'reading.html')
      template_values = {
        'code_date': d,
        'date': str_d,
        'lewi_main': lewis[0],
        'lewis': lewis,
        'spiller': spiller,
        'spiller_converted': convertSpiller(spiller),
        'chinese': chinese,
        'btype': btype,
        'millman': millman,
        'millman_main': millman[0],
        'mb': mb_astro_res,
        'lewi_summary': lewi_summary,
        'spiller_summary': spiller_summary,
        'chinese_summary': chinese_summary,
        'millman_summary': millman_summary,
        'mbti_summary': mbti_summary,
        'cycle': cycle,
        'now_year': now_year
        }  
    except Exception, e:
      logging.debug(e)
      path = os.path.join(os.path.dirname(__file__), 'explore.html')
      template_values = {
        'error': 'Wrong date',
        }        
    self.response.out.write(template.render(path, template_values))    
    
  def get_lewi(self, lewi):
    file = open ("astro/lewi/" + lewi + ".html")    
    content = file.read()
    file.close()
    return content[0:300]
  
  def get_mbti(self):
    file = open ("astro/mbti/mb_stat_explain.html")    
    content = file.read()
    file.close()
    return content
  
  def get_spiller(self, spiller):
    file = open ("astro/spiller/" + spiller + ".html")    
    content = file.read()
    file.close()
    return content[0:300]
  
  def get_millman(self, millman):
    file = open ("astro/millman/" + millman + ".html")    
    content = file.read()
    file.close()
    return content[0:300]
  
  def get_chinese(self, chinese):
    file = open ("astro/chinese/" + chinese + ".html")    
    content = file.read()
    file.close()
    return content[0:300]  
    
class Detail(webapp.RequestHandler):
  
  def get(self):
    item = self.request.get('item')     
    type = self.request.get('type')     
    detail = open ("astro/"+type+"/"+item+".html")
    content = detail.read()
    detail.close()
    template_values = {
      'header': item,
      'detail': content,
      }  
    path = os.path.join(os.path.dirname(__file__), 'detail.html')
    self.response.out.write(template.render(path, template_values))    

  
class ReadingAjax(webapp.RequestHandler):
  def get(self):    
    bday = self.request.get('bday')     
    btype = self.request.get('btype')    
    [lewis, spiller, chinese, millman] = calculate.calculate(bday)
    logging.debug(lewis)
    lewis_int = [int(x) for x in lewis]
    mb = calculate.calculate_mbti_full([lewis, spiller, chinese, millman]) 
    cycle, now_year, str_d = calculate.calculate_cycle(bday)
    res = {"lewis": lewis_int, "spiller": spiller, "chinese": chinese, "millman": millman, "mb": mb, "cycle": cycle}
    self.response.out.write(simplejson.dumps(res))

    
class ReadingMultiAjax(webapp.RequestHandler):
  def get(self):    
    res = []
    bdays = self.request.get('bdays')
    for bday in bdays.split(","): 
      bday_date = datetime.datetime.strptime(bday, '%B %d %Y').date()
      bday_pb_date = bday_date.strftime('%Y%m%d')
      [lewis, spiller, chinese, millman] = calculate.calculate(bday_pb_date)
      logging.debug(lewis)
      lewis_int = [int(x) for x in lewis]
      mb_astro_res = calculate.calculate_mb([lewis, spiller, chinese, millman]) 
      cycle, now_year, str_d = calculate.calculate_cycle(bday_pb_date)
      res.append({"lewis": lewis_int, "spiller": spiller, "chinese": chinese, "millman": millman, "mb": mb_astro_res, "cycle": cycle, "bday": bday_pb_date})

    self.response.out.write(simplejson.dumps(res))
    
class MbtiAjax(webapp.RequestHandler):
  def get(self):    
      ans = str(self.request.get('answers'))
      #logging.debug(ans)
      choices = ans.split(":")[1:] 
      #logging.debug(choices)
      res = calculate.calculate_mb(choices)
      logging.debug(res)
      self.response.out.write(simplejson.dumps(res))

