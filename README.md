## BOORU-CHARS OPEN DATASET (english description [here](https://github.com/aperveyev/booru_processor/blob/master/README_EN.md)  ):
- открытый набор данных о [качественных](https://github.com/aperveyev/booru_processor/blob/master/about_quality.md) арт-изображениях персонажей аниме, игр, мультипликации и т.п.
- состоит из мета-данных (ссылок на booru-первоисточник, смысловых тегов, статистических показателей,
  результатов применения алгоритмов на изображениях) и thumbnail-изображений 512x512px
- содержит описание используемых методов, скриптов, программ и их параметров для единообразного применения
- большие наборы распространяются через torrent, код, описание и компактные данные хостятся на Github

**ЦЕЛИ ПРОЕКТА:**
- быть основой для применения Machine Learning & Neural Networks алгоритмов к не-фотографическим изображениям (их "иконкам"), например
  - обнаружение ключевых объектов в рисованных изображениях (с лицами у [nagadomi](https://github.com/nagadomi/lbpcascade_animeface) очень хорошо получилось). Хотелось бы получить нечто подобное для ростовых гуманоидных фигур и груди
  (более-менее одетой, обнаженка - out of scope).
  - сегментирование изображений по композиции и масштабу на основе относительного размера и положения детектированных лиц (и дгугих ключевых объектов)
  - разработка "весовой функции визуального качества", пригодной для создания априорных "хит-парадов", а также (хотя бы частичной) автоматизации разгребания безбрежного арт-океана 
- быть основой для нетривиального анализа накопленных мета-данных: SQL-запросы, data mining clustering & classification
  (с легкой визуализацией результатов), например 
  - рейтинг популярности для портретных изображений в разрезе персонажей и годов постинга
  - самые многочисленные (в разрезе по авторам) серии для заданной комбинации тегов
  - неисчислимое множество примеров "хит-парадов", на основе которых можно отбирать для просмотра и/или качать подборки
- систематизация мета-данных артист/произведение/персонаж как таковых в т.ч. координация между их источниками, например
  - соотнесение персонажей myanimelist и соответствующих тегов Danbooru & Safebooru
  - группировка произведений во "франшизы" с (в основном) пересекающимся множеством персонажей

**BOORU-источники данных (только самые интенсивно используемые) и сопутствующие сервисы:**
- https://safebooru.org/ самый массовый ресурс без откровенной эротики и хентая, служит основой композитной подборки **2.5 млн**
- http://e-shuushuu.net/ самый "приличный" из ресурсов, в последние годы активность затухает **1 млн**
- https://yande.re/post **NSFW** специализируется на высококачественных сканах, процент "уникальности" высок **0.6 млн**
- https://gelbooru.com/ **NSFW** "полный" вариант safebooru без моральных ограничений **3.5 млн**
- http://konachan.com/ **NSFW** специализируется на "обоях" (ландшафтной ориентации), уникален за счет переделок арта с других ресурсов **0.4 млн**
- https://chan.sankakucomplex.com/ **очень NSFW** самый богатый выбор, но защищен от массового скачивания **7 млн** артовин + 8 млн хентайных додзинси и gameCG
- https://www.zerochan.net/ достаточно уникальный набор, допускает эротику, нет способов массового скачивания **2.5 млн**
- https://danbooru.donmai.us/ **NSFW** классика жанра, до появления dataset мною не использовался (теперь - буду) **3.5 млн**
- "специализированный" поиск по вышеупомянутым и другим ресурсам http://iqdb.org/ охват порядка 15 млн. изображений

Необходимо упомянуть массовый кросспостинг между некоторыми источниками (например danbooru -> gelbooru -> safebooru ) и относительную изоляцию других (zerochan, yande-re).

**ВНЕШНИЕ ПРОГРАММЫ (под Windows):**
- скачивание [Grabber](https://github.com/Bionus/imgbrd-grabber)
- разбивка по пропорциям [Dimensions2Folders](https://www.dcmembers.com/skwire/download/dimensions-2-folders/)
- просмотр и простые преобразования [Fast stone image viewer](https://www.faststone.org/FSViewerDetail.htm)
- дедубликация [AntiDupl.NET](https://github.com/ermig1979/AntiDupl)
- простой листинг метаданных [ExifTool](https://www.sno.phy.queensu.ca/~phil/exiftool/)
- преобразования, в т.ч. весьма нетривиальные и статистики [ImageMagick](https://imagemagick.org/script/download.php)
- скриптовый "клей" для процессинга и скачивания с кучей готовых библиотек [Python 3.8](https://www.python.org/)
- файловый менеджер **Far** восхитительный инструмент в умелых руках

**ДАТАСЕТЫ, СЕРВИСЫ И МОДЕЛИ:**
- сервис: первоисточник хайпа https://www.thiswaifudoesnotexist.net/
- сервис: попытка определить теги для произвольной картинки http://kanotype.iptime.org:8003/deepdanbooru/
- фундаментальные статьи с массой полезных ссылок https://www.gwern.net/Danbooru2018 и https://www.gwern.net/TWDNE
- полезная всячина с Kaggle (списком) https://www.kaggle.com/datasets?search=anime меня особо заинтересовали метаданные 
  MyAnimeList и Safebooru
- torrent-ы с "иконками" и метаданными, [описаны отдельно](https://github.com/aperveyev/booru_processor/blob/master/%23DATA/readme.md)  

**МЕТОДИКА ОБРАБОТКИ:**
- сбор (скачивание) и накопление оригинальных изображений для очередного *релиза*
- начальная обработка и итеративное улучшение *релиза* в т.ч. с помощью анализа атипичных метаданных
- слияние *текущего релиза* с *пулом предыдущих релизов*
В подробностях [описана отдельно](https://github.com/aperveyev/booru_processor/blob/master/preparations.md)
