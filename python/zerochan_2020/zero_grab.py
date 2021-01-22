from bs4 import BeautifulSoup as bs
import requests
import time
import re
import json
import traceback
import sys

jfl = open('zero_grab.json', 'a')

# comment this to switch to ID_RANGE mode
with open('zero_grab.lst') as fp:
 for cnt, line in enumerate(fp):
  i = int(line)
#for i in range(2679411,2500000,-1): # ID_RANGE mode
  try:
   page = requests.get("https://www.zerochan.net/" + str(i))
   if page:
     soup = bs(page.content, "html.parser")
     mnu = soup.find("div", {"id": "menu"})
     tgs = mnu.find("ul", {"id": "tags"})
#     print(tgs)
     for li in tgs.findAll("li"):
#       print(li)
       ttp = re.search('/a>(.*)</li>', str(li))
       print(str(i)+"\t"+str(ttp.group(1))[1:]+"\t",end='')
       a = li.find("a")
#       print(a)
       aaa = re.search('>(.*)</a>', str(a))
       try:
         print(aaa.group(1),flush=True)
       except:
         print("TAGFAIL",flush=True)
         time.sleep(1)
         pass
     scrp = soup.find("script", {"type": "application/ld+json"})
#     print(str(scrp)[36:-9].replace('\n',''), flush=True)
     try:
       jfl.write(str(scrp)[36:-9].replace('\n','').replace("\\'","").replace("'","")+'\n')
       jfl.flush()
     except:
       print(str(i) + ';JSONFAIL', file=sys.stderr, flush=True) # some tags will be lost
       print(traceback.format_exc(), file=sys.stderr, flush=True)
       time.sleep(4)
       pass
#     print(str(scrp)[36:-9].replace("\\'","").replace("'",""))
     j = json.loads(str(scrp)[36:-9].replace("\\'","").replace("'",""))
#     print(j['contentUrl'].rsplit('/',1)[1], flush=True)
     iw = int(str(j['width'])[0:-3])
     ih =  int(str(j['height'])[0:-3])
     if iw>1079 and ih>1079 : # here are filters
       p = requests.get(j['contentUrl'])
       with open('GRAB\zero - '+str(i)+ '.jpg', 'wb') as outfile: # extension JPG not correct, will rename
         outfile.write(p.content)
       time.sleep(3)
  except:
   print(str(i) + ';LINEFAIL', file=sys.stderr, flush=True) # try to regrab by list
   print(traceback.format_exc(), file=sys.stderr, flush=True)
   time.sleep(4)
  time.sleep(1)
