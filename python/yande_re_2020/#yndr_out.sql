set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on
col nnn noprint

spool yndr_rip_RU.tsv

select 'POST_ID' ||chr(9)|| 'SCORE' ||chr(9)|| 'RATING' ||chr(9)|| 'POST_RANK' ||chr(9)|| 'IMG_WIDTH' ||chr(9)|| 'IMG_HEIGHT' ||chr(9)|| 'FILE_SIZE' ||chr(9)||
       'SAMPLE_URL' ||chr(9)|| 'FILE_URL' ||chr(9)|| 'LOCAL_FILE_NAME' ||chr(9)|| 'LOCAL_PATH' ||chr(9)||
       'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)|| 'RES_X' ||chr(9)|| 'RES_Y' ||chr(9)|| 'RES_UNIT' ||chr(9)|| 'BOUNDBOX' ||chr(9)|| 'JPEG_QUALITY' ||chr(9)|| 'COLORSPACE' ||chr(9)||
       'ENTHROPY' ||chr(9)|| 'SKEWNESS' ||chr(9)|| 'IMEAN' ||chr(9)|| 'STDDEV' ||chr(9)|| 'COLORS' ||chr(9)|| 
       'HCL_MEAN' ||chr(9)|| 'HCL_MAX' ||chr(9)|| 'RED_MEAN' ||chr(9)|| 'GREEN_MEAN' ||chr(9)|| 'BLUE_MEAN' ||chr(9)|| 'EDGES' ||chr(9)|| 'ARIA_MOVE' l
from dual
/

select y.id ||chr(9)|| y.score ||chr(9)|| y.rating ||chr(9)|| y.rnk ||chr(9)|| y.i_width ||chr(9)|| y.i_height ||chr(9)|| y.f_size ||chr(9)||
       y.s_url ||chr(9)|| y.f_url ||chr(9)|| y.fname ||chr(9)|| case when i.ipath like '%xxxxxx%' then 'EXPLICIT' when i.ipath is null then 'DEDUPLICATED' else i.ipath end ||chr(9)||
       i.ibytes ||chr(9)|| i.iwidth ||chr(9)|| i.iheight ||chr(9)|| i.resx ||chr(9)|| i.resy ||chr(9)|| i.resunit ||chr(9)|| i.boundbox ||chr(9)|| i.compqual ||chr(9)|| i.colorspace ||chr(9)||
       round(i.ientr,3) ||chr(9)|| round(i.iskew,2) ||chr(9)|| round(i.imean,3) ||chr(9)|| round(i.istddev,3) ||chr(9)|| i.icolors ||chr(9)|| 
       round(i.meang,3) ||chr(9)|| round(i.maximag,3) ||chr(9)|| round(i.rmean,3) ||chr(9)|| round(i.gmean,3) ||chr(9)|| round(i.bmean,3) ||chr(9)|| round(i.edge,3) ||chr(9)||
       'move "'||replace(replace(replace(replace(replace(replace(replace(regexp_substr(f_url,'[^/]+$'),
                 '%20',' '),'%28','('),'%29',')'),'%40','@'),'%21','!'),'%27',''''),'%','%%')||'" "'||y.fname||'"' l, y.id nnn
from yndr_rip y
left join yndr_im i on y.id=i.fid
where y.rating='s'
order by y.id desc
/

spool off

spool yndr_copyr_char_tags.tsv

select 'TAG_NAME' ||chr(9)|| 'TAG_CAT' ||chr(9)|| 'POSTS_CNT' ||chr(9)|| 'DANB_ID' ||chr(9)||
       'FR_ID' ||chr(9)|| 'FR_NAME' ||chr(9)||
       'MAL_ID' ||chr(9)|| 'MAL_NAME' l
from dual
/

select u.tag ||chr(9)|| u.tag_cat ||chr(9)|| u.cnt ||chr(9)|| nvl(u.tag_id,0) ||chr(9)||
       nvl(nvl(d.group_id,d.tag_id),0) ||chr(9)|| nvl(g.tag_name,'NONE') ||chr(9)||
       nvl(nvl(d.mal_id,g.mal_id),0) ||chr(9)|| nvl(nvl(t.title,c.char_name),'NONE') l
from yndr_tg u
left join danb_tg d on d.tag_id=u.tag_id
left join danb_tg g on nvl(d.group_id,d.tag_id)=g.tag_id
left join mal_titles t on nvl(d.mal_id,g.mal_id)=t.anime_id and u.tag_cat=3
left join mal_chars c on nvl(d.mal_id,g.mal_id)=c.char_id  and u.tag_cat=4
where u.tag_cat in (3,4) and nvl(nvl(d.group_id,d.tag_id),0) not in (18) and u.cnt>2
  and tag not like '%''%''%'
  and nvl(g.tag_name,'X') not like '%''%''%'
order by g.cnt_19 desc nulls last, u.tag_cat, u.cnt desc
/

spool off

spool yndr_posts.tsv

select 'POST_ID' ||chr(9)|| 'CREATED_AT' ||chr(9)|| 'SCORE' ||chr(9)|| 'RATING' ||chr(9)|| 'IMG_WIDTH' ||chr(9)|| 'IMG_HEIGHT' ||chr(9)||
       'FILE_EXT' ||chr(9)|| 'FILE_SIZE' ||chr(9)|| 'FILE_URL' ||chr(9)|| 'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)|| 'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_URL' ||chr(9)|| 
       'JPEG_SIZE' ||chr(9)|| 'JPEG_URL' ||chr(9)|| 'AUTHOR' ||chr(9)|| 'FILE_MD5' ||chr(9)|| 'PARENT_ID' 
from dual
/

select id ||chr(9)|| to_char(created_at,'YYYY-MM-DD HH24:MI') ||chr(9)|| score ||chr(9)|| rating ||chr(9)|| i_width ||chr(9)|| i_height ||chr(9)||
       f_ext ||chr(9)|| f_size ||chr(9)|| f_url ||chr(9)|| s_width ||chr(9)|| s_height ||chr(9)|| s_size ||chr(9)|| s_url ||chr(9)|| j_size ||chr(9)|| j_url ||chr(9)||
       author ||chr(9)|| fmd5 ||chr(9)|| parent_id 
from yndr
order by id  desc
/

spool off

spool yndr_dt.tsv

select 'ID'||chr(9)||'TAG'||chr(9)||'TAG_CAT'||chr(9)||'TAG_RANK'
from dual
/

select id ||chr(9)|| tag ||chr(9)|| decode(nvl(tag_cat,0),-1,0,nvl(tag_cat,0)) ||chr(9)|| rank() over (partition by id, tag_cat order by x) l
from yndr_dt
order by id, decode(tag_cat,3,1,4,2,1,3,9), x
/

spool off

exit
