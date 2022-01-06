import numpy as np
import cv2
import sys
import glob
import os
from pathlib import Path
#from matplotlib import pyplot as plt

#  Felzenszwalb et al.
def non_max_suppression(boxes, overlapThresh=0.5):
	# if there are no boxes, return an empty list
	if len(boxes) == 0:
		return []
	# initialize the list of picked indexes
	pick = []
	# grab the coordinates of the bounding boxes
	x1 = boxes[:,0]
	y1 = boxes[:,1]
	x2 = boxes[:,2]
	y2 = boxes[:,3]
	# compute the area of the bounding boxes and sort the bounding
	# boxes by the bottom-right y-coordinate of the bounding box
	area = (x2 - x1 + 1) * (y2 - y1 + 1)
	idxs = np.argsort(y2)
	# keep looping while some indexes still remain in the indexes
	# list
	while len(idxs) > 0:
		# grab the last index in the indexes list, add the index
		# value to the list of picked indexes, then initialize
		# the suppression list (i.e. indexes that will be deleted)
		# using the last index
		last = len(idxs) - 1
		i = idxs[last]
		pick.append(i)
		suppress = [last]
		# loop over all indexes in the indexes list
		for pos in range(0, last):
			# grab the current index
			j = idxs[pos]
			# find the largest (x, y) coordinates for the start of
			# the bounding box and the smallest (x, y) coordinates
			# for the end of the bounding box
			xx1 = max(x1[i], x1[j])
			yy1 = max(y1[i], y1[j])
			xx2 = min(x2[i], x2[j])
			yy2 = min(y2[i], y2[j])
			# compute the width and height of the bounding box
			w = max(0, xx2 - xx1 + 1)
			h = max(0, yy2 - yy1 + 1)
			# compute the ratio of overlap between the computed
			# bounding box and the bounding box in the area list
			overlap = float(w * h) / area[j]
			# if there is sufficient overlap, suppress the
			# current bounding box
			if overlap > overlapThresh:
				suppress.append(pos)
		# delete all indexes from the index list that are in the
		# suppression list
		idxs = np.delete(idxs, suppress)
	# return only the bounding boxes that were picked
	return boxes[pick]


def predictions(prob_score, geo):
	(numR, numC) = prob_score.shape[2:4]
	boxes = []
	confidence_val = []
	# loop over rows
	for y in range(0, numR):
		scoresData = prob_score[0, 0, y]
		x0 = geo[0, 0, y]
		x1 = geo[0, 1, y]
		x2 = geo[0, 2, y]
		x3 = geo[0, 3, y]
		anglesData = geo[0, 4, y]
		# loop over the number of columns
		for i in range(0, numC):
			if scoresData[i] < 0.9:
				continue
			(offX, offY) = (i * 4.0, y * 4.0)
			# extracting the rotation angle for the prediction and computing the sine and cosine
			angle = anglesData[i]
			cos = np.cos(angle)
			sin = np.sin(angle)
			# using the geo volume to get the dimensions of the bounding box
			h = x0[i] + x2[i]
			w = x1[i] + x3[i]
			# compute start and end for the text pred bbox
			endX = int(offX + (cos * x1[i]) + (sin * x2[i]))
			endY = int(offY - (sin * x1[i]) + (cos * x2[i]))
			startX = int(endX - w)
			startY = int(endY - h)
			boxes.append((startX, startY, endX, endY))
			confidence_val.append(scoresData[i])
	# return bounding boxes and associated confidence_val
	return (boxes, confidence_val)

if __name__ == "__main__":
  net = cv2.dnn.readNet("uul3_frozen_east_text_detection.pb")
  layerNames = ["feature_fusion/Conv_7/Sigmoid","feature_fusion/concat_3"]
  files = sorted(glob.glob(sys.argv[1]))
  for ff in files:
    image = cv2.imread(ff)
    orig = image.copy()
    (origH, origW) = image.shape[:2]
# 1280
    (newW, newH) = (1280, 1280)
    rW = origW / float(newW)
    rH = origH / float(newH)
    image = cv2.resize(image, (newW, newH))
    (H, W) = image.shape[:2]
    blob = cv2.dnn.blobFromImage(image, 1.0, (W, H),(123.68, 116.78, 103.94), swapRB=True, crop=False)
    net.setInput(blob)
    (scores, geometry) = net.forward(layerNames)
    (boxes, confidence_val) = predictions(scores, geometry)
    boxes = non_max_suppression(np.array(boxes))
    ss=0
    nn=0
    aa=0
    ii=origH*origW
    for (startX, startY, endX, endY) in boxes:
      startX = int(startX * rW)
      startY = int(startY * rH)
      endX = int(endX * rW)
      endY = int(endY * rH)
      ss=ss+(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)>aa:
        aa=(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)<ii:
        ii=(endY-startY)*(endX-startX)
      nn=nn+1
      cv2.rectangle(orig, (startX, startY), (endX, endY), (0, 255, 0), 4)
# 640
    image = orig.copy()
    (newW, newH) = (640, 640)
    rW = origW / float(newW)
    rH = origH / float(newH)
    image = cv2.resize(image, (newW, newH))
    (H, W) = image.shape[:2]
    blob = cv2.dnn.blobFromImage(image, 1.0, (W, H),(123.68, 116.78, 103.94), swapRB=True, crop=False)
    net.setInput(blob)
    (scores, geometry) = net.forward(layerNames)
    (boxes, confidence_val) = predictions(scores, geometry)
    boxes = non_max_suppression(np.array(boxes))
    ss640=0
    nn640=0
    aa640=0
    ii640=origH*origW
    for (startX, startY, endX, endY) in boxes:
      startX = int(startX * rW)
      startY = int(startY * rH)
      endX = int(endX * rW)
      endY = int(endY * rH)
      ss640=ss640+(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)>aa640:
        aa640=(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)<ii640:
        ii640=(endY-startY)*(endX-startX)
      nn640=nn640+1
      cv2.rectangle(orig, (startX, startY), (endX, endY), (255, 0, 0), 4)
# 320
    image = orig.copy()
    (newW, newH) = (320, 320)
    rW = origW / float(newW)
    rH = origH / float(newH)
    image = cv2.resize(image, (newW, newH))
    (H, W) = image.shape[:2]
    blob = cv2.dnn.blobFromImage(image, 1.0, (W, H),(123.68, 116.78, 103.94), swapRB=True, crop=False)
    net.setInput(blob)
    (scores, geometry) = net.forward(layerNames)
    (boxes, confidence_val) = predictions(scores, geometry)
    boxes = non_max_suppression(np.array(boxes))
    ss320=0
    nn320=0
    aa320=0
    ii320=origH*origW
    for (startX, startY, endX, endY) in boxes:
      startX = int(startX * rW)
      startY = int(startY * rH)
      endX = int(endX * rW)
      endY = int(endY * rH)
      ss320=ss320+(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)>aa320:
        aa320=(endY-startY)*(endX-startX)
      if (endY-startY)*(endX-startX)<ii320:
        ii320=(endY-startY)*(endX-startX)
      nn320=nn320+1
      cv2.rectangle(orig, (startX, startY), (endX, endY), (0, 0, 255), 4)
# FINAL
    uu=int(ss/(origH*origW)*200+0.66*nn)
    uu640=int(ss640/(origH*origW)*200+nn640)
    uu320=int(ss320/(origH*origW)*200+1.5*nn320)
# FNAME;S1280;N1280;I1280;A1280;K1280;S640;N640;I640;A640;K640;S320;N320;I320;A320;K320
    ww='"'+ff+'";'+str(round(ss/(origH*origW),3))+';'+str(nn)+';'+str(round(ii/(origH*origW),4))+';'+str(round(aa/(origH*origW),4))+';'+str(uu) \
             +';'+str(round(ss640/(origH*origW),3))+';'+str(nn640)+';'+str(round(ii640/(origH*origW),4))+';'+str(round(aa640/(origH*origW),4))+';'+str(uu640) \
             +';'+str(round(ss320/(origH*origW),3))+';'+str(nn320)+';'+str(round(ii320/(origH*origW),4))+';'+str(round(aa320/(origH*origW),4))+';'+str(uu320)
    print(ww)
    with open(sys.argv[2], 'a') as tt:
      tt.write(('%s'+'\n')%(ww))
#    if uu>24 or uu640>18 or uu320>12 :
#      imgplot = plt.imshow(orig)
#      plt.title('['+str(uu)+'+'+str(uu640)+'+'+str(uu320)+'] '+ff.rpartition('\\')[2].rpartition(' - ')[0])
#      plt.show()
