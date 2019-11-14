# pip install python3-mal==0.2.19

import time
from myanimelist.session import Session

s = Session()

for i in range(40000,39996,-1):
    try:
        aa = s.anime(i)
        aa.load()
#        pprint(aa.__dict__)
        print( str(i) + ";" + aa.title + ";" + aa.type + ";" + str(aa.episodes) + ";" + str(aa.favorites) + ";" + str(aa.genres) + ";" + str(aa.members) + ";" + str(aa.popularity) + ";" + aa.premiered + ";" + str(aa.rank) + ";" + str(aa.rating) + ";" + str(aa.related) , flush=True )
        time.sleep(5)
    except:
        print( str(i) + " ERROR " )
        time.sleep(5)
        pass

exit()

