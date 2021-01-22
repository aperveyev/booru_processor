set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on
col nnn noprint

spool ess_tags.tsv

select 'POST_ID'||chr(9)||'TAG'||chr(9)||'TAG_CAT'||chr(9)||'TAG_RANK'
from dual
/

select id ||chr(9)|| tag ||chr(9)|| tag_cat ||chr(9)|| n l
from ess_dt_ld
where id between 1 and 1046967
order by id desc, decode(tag_cat,3,1,4,2,1,3,9), n
/

spool off

spool ess_posts.tsv

select 'POST_ID' ||chr(9)|| 'POST_DT' ||chr(9)|| 'FILE_SIZE' ||chr(9)|| 'IMG_FMT' ||chr(9)|| 'FILE_MD5' ||chr(9)||
       'IMAGE_SIZE' ||chr(9)|| 'FAV_COUNT' ||chr(9)|| 'FILE_NAME' ||chr(9)|| 'TORR_PATH' ||chr(9)||
       'TAGS_GENERAL' ||chr(9)|| 'TAGS_COPYR' ||chr(9)|| 'TAGS_CHAR' ||chr(9)|| 'TAGS_ARTIST'
from dual
/

select l.id ||chr(9)|| to_char(l.fdt,'YYYY-MM-DD HH24:MI') ||chr(9)|| nvl(z.filesize,0) ||chr(9)|| nvl(ifmt,'NONE') ||chr(9)||
       nvl(fmd5,'--------------------------------') ||chr(9)|| nvl2(z.iw,z.iw||'x'||z.ih,l.isize) ||chr(9)|| l.favn ||chr(9)||
       nvl(z.fname,'none') ||chr(9)|| nvl(replace(z.fpath,'\\','\'),'none') ||chr(9)|| 
       nvl(l.tags,'none') ||chr(9)|| nvl(l.tagc,'misc') ||chr(9)|| nvl(l.tagp,'unknown') ||chr(9)|| nvl(l.taga,'anonymous') l,
       l.id nnn
from ess_ld l
left join ess_zip z on l.id=z.fid
where l.id between 1 and 1046967
order by l.id desc
/

spool off

exit
