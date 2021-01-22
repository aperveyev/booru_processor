from bs4 import BeautifulSoup as bs
import requests
import time
import re
import sys
import traceback

for i in range(3100000,3300000):
  try:
    page = requests.get("https://safebooru.org/index.php?page=post&s=view&id="+str(i))
    if page:
      soup = bs(page.content, "html.parser")
      titl = soup.find("title")
      tags = soup.find("ul", {"id": "tag-sidebar"})
#      print(tags)
      for li in tags.findAll("li"):
#          print(li)
          if str(li).startswith("<li class=\"tag-type-copyright") or \
             str(li).startswith("<li class=\"tag-type-artist") or \
             str(li).startswith("<li class=\"tag-type-character") :
               print(str(i)+"\t"+str(li["class"])+"\t", end = '')
               a = li.find("a")
#               print(a)
               result = re.search('>(.*)</a>', str(a))
               print(result.group(1),flush=True)
  except:
    print(str(i),file=sys.stderr,flush=True)
    print(traceback.format_exc(),file=sys.stderr,flush=True)
    time.sleep(1)
  time.sleep(0.6)
