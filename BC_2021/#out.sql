set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on
col nnn noprint

spool BC_posts.tsv

SELECT 'BOORU'||chr(9)||'FID'||chr(9)||'TORR_PATH'||chr(9)||'TORR_FNAME'||chr(9)||'TORR_FSIZE'||chr(9)||'TORR_ISIZE'||chr(9)||
       'BOUNDBOX'||chr(9)||'S_JQ'||chr(9)||'R_ALL'||chr(9)||'TENTR'||chr(9)||'R_ENTR'||chr(9)||
       'TSKEW'||chr(9)||'TSTDDEV'||chr(9)||'R_SDEV'||chr(9)||'TCOLORS'||chr(9)||'R_COLOR'||chr(9)||
       'MEANG'||chr(9)||'R_MEANG'||chr(9)||'EDGE'||chr(9)||'R_EDGE'||chr(9)||
       'ORIG_FSIZE'||chr(9)||'ORIG_ISIZE'||chr(9)||'ORIG_JQ'||chr(9)||'ORIG_MD5'||chr(9)||
       'POST_DT'||chr(9)||'RATING'||chr(9)||'SCORE'||chr(9)||'FAVS'||chr(9)||'POST_EXT'||chr(9)||
       'TAGS_COPYR'||chr(9)||'TAGS_CHARS'||chr(9)||'TAGS_ART'||chr(9)||'TAGS_GEN'||chr(9)||'TAGS_ETC'||chr(9)||
       'POST_FSIZE'||chr(9)||'POST_ISIZE'||chr(9)||'POST_MD5'
from dual
/

select booru||chr(9)||fid||chr(9)||ipath||chr(9)||fname||chr(9)||s_fsize||chr(9)||s_isize||chr(9)||
       boundbox||chr(9)||s_jq||chr(9)||r_all||chr(9)||rtrim(to_char(tentr,'FM90.999'),'.')||chr(9)||r_entr||chr(9)||
       rtrim(to_char(tskew,'FM90.99'),'.')||chr(9)||rtrim(to_char(tstddev,'FM90.999'),'.')||chr(9)||r_sdev||chr(9)||tcolors||chr(9)||r_color||chr(9)||
       rtrim(to_char(meang,'FM90.9999'),'.')||chr(9)||r_meang||chr(9)||rtrim(to_char(edge,'FM90.999'),'.')||chr(9)||r_edge||chr(9)||
       o_fsize||chr(9)||o_isize||chr(9)||o_jq||chr(9)||o_fmd5||chr(9)||
       to_char(p_dt,'YYYY-MM-DD')||chr(9)||ratn||chr(9)||scor||chr(9)||favs||chr(9)||fext||chr(9)||
       tags_c||chr(9)||tags_p||chr(9)||tags_a||chr(9)||tags_g||chr(9)||tags_x||chr(9)||
       p_fsize||chr(9)||p_isize||chr(9)||p_fmd5 lin,
       booru||lpad(fid,10,'0') nnn
from bct
order by 2
/

spool off

exit

spool BCS_arch.tsv

SELECT 'BOORU'||chr(9)||'FID'||chr(9)||'FVOLUME'||chr(9)||'FILENAME'||chr(9)||
       'IMAGESIZE'||chr(9)||'FILESIZE'||chr(9)||'JPEGQ'||chr(9)||'FMD5' ll
from dual
/

select h.booru||chr(9)||h.fid||chr(9)||substr(h.fpath,8,instr(h.fpath,'\',1,3)-8)||chr(9)||h.fname||chr(9)||
       r.imagesize||chr(9)||r.filesize||chr(9)||r.jq||chr(9)||h.fmd5 lin,
       r.sourcefile nnn
from arch_exif_2021a r
join arch_md5_2021a h on r.booru=h.booru and r.fid=h.fid
where h.fpath not like '%v2014%' and h.fpath not like '%v2016x%' 
  and substr(h.fpath,8,instr(h.fpath,'\',1,3)-8) is not null
  and h.booru not in ('animepaper','tag')  
order by 2
/

spool off

exit



spool BCS_torr.tsv

SELECT 'TORR'||chr(9)||'BOORU'||chr(9)||'FID'||chr(9)||'SOURCEFILE'||chr(9)||'IMAGESIZE'||chr(9)||'FILESIZE'||chr(9)||
       'IFMT'||chr(9)||'FDATE'||chr(9)||'FMD5'||chr(9)||'ZPATH' ll
from dual
/

select e.torr||chr(9)||e.booru||chr(9)||e.fid||chr(9)||e.sourcefile||chr(9)||e.imagesize||chr(9)||e.filesize||chr(9)||
       e.ifmt||chr(9)||to_char(e.filecreatedate,'YYYY-MM-DD')||chr(9)||fmd5||chr(9)||e.zpath lin,
       e.torr||e.zpath||e.sourcefile nnn
from zip_exif e
join zip_md5 m on e.torr=m.torr and e.sourcefile=m.fname
where e.torr not in ('1000 Authors of Anime Art','= exehint coll =','Animepaper.net','Animepaper.Scans')
order by 2
/

spool off

exit




spool BC_tags.tsv

select 'BOORU'||chr(9)||'FID'||chr(9)||'TAG'||chr(9)||'TAG_ID'||chr(9)||'TAG_CAT'||chr(9)||'DANB_TAG'  l
from dual
/

select d.booru||chr(9)||d.id||chr(9)||d.orig_tag||chr(9)||nvl(d.tag_id,0)||chr(9)||nvl(d.tag_cat,-1)||chr(9)|| 
       case when g.tag_name!=d.orig_tag then g.tag_name
            when t.tag_name!=d.orig_tag then t.tag_name
              else to_char(null) end ln,
      d.booru||lpad(d.id,10,'0')||decode(nvl(d.tag_cat,-1),3,1,4,2,1,3,0,4,5,5,-1,6) nnn
from bct_dt d
join bct b on b.booru=d.booru and b.fid=d.id -- as filter
left join danb_tg t on d.tag_id=t.tag_id
left join danb_tg g on g.tag_id=t.group_id
order by 2
/

spool off

exit
