## BOORU-CHARS OPEN DATASET (english description below):
- открытый набор данных о качественных арт-изображениях персонажей аниме, игр, мультипликации и т.п.
- состоит из мета-данных (ссылок на booru-первоисточник, смысловых тегов, статистических показателей,
  результатов применения алгоритмов на изображениях) и thumbnail-изображений 512x512px (дополнены черными полями)
- содержит описание используемых методов, скриптов, программ и их параметров для единообразного применения
- большие наборы распространяются через torrent, код, описание и компактные данные хостятся на Github

**ЦЕЛИ ПРОЕКТА:**
- систематизация мета-данных как таковых в т.ч. координация между их источниками, например
  - соотнесение персонажей myanimelist и соответствующих тегов Danbooru & Safebooru
  - группировка произведений во "франшизы" с в основном пересекающимся множеством персонажей
- быть основой для нетривиального анализа накопленных мета-данных: SQL-запросы, data mining clustering & classification,   например 
  - рейтинг популярности для портретных изображений в разрезе персонажей и годов постинга
  - самые многочисленные (в разрезе по авторам) серии для заданной комбинации тегов
  - неисчислимое множество примеров "хит-парадов", на основе которых можно отбирать для просмотра и/или качать подборки
- быть основой для применения Machine Learning & Neural Networks алгоритмов к не-фотографическим изображениям (их "иконкам"), например
  - создание обучающих и проверочных выборок с использованием фильтров по тегам и/или мета-данным
  - сегментирование изображений по композиции и масштабу на основе относительного размера детектированного лица 
  - "весовая функция визуального качества" и т.п.

**BOORU-источники данных (только интенсивно используемые) и сопутствующие сервисы:**
- https://safebooru.org/ самый массовый ресурс без откровенной эротики и хентая, служит основой композитной подборки **2.5 млн**
- https://yande.re/post **NSFW** специализируется на высококачественных сканах, процент "уникальности" высок **0.6 млн**
- https://gelbooru.com/ **NSFW** "полный" вариант safebooru без моральных ограничений **3.5 млн**
- http://e-shuushuu.net/ самый "приличный" из ресурсов, в последние годы активность затухает **1 млн**
- http://konachan.com/ **NSFW** специализируется на "обоях" (ландшафтной ориентации), уникален за счет переделок арта с других ресурсов **0.4 млн**
- https://chan.sankakucomplex.com/ **очень NSFW** самый богатый выбор, но защищен от массового скачивания **7+ млн**
- https://www.zerochan.net/ достаточно уникальный набор, допускает эротику, нет способов массового скачивания **2.5 млн**
- https://danbooru.donmai.us/ **NSFW** классика жанра, до появления dataset мною не использовался (теперь - не знаю ...) **3.5 млн**
- "специализированный" поиск по вышеупомянутым и другим ресурсам http://iqdb.org/ охват порядка 15 млн. изображений

Необходимо учитывать массовый кросспостинг между некоторыми источниками и практически полную изоляцию других.
Ряд ресурсов не упомянут потому что "не проходят по конкурсу", не так велики, уже закрылись или не совсем по теме.

**ВНЕШНИЕ ПРОГРАММЫ (под Windows):**
- скачивание **Grabber** https://github.com/Bionus/imgbrd-grabber
- разбивка по пропорциям **Dimensions2Folders** https://www.dcmembers.com/skwire/download/dimensions-2-folders/
- просмотр и простые преобразования **Fast stone image viewer** https://www.faststone.org/FSViewerDetail.htm
- дедубликация **AntiDupl.NET** https://github.com/ermig1979/AntiDupl
- каталогизация метаданных **ExifTool** https://www.sno.phy.queensu.ca/~phil/exiftool/
- преобразования, в т.ч. весьма нетривиальные **ImageMagick** https://imagemagick.org/script/download.php
- скриптовый "клей" с кучей готовых библиотек **Python 3.8** https://www.python.org/

**ДАТАСЕТЫ, СЕРВИСЫ И МОДЕЛИ:**
- фундаментальные статьи с массой полезных ссылок https://www.gwern.net/Danbooru2018 и https://www.gwern.net/TWDNE
- сервис: попытка определить теги для произвольной картинки http://kanotype.iptime.org:8003/deepdanbooru/
- сервис: первоисточник хайпа и мой вдохновитель https://www.thiswaifudoesnotexist.net/
- torrent с "иконками" и метаданными danbooru https://nyaa.si/view/1176129 (перераздача Danbooru2018 в гуманном формате)
- полезная всячина с Kaggle (списком) https://www.kaggle.com/datasets?search=anime меня особо заинтересовало 
  все связанное с MyAnimeList и Safebooru

### ENGLISH: datasets and software for Booru (painted or CG characters, mostly anime style) image processing

Here is a hobbie project inspired by results of https://www.thiswaifudoesnotexist.net/ and it's technical background - https://www.gwern.net/TWDNE and dataset https://www.gwern.net/Danbooru2018 , algorithms and software available for free use.

This activity goals are:
- to arrange available metadata, software, scripts and models for the subject
- to collect (and create) training image datasets ("thumbnails") with good quality and metadata background
- an attempt to build usable tools for imagesets & metadata analysis and processing, e.g.
  - scene composition classification
  - visual attractiveness estimation
  - auto correction ?
