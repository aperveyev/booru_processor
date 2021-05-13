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