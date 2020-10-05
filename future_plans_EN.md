### continue grabbing and make next "volumes" of (nearly) original images

use the same set of sources, exclude unreacheble, maybe include new - if valuable

periodicity based on Safebooru 100.000-group, currently ~4 months
 - 2020C for june-september 2020 now rectifying
 - 2020D till the end of 2020 now collecting
 
the same [quality requirements](https://github.com/aperveyev/booru_processor/blob/master/about_quality.md) - to be surely DRY (DontRepeateYourself) in the future

### next BOORU_CHARS release of metadata and thumbnails

at the beginning of 2021
 - add 2020 volumes
 - maybe back to past and include 2014 and 2015 volumes, prior to 2016(W) 
   * there are initial images with the same "technical" requirements
   * much worse in visual average quality (attractiveness)

mostly the same - compatible -  metadata, maybe some new ones

1024x1024 thumbnails for 2020 ???

### dataset for portraits "heads" detection

inspired by [by Gwern danbooru portraits](https://www.gwern.net/Crops#danbooru2019-portraits)
 - very good idea, but not very suitable crop and problematic (even after all Gwern's cleanup) quality - too much outliers
   * change extension policy after face detection : down 0% up 30% sides 15% each
   * play with image rotation and detection thresholds over every image till first success
   * don't limit youself with single-character pictures   
   * ENORMOUS AMOUNT OF MANUAL POSTPROCESSING (filtering) to assure output quality   
   * use only Portraits initially over 200px and extend them (with Waifu2x) to 1024x1024
- wanna build 200k+ high quality traning dataset for Nagadomi-like cascade XML-s
   * use BOORU_CHARS (multiBOORU) original images from several torrents, tagged with copyright and characters
   * informative image files naming, collect supporting metadata
   * now not sure whether to start with outstanding copyrights (with limited characters) or chronologically covering all characters
   * when no success (no good model can be created over this dataset) - no efforts in this direction will be reasonable
 
 BTW Gwern's Figures seemed not usable because of poor AniGeg detection and domination of Figure in most images
   * one more reason to buld something like Nagadomi rather than AniSeg
   
