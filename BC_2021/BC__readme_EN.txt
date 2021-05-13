BOORU CHARS dataset 2021 (Safebooru yande-re etc) 1280 px samples + metadata 

BOORU CHARS OPEN DATASET is an attempt to consolidate and arrange available character-centric SFW anime/CG/game art. 
It uses a localized format suited both for batch processing and visual estimation and contains sample images
with reasonable quality and also tag and technical metadata.

Here is some descriptive insight into data and process of creation as of torrent release (05.2021).
More and improved info can be found at https://github.com/aperveyev/booru_processor (mostly russian).
Earlier version of this dataset (2019, 512px) https://nyaa.si/view/1206322 

The basis of this dataset are booru imageboards with images and database-like organized metadata.
Wide user community fill boorus from pixiv, deviantart and other sources, tag and rate posts.

There are several booru, biggest are 10+ years old and hosts lots of pictures:
* safebooru.org - SFW art, basis of dataset (3.3 M posts as of 2021)
* yande.re - high quality unique scans, incl NSFW  (almost 0.8 M)
* gelbooru.com - complete version of safebooru with NSFW (6+ M)
* e-shuushuu.net - nice SFW resource, not very active last years (1 M) specific tagging
* anime-pictures.net - good selection but not very big (0.7 M) some ecchi
* konachan.com - wallpapers dedicated, with NSFW (0.32 M)
* danbooru.donmai.us - classic booru, great community (4.5 M) some NSFW
* zerochan.net - large (3.3 M) and unique, some ecchi
* chan.sankakucomplex.com - biggest hentai resource (15+ M NSFW doujinshi only) with lots of art (~8 M) 
* theanimegallery.com, animepapers.net - RIP

Using "bionus imgbrd grabber" (safebooru, yande-re, gelbooru, anime-pictures, konachan), other ready-to-use grabbers
and also python (requests, BeautifulSoup, json, re, ...) for downloading some torrents created with minimal 
or none image transformations (root folder mentioned).
e-shuushuu       -1
e-shuushuu 2013  -2
e-shuushuu 2013s -3
e-shuushuu 2014  -4 joined into https://nyaa.si/view/513582
e-shuushuu 2015  - https://nyaa.si/view/771715 (also duplicates 2014)
e-shuushuu 2016  -1
e-shuushuu 2017  -2
e-shuushuu 2018  -3 joined into https://www.acgnx.se/show-cceb3260269b5423cbd7f8d59f2c84531750923b.html
e-shuushuu_2020  - https://nyaa.si/view/1323390
Safebooru 1280   -1
Safebooru 1280 b -2
Safebooru pages  -3 joined into https://nyaa.si/view/719463
Safebooru 2M    - https://nyaa.si/view/891391
Safebooru 2017  -1
Safebooru 2018  -2 joined into https://nyaa.si/view/1181364
Safebooru 2019  - https://nyaa.si/view/1202653 (actual composite rip sequence)
Safebooru 2020a - https://nyaa.si/view/1227047
Safebooru 2020b - https://nyaa.si/view/1265063
Safebooru 2020c - https://nyaa.si/view/1291697
Safebooru 2020d - https://nyaa.si/view/1340980
Safebooru 2021a - https://nyaa.si/view/1376135 
Sankaku 2013 wallsHD - https://rutracker.org/forum/viewtopic.php?t=4621394
Sankaku 2014    -1
Sankaku 2015    -2
Sankaku 2015b   -3 joined into https://nyaa.si/view/750972
Sankaku 2016a   -1
Sankaku 2016b   -2
Sankaku 2016c   -3 joined into https://nyaa.si/view/875411
zerochan_2014s  - https://nyaa.si/view/1336359 (downsize to 1920 px, PNG -> JPG)
zerochan_2016   - https://nyaa.si/view/1313832
zerochan-2017   - https://rutracker.org/forum/viewtopic.php?t=5478026
zerochan_2020   - https://nyaa.si/view/1304539 (600+ GB!, lots of PNG)
There are always %booru% + %id% key in file name.
Rutracker version of list is in the "readme_RU".

You can find stats BCS_torr_stat.xls and listing BCS_torr.tsv (3.839.005 rows):
TORR - root folder
BOORU - imageboard
FID - post ID
SOURCEFILE - zip=folder name / file name
             most filenames are %website% - %id% - %copyright% ~ %characters% (%artist%) as of release date
IMAGESIZE - WIDTHxHEIGHT
FILESIZE - bytes
IFMT - by EXIFTOOL
FDATE - timestamp in release (not posting date)
FMD5 - MD5 by FCIV in release (after PNG -> JPG 94% and other intrusions)
ZPATH - torrent path as of rutracker version, often empty = zip is in torrent root

Also there are some "wallpaper" releases with already processed pictures (complete rutracker list is in the "readme_RU")
  wallpapers          - https://nyaa.si/view/710893 and https://nyaa.si/view/520283
  portrait wallpapers - https://nyaa.si/view/745633 

The next storage level is "main archive" - common set from all releases above (and not only) with
- unique BOORU + FID
- unique MD5
- antidupl.net deduplication up to ~4% similarity

Main archive structure is by posting year (or release identificator) and aspect ratio :
* 7x10 +/- 4% artbook pages
* 3x4 +/- 10% wide pages
* 1x1 +/- 20% squares
* 3x2 +/- 40% landscape inct wallpapers
* 2x3 +/- 40% tall pages, aspect name 1õ2 used
There are 48 "volumes" in total. The main archive is a direct source of dataset images.

You can find summary BCS_arch_stat.xls and listing BCS_arch.tsv (1.952.491 rows):
BOORU - imageboard
FID - post_id
FVOLUME - volume (e.g. v2020d.7x10)
FILENAME - %website% - %id% - %copyright% ~ %characters% (%artist%)
           often file name is "better" than in initial torrent release
           lots of work done last years to parse metadata from boorus
IMAGESIZE - WIDTHxHEIGHT
FILESIZE - bytes
JPEGQ - quality by EXIFTOOL
FMD5 - MD5 by FCIV

The BOORU CHARS dataset consists of 1.593.429 images (some filters applied over main archive):
* samples with longer side 1280px (1024px for 1õ1)
  for /d %%r in (D:\BC7\V2021A.7x10\*) do magick mogrify -path B:\BCT\V2021A.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
* JPEG quality lowered to 95% from 98-100%
  magick mogrify -path B:\BCT\V2021A.7x10\#LSO -verbose -quality 94 "B:\BCT\V2021A.7x10\#LST\*.jpg"
These are compromise settings.
Images were re-volumed to 18 directories (again by aspect ratio and simplified chronology).

Some statistics computed by ImageMagick
    magick identify -format """%%f"";%%d;%%@;%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" "file_name" >> "log"
    magick convert "file_name" -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> "log"
    magick convert "file_name" -edge 3 -format "%%[fx:mean]\n" info: >> "log"
It's results used to reorder images by visual similarity into small (up to 1000) zip-folders Mxx (main list) and Rxx (reverse list).

Also some tags places into EXIF-info
    exiftool -P -overwrite_original_in_place 
      -EXIF:Copyright="copyright" -EXIF:Software="BOORU - FID" -EXIF:Artist="artist" 
      -EXIF:Make="copyright [artist]" -EXIF:Model="character" "file_name"
so Windows explorer or image viewers (e.g. Perfect Viewer for Android) can show it.

Most valuable listing of dataset is BC_posts.tsv (1.593.429 rows):
BOORU - imageboard
FID - post id
TORR_PATH - path: root / zip-archive
TORR_FNAME - file name
* info for samples, always JPG <1280 (<1024)
TORR_FSIZE - bytes
TORR_ISIZE - WIDTHxHEIGHT
BOUNDBOX - frame by ImageMagick
S_JQ - JPEG quality estimation
R_ALL - rank inside volume "+" main rating (Ìxx) "-" reverse rating (Rxx)
TENTR - enthropy
R_ENTR - rank by enthropy ( "-" reverse list )
TSKEW - skewness
TSTDDEV - standard deviation
R_SDEV - rank by standard deviation
TCOLORS - colors count
R_COLOR - rank by colors count
MEANG - mean grey channel
R_MEANG - rank by mean grey
EDGE - canny edge detector
R_EDGE - rank by canny
* info for initial (main archive) images, always JPG
ORIG_FSIZE - bytes
ORIG_ISIZE - WIDTHxHEIGHT
ORIG_JQ - JPEG quality
ORIG_MD5 - MD5
* initial booru info, sometimes empty or default
POST_DT - posting date
RATING - trating Safe / Questionable / Explicit (very exotic) / None (no info)
SCORE - popularity @ booru if available
FAVS - favorite count @ booru
POST_EXT - original post extension
POST_FSIZE - bytes @ booru if available and != ORIG_FSIZE
POST_ISIZE - WIDTHxHEIGHT @ booru if available and != ORIG_ISIZE
POST_MD5 - MD5 @ booru if available and != ORIG_MD5
* tags count by category (BC_tags.tsv) for post
TAGS_COPYR - (copyright)
TAGS_CHARS - (character)
TAGS_ART - (artist)
TAGS_GEN - (general)
TAGS_ETC - (technical, others)

Large listing BC_tags.tsv (35.222.997 rows) is about tag occurences:
BOORU - imageboard
FID - post id
TAG_CAT - tag category as of DANBOORU notation (3=copyright, 4=character, 1=artist, 0=general, 5=others,undef)
TAG - text tag @ booru
TAG_ID - numeric tag as of DANBOORU notation (big work done for correlation and synonyms detection)
DANB_TAG - DANBOORU text tag 
 * for CAT in (0,1,5) DANBOORU-synonum for TAG if != TAG
 * for CAT in (3,4) DANBOORU-franchise (generalised copyright series) for TAG if != TAG 

Some stats - BC_tags_stat.xls (by volume, booru and cat), BC_tags_top.xls for frequently used tags.

BOORU CHARS dataset can be used:
- as visual summary for character-centric anime/CG/game art (can be viewed mobile, contains EXIF tags)
- as source of specific image subsets
  for %%F in ("B:\BCT\2016-7x10\*.zip") do 7z x -r -o"d:\sortarea\" "%%F" *sword*art*online*
  xcopy /s B:\BCT\2016-7x10\*sword*art*online* d:\sortarea
- (with tags and stats in database) as source for any SQL analysis and reordering making BAT-s (XCOPY, MOVE etc)
  select 'xcopy "B:\BCT\'||e.ipath||'\'||e.fname||'" d:\sortarea\ /Y' xc, 
         d.booru, d.id, d.orig_tag tag_1, n.orig_tag tag_2
  from bct_dt d
  join bct e on e.booru=d.booru and e.fid=d.id
  join bct_dt n on n.booru=d.booru and n.id=d.id and n.orig_tag in ('nude','naked')
  where d.orig_tag in ('loli')

Additional descriptions for metadata and examples in this release 
BCI__readme.txt - about stats, ranking and X/Y diagrams
BCN__readme.txt - about object detections (with notAI-tech NudeNet) and characters assembling
