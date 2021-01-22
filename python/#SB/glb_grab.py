import requests
import time
import traceback
import sys

headerrs = {'User-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101 Firefox/83.0'}

downl = 2

for i in range(4000000,5000000):
  try:
    r = requests.get('https://gelbooru.com/index.php?page=dapi&s=post&q=index&id=' + str(i) + '&json=1', headers=headerrs)
    j = r.json()
    if r:
      print(str(i)+'\t'+str(j[0]),flush=True)
      ir = j[0]['rating']
      iw = int(j[0]['width'])
      ih = int(j[0]['height'])
      if iw > 1079 and ih > 1079 and ih*iw > 1199999 \
              and not ' comic ' in j[0]['tags'] and ir != "e" :
        if downl == 1 or downl == 3 : # original
          l_ext = j[0]['file_url'].rpartition('.')[2]
          p = requests.get(j[0]['file_url'], headers=headerrs)
          with open('GLB'+ir+'\gelbooru.com - ' + str(i) + '.' + l_ext, 'wb') as outfile:
            outfile.write(p.content)
          print(str(i) + ";GOT_FILE;" + ir + " (" + str(iw) + "x" + str(ih) + ")", file=sys.stderr, flush=True)
          time.sleep(2)
        if downl == 2 or downl == 3 :  # sample
          p = requests.get('https://img2.gelbooru.com/samples/' + j[0]['directory'] + '/sample_' + j[0]['image'], headers=headerrs)
          with open('GLS'+ir+'\gelbooru.com - ' + str(i) + '.jpg', 'wb') as outfile:
            outfile.write(p.content)
          print(str(i) + ";GOT_SAMPLE;" + ir + " (" + str(iw) + "x" + str(ih) + ")", file=sys.stderr, flush=True)
          time.sleep(2)
      else:
        if downl > 0:
          print(str(i) + ";SKIPPED;" + ir + " (" + str(iw) + "x" + str(ih) + ")", file=sys.stderr, flush=True)
    else:
      print(str(i) + ";NOPAGE", file=sys.stderr, flush=True)
      time.sleep(5)
  except:
    print(str(i) + ";FAIL;" + traceback.format_exc().replace("\n",""),file=sys.stderr,flush=True)
    time.sleep(5)
  time.sleep(1)
