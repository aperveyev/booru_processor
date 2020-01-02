### Datasets and software for Booru (painted or CG characters, mostly anime style) image processing

Here is a hobbie project inspired by results of [TWNDE](https://www.thiswaifudoesnotexist.net/), it's technical background
[by Gwern](https://www.gwern.net/TWDNE) and [his dataset](https://www.gwern.net/Danbooru2018) and also algorithms and software available for free use.

**This activity goals are:**
* to arrange available metadata, software, scripts and models for the subject
* to collect (and create) training image datasets ("thumbnails") with good quality and metadata background
* an attempt to build usable tools for imagesets & metadata analysis and processing, e.g.
  - scene composition classification
  - visual attractiveness estimation
  - auto correction ?

[This release](https://nyaa.si/view/1206322 ) is my open dataset made in line with [Danbooru 2018 set](https://nyaa.si/view/1176129)
It covers 1.227.622 thumbnail (512x512px images) from several imageboards combined with supporting metadata.

**The main features there are:**
- much higher original images technical and visual quality 
  * width>=900 height>=900 MPixels>=1.2
  * most of comixes, primitives, overtexted images manually excluded
  * no photo, almost no characterless scenes
- several sources but unique image identification %website% + %id%
  * most of original images can be found in torrents (nyaa, rutracker)
  * selective regrab of originals possible if source website available
- careful deduplication with relative website priorities,  high to low (mostly)
  * safebooru.org
  * yande.re
  * e-shuushuu.net
  * konachan.com
  * gelbooru.com
  * chan.sankakucomplex.com
  * zerochan.net
  * anime-pictures.net
  * danbooru.donmai.us
  * tbib.org
- image file names mostly structured and contains %website% - %id% - %copyright% ~ %charachers% (%artist%)
- not completely SFW (some softcore ecchi here and there)

Image dates covers 10.2016 - 08.2019 densely, earlier period selectively:
V2019  - 11.2018-08.2019  from rip https://nyaa.si/view/1202653
V2018  - period 2017-2018 from rips https://nyaa.si/view/1181364
                                    https://www.acgnx.se/show-cceb3260269b5423cbd7f8d59f2c84531750923b.html
                                    https://nyaa.si/view/771715 and https://nyaa.si/view/513582
                                    https://rutracker.org/forum/viewtopic.php?t=5478026
V2016  - till 10.2016 https://nyaa.si/view/891391
         partially https://nyaa.si/view/750972 and https://nyaa.si/view/875411
V2016W - till 05.2016 converted to wallpapes sizes
         https://nyaa.si/view/710893, https://nyaa.si/view/745633
         https://rutracker.org/forum/viewtopic.php?t=5198985
V2018D - remainder from https://nyaa.si/view/1176129 survived after cleanup and deduplication, mostly 2015 and earlier
         files renamed according to metadata, white border for addon-2018 replaced with black one

**Metadata:**
- copyrights, characters and artists taglist based on Danbooru tags
  * copyrights bundled into Frachises
  * characters refers to Frachises
  * copyrights and characters refer to Myanimelist entities
- images statistical properties from JPG header and calculated
  * entropy (complexity), skewness (darkness)
  * colors count and intensity by channels
  * color saturation (grayness), edge intensity
  * boundbox coordinates and more
- face detection results with 3 level of accuracy combined
  [the only stable detector for painted images features I found]

**Software:**
- Windows BAT scripts for processing with Image Magick
- Python scripts for some grabbing and processing

This dataset may be used for massive image processing and [meta-]data mining, e.g.
- painted image features (tags) recognition algorithms training/estimation
- visual quality and attractiveness prediction/ranking
- scene scale and composition classification
- any imaginable metadata query with their visualized results on fingertips

******************************************************************************************************************

MATADATA STRUCTURES and meaning (all data are texts delimited with ";", first line is a header):

DANB_MAL_tag_2019.csv - Danbooru character to copyrights reference and correlation with Myanimelist

TAG_CAT - tag "category" 1 - artist, 3 - copyright, 4 - character, 0 - general
TAG_ID - unique ID given by Danbooru, backward compatible, common key for existing and planned correlations
TAG_NAME - unique name given by Danbooru, other resources may use similar names
TAG_CNT - count of tag occurences as of Danbooru2018, estimation of relative popularity
          tags with less than 5 occurences omitted from analysis
FR_ID - FRANCHIZE (FR for short) defined as "group of copyrights with mostly common characters community"
        As a FR_ID I used TAG_ID of first, mostly popular or "series" copyright and then refer other copyrights 
        and characters to it. IMHO it's much more stable and less controversal reference not degraded with time
        (compared to refer character directly to copyright). More work on that TBD.
MAL_ID - related entity ID on Myanimelist, may be used for reference as
         https://myanimelist.net/anime/11757 (11757 is SAO) for copyrights
         https://myanimelist.net/character/43892 (43892 is Yui) for characters
         Again, reference is not complete and sometimes maybe incorrect. Has to be improved. 
MAL_NAME - entity name on Myanimelist to check if relation is correct
MAL_CNT - count of favorites on Myanimelist, estimation of relative popularity

SB_TAGS_2019.csv - list of tags with categories 1-artist, 3-copyright, 4-character for Safebooru images in release
                   tags correlated with Danbooru (see above) if possible

SB_FID - safebooru FILE_ID
TAG_CAT - tag category
SB_TAG - tag name as of Safebooru (Safebooru has no available internal numerical TAG_ID)
DANB_TAG - Danbooru TAG_ID
DANB_FR - Danbooru FR_ID

Only tags with 5 or more occurences included.
Complete list of Safebooru tags can be found in Kaggle dataset https://www.kaggle.com/alamson/safebooru
The same taglist for Danbooru2018 can be found in release https://nyaa.si/view/1176129 (metadata_processed_csv.zip)

V20??[?].csv - image metadata for every "volume" in this release

BOORU - source website short name
FID - source website file ID, globally unique when combined with BOORU
IPATH - path of thumbnail file in release
IFILE - file name on thimbnail (512x512px image)
        often structured and contains %website% - %id% - %copyright% ~ %charachers% (%artist%)
XBYTES - "original" image file size
XWIDTH - "original" image width
XHEIGHT - "original" image height
BOUNDW - "original" image boundbox width
BOUNDH - -//- height
BOUNDX - -//- upper left corner X
BOUNDY - -//- upper left corner Y
TBYTES - thumbnail file size in bytes
TWIDTH - thumbnail width before border apply
THEIGHT - thumbnail height before border apply
next calculated fields made on thumbnails
TENTR - image enthropy, the measure of complexity, inverted to the amount of simple background
TSKEW - skewness, the measure of image "darkness"
TMEAN - mean intensity
TSTDDEV - standard deviation
TCOLORS - count of colors
MEANGREY - mean intensity after colorspace converted to HCL, value close to 0 mean B&W
MAXGREY - max intensity after colorspace converted to HCL, value well below 1 mean absense of intense colors
REDMEAN - mean intensity of RED channel
GREENMEAN - mean intensity of GREEN  
BLUEMEAN - mean intensity of BLUE, 3 means compared describe the preferred color
EDGE - intensity of "edges"
FACES - JSON list of up to 5 face detection results made 3 times with different settings
        flevel - level of first detection 7-strict 4-average 2-relaxed
        facex,facey - upper left corner of bounbox on thumbnail
        facew - face size, boundbozx is always square
COPYRTAG1 - some Danbooru tag IDs denormalized, for Danbooru and Safebooru this info got from taglists
            for other sources I tried to parse filenames (better than nothing)
COPYRTAG2 - copyright tag 2
CHARSTAG1 - character tag 1
CHARSTAG2 - character tag 2
CHARSTAG3 - character tag 3
ARTTAG1 - artist tag 1


SOME SOFTWARE trivial scripts:

facedet.py - face detection python script, illustrate 3-pass detection
             may be used to generate image with boundboxes
lbpcascade_animeface.xml - required model for facedet.py
facedet.bat - loop call for facedet.py

IMloop.bat - Image magick single file processing, illustrate action and parameters
IM.bat - loop call for IMloop.bat for with thumbnail generation and total output
