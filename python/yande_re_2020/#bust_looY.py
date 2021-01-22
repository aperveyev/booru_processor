import cv2
import sys
import numpy
import imutils
import os.path

def detect(filename, cascade_file = "lbpcascade_animeface.xml"):
    if not os.path.isfile(cascade_file): raise RuntimeError("%s: not found" % cascade_file)
    cascade = cv2.CascadeClassifier(cascade_file)
    image = cv2.imread(filename, cv2.IMREAD_COLOR)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.equalizeHist(gray)
    ih, iw, _ = image.shape
    imrect = image.copy()

    faces = cascade.detectMultiScale(gray, scaleFactor = 1.02, minNeighbors = 5, minSize = ( int(min(ih,iw,1024)/6), int(min(ih,iw,1024)/6)), maxSize = (int(max(ih,iw)/1.5), int(max(ih,iw)/1.5)))
    for (x, y, w, h) in faces:
# the most tricky is to set proper margins
        crop_img = image[max(0,int(y-0.35*h)): int(y+1.6*h), max(0,int(x-0.15*w)): min(iw,int(x+1.15*w))]
        cv2.imwrite(sys.argv[2]+"_A_"+str(x)+".jpg", crop_img)
        cv2.rectangle(imrect, (x, y), (x + w, y + h), (0, 0, 255), max(int(min(ih,iw)/256),6) )
#        cv2.imwrite(sys.argv[2]+".jpg", imrect)
        print("'" + filename + "';A;" + str(x) + ";" + str(y) + ";" + str(w) + ";" + str(h) , flush=True )
# there was a case with several algorithms combined, letter A in file name and output file is an "algorithm mark"

detect(sys.argv[1])
