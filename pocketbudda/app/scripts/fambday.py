#http://www.slipyourmind.com/famous-bdays.html?m=4&d=18

import urllib
import re
import os

fout = open ("fambday.txt", "w")
for m in range(12):
    mon = str(m+1)
    for d in range(31):
        day = str(d+1)
        print mon, day
        url = "http://www.slipyourmind.com/famous-bdays.html?m=" + mon + "&d="+ day
        h = urllib.urlopen(url)
        content = h.read()
        content = content.replace('\r',"")
        #print content
        m = re.findall("<td nowrap>.*?(\d\d\d\d).*?<a href.*?>(.*?)</a>.*?</td>.*?<td>(.*?)</td>", content, re.DOTALL)
        for item in m:
            b = day + "/" + mon + "/" + item[0]
            fout.write(item[1] + ":" + item[2].replace("\t","").replace("\n","") + ":" + b)
            fout.write("\n")
