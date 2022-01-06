import sys
import glob
import keras_craft

detector = keras_craft.Detector()
files = sorted(glob.glob(sys.argv[1]))
dfl = open(sys.argv[2],'a')

for ff in files:
  all_boxes = detector.detect( ff )
  i=0
  n=0
  for bx in all_boxes:
    dfl.write(ff+'\t'+ str(n) + '\t' + str(int((bx[1][0]+bx[0][0])/2)) + '\t' + str(int((bx[3][1]+bx[0][1])/2)) + '\t' + \
                                       str(int(bx[1][0]-bx[0][0]))     + '\t' + str(int(bx[3][1]-bx[0][1])) + '\n' )
    dfl.flush()
    i=i+int(abs(bx[1][0]-bx[0][0])*abs(bx[3][1]-bx[1][1]))
    n=n+1
  print(ff+'\t'+str(i)+'\t'+str(n), flush=True)

# write details to file, totals - to stdout
