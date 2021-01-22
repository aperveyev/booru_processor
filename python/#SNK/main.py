from bs4 import BeautifulSoup as bs
import requests
import time
import re
import sys
import traceback
from unicodedata import normalize
import cx_Oracle
import pandas as pd

headerrs = {'User-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'}

with open('snk_id.lst') as fp:
 for cnt, line in enumerate(fp):
   try:
     i = int(line)
     page = requests.get("https://chan.sankakucomplex.com/post/show/"+str(i))
     if page:
       soup = bs(page.content, "html.parser")
       titl = soup.find("title")
       l_tags = str(normalize('NFKD', str(titl)[7:-26]).encode('ascii', 'ignore'))[2:-1]
       print(str(i)+"\t"+l_tags+"\t", end = '')
       p_score = soup.find("span", {"id":"post-score-"+str(i)})
       resp = re.search('>(.*)</span>', str(p_score))
       print(resp.group(1)+"\t", end = '')
       p_vcnt = soup.find("span", {"id":"post-vote-count-"+str(i)})
       resc = re.search('>(.*)</span>', str(p_vcnt))
       print(resc.group(1)+"\t", end = '')
       stts = soup.find("div", {"id": "stats"})
       uull = stts.find("ul")
       for li in uull.findAll("li"):
          if str(li).replace("\n","").startswith("<li>Posted:") or str(li).replace("\n","").startswith("<li>Опубликовано:"):
              a = li.find("a")
              print(a["title"]+"\t", end = '')
          if str(li).startswith("<li>Rating:") or str(li).startswith("<li>Рейтинг:"):
              l_rating = str(li)[12:-5]
              print(l_rating+"\t", end = '')
          if str(li).startswith("<li>Original:") or str(li).startswith("<li>Оригинал:"):
              a = li.find("a")
              l_bytes = int(a["title"].rstrip(' bytes').replace(',',''))
              print(str(l_bytes)+"\t", end = '')
              result = re.search('>(.*)</a>', str(a))
              l_sizes = result.group(1)
              s_array = re.findall(r'[0-9]+',l_sizes)
              l_width = int ( s_array[0] )
              l_height = int ( s_array[1] )
              print( str(l_width) + '\t' + str(l_height) +"\t", end = '' )
              l_url = "https:"+a["href"]
              print(l_url+"\t", end = '')
              l_md5 = l_url[40:72]
              l_ext = l_url[72:76]
       print("EOL",flush=True)
       p = requests.get(l_url,headers=headerrs)
       with open('SNK_ID\chan.sankakucomplex.com - ' + str(i) + ' - misc ~ unknown (anonymous)' + l_ext, 'wb') as outfile:
         outfile.write(p.content)
       time.sleep(4)
     else:
       print(str(i)+"\t"+"NOPAGE", file=sys.stderr, flush=True)
       time.sleep(8)
   except:
     print(str(i)+"\t"+traceback.format_exc().replace("\n",""), file=sys.stderr, flush=True)
     time.sleep(8)
   time.sleep(4)
