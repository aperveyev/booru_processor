import re
import json
import requests
import time
import sys
import traceback
from bs4 import BeautifulSoup as bs

jfl = open('tbib_grab_70.json', 'a')

for i in range(7165725,7000000,-1):
#with open('tbib_id.lst') as fp:
# for cnt, line in enumerate(fp):
#  i = int(line)
  try:
    time.sleep(2)
    r = requests.get('https://tbib.org/index.php?page=dapi&s=post&q=index&id='+str(i)+'&json=1')
    j = r.json()
    jfl.write( str(i) + '\t' + str(j) + '\n' )
    jfl.flush()
    if int(j[0]['width']) > 1079 and int(j[0]['height']) > 1079 and j[0]['rating'] == 'safe' and j[0]['owner'] == 'e621' :
      p = requests.get('https://tbib.org//images/'+j[0]['directory']+'/'+j[0]['image'])
      with open('TBIB\\tbib.org - '+str(j[0]['id']) +' - '+j[0]['image'], 'wb') as outfile:
        outfile.write(p.content)
      time.sleep(1)
      page = requests.get("https://tbib.org/index.php?page=post&s=view&id="+str(i))
      if page:
        soup = bs(page.content, "html.parser")
        titl = soup.find("title")
        tags = soup.find("ul", {"id": "tag-sidebar"})
        for li in tags.findAll("li"):
          if str(li).startswith("<li class=\"tag-type-copyright") or \
             str(li).startswith("<li class=\"tag-type-artist") or \
             str(li).startswith("<li class=\"tag-type-character") :
               print(str(i)+"\t"+str(li["class"])+"\t", end = '')
               a = li.find("a")
               result = re.search('>(.*)</a>', str(a))
               print(result.group(1),flush=True)
  except:
    print(str(i)+"\t"+traceback.format_exc().replace("\n",""), file=sys.stderr, flush=True)
    time.sleep(1)
    pass
