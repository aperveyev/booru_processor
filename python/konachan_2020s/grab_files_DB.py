from bs4 import BeautifulSoup as bs
import requests
import time
import sys
import traceback
import cx_Oracle

myconnection = cx_Oracle.connect('usr','pwd','db')
mycursor = myconnection.cursor()
mycursor.execute(" select id, fname, d_url, rating, d_src from kona_rip where done=0 order by id desc fetch first 10000 rows only ")
insconnection = cx_Oracle.connect('usr','pwd','db')
inssql = ("update kona_rip set done=1 where id = :v_id ")
errsql = ("update kona_rip set done=-1 where id = :v_id ")

for (cur) in mycursor:
  try:
    headerrs = {'User-agent': 'Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0'}
    p = requests.get(cur[2], headers=headerrs)
# you MUST create 10 directories KONA[S/Q][F/FO/S/J/JO] for possible "rating + d_src" combos OR simplify dir structure
    with open('KONA'+cur[3]+cur[4]+'\\' + cur[1], 'wb') as outfile:
      outfile.write(p.content)
    with insconnection.cursor() as inscursor:
      inscursor.execute(inssql, [cur[0]])
      insconnection.commit()
    print(str(cur[0])+' >> '+cur[1], flush=True)
  except:
    print(str(cur[0])+' !! '+traceback.format_exc().replace('\n','')+'\n',file=sys.stderr,flush=True)
    with insconnection.cursor() as inscursor:
      inscursor.execute(errsql, [cur[0]])
      insconnection.commit()
  time.sleep(3)

myconnection.close
insconnection.close
