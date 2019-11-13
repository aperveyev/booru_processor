## BOORU-CHARS OPEN DATASET:
- открытый набор данных о качественных арт-изображениях персонажей аниме, игр, мультипликации и т.п.
- состоит из мета-данных (ссылок на booru-первоисточник, смысловых тегов, статистических показателей,
  результатов применения алгоритмов на изображениях) и thumbnail-изображений 512x512px (дополнены черными полями)
- содержит описание используемых методов, скриптов, программ и их параметров для единообразного применения
- большие наборы распространяются через torrent, код, описание и компактные данные хостятся на Github

**ЦЕЛИ ПРОЕКТА:**
- систематизация мета-данных как таковых в т.ч. координация между их источниками 
  (например, соотнесение персонажей myanimelist и соответствующих тегов Safebooru)
- быть основой для нетривиального анализа накопленных мета-данных: SQL-запросы, data mining [clustering, classification]
  (например - рейтинг популярности авторов для портретных изображений персонажей некоего фендома)
- быть основой для применения Machine Learning & Neural Networks алгоритмов к не-фотографическим изображениям [их "иконкам"]
  (например, создание обучающих и проверочных выборок с использованием мета-данных,
   сегментирование изображений по композиции, "весовая функция визуального качества" и т.п.)


**ВНЕШНИЕ ПРОГРАММЫ (под Windows) И ДАТАСЕТЫ:**
- скачивание Grabber https://github.com/Bionus/imgbrd-grabber
- разбивка по пропорциям Dimensions2Folders https://www.dcmembers.com/skwire/download/dimensions-2-folders/
- просмотр и простые преобразования Fast stone image viewer https://www.faststone.org/FSViewerDetail.htm
- дедубликация AntiDupl.NET https://github.com/ermig1979/AntiDupl
- ExifTool https://www.sno.phy.queensu.ca/~phil/exiftool/
- ImageMagick https://imagemagick.org/script/download.php
- Python (3.8) https://www.python.org/


### OBSOLETE ENGLISH DESCRIPTION: code and texts for Booru (anime style) image processing

Inspired by dataset : https://www.gwern.net/Danbooru2018
which can be used for creation of trained models for services like http://kanotype.iptime.org:8003/deepdanbooru/
and local use https://www.reddit.com/r/MachineLearning/comments/akbc11/p_tag_estimation_for_animestyle_girl_image/

At a time my tasks are:
- to develop image set segmentation methods and tools
- to analyze high level character (so - copyrights) tags usage

with strategic goal to create a usable tool (including model) for:
- general image composition classification
- anime characters recognition
- image attractiveness (visual quality) prediction
