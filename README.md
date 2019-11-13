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

**BOORU-источники данных (только интенсивно используемые) и сопутствующие сервисы:**
- https://safebooru.org/ самый массовый ресурс без откровенной эротики и хентая, служит основой композитной подборки 2.5 млн
- https://yande.re/post **NSFW** специализируется на высококачественных сканах, процент "уникальности" высок 0.6 млн
- https://gelbooru.com/ **NSFW** "полный" вариант safebooru без моральных ограничений 3.5 млн
- http://e-shuushuu.net/ самый "приличный" из ресурсов, в последние годы активность затухает 1 млн
- http://konachan.com/ **NSFW** специализируется на "обоях" (ландшафтной ориентации), уникален за счет переделок 0.4 млн
  арта с других ресурсов
- https://chan.sankakucomplex.com/ **очень NSFW** самый богатый выбор, но защищен от массового скачивания 7? млн
- https://www.zerochan.net/ достаточно уникальный набор, допускает эротику, нет способов массового скачивания 2.5 млн
- https://danbooru.donmai.us/ **NSFW** классика жанра, до появления dataset мною не использовался (теперь - не знаю ...) 3.5 млн
- "специализированный" поиск по вышеупомянутым и другим ресурсам http://iqdb.org/ охват порядка 15 млн. изображений

Необходимо учитывать массовый кросспостинг между некоторыми источниками и практически полную изоляцию других.
Ряд ресурсов не упомянут потому что "не проходят по конкурсу", не так велики, уже закрылись или не совсем по теме.

**ВНЕШНИЕ ПРОГРАММЫ (под Windows):**
- скачивание Grabber https://github.com/Bionus/imgbrd-grabber
- разбивка по пропорциям Dimensions2Folders https://www.dcmembers.com/skwire/download/dimensions-2-folders/
- просмотр и простые преобразования Fast stone image viewer https://www.faststone.org/FSViewerDetail.htm
- дедубликация AntiDupl.NET https://github.com/ermig1979/AntiDupl
- ExifTool https://www.sno.phy.queensu.ca/~phil/exiftool/
- ImageMagick https://imagemagick.org/script/download.php
- Python (3.8) https://www.python.org/

**ДАТАСЕТЫ:**


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
