import os
import keras
import pydload
from keras_retinanet import models
from keras_retinanet.utils.image import preprocess_image, resize_image
from keras_retinanet.utils.visualization import draw_box, draw_caption
from keras_retinanet.utils.colors import label_color
import cv2
import numpy as np
import logging
import warnings
import sys
from PIL import Image as pil_image

def read_image_bgr(path):
    if isinstance(path, str):
        image = np.ascontiguousarray(pil_image.open(path).convert("RGB"))
    else:
        path = cv2.cvtColor(path, cv2.COLOR_BGR2RGB)
        image = np.ascontiguousarray(pil_image.fromarray(path))
    return image[:, :, ::-1]

def dummy(x):
    return x

FILE_URLS = {
    "default": {
        "checkpoint": "https://github.com/notAI-tech/NudeNet/releases/download/v0/detector_v2_default_checkpoint",
        "classes": "https://github.com/notAI-tech/NudeNet/releases/download/v0/detector_v2_default_classes",
    },
    "base": {
        "checkpoint": "https://github.com/notAI-tech/NudeNet/releases/download/v0/detector_v2_base_checkpoint",
        "classes": "https://github.com/notAI-tech/NudeNet/releases/download/v0/detector_v2_base_classes",
    },
}

class Detector:
    detection_model = None
    classes = None

    def __init__(self, model_name="default"):
        checkpoint_url = FILE_URLS[model_name]["checkpoint"]
        classes_url = FILE_URLS[model_name]["classes"]
        home = os.path.expanduser("~")
        model_folder = os.path.join(home, f".NudeNet/{model_name}")
        if not os.path.exists(model_folder):
            os.makedirs(model_folder)
        checkpoint_path = os.path.join(model_folder, "checkpoint")
        classes_path = os.path.join(model_folder, "classes")
        if not os.path.exists(checkpoint_path):
            print("Downloading the checkpoint to", checkpoint_path)
            pydload.dload(checkpoint_url, save_to_path=checkpoint_path, max_time=None)
        if not os.path.exists(classes_path):
            print("Downloading the classes list to", classes_path)
            pydload.dload(classes_url, save_to_path=classes_path, max_time=None)
        self.detection_model = models.load_model( checkpoint_path, backbone_name="resnet50" )
        self.classes = [ c.strip() for c in open(classes_path).readlines() if c.strip() ]

    def detect(self, img_path, min_prob=0.35):
        image = read_image_bgr(img_path)
        image = preprocess_image(image)
        image, scale = resize_image(image)
        boxes, scores, labels = self.detection_model.predict_on_batch( np.expand_dims(image, axis=0) )
        boxes /= scale
        processed_boxes = []
        for box, score, label in zip(boxes[0], scores[0], labels[0]):
            if score < min_prob:
                continue
            box = box.astype(int).tolist()
            label = self.classes[label]
            processed_boxes.append({"box": box, "score": score, "label": label})
        return processed_boxes

    def censor(self, img_path, out_path ):
        image = cv2.imread(img_path)
        ih, iw, _ = image.shape
        boxes = self.detect(img_path)
#        print(boxes)
        i = 0
        for box in boxes:
            if 'FACE' in box['label'] : colr=(0, 255, 0)
            if 'EXPOSED' in box['label'] : colr=(0, 0, 255)
            if 'COVERED' in box['label'] : colr=(255, 0, 0)
            lnw = int(min(ih, iw)/48*(box['score']-0.3))
            print(img_path + ';' + box['label'] + ';' + str(round(box['score'],3)) + ';' + str(box['box'][0]) + ';' + str(box['box'][1]) + ';' + str(box['box'][2] - box['box'][0])+ ';' + str(box['box'][3] - box['box'][1]), flush = True )
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

if __name__ == "__main__":
    m = Detector()
    for fname in os.listdir(sys.argv[1]):
       m.censor(sys.argv[1]+fname,sys.argv[2]+fname )
