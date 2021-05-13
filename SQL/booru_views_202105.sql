prompt PL/SQL Developer Export User Objects for user BOORU@HH19
set define off
spool booru_views_202105.log

prompt
prompt Creating view ARCH_EXIF_2020_V
prompt ==============================
prompt
create or replace force view arch_exif_2020_v as
select booru, fid,
       replace(substr(substr(sourcefile,instr(sourcefile,'/',1,2)+1),1,6),'.','') voly,
       replace(substr(substr(sourcefile,instr(sourcefile,'.')+1),1,4),'/','') volar,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       filesize, jq,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       round(substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1),4) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       replace(substr(sourcefile,1,instr(sourcefile,'/',-1)-1),'/','\') fpath,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       replace(sourcefile,'/','\') sourcefile, filecreatedate, ifmt
from  arch_exif_2021A;

prompt
prompt Creating view ARCH_EXIF_V
prompt =========================
prompt
create or replace force view arch_exif_v as
select booru, fid,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       substr(sourcefile,instr(sourcefile,'/',1,2)+1,instr(sourcefile,'.')-instr(sourcefile,'/',1,2)-1) ydir,
       substr(sourcefile,instr(sourcefile,'.')+1,instr(sourcefile,'/',1,3)-instr(sourcefile,'.')-1) adir,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       filesize, ifmt, jq,
       substr(sourcefile,instr(sourcefile,'.',-1)+1) fext,
       replace(substr(sourcefile,1,instr(sourcefile,'/',-1)-1),'/','\') fpath,
       substr(sourcefile,instr(sourcefile,'/',1,2)+1,instr(sourcefile,'/',1,3)-instr(sourcefile,'/',1,2)-1) vdir,
       replace(sourcefile,'/','\') sourcefile, filecreatedate
from  arch_exif_2021A;

prompt
prompt Creating view BOORU_FMD5_V
prompt ==========================
prompt
create or replace force view booru_fmd5_v as
select 'anime-pictures.net' booru, id, fmd5 from apic union all
select 'konachan.com' booru, id, fmd5 from kona union all
select 'danbooru.donmai.us' booru, fid id, fmd5 from arch_md5_alt where booru='danbooru.donmai.us' union all
select 'gelbooru.com' booru, e.id, t.fmd5 from glb_load e, json_table ( e.j, '$' columns ( id number path '$.id', fmd5 path '$.hash' ) ) t  union all
select 'chan.sankakucomplex.com' booru, fid id, case when furl like '%sample%' then substr(furl,55,32) else substr(furl,41,32) end fmd5 from snk_ld union all
select 'chan.sankakucomplex.com' booru, fid id, case when furl like '%sample%' then substr(furl,55,32) else substr(furl,41,32) end fmd5 from snk_lda union all
select 'chan.sankakucomplex.com' booru, fid id, case when furl like '%sample%' then substr(furl,55,32) else substr(furl,41,32) end fmd5 from snk_ldo union all
select 'chan.sankakucomplex.com' booru, fid id, substr(furl,55,32) fmd5 from snk_sl union all
select 'tbib.org' booru, id, fmd5 from tbib union all
select 'tbib.org' booru, id, fmd5 from tbibo union all
select 'yande.re' booru, id, fmd5 from yndr;

prompt
prompt Creating view DANB_TG_ALT
prompt =========================
prompt
create or replace force view danb_tg_alt as
select antecedent_name alt_name, t.tag_name, t.tag_id, t.tag_cat, 'ALIAS-A' alt
from danb_tg_alias a
join danb_tg t on t.tag_name=consequent_name and t.tag_cat in (1,3,4,0,5)
union
select consequent_name alt_name, t.tag_name, t.tag_id, t.tag_cat, 'ALIAS-C' alt
from danb_tg_alias a
join danb_tg t on t.tag_name=antecedent_name and t.tag_cat in (1,3,4,0,5)
union
select consequent_name alt_name, antecedent_name tag_name, a.c_id, a.tag_cat, 'ALIAS-X' alt
from danb_tg_alias a
where a.booru!='danbooru.donmai.us'
union
select s.tag alt_name, t.tag_name, t.tag_id, t.tag_cat, 'SB' alt
from sb_tags s
join danb_tg t on t.tag_id=s.tag_id and t.tag_cat in (1,3,4,0,5) and s.tag!=t.tag_name
/*union
select replace(lower(tag),' ','_') alt_name, t.tag_name, t.tag_id, t.tag_cat, 'ESS' alt
from ess_tg_c c
join danb_tg t on t.tag_id=c.tag_id and t.tag_cat in (1,3,4) and replace(lower(c.tag),' ','_')!=t.tag_name*/;

prompt
prompt Creating view DIR_BS_EXT_V
prompt ==========================
prompt
create or replace force view dir_bs_ext_v as
select replace(fline,chr(13),'') fline,
       replace(booru_fname.GET_ELEM(fline,'FNAME'),chr(13),'') fname,
       booru_fname.GET_ELEM(fline,'FPATH') fpath,
       booru_fname.GET_ELEM(fline,'FID') fid,
       booru_fname.GET_ELEM(fline,'BOORU') booru,
       booru_fname.GET_ELEM(fline,'COPYR') copyr,
       booru_fname.GET_ELEM(fline,'ARTIS') artis,
       replace(substr(fline,instr(fline ,'.',-1)+1),chr(13),'') fext,
       to_number(regexp_substr(regexp_substr(fline,'[^\]+$'),'[0-9]+',1,1)) fnum1,
       to_number(regexp_substr(regexp_substr(fline,'[^\]+$'),'[0-9]+',1,2)) fnum2
from dir_bs_ext
where length(fline)>32;

prompt
prompt Creating view EXIF_EXT_V
prompt ========================
prompt
create or replace force view exif_ext_v as
select booru_fname.GET_ELEM(replace(sourcefile,'/','\'),'BOORU') booru,
       booru_fname.GET_ELEM(replace(sourcefile,'/','\'),'FID') fid,
       filesize,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       round(substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1),4) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       to_date(replace(substr(filecreatedate,1,10),':','.')||substr(filecreatedate,11,9),'YYYY.MM.DD HH24:MI:SS') filecreatedate,
       ifmt,
       case when jq  like '<%' then 0 else to_number(replace(jq,chr(13),'')) end jq,
       replace(substr(sourcefile,1,instr(sourcefile,'/',-1)-1),'/','\') fpath,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       substr(sourcefile,instr(sourcefile,'.',-1)+1) fext,
       replace(sourcefile,'/','\') sourcefile
from exif_ext
where sourcefile!='SourceFile';

prompt
prompt Creating view FCIV_EXT_V
prompt ========================
prompt
create or replace force view fciv_ext_v as
select fmd5, fname fline,
       booru_fname.GET_ELEM(fname,'FNAME') fname,
       booru_fname.GET_ELEM(fname,'FPATH') fpath,
       booru_fname.GET_ELEM(fname,'BOORU') booru,
       booru_fname.GET_ELEM(fname,'FID') fid,
       substr(fname,instr(fname,'.',-1)+1) fext,
       to_number(regexp_substr(booru_fname.GET_ELEM(fname,'FNAME'),'[0-9]+',1,1)) fnum1,
       to_number(regexp_substr(booru_fname.GET_ELEM(fname,'FNAME'),'[0-9]+',1,2)) fnum2
from fciv_ext
where length(fname)>20;

prompt
prompt Creating view GRAB_TXT_V
prompt ========================
prompt
create or replace force view grab_txt_v as
select substr(t.fline,1,instr(t.fline,'---')-2) booru,
       substr(t.fline,instr(t.fline,'---')+4,instr(t.fline,'---',1,2)-instr(t.fline,'---')-5) fid,
       trim(substr(regexp_substr(substr(t.fline,instr(t.fline,'---')+4),'\-{3}([^~{3}]+)'),4)) copyright,
       trim(substr(regexp_substr(t.fline,'\#{3}([^@{3}]+)'),4)) artist,
       substr(t.fline,instr(t.fline,'~~')+4,instr(t.fline,'##')-instr(t.fline,'~~')-5) characters,
       trim(substr(regexp_substr(t.fline,'\@{3}([^${3}]+)'),4)) tagall,
       case when t.fline like '%$$$%' and fline not like '%$$$  &%' then
          grab_log_date(substr(t.fline,instr(t.fline,'$$')+4,instr(t.fline,'&&&')-instr(t.fline,'$$')-5))
       end fdate,
       case when t.fline like '%&&&%' and fline not like '%& unknown ^^%' then substr(t.fline,instr(t.fline,'&&&')+4,instr(t.fline,'^^')-instr(t.fline,'&&&')-5) else 'NONE' end frating,
       case when t.fline like '%^^%' then
         case when t.fline like '%***%' then trim(substr(t.fline,instr(t.fline,'^^')+3,instr(t.fline,'**')-instr(t.fline,'^^')-3))
              else substr(t.fline,instr(t.fline,'^^')+3) end
         else '0' end fscore,
       case when t.fline like '%***%' then substr(t.fline,instr(t.fline,'**')+4,instr(t.fline,'==')-instr(t.fline,'**')-5) else '0x0' end sizes,
       case when t.fline like '%***%' then substr(t.fline,instr(t.fline,'===')+4) else 'XXX' end fext,
       t.fline
-- %website% --- %id% --- %copyright% ~~~ %character% ### %artist% @@@ %all% $$$ %date:format=yyyy-MM-dd% & %rating% ^^^ %score% *** %width%x%height% === %ext%
from GRAB_TXT_EXT t
where t.fline like '%$$$%' -- sometimes tags > 4000 chars and extab truncate it
;

prompt
prompt Creating view GRAB_TXT_VZ
prompt =========================
prompt
create or replace force view grab_txt_vz as
select substr(t.fline,1,instr(t.fline,'---')-2) booru,
       substr(t.fline,instr(t.fline,'---')+4,instr(t.fline,'---',1,2)-instr(t.fline,'---')-5) fid,
       replace(replace(substr(t.fline,instr(t.fline,'@@@')+4,instr(t.fline,'$$$')-instr(t.fline,'@@@')-5),'...',''),'e','e') tagall,
       substr(t.fline,instr(t.fline,'$$$')+4,10) fdate,
       t.fline
-- select *
from GRAB_TXT_EXT t
;

prompt
prompt Creating view LOAD_EXIF_C_V
prompt ===========================
prompt
create or replace force view load_exif_c_v as
select booru, fid, filesize,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       sourcefile, filecreatedate, ifmt
from  load_exif_c;

prompt
prompt Creating view LOAD_EXIF_G_V
prompt ===========================
prompt
create or replace force view load_exif_g_v as
select filesize, booru, fid,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       sourcefile, filecreatedate
from  load_exif_g;

prompt
prompt Creating view LOAD_EXIF_V
prompt =========================
prompt
create or replace force view load_exif_v as
select booru, fid,
       substr(sourcefile,instr(sourcefile ,'/',-1)+1) fname,
       replace(substr(sourcefile,1,instr(sourcefile,'/',-1,1)-1),'/','\') fpath,
       substr(sourcefile,instr(sourcefile,'/',-1,2)+1,instr(sourcefile,'/',-1)-instr(sourcefile,'/',-1,2)-1) ldir,
       filesize, filecreatedate fdate,
       substr(imagesize,1,instr(imagesize,'x')-1) iw, substr(imagesize,instr(imagesize,'x')+1) ih,
       substr(imagesize,1,instr(imagesize,'x')-1) / substr(imagesize,instr(imagesize,'x')+1) ar,
       substr(imagesize,1,instr(imagesize,'x')-1) * substr(imagesize,instr(imagesize,'x')+1) px,
       replace(sourcefile,'/','\') fline,
       to_number(regexp_substr(substr(sourcefile,instr(sourcefile ,'/',-1)+1),'[0-9]+',1,1)) fnum1,
       to_number(regexp_substr(substr(sourcefile,instr(sourcefile ,'/',-1)+1),'[0-9]+',1,2)) fnum2,
       ifmt, jq
from  load_exif;

prompt
prompt Creating view LOAD_IM_G_V
prompt =========================
prompt
create or replace force view load_im_g_v as
select booru, fid, ifile fname, ipath,
       substr(ipath,instr(ipath,'\',-1)+1) ldir, ibytes fsize,
       iwidth, iheight, iwidth*iheight pix, round(iwidth/iheight,3) ar,
       substr(boundbox,1,instr(boundbox,'x')-1) b_x, substr(boundbox,instr(boundbox,'x')+1,instr(boundbox,'+')-instr(boundbox,'x')-1) b_y,
       substr(boundbox,instr(boundbox,'+')+1,instr(boundbox,'+',1,2)-instr(boundbox,'+')-1) b_w, substr(boundbox,instr(boundbox,'+',1,2)+1) b_h,
       tentr, tskew, tmean, tstddev, tcolors, meang, maximag, rmean, gmean, bmean, edge
from  load_im_g
where dtm>sysdate-5;

prompt
prompt Creating view LOAD_WAIFU_V
prompt ==========================
prompt
create or replace force view load_waifu_v as
select to_number(json_value(fline,'$.id')) wid,
       json_value(fline,'$.name') wname,
       json_value(fline,'$.slug') wslug,
       json_value(fline,'$.alternative_name') waltname,
       to_number(json_value(fline,'$.age')) wage,
       substr(json_value(fline,'$.display_picture'),8) wpic,
       to_number(to_number(json_value(fline,'$.likes'))) wlikes,
       to_number(json_value(fline,'$.trash')) wtrash,
       json_value(fline,'$.series.name') wseries,
       json_value(fline,'$.creator.name') wcreator,
       json_value(fline,'$.origin') worigin,
       json_query(fline,'$.tags[*].name' with wrapper) wtags,
       fline
from load_waifu
order by 1 desc;

prompt
prompt Creating view NUDE_Y_V
prompt ======================
prompt
create or replace force view nude_y_v as
with n as (
select batch_id, fname, prob,
case when obj like '%FACE%' then 'FACE'
 when obj like '%BREAST%' then 'BRST'
 when obj like '%BELLY%' then 'BELL'
 when obj like '%ARMPITS%' then 'ARMP'
 when obj like '%FEET%' then 'FEET'
 when obj like '%GENIT%' or obj like '%ANUS%' or obj like '%BUTT%' then 'XXXX'
end obj,
obj init_obj,
first_value(x+w) over (partition by fname order by x+w desc) ma_x,
first_value(x) over (partition by fname order by x) mi_x,
 x, y, w, h,
 booru_fname.GET_ELEM(fname,'BOORU') booru,
 booru_fname.GET_ELEM(fname,'FID') fid,
 face,
 case when obj like '%FACE%' then lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824/*1024*1024*1024*/),10000),4,'0')
                             else lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824/*1024*1024*1024*/),1000000),6,'0') end hashid
from nude_y
where suppr is null )
select batch_id, fname, prob, obj, init_obj, -- ma_x, mi_x,
       round(sqrt(((x+w/2)-(ma_x+mi_x)/2)*((x+w/2)-(ma_x+mi_x)/2)+(y+h/2)*(y+h/2))) ds,
       round(sqrt(w*h)) sz, round((x+w/2)-(ma_x+mi_x)/2) lr,
       x, y, w, h, booru, fid, hashid, face
from n
--where fname like '% - 64____ %'
order by 1, 4
;

prompt
prompt Creating view TAGS_EXT_V
prompt ========================
prompt
create or replace force view tags_ext_v as
select id,
decode(tag_cat,'[''tag-type-artist'']',1,'[''tag-type-copyright'']',3,'[''tag-type-character'']',4,0) tag_cat,
replace(replace(tag,' ','_'),chr(13),'') tag
from tags_ext;


prompt Done
spool off
set define on
