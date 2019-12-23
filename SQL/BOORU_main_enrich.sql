-- (so) REOLD-OLD PROCESSED 124102 changed 124102
-- (so) REOLD-NEW PROCESSED 130436 changed 130436
declare
  p_reparse  number:=1;
  p_reupdate number:=0;
/* материализовать части имени файла пр€мо в таблицу
   booru_fname.GET_ELEM(sourcefile,'COPYR') copyr, booru_fname.GET_ELEM(sourcefile,'CHARS') chars, booru_fname.GET_ELEM(sourcefile,'ARTIS') artis, 
   а затем - ќ“ƒ≈Ћ№Ќќ, процесс ќЅќ√јў≈Ќ»я - распарсить их (через "+") чтобы проставить TAG_ID одного автора, парочки франшиз и трех персонажей 
   в соответствующие пол€ - причем использу€ нечеткий поиск ! */
  t_main main_so%ROWTYPE; 
  e_main main_so%ROWTYPE;   
  t_cnt    number:=0;
  t_cnt_ch number:=0;
begin
  for cc in ( select rowid rid, t.* from main_w t ) loop    
    t_cnt:=t_cnt+1;
    t_main:=e_main;
    if p_reparse!=0 then
begin      
      BOORU_FNAME.PARSE_FNAME(cc.sourcefile,t_main.ipath,t_main.ifile,t_main.booru,t_main.fid,
                              t_main.copyr,t_main.chars,t_main.artis,t_main.fr);
exception
      when others then continue;
end;                              
      t_main.copyr:=replace(lower(t_main.copyr),' ','_');
      t_main.chars:=replace(replace(lower(t_main.chars),' ','_'),',','+');
      t_main.artis:=replace(lower(t_main.artis),' ','_');      
    else
      t_main.copyr:=cc.copyr; t_main.chars:=cc.chars; t_main.artis:=cc.artis; t_main.fr:=cc.fr;
    end if;                            
-- first direct attempt                            
    for ct in ( select distinct nvl(group_id,tag_id) tag_id from danb_tg 
                 where tag_name in (REGEXP_SUBSTR(t_main.copyr,'[^+]+',1,1),
                                    nvl(REGEXP_SUBSTR(t_main.copyr,'[^+]+',1,2),'-'),
                                    nvl(REGEXP_SUBSTR(t_main.copyr,'[^+]+',1,3),'-'))
                   and tag_cat=3 ) loop
      if    t_main.copyr_tag_1 is null then t_main.copyr_tag_1:=ct.tag_id; 
      elsif t_main.copyr_tag_2 is null then t_main.copyr_tag_2:=ct.tag_id; 
      end if;
    end loop;
    for ct in ( select distinct tag_id, group_id from danb_tg 
                 where tag_name in (REGEXP_SUBSTR(t_main.chars,'[^+]+',1,1),
                                    nvl(REGEXP_SUBSTR(t_main.chars,'[^+]+',1,2),'-'),
                                    nvl(REGEXP_SUBSTR(t_main.chars,'[^+]+',1,3),'-'),
                                    nvl(REGEXP_SUBSTR(t_main.chars,'[^+]+',1,4),'-'))
                   and tag_cat=4 ) loop 
      if    t_main.chars_tag_1 is null then t_main.chars_tag_1:=ct.tag_id; 
      elsif t_main.chars_tag_2 is null then t_main.chars_tag_2:=ct.tag_id;
      elsif t_main.chars_tag_3 is null then t_main.chars_tag_3:=ct.tag_id;
      end if;
      if t_main.copyr_tag_1 is null and ct.group_id is not null then t_main.copyr_tag_1:=ct.group_id; end if;
      if t_main.copyr_tag_2 is null and ct.group_id!=t_main.copyr_tag_1 then t_main.copyr_tag_2:=ct.group_id; end if;      
    end loop;    
    for ct in ( select tag_id from danb_tg where tag_name=t_main.artis and tag_cat=1 ) loop t_main.artis_tag_1:=ct.tag_id; end loop;    
-- more sophisticated : copyright in place of fr
    if t_main.copyr is null and t_main.fr is not null then
      for ct in ( select tag_id from danb_tg where tag_name=replace(lower(t_main.fr),' ','_') and tag_cat=3 and cnt>=5 ) loop 
        if    t_main.copyr_tag_1 is null then t_main.copyr_tag_1:=ct.tag_id; 
        elsif t_main.copyr_tag_2 is null and t_main.copyr_tag_1!=ct.tag_id then t_main.copyr_tag_2:=ct.tag_id;
        end if;
        t_main.copyr:=replace(lower(t_main.fr),' ','_');
        t_main.chars:=null;
        t_main.artis:=null;
        t_main.fr:=null;
      end loop;
      if t_main.copyr is null and t_main.fr='misc' then t_main.copyr:='misc'; t_main.fr:=null; end if;      
    end if;  
-- more sophisticated : char is partially divided to artist
    if t_main.chars is not null and t_main.artis is not null then 
      for ct in ( select tag_id from danb_tg where tag_name=t_main.chars||'_('||t_main.artis||')' and tag_cat=4 and cnt>=3 ) loop 
        if    t_main.chars_tag_1 is null then t_main.chars_tag_1:=ct.tag_id; 
        elsif t_main.chars_tag_2 is null and t_main.chars_tag_1!=ct.tag_id then t_main.chars_tag_2:=ct.tag_id;
        elsif t_main.chars_tag_3 is null and t_main.chars_tag_1!=ct.tag_id and t_main.chars_tag_2!=ct.tag_id then t_main.chars_tag_3:=ct.tag_id;
        end if;
        if t_main.artis is not null then t_main.chars:=t_main.chars||' ('||t_main.artis||')'; end if;
        t_main.artis:=null;
      end loop;
    end if;
-- more sophisticated : char in place of fr
    if t_main.chars is null and t_main.fr is not null then
      for ct in ( select tag_id from danb_tg 
                   where tag_name in (REGEXP_SUBSTR(replace(lower(t_main.fr),' ','_'),'[^+]+',1,1),
                                      REGEXP_SUBSTR(replace(lower(t_main.fr),' ','_'),'[^+]+',1,1)||'_('||t_main.copyr||')',
                                  nvl(REGEXP_SUBSTR(replace(lower(t_main.fr),' ','_'),'[^+]+',1,2),'-'),
                                  nvl(REGEXP_SUBSTR(replace(lower(t_main.fr),' ','_'),'[^+]+',1,3),'-'),
                                  nvl(REGEXP_SUBSTR(replace(lower(t_main.fr),' ','_'),'[^+]+',1,4),'-'))
                     and tag_cat=4 and cnt>=3 ) loop 
        if    t_main.chars_tag_1 is null then t_main.chars_tag_1:=ct.tag_id; 
        elsif t_main.chars_tag_2 is null and t_main.chars_tag_1!=ct.tag_id then t_main.chars_tag_2:=ct.tag_id;
        elsif t_main.chars_tag_3 is null and t_main.chars_tag_1!=ct.tag_id and t_main.chars_tag_2!=ct.tag_id then t_main.chars_tag_3:=ct.tag_id;
        end if;
        if t_main.fr is not null then t_main.chars:=replace(lower(t_main.fr),' ','_'); end if;
        t_main.fr:=null;
      end loop;
      if t_main.chars is null and t_main.fr='unknown' then t_main.chars:='unknown'; t_main.fr:=null; end if;      
    end if;  
-- more sophisticated : artist in place of fr
    if t_main.artis is null and t_main.fr is not null then
      for ct in ( select tag_id from danb_tg where tag_name=replace(lower(t_main.fr),' ','_') and tag_cat=1 and cnt>=5 ) loop 
        if    t_main.artis_tag_1 is null then t_main.artis_tag_1:=ct.tag_id; 
        end if;
        t_main.artis:=replace(lower(t_main.fr),' ','_');
        t_main.fr:=null;
      end loop;
    end if;  
-- conditional UPDATE
    if nvl(cc.copyr,'-') != nvl(t_main.copyr,'-') or nvl(cc.chars,'-') != nvl(t_main.chars,'-') or
       nvl(cc.artis,'-') != nvl(t_main.artis,'-') or nvl(cc.fr,'-') != nvl(t_main.fr,'-') or
       nvl(cc.copyr_tag_1,-1) != nvl(t_main.copyr_tag_1,-1) or nvl(cc.copyr_tag_2,-1) != nvl(t_main.copyr_tag_2,-1) or
       nvl(cc.chars_tag_1,-1) != nvl(t_main.chars_tag_1,-1) or nvl(cc.chars_tag_2,-1) != nvl(t_main.chars_tag_2,-1) or
       nvl(cc.chars_tag_3,-1) != nvl(t_main.chars_tag_3,-1) or nvl(cc.artis_tag_1,-1) != nvl(t_main.artis_tag_1,-1) or p_reupdate!=0 then
         t_cnt_ch:=t_cnt_ch+1;   
         update main_w set copyr=t_main.copyr, chars=t_main.chars, artis=t_main.artis, fr=t_main.fr,
                            copyr_tag_1=t_main.copyr_tag_1, copyr_tag_2=t_main.copyr_tag_2, artis_tag_1=t_main.artis_tag_1,
                            chars_tag_1=t_main.chars_tag_1, chars_tag_2=t_main.chars_tag_2, chars_tag_3=t_main.chars_tag_3, dtm=sysdate
         where rowid=cc.rid;
    end if; 
  end loop;
  dbms_output.put_line('PROCESSED '||t_cnt||' changed '||t_cnt_ch);
  commit;  
end;
/* DANBOORU made by direct substitution of most popular tags 
update main_d u set u.artis_tag_1=(select tag_id
         from ( select d.id, t.tag_id, row_number() over (partition by d.id order by t.cnt desc) r
                  from danb_dt d 
                  join danb_tg t on d.tag_id=t.tag_id
                 where d.tag_cat=1 and d.id in ( select fid from main_d ) 
                 ) q where r=1 and q.id=u.fid )

update main_d u set u.chars_tag_3=(select tag_id
         from ( select d.id, t.tag_id, row_number() over (partition by d.id order by t.cnt desc) r
                  from danb_dt d 
                  join danb_tg t on d.tag_id=t.tag_id
                 where d.tag_cat=4 and d.id in ( select fid from main_d ) 
                 ) q where r=3 and q.id=u.fid )

update main_d u set u.copyr_tag_2=(select tag_id
         from ( select d.id, e.tag_id, row_number() over (partition by d.id order by e.cnt desc) r
                  from ( select distinct d.id, nvl(t.group_id,t.tag_id) title
                           from danb_dt d 
                           join danb_tg t on d.tag_id=t.tag_id
                          where d.tag_cat=3 and t.tag_cat=3 and d.id in ( select fid from main_d ) ) d
                   join danb_tg e on d.title=e.tag_id
               ) q where r=2 and q.id=u.fid )
*/
/*
select booru, fid, dtm,
-- xdate, xbytes, xwidth, xheight, boundw, boundh, boundx, boundy, tbytes, twidth, theight, tentr, tskew, tmean, tstddev, tcolors, meang, maximag, 
-- rmean, gmean, bmean, edge, resx, resy, resunit, compqual, colorspace, ihash, 
-- sourcefile, ifile, ipath, 
copyr, chars, artis, fr, copyr_tag_1, copyr_tag_2, chars_tag_1, chars_tag_2, chars_tag_3, artis_tag_1, frest
from main_sb
where dtm>sysdate-1/50
-- where booru not in ('safebooru.com','-safebooru.org','e-shuushuu.net','gelbooru.com','yande.re','zerochan.net','konachan.com')
order by dtm desc
-- and fid=2340126 for update
*/  
