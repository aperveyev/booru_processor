from bs4 import BeautifulSoup as bs
import requests
import time
import sys
import traceback
from unicodedata import normalize

#for i in range(100000,199999): # to grab by range comment some lines below
with open('kona_list.lst') as fp:
  for cnt, line in enumerate(fp):
    try:
      i = int(line)
      page = requests.get("https://konachan.com/post/show/"+str(i))
      if page:
        soup = bs(page.content, "html.parser")
        cntt = soup.find("div", {"id": "content"})
        pv = cntt.find("div", {"id": "post-view"})
        rresp = pv.find("script", {"type": "text/javascript"})
        try:
          if not str(rresp)[51:-12].startswith("Box"):
            print(str(i)+";"+str(normalize('NFKD',str(rresp)[51:-12]).encode('ascii', 'ignore'))[2:-1],flush=True)
        except:
          print(str(i) + ';TAGFAIL', file=sys.stderr, flush=True)
          print(traceback.format_exc(), file=sys.stderr, flush=True)
          time.sleep(2)
      else:
        print(str(i) + ';{"posts":[{"id":' + str(i) + '}]}', flush=True)
      time.sleep(3)
    except:
      print(str(i) + ';LINEFAIL', file=sys.stderr, flush=True)
      print(traceback.format_exc(), file=sys.stderr, flush=True)
      time.sleep(1)
      pass
