import requests
import time

for i in range(2720000, 2720020):
	try:
		time.sleep(1)
		r = requests.get('https://safebooru.org/index.php?page=dapi&s=post&q=index&id='+str(i)+'&json=1')
		j = r.json()
		print(str(j[0]['id'])+';'+str(j[0]['width'])+';'+str(j[0]['height'])+';'+str(j[0]['score'])+';'+str(j[0]['change'])+';'+j[0]['tags'], flush=True);
		if int(j[0]['width']) > 1199 and int(j[0]['height']) > 1199 and not ' comic ' in j[0]['tags'] :
			p = requests.get('https://safebooru.org//images/'+j[0]['directory']+'/'+j[0]['image'])
			with open('safebooru.org - '+str(j[0]['id'])+' - '+j[0]['image'], 'wb') as outfile:
				outfile.write(p.content)
	except:
		print(str(i)+';FAIL', flush=True )
		time.sleep(1)
		pass

#"height":1000,"width":707
#"change":1576483240,
#"score":0,
#"tags":"1girl bangs black_eyes black_legwear black_panties blush breasts clenched_teeth 

# https://konachan.com/post.json?tags=id:248816
