set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on

spool ZERO_TAGS.TSV

select 'ID'||chr(9)||'TAG'||chr(9)||'TAG_CAT'||chr(9)||'TAG_RANK'
from dual
/

select id ||chr(9)|| tag ||chr(9)|| decode(tag_cat,-1,0,tag_cat) ||chr(9)|| rank() over (partition by id, tag_cat order by tag) l
from zero_dt
where tag not in ('TAGFAIL')
order by id, decode(tag_cat,3,1,4,2,1,3,9), r
/

spool off

spool ZERO_POSTS.TSV

select 'ID'||chr(9)||'FILE_NAME'||chr(9)||'MD5'||chr(9)||'IMAGE_SIZE'||chr(9)||'FILE_SIZE'||chr(9)||'IMAGE_URL'||chr(9)||'CREATED_AT'
from dual
/

select d.fid ||chr(9)|| l.ifile ||chr(9)|| fmd5 ||chr(9)|| imagesize ||chr(9)|| filesize ||chr(9)||
       nvl(y.furl,'NOT_RETRIEVED') ||chr(9)|| nvl(to_char(y.created_at,'YYYY-MM-DD HH24:MI'),'2018-01-01 00:00') l
from zero_f d
join ( select substr(replace(fline,chr(13),''),37,7) fid, substr(replace(fline,chr(13),''),18) ifile, replace(fline,chr(13),'') fline from DIR_BS_EXT ) l on l.fid=d.fid
left join zero y on d.fid=y.id
where d.ifmt is not null
  and substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1) between 0.248 and 4
order by d.fid  
/

spool off

quit
