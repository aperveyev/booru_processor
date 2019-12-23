#import os
#import urllib
import requests
import time

for i in range(3600000, 3700000):
	try:
		time.sleep(1)
		r = requests.get('https://danbooru.donmai.us/posts/'+str(i)+'.json')
		j = r.json()
		f = j['tag_string_copyright']+' ~ '+j['tag_string_character']
		f2 = f.replace('/','_')[:120]
		f2 = f2.replace(':','_')
		f2 = f2.replace('?','_')
		print(str(j['id'])+';'+j['rating']+';'+str(j['fav_count'])+';'+str(j['score'])+';'+str(j['image_width'])+';'+str(j['image_height'])+';'+j['created_at']+';"'+j['tag_string_copyright']+'";"'+j['tag_string_character']+'";"'+j['tag_string_artist']+'";"'+j['tag_string_general']+'"', flush=True);
		if j['rating'] == 's' and int(j['image_width']) > 1199 and int(j['image_height']) > 1199 and not ' comic ' in j['tag_string_general'] :
			p = requests.get(j['file_url'])
			with open('DANB/danbooru.donmai.us - '+str(j['id'])+' - '+f2+' ('+j['tag_string_artist']+').'+j['file_ext'], 'wb') as outfile:
				outfile.write(p.content)
			time.sleep(2)
		if j['rating'] == 'q' and int(j['image_width']) > 1199 and int(j['image_height']) > 1199 and not ' comic ' in j['tag_string_general'] :
			p = requests.get(j['file_url'])
			with open('DANQ/danbooru.donmai.us - '+str(j['id'])+' - '+f2+' ('+j['tag_string_artist']+').'+j['file_ext'], 'wb') as outfile:
				outfile.write(p.content)
			time.sleep(2)
	except:
		print(str(i)+';FAIL', flush=True )
		time.sleep(3)
		pass
