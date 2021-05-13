Помимо визуального summary персонажного anime/CG/game арта, BOORU CHARS dataset может быть использован для:
- тренировки нейронных сетей для угадывания тегов (Deep Danbooru - своими руками, на высококачественной основе)
  и/или распознавания ключевых объектов рисованных изображений
- разработки алгоритмов классификации масштаба и композиции рисованной сцены на основе ключевых объектов
* например, исходя из размера и положения лиц определить масштаб сцены, классифицировать позы и взаимодействие персонажей

Я использовал детектор notAI-tech NudeNet (github.com/notAI-tech/NudeNet) на основе tensorflow, который оказался приемлем 
по ресурсам (на видеокарте - так вообще шикарно) и не слишком требователен к python-нубам (м-да ... все относительно)

# PYTHON
# опуская чистые копипасты из примера
...
class Detector:
# и почти не затрагивая фрагмент кода с вызовом детектора
...
    def detect(self, img_path, min_prob=0.25):
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
# потребовалось переделать выдачу данных, включая отрисовку обнаруженных объектов на картинке
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
# и собственно циклический вызов
if __name__ == "__main__":
    m = Detector()
    for fname in os.listdir(sys.argv[1]):
       m.censor(sys.argv[1]+fname,sys.argv[2]+fname )

Детектор я применил к нескольким томам портретно ориентированных картинок 2020-3x4 и 2020-1x2, в результате сформировался 
лог BCN_detect.tsv из 200.887 "обнаружений" (изначально через ";" но перед релизом я немного потоптался в нем Excel), содержащий 
  FNAME; класс обекта OBJ; вероятность PROB и координаты X;Y;W;H 
а также картинки, "обрисованные" квадратиками и подписями, где использованы салатовый, красный и синий цвета (см. код выше)

Дальше пришлось (самостоятельно, запихнув все в БД):
- реализовать некоторое подобие NMS (Non Maximum Suppression) чтобы не морочиться с (почти) накладывающимися обнаружениями
- изваять алгоритм поиска (в полярных координатах с центром в середине верхней грани картинки) частей тела, стартуя с лица 
* сначала ARMPITS и BREASTS (приемлемых размеров и расположения по отношению к лицу)
* далее BELLY (с учетом предыдущих обнаружений)
* затем GENITALIA и ANUS (опять же учитывая все предыдущие находки)
* и в завершение FEETS (с которыми сложнее всего в силу удаленности от прочих частей тела и потенциальным изменением вектора)
В данном релизе реализации алгоритма не содержится (там дремучий PL/SQL), есть шанс что она со временем появится на Git.

Полученные привязки ассоциировались с конкретным лицом и приведены в листинге BCN_lineup.tsv из 78.184 связей :
'FNAME' - имя файла
'FACE_ID' - уникальный идентификатор лица в пределах картинки
'PROB','X','Y','W','H' - прочие данные по лицу, повторяются в необходимом числе строк
'OBJ' - тип привязанного объекта в упрощенной кодировке ('BRST','ARMP','BELL' и т.п.)
'OPROB','OX','OY','OW','OH' - прочие данные по привязанному объекту

На основе листинга следующая программулина накладывала на уже обрисованную картинку детектированные связи,
"перекрашивая" опорное лицо и связанные с ним объекты, а также соединяя их с лицом центр-к-центру
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

В состав релиза включены два архива - 2020-1x2_O.zip и 2020-3x4_O.zip - с ~4000 примерами с разным соотношением сторон,
куда были волюнтаристски отобраны картинки, содержащие:
- по 5 и более обнаруженных связей (потенциально сложные сцены с 6+ связанных объектов)
- содержащие EXPOSED объекты с высокими вероятностями (интересно ведь, что накопал NudeNet уже после визуальной очистки)
Примеров весьма мало по сравнению с числом обработанных картинок (77.000+) чтобы не раздувать и без того увесистый релиз.

Результаты сложно назвать впечатляющими с учетом того, что красивые и интересные примеры составляют десяток-второй процентов
от общего числа обработанных картинок. На прочих - или объектов мало (это чаще всего, NudeNet есть куда улучшаться),
или связываются они плохо (а вот это уже моя забота).

Чтобы продолжить решение изначальной задачи "классификации масштаба и композиции сцены ...", мне еще потребуется:
- адаптировать алгоритм связывания (отдельную версию, скорее всего) под "горизонтальные" картинки
- потратить немалое количество киловатт*часов на наработку представительной (100.000+ ?) выборки картинок с хорошими обнаружениями
- стряхнуть пыль с Oracle DBMS_DATA_MINING или освоить нечто эквивалентное (кластеризация, attribute importance) на python
Дорогу осилит идущий.