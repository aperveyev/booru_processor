#import os
#import urllib
import requests
import time

with open('danb_glist.lst') as fp:
	for cnt, line in enumerate(fp):
		i = int(line)
		try:
			r = requests.get('https://danbooru.donmai.us/posts/'+str(i)+'.json')
			j = r.json()
			f = j['tag_string_copyright']+' ~ '+j['tag_string_character']
			f2 = f.replace('/','_')[:120]
			f2 = f2.replace(':','_')
			f2 = f2.replace('?','_')
			print(str(j['id'])+';'+j['rating']+';'+str(j['fav_count'])+';'+str(j['score'])+';'+str(j['image_width'])+';'+str(j['image_height'])+';'+j['created_at']+';"'+j['tag_string_copyright']+'";"'+j['tag_string_character']+'";"'+j['tag_string_artist']+'";"'+j['tag_string_general']+'"', flush=True);
			p = requests.get(j['file_url'])
			with open('DAN_LST/danbooru.donmai.us - '+str(j['id'])+' - '+f2+' ('+j['tag_string_artist']+').'+j['file_ext'], 'wb') as outfile:
				outfile.write(p.content)
			time.sleep(3)
		except:
			print(str(i)+';FAIL;'+str(cnt), flush=True )
			time.sleep(3)
			pass
