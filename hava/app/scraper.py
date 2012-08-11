# coding=utf-8
import re, urllib, urllib2
import logging
from datetime import datetime
from datetime import timedelta
from urllib import FancyURLopener

class MyOpener(FancyURLopener):
    version = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.11) Gecko/20071127 Firefox/2.0.0.11'        
    
class Scraper:
    opener = MyOpener()
    
    def hava_sehir(self, sehir):
        res = []
        url = "http://www.dmi.gov.tr/tahmin/il-ve-ilceler.aspx?m=%s" % sehir
        h = self.opener.open(url)
        content = h.read()
        tmp = re.findall("thmGun.*?\">(.*?)</th>", content)
        gun = []
        for g in tmp:
            s = g.split(" ")[2]
            s = s.replace("\xc5\x9f","s")
            s = s.replace("\xc3\x87","C")
            s = s.replace("\xc4\xb1","i")            
            gun.append(s)
        mins = re.findall("minS\">(.*?)</td>", content)
        maxs = re.findall("maxS\">(.*?)</td>", content)
        minn = re.findall("minN\">(.*?)</td>", content)
        maxn = re.findall("maxN\">(.*?)</td>", content)
        yon = re.findall("RuzgarYon.*?src=\"(.*?)\" alt", content)
        yon = [y.replace("../FILES","http://www.dmi.gov.tr/FILES") for y in yon]
        hiz = re.findall("RuzgarHiz.*?\">(.*?)</td>", content)
        hadise = re.findall("imgHadise.*?src=\"(.*?)\" alt", content)
        hadise = [h.replace("../FILES","http://www.dmi.gov.tr/FILES") for h in hadise]
        return {"gun": gun, "mins":mins, "maxs": maxs, "minn": minn, "maxn":maxn, 
                "yon":yon, "hiz": hiz, "hadise": hadise}
    
if __name__ == '__main__':

    s = Scraper()
    print s.hava_sehir("istanbul")
        
