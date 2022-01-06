set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 4000
set trimspool on
col nnn noprint

spool BC_2015.tsv

SELECT 'BOORU'||chr(9)||'FID'||chr(9)||'RPATH'||chr(9)||'RNK'||chr(9)||'FNAME'||chr(9)||
       'S_FSIZE'||chr(9)||'S_ISIZE'||chr(9)||'S_JQ'||chr(9)||
       'O_FSIZE'||chr(9)||'O_ISIZE'||chr(9)||'O_JQ'||chr(9)||'O_FMD5'||chr(9)||
       'TENTR'||chr(9)||'ENT_R'||chr(9)||'TSKEW'||chr(9)||'SKEW_R'||chr(9)||'TSTDDEV'||chr(9)||'SDEV_R'||chr(9)||
       'TCOLORS'||chr(9)||'COLR_R'||chr(9)||'MEANG'||chr(9)||'GREY_R'||chr(9)||'MAXIMAG'||chr(9)||'GMAX_R'||chr(9)||
       'EDGE'||chr(9)||'EDGE_R'||chr(9)||'EMEAN'||chr(9)||'EMEAN_R'||chr(9)||'EMEANBL'||chr(9)||'EBL_R'||chr(9)||'BOUNDBOX'||chr(9)||'BB_R'||chr(9)||
       'TXSIZE'||chr(9)||'TXS_R'||chr(9)||'TXCNT'||chr(9)||'TXN_R'||chr(9)||
       'S1280'||chr(9)||'K1280'||chr(9)||'S640'||chr(9)||'K640'||chr(9)||'S320'||chr(9)||'K320'||chr(9)||'TXE_R'||chr(9)||
       'YFACE'||chr(9)||'YFACEJ'||chr(9)||'YFMAX'||chr(9)||'YFAVG'||chr(9)||'YF_R'||chr(9)||
       'ISOVR'||chr(9)||'ISOAREA'||chr(9)||'ISALL'||chr(9)||'ISAVG' l
from dual
/

SELECT BOORU||chr(9)||FID||chr(9)||RPATH||chr(9)||RNK||chr(9)||FNAME||chr(9)|| 
       S_FSIZE||chr(9)||S_ISIZE||chr(9)||S_JQ||chr(9)|| 
       O_FSIZE||chr(9)||O_ISIZE||chr(9)||O_JQ||chr(9)||O_FMD5||chr(9)|| 
       rtrim(to_char(TENTR,'FM90.999'),'.')||chr(9)||ENT_R||chr(9)||rtrim(to_char(TSKEW,'FM90.999'),'.')||chr(9)||SKEW_R||chr(9)||rtrim(to_char(TSTDDEV,'FM90.999'),'.')||chr(9)||SDEV_R||chr(9)|| 
       TCOLORS||chr(9)||COLR_R||chr(9)||rtrim(to_char(MEANG,'FM90.9999'),'.')||chr(9)||GREY_R||chr(9)||rtrim(to_char(MAXIMAG,'FM90.999'),'.')||chr(9)||GMAX_R||chr(9)|| 
       rtrim(to_char(EDGE,'FM90.999'),'.')||chr(9)||EDGE_R||chr(9)||rtrim(to_char(EMEAN,'FM90.999'),'.')||chr(9)||EMEAN_R||chr(9)||rtrim(to_char(EMEANBL,'FM90.999'),'.')||chr(9)||EBL_R||chr(9)||BOUNDBOX||chr(9)||BB_R||chr(9)||
       rtrim(to_char(TXSIZE,'FM90.9999'),'.')||chr(9)||TXS_R||chr(9)||TXCNT||chr(9)||TXN_R||chr(9)|| 
       rtrim(to_char(S1280,'FM90.9999'),'.')||chr(9)||K1280||chr(9)||rtrim(to_char(S640,'FM90.9999'),'.')||chr(9)||K640||chr(9)||rtrim(to_char(S320,'FM90.9999'),'.')||chr(9)||K320||chr(9)||TXE_R||chr(9)|| 
       YFACE||chr(9)||YFACEJ||chr(9)||rtrim(to_char(YFMAX,'FM90.9999'),'.')||chr(9)||rtrim(to_char(YFAVG,'FM90.9999'),'.')||chr(9)||YF_R||chr(9)|| 
       ISOVR||chr(9)||rtrim(to_char(ISOAREA,'FM90.999'),'.')||chr(9)||ISALL||chr(9)||rtrim(to_char(ISAVG,'FM90.999'),'.') ln,
       booru||lpad(fid,10,'0') nnn
FROM BCO_A
where rpath is not null
order by 2
/

spool off

exit

spool BC_2015_tags.tsv

select 'BOORU'||chr(9)||'FID'||chr(9)||'TAG'||chr(9)||'TAG_ID'||chr(9)||'TAG_CAT'||chr(9)||'DANB_TAG'  l
from dual
/

select d.booru||chr(9)||d.id||chr(9)||d.orig_tag||chr(9)||nvl(d.tag_id,0)||chr(9)||nvl(d.tag_cat,-1)||chr(9)|| 
       case when g.tag_name!=d.orig_tag then g.tag_name
            when t.tag_name!=d.orig_tag then t.tag_name
              else to_char(null) end ln,
      d.booru||lpad(d.id,10,'0')||decode(nvl(d.tag_cat,-1),3,1,4,2,1,3,0,4,5,5,-1,6) nnn
from bco_dt d
join bco_a b on b.booru=d.booru and b.fid=d.id and b.rpath is not null -- as filter
left join danb_tg t on d.tag_id=t.tag_id
left join danb_tg g on g.tag_id=t.group_id
order by 2
/

spool off

spool BC_KC.tsv

SELECT 'BOORU'||chr(9)||'FID'||chr(9)||'TN'||chr(9)||'TX'||chr(9)||'TY'||chr(9)||'TW'||chr(9)||'TH' l
from dual
/

select d.booru||chr(9)||d.fid||chr(9)||t_n||chr(9)||t_x||chr(9)||t_y||chr(9)||t_w||chr(9)||t_h ln,
       d.booru||lpad(d.fid,10,'0')||lpad(t_n,4,'0') nnn
from bc_kc_det d
join bco_a b on b.booru=d.booru and b.fid=d.fid and b.rpath is not null -- as filter
order by 2
/

spool off

spool BC_IS.tsv

SELECT 'BOORU'||chr(9)||'FID'||chr(9)||'NN'||chr(9)||'BBOX'||chr(9)||'CX'||chr(9)||'CY'||chr(9)||'SZ'||chr(9)||'COLR' l
from dual
/

select d.booru||chr(9)||d.fid||chr(9)||nn||chr(9)||bbox||chr(9)||round(cx)||chr(9)||round(cy)||chr(9)||sz||chr(9)||colr ln,
       d.booru||lpad(d.fid,10,'0')||lpad(nn,4,'0') nnn
from bc_is d
join bco_a b on b.booru=d.booru and b.fid=d.fid and b.rpath is not null -- as filter
order by 2
/

spool off

spool BC_Y.csv

select 'BOORU'||chr(9)||'FID'||chr(9)||'BATCH_ID'||chr(9)||'OBJ'||chr(9)||'PROB'||chr(9)||'X'||chr(9)||'Y'||chr(9)||'W'||chr(9)||'H'||chr(9)||
       'OID'||chr(9)||'SUPPR'||chr(9)||'SID'||chr(9)||'OUP'||chr(9)||'ODN' lin 
from dual
/

select d.booru||chr(9)||d.fid||chr(9)||batch_id||chr(9)||obj||chr(9)||rtrim(to_char(prob,'FM90.999'),'.')||chr(9)||rtrim(to_char(x,'FM90.999'),'.')||chr(9)||rtrim(to_char(y,'FM90.999'),'.')||chr(9)||
       rtrim(to_char(w,'FM90.999'),'.')||chr(9)||rtrim(to_char(h,'FM90.999'),'.')||chr(9)||oid||chr(9)||suppr||chr(9)||sid||chr(9)||oup||chr(9)||odn lin,
       d.booru||lpad(d.fid,11,'0')||decode(batch_id,'SS',2,1)||decode(obj,0,0,1,1,3,1,2)||rtrim(to_char(y,'FM90.999'),'.') nnn
from yolobo d
join bco_a b on b.booru=d.booru and b.fid=d.fid and b.rpath is not null -- as filter
order by 2
/
