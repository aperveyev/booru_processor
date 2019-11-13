# BOORU-CHARS OPEN DATASET:
- открытый набор данных о качественных арт-изображениях персонажей аниме, игр, мультипликации и т.п.
- состоит из мета-данных (ссылок на booru-первоисточник, смысловых тегов, статистических показателей, 
  результатов применения алгоритмов на изображениях)
- также включает "иконки" изображений 512x512px (дополнены черными полями) - В ДАННЫЙ РЕЛИЗ НЕ ВХОДЯТ, здесь "оригиналы"
- содержит описание используемых методов, скриптов, программ и их параметров для единообразного применения (github)


ЦЕЛИ ПРОЕКТА:
- систематизация мета-данных как таковых в т.ч. координация между их источниками 
  (например, соотнесение персонажей myanimelist и соответствующих тегов Safebooru)
- основа для нетривиального анализа накопленных мета-данных: SQL-запросы, data mining [clustering,classification]
  (например - рейтинг популярности авторов для портретных изображений персонажей некоего фендома)
- основа для применения Machine Learning & Neural Networks алгоритмов к не-фотографическим изображениям [их "иконкам"]
  (например, создание обучающих и проверочных выборок с использованием мета-данных,
   сегментирование изображений по композиции, "весовая функция визуального качества" и т.п.)


СКРИПТЫ И ССЫЛКИ НА СОФТ 
- поддерживаются на гитхабе https://github.com/aperveyev/booru_processor
- там же накапливаются ссылки на используемые внешние датасеты (в основном Kaggle) и тулзы (в основном Github)


СОСТАВ МЕТАДАННЫХ [на 2019.12] включенных в релиз:
- соотнесенные теги персонажей/копирайтов Danbooru и персонажей/аниме Myanimelist с их группировкой по "франшизам"
- ExifTool + ImageMagick показатели изображений этого релиза ("иконки" в релиз не включены, скрипты на хабе)
- ExifTool + ImageMagick показатели "иконок" датасета Danbooru-2018 (https://rutracker.org/forum/viewtopic.php?t=5777178)
? информация по тегам постов Danbooru и (отдельно) Safebooru (SQL унификация датасетов с Kaggle)
? информация по соотнесению персонажей/аниме между собой Myanimelist (SQL трансформация датасетов с Kaggle + моих докачек)
- readme по вышеупомянутым структурам и SQL DDL для создания базы данных для их загрузки

Grabber
AntiDupl.NET
Dimensions2Folders
ExifTool
ImageMagick
Python 3.8

# Code and texts about Booru (anime style) image processing

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

