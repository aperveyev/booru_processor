BOORU CHARS dataset can be used for:
- NN training for tag detection (as Deep Danbooru and better) and/or object detection
- scene scale and composition classification based on key objects (e.g. face) detected

I used notAI-tech NudeNet detector (github.com/notAI-tech/NudeNet) 
# rewrote logging and painting of detected objects
    def censor(self, img_path, out_path ):
        image = cv2.imread(img_path)
        ih, iw, _ = image.shape
        boxes = self.detect(img_path)
        i = 0
        for box in boxes:
            if 'FACE' in box['label'] : colr=(0, 255, 0)
            if 'EXPOSED' in box['label'] : colr=(0, 0, 255)
            if 'COVERED' in box['label'] : colr=(255, 0, 0)
            lnw = int(min(ih, iw)/48*(box['score']-0.3))
            print(img_path+';'+box['label']+';'+str(round(box['score'],2))+';'+str(box['box'][0])+';'\
                  +str(box['box'][1])+';'+str(box['box'][2]-box['box'][0])+';'+str(box['box'][3]-box['box'][1]),flush = True)
            if 'FACE' in box['label'] :
               x = box['box'][0]
               y = box['box'][1]
               w = box['box'][2] - box['box'][0]
               h = box['box'][3] - box['box'][1]
               crop_img = image[max(0,int(y-0.6*h)): int(y+1.1*h), max(0,int(x-0.35*w)): min(iw,int(x+1.35*w))]
               i = 1
            image = cv2.rectangle(
                image, (box['box'][0], box['box'][1]), (box['box'][2], box['box'][3]), colr, max(lnw, 4)
            )
            cv2.putText(image, box['label'] + ' ' + str(round(box['score'],2)),
                        (box['box'][0], box['box'][1]-int(ih*0.005)), cv2.FONT_HERSHEY_SIMPLEX,
                        ih*0.0004,
                        (0,0,0), 2, 2)
        cv2.imwrite(out_path, image)
# main loop
if __name__ == "__main__":
    m = Detector()
    for fname in os.listdir(sys.argv[1]):
       m.censor(sys.argv[1]+fname,sys.argv[2]+fname )

With volumes 2020-3x4 and 2020-1x2 processed I got 200.887 detections listed in BCN_detect.tsv  
  FNAME; class OBJ; probability PROB coordinates X;Y;W;H 
and also copies of sample pictures with objects shown.

Then I used DB (PL/SQL stored proc) for
- Non Maximum Suppression
- assembling algorithm (in polar coordinates), started from FACE which
* find ARMPITS & BREASTS (with suitable size and position)
* then BELLY (using all findings above)
* then GENITALIA & ANUS (again using findings available)
* and then FEETS (most trucky because of distance and possible vector change)

All findings associated with faces listed in BCN_lineup.tsv (78.184 rows) where:
'FNAME' - file name
'FACE_ID' - face hash inside file
'PROB','X','Y','W','H' - face parameters
'OBJ' - assembled object type simplified ('BRST','ARMP','BELL' etc)
'OPROB','OX','OY','OW','OH' - object parameters

Using listing I can recolor related object and join it center-to-center using code
# PYTHON
import cv2
import pandas as pd
prev_fname = 'NONE'
prev_oname = 'NONE'
prev_hashid = 0
data = pd.read_csv('in.lst',sep=';', decimal=',',index_col='IDX')
#"IDX";"FNAME";"HASHID";"PROB";"X";"Y";"W";"H";"OBJ";"OPROB";"OX";"OY";"OW";"OH";"ONAME"
for i, row in data.iterrows():
   print(str(i)+' '+row['FNAME'])
   if row['FNAME']!=prev_fname:
      image = cv2.imread(row['FNAME'])
      ih, iw, _ = image.shape
      print(str(i) + ' RD ' + row['FNAME'])
      if row['ONAME']!=prev_oname and prev_oname!='NONE':
         cv2.imwrite(prev_oname, prev_image)
         print(str(i)+' WR '+prev_oname)
      prev_oname=row['ONAME']
      prev_fname=row['FNAME']
      prev_image = image
   lnw = int(min(ih, iw) / 48 * (row['PROB'] - 0.3))
   prev_image = cv2.rectangle( prev_image, (row['X'], row['Y']),\
                               (row['X']+row['W'], row['Y']+row['H']), (255,255,255), max(lnw, 4) )
   lnwr = int(min(ih, iw) / 48 * (row['OPROB'] - 0.3))
   if row['OBJ']=='BRST':
      colr = (255, 153, 0) # light blue
      lnw = int(lnwr*0.66)
   if row['OBJ'] in ('BELL','XXXX'):
      colr = (0, 153, 255) # orange
      lnw = int(lnwr*0.66)
   if row['OBJ']=='ARMP':
      colr = (153,0,153) # violet
      lnw = int(lnwr*0.33)
   if row['OBJ']=='FEET':
      colr = (51, 153, 102) # green
      lnw = int(lnwr*0.33)
   prev_image = cv2.line( prev_image, (int(row['X']+row['W']/2), int(row['Y']+row['H']/2)),\
                          (int(row['OX']+row['OW']/2), int(row['OY']+row['OH']/2)),colr, max(lnw, 4) )
   prev_image = cv2.rectangle( prev_image, (row['OX'], row['OY']),\
                               (row['OX']+row['OW'], row['OY']+row['OH']), colr, max(lnwr, 4) )
cv2.imwrite(prev_oname, prev_image)
print(str(i) + ' WR ' + prev_oname)

You can find ~4000 selected examples in archives 2020-1x2_O.zip and 2020-3x4_O.zip with:
- 5 or more relations (good complex detection scenarios)
- some EXPOSED objects with high probabilities (possible fails in manual cleanup)
Much more examples omitted because on release size.

Much more efforts has to be done for NudeNet (better detection) and for me (better assembling).

Initial task "scene scale and composition classification" will require
- much more (100.000+ ?) good complex detections 
- data mining (attribute importance, clustering) with Oracle DBMS_DATA_MINING or python equivalent
