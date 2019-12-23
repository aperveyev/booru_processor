set verify off
set termout off
set head off
set feedback off
set pagesize 0
set linesize 2400
set trimspool on

spool V2018D.csv

select 'BOORU;FID;IPATH;IFILE;XBYTES;XWIDTH;XHEIGHT;BOUNDW;BOUNDH;BOUNDX;BOUNDY;TBYTES;TWIDTH;THEIGHT;TENTR;TSKEW;TMEAN;TSTDDEV;TCOLORS;MEANGREY;MAXGREY;REDMEAN;GREENMEAN;BLUEMEAN;EDGE;FACES;COPYRTAG1;COPYRTAG2;CHARSTAG1;CHARSTAG2;CHARSTAG3;ARTTAG1'
from dual
/

with fc as (
select fid, '['||s||']' faces from (
select ffile, fid, listagg(f,',') within group (order by flevel desc, facew desc) s
from ( select ffile, substr(ffile,23,instr(ffile,'.')-23) fid, flevel, facew, '{"flevel":"'||flevel||'","facex":"'||facex||'","facey":"'||facey||'","facew":"'||facew||'"}' f,
       row_number() over (partition by ffile order by flevel desc, facew desc) rn from load_face_d where flevel>0 ) where rn<6
group by ffile, fid ) )
select m.booru||';'||m.fid||';'||ipath||';"'||ifile||'";'||
       xbytes||';'||xwidth||';'||xheight||';'||boundw||';'||boundh||';'||boundx||';'||boundy||';'||
       tbytes||';'||twidth||';'||theight||';'||round(tentr,3)||';'||round(tskew,3)||';'||round(tmean,3)||';'||round(tstddev,3)||';'||tcolors||';'||
       round(meang,4)||';'||round(maximag,3)||';'||round(rmean,3)||';'||round(gmean,3)||';'||round(bmean,3)||';'||round(edge,3)||';'||
       faces||';'||copyr_tag_1||';'||copyr_tag_2||';'||chars_tag_1||';'||chars_tag_2||';'||chars_tag_3||';'||artis_tag_1 l
from main_d m
left join fc on fc.fid=m.fid
order by 1
/

spool off

quit

with fc as (
select booru, fid, '['||s||']' faces from (
select ffile, booru_fname.GET_ELEM(ffile,'BOORU') booru, booru_fname.GET_ELEM(ffile,'FID') fid, listagg(f,',') within group (order by flevel desc, facew desc) s
from ( select ffile, flevel, facew, '{"flevel":"'||flevel||'","facex":"'||facex||'","facey":"'||facey||'","facew":"'||facew||'"}' f,
       row_number() over (partition by ffile order by flevel desc, facew desc) rn from load_face_w where flevel>0 ) where rn<6
group by ffile, booru_fname.GET_ELEM(ffile,'BOORU'), booru_fname.GET_ELEM(ffile,'FID') ) )
select m.booru||';'||m.fid||';'||ipath||';"'||ifile||'";'||
       xbytes||';'||xwidth||';'||xheight||';'||boundw||';'||boundh||';'||boundx||';'||boundy||';'||
       tbytes||';'||twidth||';'||theight||';'||round(tentr,3)||';'||round(tskew,3)||';'||round(tmean,3)||';'||round(tstddev,3)||';'||tcolors||';'||
       round(meang,4)||';'||round(maximag,3)||';'||round(rmean,3)||';'||round(gmean,3)||';'||round(bmean,3)||';'||round(edge,3)||';'||
       faces||';'||copyr_tag_1||';'||copyr_tag_2||';'||chars_tag_1||';'||chars_tag_2||';'||chars_tag_3||';'||artis_tag_1 l
from main_w m
left join fc on fc.booru=m.booru and fc.fid=m.fid
where ipath is not null
order by 1
