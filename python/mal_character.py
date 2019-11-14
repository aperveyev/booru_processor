# pip install python3-mal==0.2.19

import time

from pprint import pprint
from myanimelist.session import Session

s = Session()

for i in range(40500, 80000):
    try:
        chrt = s.character(i)
        chrt.load()
#        print(chrt.__dict__)
        print( str(i) + ";" + chrt.name + ";" + str(chrt.num_favorites) + ";" , end = '' )
        print( chrt.animeography , flush=True )
        time.sleep(5)
    except:
        print( str(i) + " FAIL ", flush=True )
        time.sleep(5)
        pass

exit()

# pprint(chrt.animeography)
