from bs4 import BeautifulSoup as bs
import requests
import time
import re
import sys
import traceback
from unicodedata import normalize
import pandas as pd

headerrs = {'User-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'}

data = pd.read_fwf("fciv.txt", names=['fmd5', 'fname'], header=None, colspecs=[(0, 32), (33, 400)])

#with open('snk_id_x.lst') as fp:
# for cnt, line in enumerate(fp):
for i in range(22184817,22184818): 
   try:
#     i = int(line)
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
          if str(li).replace("\n","").startswith("<li>Posted:"):
              a = li.find("a")
              print(a["title"]+"\t", end = '')
          if str(li).startswith("<li>Rating:"):
              l_rating = str(li)[12:-5]
              print(l_rating+"\t", end = '')
          if str(li).startswith("<li>Original:"):
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
#              print(str(i) + "\t" + l_md5 + "\t" + l_ext, file=sys.stderr, flush=True)
       print("EOL",flush=True)
       time.sleep(2)
       if l_rating != "Explicit" and l_width>1079 and l_height>1079 and (l_width*l_height)>1199999 \
               and not "doujinshi," in l_tags and not "comic," in l_tags and not "4koma," in l_tags \
               and not ".swf?e=" in l_url and not ".gif?e=" in l_url and not ".mp4?e=" in l_url:
          exst = 0
#          for (cur) in mycursor.execute(" select booru, fid from arch_md5 where fmd5 = :f1 fetch first 1 rows only ",[l_md5]):
#            exst = 1
#            print(str(i) + "\t" + "EXISTS" + "\t" + cur[0] + " - " + str(cur[1]), file=sys.stderr, flush=True)
          if exst == 0:
            try:
              strr = str(data.loc[data['fmd5'] == l_md5]['fname'].values[0])
              exst = 2
              print(str(i) + "\t" +  "EXI_FCIV" + "\t" + strr.rpartition('\\')[2].rpartition(' - ')[0], file=sys.stderr, flush=True)
            except:
              pass
          if exst == 0:
            p = requests.get(l_url,headers=headerrs)
            with open('SNK\chan.sankakucomplex.com - ' + str(i) + ' - misc ~ unknown (anonymous)' + l_ext, 'wb') as outfile:
              outfile.write(p.content)
            time.sleep(1)
       else:
          print(str(i) + "\t" + "FILTERED" + "\t" + l_rating + ' ' + str(l_width)+'x'+str(l_height) , file=sys.stderr, flush=True)
     else:
       print(str(i)+"\t"+"NOPAGE", file=sys.stderr, flush=True)
       time.sleep(10)
   except:
     print(str(i)+"\t"+traceback.format_exc().replace("\n",""), file=sys.stderr, flush=True)
     time.sleep(8)
   time.sleep(2)
