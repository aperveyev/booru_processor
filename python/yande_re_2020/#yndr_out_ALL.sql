set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on
col nnn noprint

spool yndr_rip_ALL.tsv

select 'POST_ID' ||chr(9)|| 'SCORE' ||chr(9)|| 'RATING' ||chr(9)|| 'POST_RANK' ||chr(9)|| 'IMG_WIDTH' ||chr(9)|| 'IMG_HEIGHT' ||chr(9)|| 'FILE_SIZE' ||chr(9)||
       'SAMPLE_URL' ||chr(9)|| 'FILE_URL' ||chr(9)|| 'LOCAL_FILE_NAME' ||chr(9)|| 'LOCAL_PATH' ||chr(9)||
       'SAMPLE_SIZE' ||chr(9)|| 'SAMPLE_WIDTH' ||chr(9)|| 'SAMPLE_HEIGHT' ||chr(9)|| 'RES_X' ||chr(9)|| 'RES_Y' ||chr(9)|| 'RES_UNIT' ||chr(9)|| 'BOUNDBOX' ||chr(9)|| 'JPEG_QUALITY' ||chr(9)|| 'COLORSPACE' ||chr(9)||
       'ENTHROPY' ||chr(9)|| 'SKEWNESS' ||chr(9)|| 'IMEAN' ||chr(9)|| 'STDDEV' ||chr(9)|| 'COLORS' ||chr(9)|| 
       'HCL_MEAN' ||chr(9)|| 'HCL_MAX' ||chr(9)|| 'RED_MEAN' ||chr(9)|| 'GREEN_MEAN' ||chr(9)|| 'BLUE_MEAN' ||chr(9)|| 'EDGES' ||chr(9)|| 'ARIA_MOVE' l
from dual
/

select y.id ||chr(9)|| y.score ||chr(9)|| y.rating ||chr(9)|| y.rnk ||chr(9)|| y.i_width ||chr(9)|| y.i_height ||chr(9)|| y.f_size ||chr(9)||
       y.s_url ||chr(9)|| y.f_url ||chr(9)|| nvl(v.fname,y.fname) ||chr(9)|| 
       case when v.fpath like '%EXPLICIT%' then 'EXPLICIT' when v.fpath like '%EXCLUDED%' then 'EXCLUDED' when v.fpath is null then 'DEDUPLICATED' else substr(v.fpath,10) end ||chr(9)||
       i.ibytes ||chr(9)|| i.iwidth ||chr(9)|| i.iheight ||chr(9)|| i.resx ||chr(9)|| i.resy ||chr(9)|| i.resunit ||chr(9)|| i.boundbox ||chr(9)|| i.compqual ||chr(9)|| i.colorspace ||chr(9)||
       round(i.ientr,3) ||chr(9)|| round(i.iskew,2) ||chr(9)|| round(i.imean,3) ||chr(9)|| round(i.istddev,3) ||chr(9)|| i.icolors ||chr(9)|| 
       round(i.meang,3) ||chr(9)|| round(i.maximag,3) ||chr(9)|| round(i.rmean,3) ||chr(9)|| round(i.gmean,3) ||chr(9)|| round(i.bmean,3) ||chr(9)|| round(i.edge,3) ||chr(9)||
       'move "'||replace(replace(replace(replace(replace(replace(replace(regexp_substr(f_url,'[^/]+$'),
                 '%20',' '),'%28','('),'%29',')'),'%40','@'),'%21','!'),'%27',''''),'%','%%')||'" "'||y.fname||'"' l, y.id nnn
from yndr_rip y
left join yndr_im i on y.id=i.fid
left join dir_bs_ext_v v on v.fid=y.id
order by y.id desc
/

spool off
