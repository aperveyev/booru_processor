Some info about data structures:

Y_pretty.json - example of single JSON with evident content

yndr_posts.tsv - all (618801) JSON responses from site, divided across several files

yndr_dt.tsv - tags in posts, 4261026 rows

yndr_copyr_char_tags.tsv - extended summary for tags describing copyrights (type 3) and characters (type 4)
Tags (more or less) correlated with Danbooru and grouped into "franchises" (series with mostly common characters). 
Also Danbooru tags correlated with Myanimelist entries. This catalogue is my ongoing activity, not ideal at the time.

yndr_pools.tsv, yndr_pool_posts.tsv - pools and pool entries with evident structure

yndr_rip.tsv - extended info for "sampled" posts, some nonevident values are:

 'POST_RANK' - percent rank by post score in 10.000-ID group, 0 - is the best, 1 - worst
 'BOUNDBOX' - area without empty margins
 'ENTHROPY' - close to 1 most informative, close to 0 - more background
 'SKEWNESS' - dark/bright balance
 'IMEAN' - image intensity for all color channels
 'STDDEV' - standart deviation
 'COLORS' - colors count
 'HCL_MEAN' - avegare color intensity, 0 is black&white
 'HCL_MAX' - maximum colors intensity
 'RED/GREEN/BLUE_MEAN' - average color intensity by color channel
 'EDGES' - edge effects intensivity (from foreground object or complex background)
 'ARIA_MOVE' - BAT command to rename Aria (downloader) results to local filename

Most valuable stats IMHO are 'ENTHROPY', 'SKEWNESS', 'HCL_MEAN' and 'COLORS'.

Analysis can be done with SQL-s against YNDR_RIP/INDR_IM & YNDR_DT - then xcopying image subsets to look at. 

select 'xcopy "D:\TORR\yande_re_2020'||substr(i.ipath,9)||'\'||y.fname||'" C:\SORT\ ' xcpy from ...

For example SQL "for what copyrights BW series has maximum relative score against colored ones"

select tag, rating, cnt, score, cnt_bw, score_bw, round(score_bw/score,2) bw_good from (
select t.tag, y.rating, count(*) cnt, round(avg(score),1) score, 
                        sum(case when i.meang < 0.02 then 1 else 0 end) cnt_bw,
                        round(sum(case when i.meang < 0.02 then score else 0 end)/ -- we can't use AVG selectively 
                              greatest(1,sum(case when i.meang < 0.02 then 1 else 0 end))) score_bw -- avoid /0
from yndr_rip y
join yndr_dt d on y.id=d.id 
join yndr_tg t on d.tag=t.tag and t.tag_cat=3 -- traverse to copyrights
join yndr_im i on i.fid=d.id
group by t.tag, y.rating
having count(*)>49 -- exclude non popular copyrights
) where cnt_bw>19 and score_bw>9 order by 7 desc


BUST - a full head and a body right under it.

Attractive object for detection (with lbpcascade like algorithms) and classification
- much more feature rich than face by itself
- not so volatile as full body

Detection now based on [Nagadomi face detector](https://github.com/nagadomi/lbpcascade_animeface)
- then extension 
  * crop_img = image[max(0,int(y-0.35*h)): int(y+1.6*h), max(0,int(x-0.15*w)): min(iw,int(x+1.15*w))]
  * bring result to 2x3 aspect ratio, minimum 192x288
- then manual cleanup
  * no substancial space over head (and head features), no substantial upper head crop 
  * head (with features) almost as wide as image, no substantial side cropping
  * orientation close to frontal, no side view
  * no other head/faces and artifacts (text, margins) in upper half of image
  * minimum body overlapping and artifacts in lower part of image
  * no substantial chibification and non-human styling
  * close to frontal perspective - neither from top not from bottom

It's not a problem to generate enormous amout of auto-croppings, much more valuable 
is following (semi-) manual cleanup and then use for models training / validation.
Upper body detector can be built when dataset become big and clean enough.

NUDE - promising object detector by [notAI-tech NudeNet](https://github.com/notAI-tech/NudeNet)

Requires old version of tensorflow so may be tricky to install.

Detects body parts enough to reconstruct all person:
- going top-to-bottom with metaclasses
   when obj like '%FACE%'    then 'FACE' -- mandatory to start, may be several
   when obj like '%BREAST%'  then 'BRST'
   when obj like '%ARMPITS%' then 'ARMP'  
   when obj like '%BELLY%'   then 'BELL'
   when obj like '%GENIT%' or obj like '%ANUS%' or obj like '%BUTT%' then 'XXXX'  
   when obj like '%FEET%'    then 'FEET'
- non-maximum suppression required !
- image aspect ratio (portrait, landscape or close to square) is valuable for possible person topology
- several persons can be distinguished by distance and direction from upper-center point of image
- questionable images are much more "feature-rich" (because of nudity, yep)

I loaded text logs to database (oracle) and process it there.
First target is to classify images by "skeletons" (set of metaclasses) detected
and then classify every skeleton members by numerical properties - body part sizes and relative positions.
The results are "scene compositions" - possible classes and their members. 
A lot of work to do with 400k+ dataset at quarantine ;-)

At the time NudeNet detector is far from ideal, but generally it works so can be started with.
