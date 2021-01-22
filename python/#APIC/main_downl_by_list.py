from bs4 import BeautifulSoup as bs
import requests
import time
import sys
import traceback
import re

tagf = open('apic_tags.tsv', 'a')

with open('apic_list.lst') as fp:
  for cnt, line in enumerate(fp):
    try:
      i = int(line)
      page = requests.get("https://anime-pictures.net/pictures/view_post/"+str(i)+"?lang=en")
      if page:
        print(str(i) + "\t", end='')
        soup = bs(page.content, "html.parser")
        cntn = soup.find("div", {"class": "post_content"})
#        print(cntn)
        re_du = re.search('<b>Date Upload:</b>(.*)<br/>', str(cntn))
        print(re_du.group(1) + "\t", end='')
        re_dd = re.search('<b>Downloads:</b>(.*)<br/>', str(cntn))
        print(re_dd.group(1) + "\t", end='')
        re_rx = re.search('res_x=(.*)&amp;res_y', str(cntn))
        l_width = int(re_rx.group(1))
        print(str(l_width) + "\t", end='')
        re_ry = re.search('res_y=(.*)&amp', str(cntn))
        l_height = int(re_ry.group(1))
        print(str(l_height) + "\t", end='')
        voteb = soup.find("div", {"class": "post_vote_block"})
#        print(voteb)
        print(str(voteb.find("span",{"id":"rating"}).find("span",{"id":"score_n"}).contents)[2:-2] + "\t", end='')
        re_uri = re.search('net/previews/(.*)_bp.', str(voteb))
        l_hash = re_uri.group(1)
        re_urd = re.search('/pictures/download_image/(.*)" rel="nofollow', str(voteb))
        l_ext = '.' + re_urd.group(1).split('.')[1]
        ultags = soup.find("ul", {"class": "tags"})
#        print(ultags)
        for lig in ultags.findAll("li", {"class": "green"}):
          tagf.write(str(i) + "\t3\t" + str(lig.find("a").contents)[2:-2] + '\n')
        for lib in ultags.findAll("li", {"class": "blue"}):
          tagf.write(str(i) + "\t4\t" + str(lib.find("a").contents)[2:-2] + '\n')
        for lio in ultags.findAll("li", {"class": "orange"}):
          tagf.write(str(i) + "\t1\t" + str(lio.find("a").contents)[2:-2] + '\n')
        tagf.flush()
        l_url = "https://images.anime-pictures.net/" + l_hash + l_ext
        print(l_url, flush=True)
        if l_width > 199 and l_height > 199:
           hdrs = { 'User-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'  }
           p = requests.get(l_url, headers=hdrs)
           with open('APIC\\apic - ' + str(i) + l_ext, 'wb') as outfile:
             outfile.write(p.content)
           time.sleep(1)
        else:
           print(str(i) + "\tFILTERED", file=sys.stderr, flush=True)
# print(str(i)+";"+str(normalize('NFKD',str(rresp)[51:-12]).encode('ascii', 'ignore'))[2:-1],flush=True)
      else:
        print(str(i) + '\tNOPAGE', file=sys.stderr, flush=True)
      time.sleep(2)
    except:
      print(str(i) + "\tPAGEFAIL - " + traceback.format_exc().replace("\n", ""), file=sys.stderr, flush=True)
      time.sleep(3)
