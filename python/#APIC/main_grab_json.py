from bs4 import BeautifulSoup as bs
import requests
import time
import sys
import traceback
from unicodedata import normalize

with open('apic_list.lst') as fp:
  for cnt, line in enumerate(fp):
#for i in range(100000,1,-1):
    try:
      i = int(line)
      page = requests.get("https://anime-pictures.net/pictures/view_post/"+str(i)+"?lang=en&type=json")
      if page:
        j = page.json()
        print(str(i) + "\t" + str(str(normalize('NFKD',str(j)).encode('ascii', 'ignore')))[2:-1], flush=True)
      else:
        print(str(i) + '\tNOPAGE', file=sys.stderr, flush=True)
      time.sleep(1)
    except:
      print(str(i) + "\tPAGEFAIL - " + traceback.format_exc().replace("\n", ""), file=sys.stderr, flush=True)
      time.sleep(1)
      pass
