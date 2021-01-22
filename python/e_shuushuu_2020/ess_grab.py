from bs4 import BeautifulSoup as bs
import requests
import time
import sys
import traceback
import os
from unicodedata import normalize

headers = {'User-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'}

grabb = 1

#with open('ess_id.lst') as fp:
#    for cnt, line in enumerate(fp):
for i in range(1046000,1047000):
        try:
#            i = int(line)
            time.sleep(0.4)
            page = requests.get("http://e-shuushuu.net/image/" + str(i) + "/")
            if page:
                soup = bs(page.content, "html.parser")
                main = soup.find("div", {"id": "page"})
                content = main.find("div", {"id": "content"})
                for x in content.findAll("div", {"class": "image_thread display"}):
                    for y in x.findAll("div", {"class": "image_block"}):
                        z = y.find("div", {"class": "thumb"})
                        a = z.find("a", {"class": "thumb_image"})
                        try:
                            name = str(a["href"].replace("/images/", "").strip())
                        except:
                            name = "2000-01-01-" + str(i) + ".no"
                        url = "http://e-shuushuu.net/images/" + name
                        path = "downloaded/" + name[:10] + "/"
                        print(name + "\t", end='')
                        vmeta = y.find("div", {"class": "meta"})
                        print( vmeta.find("dt", text="Submitted On:").findNext("dd").string + "\t", end='')
                        print( vmeta.find("dt", text="Dimensions:").findNext("dd").string + "\t", end='')
                        print( vmeta.find("dt", text="Favorites:").findNext("dd").string + "\t", end='')
                        for qtag in vmeta.findAll(class_="quicktag"):
                            if 'quicktag1' in str(qtag):
                              print(str(normalize('NFKD', str(qtag.get_text())).encode('ascii', 'ignore'))[2:-1].replace("\\n","") + "\t", end='')
                            if 'quicktag2' in str(qtag):
                              print("COPYRS:" + str(normalize('NFKD', str(qtag.get_text())).encode('ascii', 'ignore'))[2:-1].replace("\\n","") + "\t", end='')
                            if 'quicktag3' in str(qtag):
                              print("ARTIS:" + str(normalize('NFKD', str(qtag.get_text())).encode('ascii', 'ignore'))[2:-1].replace("\\n","") + "\t", end='')
                            if 'quicktag4' in str(qtag):
                              print("CHARS:" + str(normalize('NFKD', str(qtag.get_text())).encode('ascii', 'ignore'))[2:-1].replace("\\n", "") + "\t", end='')
                        print("EOL", flush=True)
                        if grabb != 0:
                            if not os.path.exists(path): os.makedirs(path)
                            p = requests.get(url, headers=headers)
                            with open(str(path + name), 'wb') as outfile:
                               outfile.write(p.content)
                            time.sleep(1)
            else:
                print(str(i) + ';NOPAGE', file=sys.stderr, flush=True)
                continue
        except:
            print("EOL", flush=True)
            print(str(i) + ';FAIL;' + traceback.format_exc().replace('\n','') + '\n', file=sys.stderr, flush=True)
            time.sleep(2)
            pass
