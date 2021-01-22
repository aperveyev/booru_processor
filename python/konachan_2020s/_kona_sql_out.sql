set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 28000
set trimspool on
col nnn noprint

spool kona_rip.tsv

select 'POST_ID' ||chr(9)|| 'SCORE' ||chr(9)|| 'RATING' ||chr(9)|| 'POST_RANK' ||chr(9)|| 'IMG_WIDTH' ||chr(9)|| 'IMG_HEIGHT' ||chr(9)|| 'FILE_SIZE' ||chr(9)||
       'SAMPLE_URL' ||chr(9)|| 'FILE_URL' ||chr(9)|| 'LOCAL_FILE_NAME' ||chr(9)|| 'LOCAL_PATH' ||chr(9)||
       'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)|| 'RES_X' ||chr(9)|| 'RES_Y' ||chr(9)|| 'RES_UNIT' ||chr(9)|| 'BOUNDBOX' ||chr(9)|| 'JPEG_QUALITY' ||chr(9)|| 'COLORSPACE' ||chr(9)||
       'ENTHROPY' ||chr(9)|| 'SKEWNESS' ||chr(9)|| 'IMEAN' ||chr(9)|| 'STDDEV' ||chr(9)|| 'COLORS' ||chr(9)|| 
       'HCL_MEAN' ||chr(9)|| 'HCL_MAX' ||chr(9)|| 'RED_MEAN' ||chr(9)|| 'GREEN_MEAN' ||chr(9)|| 'BLUE_MEAN' ||chr(9)|| 'EDGES' ||chr(9)|| 'ARIA_MOVE' l
from dual
/

select y.id ||chr(9)|| y.score ||chr(9)|| y.rating ||chr(9)|| y.rnk ||chr(9)|| y.i_width ||chr(9)|| y.i_height ||chr(9)|| y.f_size ||chr(9)||
       y.s_url ||chr(9)|| y.f_url ||chr(9)|| y.fname ||chr(9)||
       case when v.fpath is null then case when i.ipath is null then 'DEDUPLICATED' else 'EXPLICIT' end else substr(v.fpath,10) end ||chr(9)||
       i.ibytes ||chr(9)|| i.iwidth ||chr(9)|| i.iheight ||chr(9)|| i.resx ||chr(9)|| i.resy ||chr(9)|| i.resunit ||chr(9)|| i.boundbox ||chr(9)|| i.compqual ||chr(9)|| i.colorspace ||chr(9)||
       round(i.ientr,3) ||chr(9)|| round(i.iskew,2) ||chr(9)|| round(i.imean,3) ||chr(9)|| round(i.istddev,3) ||chr(9)|| i.icolors ||chr(9)|| 
       round(i.meang,3) ||chr(9)|| round(i.maximag,3) ||chr(9)|| round(i.rmean,3) ||chr(9)|| round(i.gmean,3) ||chr(9)|| round(i.bmean,3) ||chr(9)|| round(i.edge,3) ||chr(9)||
       'move "'||replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(regexp_substr(f_url,'[^/]+$'),
                 '%20',' '),'%28','('),'%29',')'),'%26','&'),'%23','#'),'%40','@'),'%21','!'),'%2B','+'),'%27',''''),'%','%%')||'" "'||
                 replace(y.fname,'.jpg','.'||regexp_substr(f_url,'[^.]+$'))||'"' l, y.id nnn
from kona_rip y
left join dir_bs_ext_v v on y.id=v.fid
left join kona_imm i on y.id=i.fid
order by y.id desc
/

spool kona_repack.tsv

select 'POST_ID' ||chr(9)|| 'GRAB_SRC' ||chr(9)|| 'JPEG_Q' ||chr(9)|| 'JPEG_Q_M' ||chr(9)|| 'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_SIZE_M' ||chr(9)||
       'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)||
       'ENTHROPY' ||chr(9)|| 'ENTHROPY_M' ||chr(9)|| 'ENTHR_DELTA' ||chr(9)|| 'ENTHR_D_RANK' ||chr(9)||
       'SKEWNESS' ||chr(9)|| 'SKEWNESS_M' ||chr(9)|| 'SKEW_DELTA' ||chr(9)||
       'STDDEV' ||chr(9)|| 'STDDEV_M' ||chr(9)|| 'STDDEV_DELTA' ||chr(9)||
       'COLORS' ||chr(9)|| 'COLORS_M' ||chr(9)|| 'COLORS_DELTA' ||chr(9)|| 'COLORS_D_RANK' ||chr(9)||
       'HCL_MEAN' ||chr(9)|| 'HCL_MEAN_M' ||chr(9)|| 'HCL_MEAN_DELTA' ||chr(9)||
       'EDGES' ||chr(9)|| 'EDGES_M' ||chr(9)|| 'EDGES_DELTA' ||chr(9)|| 'EDGES_D_RANK'
from dual
/

select i.fid ||chr(9)|| k.d_src ||chr(9)|| i.compqual ||chr(9)|| m.compqual ||chr(9)|| i.ibytes ||chr(9)|| m.ibytes ||chr(9)||
       i.iwidth ||chr(9)|| i.iheight ||chr(9)|| 
       round(i.ientr,3) ||chr(9)|| round(m.ientr,3) ||chr(9)|| round(abs(i.ientr-m.ientr)/greatest(i.ientr,m.ientr),3) ||chr(9)||
                                             rank() over (order by round(abs(i.ientr-m.ientr)/greatest(i.ientr,m.ientr),3) desc) ||chr(9)||
       round(i.iskew,3) ||chr(9)|| round(m.iskew,3) ||chr(9)|| round(abs(i.iskew-m.iskew)/abs(greatest(i.iskew,m.iskew)),3) ||chr(9)||
       round(i.istddev,3) ||chr(9)|| round(m.istddev,3) ||chr(9)|| round(abs(i.istddev-m.istddev)/greatest(i.istddev,m.istddev),3) ||chr(9)||
       i.icolors ||chr(9)|| m.icolors ||chr(9)|| round(abs(i.icolors-m.icolors)/greatest(i.icolors,m.icolors),3) ||chr(9)||
                                                 rank() over (order by round(abs(i.icolors-m.icolors)/greatest(i.icolors,m.icolors),3) desc) ||chr(9)||
       round(i.meang,4) ||chr(9)|| round(m.meang,4) ||chr(9)|| round(abs(i.meang-m.meang)/greatest(i.meang,m.meang),3) ||chr(9)||
       round(i.edge,3) ||chr(9)|| round(m.edge,3) ||chr(9)|| round(abs(i.edge-m.edge)/greatest(i.edge,m.edge),3) ||chr(9)||
                                           rank() over (order by round(abs(i.edge-m.edge)/greatest(i.edge,m.edge),3) desc) l, i.fid nnn
from kona_im i
join kona_imm m on m.fid=i.fid and m.ibytes!=i.ibytes
join kona_rip k on i.fid=k.id
order by 2 desc
/

spool kona_tags.tsv

select 'ID'||chr(9)||'TAG'||chr(9)||'TAG_CAT'||chr(9)||'TAG_RANK'
from dual
/

select id ||chr(9)|| tag ||chr(9)|| decode(nvl(tag_cat,0),-1,0,nvl(tag_cat,0)) ||chr(9)|| rank() over (partition by id, tag_cat order by x) l
from kona_dt
order by id, decode(tag_cat,3,1,4,2,1,3,9), x
/

spool off

spool kona_posts.tsv

select 'POST_ID' ||chr(9)|| 'CREATED_AT' ||chr(9)|| 'SCORE' ||chr(9)|| 'RATING' ||chr(9)|| 'IMG_WIDTH' ||chr(9)|| 'IMG_HEIGHT' ||chr(9)||
       'FILE_SIZE' ||chr(9)|| 'FILE_URL' ||chr(9)|| 'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)|| 'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_URL' ||chr(9)|| 
       'JPEG_SIZE' ||chr(9)|| 'JPEG_URL' ||chr(9)|| 'AUTHOR' ||chr(9)|| 'FILE_MD5' ||chr(9)|| 'PARENT_ID' 
from dual
/

select id ||chr(9)|| to_char(created_at,'YYYY-MM-DD HH24:MI') ||chr(9)|| score ||chr(9)|| rating ||chr(9)|| i_width ||chr(9)|| i_height ||chr(9)||
       f_size ||chr(9)|| f_url ||chr(9)|| s_width ||chr(9)|| s_height ||chr(9)|| s_size ||chr(9)|| s_url ||chr(9)|| j_size ||chr(9)|| j_url ||chr(9)||
       author ||chr(9)|| fmd5 ||chr(9)|| parent_id 
from kona
order by id  desc
/

spool off

spool KONA_JSON.tsv

select id ||chr(9) ||nvl(jj,j) l
from kona_load
where length(nvl(jj,j)) > 60
order by id
/

spool off
