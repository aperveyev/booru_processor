import cv2
import sys
import os.path

def detect(filename, cascade_file = "lbpcascade_animeface.xml"):
    if not os.path.isfile(cascade_file): raise RuntimeError("%s: not found" % cascade_file)
    cascade = cv2.CascadeClassifier(cascade_file)
    image = cv2.imread(filename, cv2.IMREAD_COLOR)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.equalizeHist(gray)

    faces = cascade.detectMultiScale(gray, scaleFactor = 1.2, minNeighbors = 7, minSize = (48, 48), maxSize = (240, 240))
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 0, 255), 6)
        print("'" + filename + "';7;" + str(x) + ";" + str(y) + ";" + str(w) + ";" + str(h) , flush=True )

    faces = cascade.detectMultiScale(gray, scaleFactor = 1.1, minNeighbors = 4, minSize = (32, 32), maxSize = (320, 320))
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 4)
        print("'" + filename + "';4;" + str(x) + ";" + str(y) + ";" + str(w) + ";" + str(h) , flush=True )

    faces = cascade.detectMultiScale(gray, scaleFactor = 1.05, minNeighbors = 2, minSize = (24, 24), maxSize = (400, 400))
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x + w, y + h), (255, 0, 0), 2)
        print("'" + filename + "';2;" + str(x) + ";" + str(y) + ";" + str(w) + ";" + str(h) , flush=True )

#    cv2.imwrite(sys.argv[2], image)

detect(sys.argv[1])
