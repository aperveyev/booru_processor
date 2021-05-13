prompt PL/SQL Developer Export User Objects for user BOORU@HH19
set define off
spool booru_stored_202105.log

prompt
prompt Creating package BOORU_FNAME
prompt ============================
prompt
create or replace package BOORU_FNAME as
  FUNCTION RECROP ( p_w in number, p_h in number, p_x in number, p_y in number,
                    p_iw in number, p_ih in number, p_log in number default 0 ) return varchar2 ;
  PROCEDURE PARSE_FNAME( p_FullName in varchar2, o_FPath out varchar2, o_FName out varchar2, o_booru out varchar2, o_fid out varchar2,
                         o_copyr out varchar2, o_chars out varchar2, o_artis out varchar2, o_frest out varchar2 ) ;
  FUNCTION GET_ELEM( p_FullName in varchar2, p_element in varchar2 ) return varchar2 ;
end;
/

prompt
prompt Creating package NUDP
prompt =====================
prompt
create or replace package NUDP is

  -- Author  : APERV
  -- Created : 02.01.2021 12:00:54
  -- Purpose : 
  
  -- Public type declarations
--  type <TypeName> is <Datatype>;
  
  -- Public constant declarations
--  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
--  <VariableName> <Datatype>;

  -- Public function and procedure declarations
procedure proc ( p_batch_id in varchar2) ;

  -- Public function and procedure declarations
procedure nms ( p_batch_id in varchar2) ;

end NUDP;
/

prompt
prompt Creating function GRAB_LOG_DATE
prompt ===============================
prompt
create or replace function grab_log_date ( p_s varchar2 ) return date is
 l_s varchar2(20);
 l_d date;
begin
 if    p_s like '__-__-20__ __.__' then return to_date(substr(p_s,1,10),'MM-DD-YYYY');
 elsif p_s like '20__-__-__' then return to_date(p_s,'YYYY-MM-DD');
 elsif p_s like 'for_20__-__-__' then return to_date(substr(p_s,5,10),'YYYY-MM-DD');
 elsif p_s like 'for__20__-__-__' then return to_date(substr(p_s,6,10),'YYYY-MM-DD');
 end if;
 return p_s;
exception
 when others then return null;
end;
/

prompt
prompt Creating function XSUBSTR
prompt =========================
prompt
create or replace function xsubstr ( p_line in varchar2, p_tag in varchar2 ) return varchar2 is
  t_ret varchar2(4000);
  t_pos number:=instr(p_line,' '||p_tag||'=');
begin
  if t_pos=0 then return null; else t_pos:=t_pos+length(p_tag)+2; end if;
  t_ret:=substr(p_line,t_pos);
--  return t_pos||' *** '||t_ret;
  return substr(t_ret,2,instr(substr(t_ret,2),'"')-1);
end;
/

prompt
prompt Creating procedure BLOB_TO_FILE
prompt ===============================
prompt
CREATE OR REPLACE NONEDITIONABLE PROCEDURE blob_to_file (p_blob      IN OUT NOCOPY BLOB,
                                          p_dir       IN  VARCHAR2,
                                          p_filename  IN  VARCHAR2)
AS
  l_file      UTL_FILE.FILE_TYPE;
  l_buffer    RAW(32767);
  l_amount    BINARY_INTEGER := 32767;
  l_pos       INTEGER := 1;
  l_blob_len  INTEGER;
BEGIN
  l_blob_len := DBMS_LOB.getlength(p_blob);

  -- Open the destination file.
  l_file := UTL_FILE.fopen(p_dir, p_filename,'wb', 32767);

  -- Read chunks of the BLOB and write them to the file until complete.
  WHILE l_pos <= l_blob_len LOOP
    DBMS_LOB.read(p_blob, l_amount, l_pos, l_buffer);
    UTL_FILE.put_raw(l_file, l_buffer, TRUE);
    l_pos := l_pos + l_amount;
  END LOOP;

  -- Close the file.
  UTL_FILE.fclose(l_file);

EXCEPTION
  WHEN OTHERS THEN
    -- Close the file if something goes wrong.
    IF UTL_FILE.is_open(l_file) THEN
      UTL_FILE.fclose(l_file);
    END IF;
    RAISE;
END blob_to_file;
/

prompt
prompt Creating package body BOORU_FNAME
prompt =================================
prompt
CREATE OR REPLACE package BODY BOORU_FNAME as

procedure ins_json ( p_in in out nocopy varchar2, p_add in varchar2 ) IS
BEGIN
  if p_add is null or p_add not like '"%":"%"' then return; end if;
  if p_in is null then  p_in:='{'||p_add||'}'; return; end if;
  p_in:=rtrim(rtrim(p_in,',}'),chr(10))||','||chr(10)||p_add||'}';
  return;
END ins_json;

FUNCTION RECROP ( p_w in number, p_h in number, p_x in number, p_y in number,
                  p_iw in number, p_ih in number, p_log in number default 0 ) return varchar2 IS
  t_w number:=least(p_w+60,p_iw); -- internal variables
  t_h number:=least(p_h+60,p_ih);
  t_x number:=least(greatest(p_x-30,0),p_iw-t_w);
  t_y number:=least(greatest(p_y-30,0),p_ih-t_h);
  a number:=round(t_x+t_w/2); -- center
  b number:=round(t_y+t_h/2);
  m number:=p_iw-t_x-t_w; -- back border
  n number:=p_ih-t_y-t_h;
  r number:=round(t_w/t_h,3);
  t_step number:=0;
  t_res varchar2(2000);
BEGIN
<<lab>>
  if t_w<900 or t_h<900 or t_w*t_h<1200000 or t_w/t_h not between 0.4 and 2.1 then
    ins_json(t_res,'"step'||t_step||'_w":"'||t_w||'"');
    ins_json(t_res,'"step'||t_step||'_h":"'||t_h||'"');
    ins_json(t_res,'"step'||t_step||'_x":"'||t_x||'"');
    ins_json(t_res,'"step'||t_step||'_y":"'||t_y||'"');
    a:=round(t_x+t_w/2);       ins_json(t_res,'"step'||t_step||'_center_x":"'||a||'"');
    b:=round(t_y+t_h/2);       ins_json(t_res,'"step'||t_step||'_center_y":"'||b||'"');
    m:=p_iw-t_x-t_w;           ins_json(t_res,'"step'||t_step||'_back_x":"'||m||'"');
    n:=p_ih-t_y-t_h;           ins_json(t_res,'"step'||t_step||'_back_y":"'||n||'"');
    r:=round(t_w/t_h,3);       ins_json(t_res,'"step'||t_step||'_aspect_ratio":"'||r||'"');
    if t_w<500 or t_h<500 or t_w*t_h<600000 or t_w/t_h not between 0.2 and 5 then -- aaciaaa?ii
      ins_json(t_res,'"branch":"Z"');
      t_step:=9;
    elsif t_w<900 and t_h<1350 and r<1 then -- i?iii?oeiiaeuii iiaieiaai iaa ?acia?a ai ieieioia
      t_x:=least(greatest(a-450,0),p_iw-900);
      t_y:=least(greatest(b-675,0),p_ih-1350);
      t_w:=900; 
      t_h:=1350;
      ins_json(t_res,'"branch":"w1"');      
    elsif t_w<900 and t_h between 1350 and 2250 then -- iiaieiaai oieuei oe?eio ai ieieioia
      t_x:=least(greatest(a-450,0),p_iw-900);
      t_w:=900; 
      ins_json(t_res,'"branch":"w2"');            
    elsif t_w<900 and t_h > 2250 then -- iiaieiaai oe?eio ?oiau ainoe?u 0.4
      t_x:=ceil(least(greatest(a-t_h*0.2,0),p_iw-t_h*0.4));
      t_w:=ceil(t_h*0.4);
      ins_json(t_res,'"branch":"w3"');       
    elsif t_h<900 and t_w<1350 and r>1 then -- AIAEIAE?II I?I AUNIOO
      t_y:=least(greatest(b-450,0),p_ih-900);
      t_x:=least(greatest(a-675,0),p_iw-1350);
      t_h:=900; 
      t_w:=1350;
      ins_json(t_res,'"branch":"h1"');            
    elsif t_h<900 and t_w between 1350 and 1800 then
      t_y:=least(greatest(b-450,0),p_ih-900);
      t_h:=900; 
      ins_json(t_res,'"branch":"h2"');            
    elsif t_h<900 and t_w > 1800 then 
      t_y:=ceil(least(greatest(b-t_w*0.25,0),p_ih-t_w*0.5));
      t_h:=ceil(t_w*0.5);
      ins_json(t_res,'"branch":"h3"');            
    elsif t_w*t_h < 1200000 then -- ?acaoaaai i?iii?oeiiaeuii
      r:=round(1200000/(t_w*t_h),3);
      t_w:=ceil(t_w*r);               t_x:=least(greatest(ceil(t_x*(r-1)),0),p_iw-t_w);
      t_h:=ceil(t_h*r);               t_y:=least(greatest(ceil(t_y*(r-1)),0),p_ih-t_h);
      ins_json(t_res,'"branch":"s"');
    elsif t_w/t_h < 0.4 then
      t_x:=ceil(least(greatest(a-t_h*0.2,0),p_iw-t_h*0.4));
      t_w:=ceil(t_h*0.4);
      ins_json(t_res,'"branch":"r1"');       
    elsif t_w/t_h > 2.1 then
      t_y:=greatest(ceil(least(greatest(b-t_w*0.25,0),p_ih-t_w*0.5)),0);
      t_h:=ceil(t_w*0.5);
      ins_json(t_res,'"branch":"r2"');       
    end if;
    t_step:=t_step+1;
    if t_step<4 then 
       goto lab;       
    end if;
  end if;
  if p_log=0 -- recheck before output
    and t_w>=900 and t_h>=900 and t_w*t_h>=1200000 and t_w/t_h between 0.4 and 2.1 
    and t_w+t_x<=p_iw and t_h+t_y<=p_ih and t_x>=0 and t_y>=0 then 
      return t_w||'x'||t_h||'+'||t_x||'+'||t_y; 
  else -- debug then problems (or always if required)
      return '['||t_w||'x'||t_h||'+'||t_x||'+'||t_y||'] '||t_res; 
  end if;
END RECROP ;

PROCEDURE PARSE_FNAME( p_FullName in varchar2, o_FPath out varchar2, o_FName out varchar2, o_booru out varchar2, o_fid out varchar2,
                       o_copyr out varchar2, o_chars out varchar2, o_artis out varchar2, o_frest out varchar2 ) is
  t_fpath varchar2(300);
  t_fname varchar2(300);
  t_booru varchar2(60);
  t_fid   varchar2(300);
  t_copyr varchar2(300);
  t_chars varchar2(300);
  t_frest varchar2(300);
  t_artis varchar2(300);
  t_PNG   number:=0;
begin
  if p_fullname like '%/%' then
    t_fname:=substr(p_fullname,instr(p_fullname,'/',-1)+1);
    t_fpath:=substr(p_fullname,1,instr(p_fullname,'/',-1)-1);
  elsif p_fullname like '%\%' then
    t_fname:=substr(p_fullname,instr(p_fullname,'\',-1)+1);
    t_fpath:=substr(p_fullname,1,instr(p_fullname,'\',-1)-1);
  else
    t_fname:=p_fullname;
  end if;
  o_fpath:=t_fpath;
  o_fname:=t_fname;
------------------------ source
  if t_fname like '% - %' and instr(t_fname,' - ')<30 then
    t_booru:=substr(t_fname,1,instr(t_fname,' - ')-1);
    t_frest:=substr(t_fname,instr(t_fname,' - ')+3);
  elsif t_fname like 'Animepaper anime%' or t_fname like 'Animepaper scans%' then
    t_booru:='animepaper';
    t_frest:=substr(t_fname,18);
  end if;
  if lower(t_booru) like 'animepaper%' then t_booru:='animepaper'; end if;
  o_booru:=lower(t_booru);
-- trim trailing extension and suffixes
  t_frest:=replace(replace(t_frest,CHR(10),''),CHR(13),'');
  t_frest:=replace(t_frest,'.jpg','');
  if t_frest like '% [PNG]%' then t_frest:=replace(t_frest,' [PNG]',''); t_PNG:=1; end if;
  if t_frest like '% [CNV]%' then t_frest:=replace(t_frest,' [CNV]',''); t_PNG:=t_PNG+2; end if;
  if t_frest like '% [CVT]%' then t_frest:=replace(t_frest,' [CVT]',''); t_PNG:=t_PNG+4; end if;
  if t_frest like '% [CRP]%' then t_frest:=replace(t_frest,' [CRP]',''); t_PNG:=t_PNG+8; end if;
-- fid
  if t_frest like '% - %' and instr(t_frest,' - ')<8 then
    t_fid:=substr(t_frest,1,instr(t_frest,' - ')-1);
    t_frest:=substr(t_frest,instr(t_frest,' - ')+3);
  elsif t_frest like '% %' then
    t_fid:=substr(t_frest,1,instr(t_frest,' ')-1);
    t_frest:=substr(t_frest,instr(t_frest,' - ')+1);
  elsif trim(translate(t_frest,'0123456789','          ')) is null then
    t_fid:=t_frest;
    t_frest:=null;
  end if;
-- e-shuushuu patch
  if t_fid like '%~' then t_fid:=rtrim(t_fid,'~'); t_copyr:='misc'; end if;
-- Animepaper reverse structure
  if t_fid is null and lower(t_booru)='animepaper' then
    if instr(t_frest,'_',-1)>=length(t_frest)-6  then
      t_fid:=substr(t_frest,instr(t_frest,'_',-1)+1);
      if trim(translate(t_fid,'0123456789','          ')) is null then
        t_frest:=substr(t_frest,1,instr(t_frest,'_',-1)-1);
      else
        t_fid:=null;
      end if;
    end if; 
  end if;
  o_fid:=t_fid;
-- try to go to copyr + char + artist
  if t_frest like '- %' then t_frest:=substr(t_frest,3); end if;
  if t_frest is null then
    t_copyr:='misc';
    t_chars:='unknown';
    t_artis:='anonymous';
  end if;  
  if instr(t_frest,' ~ ') between 2 and 296 then
    t_copyr:=substr(t_frest,1,instr(t_frest,' ~ ')-1);
    t_frest:=substr(t_frest,instr(t_frest,' ~ ')+3);    
  end if;
  if t_frest like '%)' and regexp_substr(t_frest,'\(([^)]*)\)[^(]*$') is not null then
     t_artis:=regexp_substr(t_frest,'\(([^)]*)\)[^(]*$');
     t_chars:=substr(t_frest,1,length(t_frest)-length(t_artis)-1);
     t_artis:=substr(t_artis,2,length(t_artis)-2);
     t_frest:=null;     
  end if;

  
  o_copyr:=t_copyr;
  o_chars:=t_chars;
  o_artis:=t_artis;
  o_frest:=t_frest;

  return;
end PARSE_FNAME;

FUNCTION GET_ELEM( p_FullName in varchar2, p_element in varchar2 ) return varchar2 IS
  t_fpath varchar2(300);
  t_fname varchar2(300);
  t_booru varchar2(60);
  t_fid   varchar2(300);
  t_copyr varchar2(300);
  t_chars varchar2(300);
  t_artis varchar2(300);  
  t_frest  varchar2(300);
begin
  PARSE_FNAME(p_FullName,t_FPath,t_FName,t_booru,t_fid,t_copyr,t_chars,t_artis,t_frest);
  if    p_element='FPATH' then return t_fpath;
  elsif p_element='FNAME' then return t_fname;
  elsif p_element='BOORU' then return t_booru;
  elsif p_element='FID'   then return t_fid;
  elsif p_element='COPYR' then return t_copyr;
  elsif p_element='CHARS' then return t_chars;
  elsif p_element='ARTIS' then return t_artis;  
  elsif p_element='FREST' then return t_frest;
  else                    return p_fullname;          end if;
end;


end;
/

prompt
prompt Creating package body NUDP
prompt ==========================
prompt
create or replace package body NUDP is
  -- Private type declarations
--  type <TypeName> is <Datatype>;
  -- Private constant declarations
--  <ConstantName> constant <Datatype> := <Value>;
  -- Private variable declarations
--  <VariableName> <Datatype>;

function insc ( p_in varchar2, p_pos number, p_char varchar2 ) return varchar2 is
begin
  return substr(rpad(nvl(p_in,'-'),p_pos,'-'),1,p_pos-1)||p_char||rpad(substr(nvl(p_in,'-'),p_pos+1),13-p_pos,'-');
end;  

-- Function and procedure implementations
procedure nms ( p_batch_id in varchar2) is
  t_start timestamp:=systimestamp;  
begin
  
update nude_y e set e.suppr=0
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%FACE%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%FACE%' and e.suppr is null 
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' FACE-on-FACE 0 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');  
commit;

update nude_y e set e.suppr=1
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BREAST%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%BREAST%' and e.suppr is null 
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' BREATS-on-BREAST 1 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=2
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BUTTOCK%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%BUTTOCK%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' BUTTOCK-on-BUTTOCK 2 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=3
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%GENITALIA%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%GENITALIA%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' GENITALIA-on-GENITALIA 3 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=4
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%FEET%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%FEET%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' FEET-on-FEET 4 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=5
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BELLY%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.1
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.1                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.1
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.1 )
  and e.obj like '%BELLY%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' BELLY-on-BELLY 5 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

-- suppr=6 '%ARMPIT%' ?

-- BREAST in BREAST relaxed
update nude_y e set e.suppr=11
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BREAST%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.5
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.5                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.3
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.3 )
  and e.obj like '%BREAST%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' BREAST-on-BREAST RELAXED 11 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=90
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%FACE%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-FACE 90 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;
  
update nude_y e set e.suppr=91
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BREAST%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-BREAST 91 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=92
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BUTTOCK%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-BUTTOCK 92 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=93
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%GENITALIA%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-GENITALIA 93 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=94
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%FEET%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-FEET 94 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;
  
update nude_y e set e.suppr=95
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%BELLY%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-BELLY 95 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

update nude_y e set e.suppr=96
where exists ( select 'x' from nude_y i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj like '%ARMPIT%' and i.prob>e.prob
                  and abs((i.x+i.w/2)-(e.x+e.w/2))/greatest(i.w,e.w) between 0 and 0.2
                  and abs((i.y+i.h/2)-(e.y+e.h/2))/greatest(i.h,e.h) between 0 and 0.2                  
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.2
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.2 )
  and e.obj like '%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' ANYTHING-on-ARMPIT 96 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

-- 3-BRST suppression
update nude_y e set e.suppr=111
where exists ( select 'l' from nude_y_v i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj='BRST'
                  and (i.x+i.w/2) between e.x-e.w/2 and e.x+e.w/2
                  and (i.y+i.h/2) between e.y+0.2*e.h and e.y+0.8*e.h
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.3
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.3 )
   and exists ( select 'r' from nude_y_v i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj='BRST'
                  and (i.x+i.w/2) between e.x+e.w/2 and e.x+3*e.w/2
                  and (i.y+i.h/2) between e.y+0.2*e.h and e.y+0.8*e.h
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.3
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.3 )                  
  and e.obj like '%BREAST%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' 3-BRST suppression 111 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
commit;

-- 3-FACE suppression
update nude_y e set e.suppr=111
where exists ( select 'l' from nude_y_v i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj='FACE'
                  and (i.x+i.w/2) between e.x-e.w/2 and e.x+e.w/2
                  and (i.y+i.h/2) between e.y+0.2*e.h and e.y+0.8*e.h
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.3
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.3 )
   and exists ( select 'r' from nude_y_v i 
                where i.fname=e.fname and (i.x!=e.x or i.y!=e.y or i.prob!=e.prob) and i.obj='FACE'
                  and (i.x+i.w/2) between e.x+e.w/2 and e.x+3*e.w/2
                  and (i.y+i.h/2) between e.y+0.2*e.h and e.y+0.8*e.h
                  and abs(i.w-e.w)/greatest(i.w,e.w) between 0 and 0.3
                  and abs(i.h-e.h)/greatest(i.h,e.h) between 0 and 0.3 )                  
  and e.obj like '%FACE%' and e.suppr is null
  and e.batch_id=p_batch_id ;
  dbms_output.put_line('RUN '||p_batch_id||' 3-FACE suppression 100 - '||SQL%ROWCOUNT||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');

commit;

end nms;

procedure proc ( p_batch_id in varchar2) is
  i_cnt   number:=0;
  t_start timestamp:=systimestamp;  
  t_nude  nude%ROWTYPE;
  z_nude  nude%ROWTYPE;
  face_n  number;
  t_minx  number;
  t_maxx  number;
  brst_cnt  number:=0;
  brst_lost number:=0;    
  armp_cnt  number:=0;
  armp_lost number:=0;    
  bell_cnt  number:=0;
  bell_lost number:=0;    
  xxxx_cnt  number:=0;
  xxxx_lost number:=0;    
  feet_cnt  number:=0;
  feet_lost number:=0;    
begin
  z_nude.batch_id:=p_batch_id;  
--  z_nude.booru:='yande.re';  
  delete from nude where batch_id=p_batch_id;
  dbms_output.put_line('START '||p_batch_id||' -'||SQL%ROWCOUNT);
  for c# in ( select distinct y.fname, y.booru, y.fid --, r.iw s_width, r.ih s_height
                from nude_y_v y
--                join bct_exif r on r.booru=y.booru and r.fid=y.fid
/*                join yndr_rip r on r.id=y.fid 
                 and ( ( r.rating=lower(substr(p_batch_id,1,1))
                       and ( ( lower(substr(p_batch_id,2,1))='a' and r.s_width/r.s_height between 0.4 and 0.9 ) or
                             ( lower(substr(p_batch_id,2,1))='b' and r.s_width/r.s_height between 0.9 and 1.2 ) or
                             ( lower(substr(p_batch_id,2,1))='c' and r.s_width/r.s_height between 1.2 and 2.1 ) )
                    ) or ( substr(p_batch_id,1,1) between '1' and '9' and y.fid=p_batch_id ) )*/
               where y.fname in ( select fname from nude_y 
                                   where obj like '%FACE%' and suppr is null and batch_id=p_batch_id
                                group by fname having count(*)<3 ) 
                 and y.batch_id=p_batch_id           
            order by 2 ) loop
    t_nude:=z_nude;
--    dbms_output.put_line('FILE '||c#.fid/*c#.fname*/);
    t_nude.booru:=c#.booru;  
    t_nude.fname:=c#.fname;
    t_nude.fid:=c#.fid;
    update nude_y set face=null where fname=c#.fname ;    
    for cf in ( select prob, ds, sz, lr, hashid, rownum rn
                  from nude_y_v 
                 where obj='FACE' and fname=c#.fname 
              order by sz desc fetch first 2 rows only /*ds*/ ) loop
      t_nude.dbg:=t_nude.dbg||'FACE #'||cf.rn||' hash '||cf.hashid||' ds '||cf.ds||' sz '||cf.sz||' lr '||cf.lr||chr(13);
      if    cf.rn=1 then
        t_nude.face1:=cf.hashid;
        t_nude.face1_prob:=cf.prob;
        t_nude.face1_ds:=cf.ds;
        t_nude.face1_sz:=cf.sz;
        face_n:=1;
        t_nude.clas:=insc(t_nude.clas,1,'F');
      elsif cf.rn=2 then
        t_nude.face2:=cf.hashid;
        t_nude.face2_prob:=cf.prob;
        t_nude.face2_ds:=cf.ds;
        t_nude.face2_sz:=cf.sz;        
        face_n:=2;
        t_nude.clas:=insc(t_nude.clas,8,'F');        
      end if;
      update nude_y set face=cf.hashid where fname=c#.fname and
                        cf.hashid=lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),10000),4,'0') ;
      t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' BRST-LIMITS dsf ['||(cf.ds+0.4*cf.sz)||' # '||(cf.ds+2.5*cf.sz)||
                                                           '] szf ['||(0.6*cf.sz)||' # '||(1.5*cf.sz)||
                                                           '] lrf [' ||(cf.lr-1.3*cf.sz)||' # '||(cf.lr+1.3*cf.sz)||']'||chr(13);
      for cb in ( select listagg(hashid,'+') brst, min(ds) ds, max(sz) sz, avg(prob) prob, round(avg(lr)) lr
                         , min(lr-0.6*sz) minx, max(lr+0.6*sz) maxx -- for belly tracking
                    from nude_y_v 
                   where obj='BRST' and fname=c#.fname and face is null
                     and ds between cf.ds+0.4*cf.sz and cf.ds+2.5*cf.sz
                     and sz between 0.6*cf.sz and 1.5*cf.sz
                     and lr between cf.lr-1.3*cf.sz and cf.lr+1.3*cf.sz
                   having count(*) between 1 and 3
                   ) loop
        t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' BRST '||cb.brst||' ds '||cb.ds||' sz '||cb.sz||' lr ' ||cb.lr||' prob ' ||round(cb.prob,3)||chr(13);
        if    cf.rn=1 then
          t_nude.brst1:=substr(cb.brst,1,20);
          t_nude.brst1_prob:=round(cb.prob,3);
          t_nude.brst1_ds:=cb.ds;
          t_nude.brst1_sz:=cb.sz;
          t_nude.clas:=insc(t_nude.clas,2,'B');
        elsif cf.rn=2 then
          t_nude.brst2:=substr(cb.brst,1,20);
          t_nude.brst2_prob:=round(cb.prob,3);
          t_nude.brst2_ds:=cb.ds;
          t_nude.brst2_sz:=cb.sz;
          t_nude.clas:=insc(t_nude.clas,9,'B');
        end if;
        t_minx:=cb.minx;
        t_maxx:=cb.maxx;
        update nude_y set face=cf.hashid where fname=c#.fname and face is null and obj like '%BREAST%' and
                   cb.brst like '%'||lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),1000000),6,'0')||'%' ;
        brst_cnt:=brst_cnt+SQL%ROWCOUNT;           
      end loop; -- cb  
      t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' ARMP-LIMITS dsf ['||(cf.ds+0.8*cf.sz)||' # '||(cf.ds+2*cf.sz)||
                                                           '] szf ['||(0.2*cf.sz)||' # '||(0.6*cf.sz)||
                                                           '] lrf [' ||(cf.lr-cf.sz)||' # '||(cf.lr+cf.sz)||']'||chr(13);
      for ca in ( select listagg(hashid,'+') armp, min(ds) ds, max(sz) sz, avg(prob) prob
                    from nude_y_v 
                   where obj='ARMP' and fname=c#.fname and face is null
                     and ds between cf.ds+0.8*cf.sz and cf.ds+2*cf.sz
                     and sz between 0.2*cf.sz and 0.6*cf.sz                     
                     and lr between cf.lr-cf.sz and cf.lr+cf.sz
                   having count(*) between 1 and 3  
                   ) loop
        t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' ARMP '||ca.armp||' ds '||ca.ds||' sz '||ca.sz||' prob ' ||round(ca.prob,3)||chr(13);
        if    cf.rn=1 then
          t_nude.armp1:=substr(ca.armp,1,20);
          t_nude.armp1_prob:=round(ca.prob,3);
          t_nude.armp1_ds:=ca.ds;
          t_nude.armp1_sz:=ca.sz;
          t_nude.clas:=insc(t_nude.clas,3,'A');
        elsif cf.rn=2 then
          t_nude.armp2:=substr(ca.armp,1,20);
          t_nude.armp2_prob:=round(ca.prob,3);
          t_nude.armp2_ds:=ca.ds;
          t_nude.armp2_sz:=ca.sz;
          t_nude.clas:=insc(t_nude.clas,10,'A');
        end if;
        update nude_y set face=cf.hashid where fname=c#.fname and face is null and obj like '%ARMPIT%' and
                   ca.armp like '%'||lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),1000000),6,'0')||'%' ;
        armp_cnt:=armp_cnt+SQL%ROWCOUNT;                              
      end loop; -- ca  
      t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' BELL-LIMITS dsf ['||(cf.ds+1.5*cf.sz)||' # '||(cf.ds+4*cf.sz)||
                                                           '] szf ['||(0.6*cf.sz)||' # '||(2*cf.sz)||
                                                           '] lrf [' ||(cf.lr-1.5*cf.sz)||' # '||(cf.lr+1.5*cf.sz)||
                                                           ']';
      if cf.rn=1 and t_nude.brst1 like '%+%' then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.brst1_ds+0.7*t_nude.brst1_sz)||' # '||(t_nude.brst1_ds+3*t_nude.brst1_sz)||
                                '] lrb [' ||(nvl(t_minx,0))||' # '||(nvl(t_maxx,9999))||']'||chr(13);
      elsif cf.rn=2 and t_nude.brst2 like '%+%' then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.brst2_ds+0.7*t_nude.brst2_sz)||' # '||(t_nude.brst2_ds+3*t_nude.brst2_sz)||
                                '] lrb [' ||(nvl(t_minx,0))||' # '||(nvl(t_maxx,9999))||']'||chr(13);
      elsif cf.rn=1 and t_nude.brst1 not like '%+%' then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.brst1_ds+0.7*t_nude.brst1_sz)||' # '||(t_nude.brst1_ds+3*t_nude.brst1_sz)||
                                '] lrb [' ||(nvl(t_minx-t_nude.brst1_sz,0))||' # '||(nvl(t_maxx+t_nude.brst1_sz,9999))||']'||chr(13);
      elsif cf.rn=2 and t_nude.brst2 not like '%+%' then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.brst2_ds+0.7*t_nude.brst2_sz)||' # '||(t_nude.brst2_ds+3*t_nude.brst2_sz)||
                                '] lrb [' ||(nvl(t_minx-t_nude.brst2_sz,0))||' # '||(nvl(t_maxx+t_nude.brst2_sz,9999))||']'||chr(13);
      else t_nude.dbg:=t_nude.dbg||chr(13); end if;
      for ce in ( select listagg(hashid,'+') bell, min(ds) ds, max(sz) sz, avg(prob) prob, round(avg(lr)) lr
                        , min(lr-sz) minx, max(lr+sz) maxx -- for xxx tracking
                    from nude_y_v 
                   where obj='BELL' and fname=c#.fname and face is null
                     and ds between cf.ds+1.5*cf.sz and cf.ds+4*cf.sz -- against face
                     and sz between 0.6*cf.sz and 2*cf.sz                     
                     and lr between cf.lr-1.5*cf.sz and cf.lr+1.5*cf.sz
                     and ( (cf.rn=1 and t_nude.brst1 like '%+%' and -- against more than one breasts
                            ds between t_nude.brst1_ds+0.7*t_nude.brst1_sz and t_nude.brst1_ds+3*t_nude.brst1_sz and 
                            lr between nvl(t_minx,0) and nvl(t_maxx,9999) )
                        or (cf.rn=2 and t_nude.brst2 like '%+%' and 
                            ds between t_nude.brst2_ds+0.7*t_nude.brst2_sz and t_nude.brst2_ds+3*t_nude.brst2_sz and 
                            lr between nvl(t_minx,0) and nvl(t_maxx,9999) ) 
                        or (cf.rn=1 and t_nude.brst1 not like '%+%' and -- against one breast
                            ds between t_nude.brst1_ds+0.7*t_nude.brst1_sz and t_nude.brst1_ds+3*t_nude.brst1_sz and 
                            lr between nvl(t_minx-t_nude.brst1_sz,0) and nvl(t_maxx+t_nude.brst1_sz,9999) )
                        or (cf.rn=2 and t_nude.brst2 not like '%+%' and 
                            ds between t_nude.brst2_ds+0.7*t_nude.brst2_sz and t_nude.brst2_ds+3*t_nude.brst2_sz and 
                            lr between nvl(t_minx-t_nude.brst2_sz,0) and nvl(t_maxx+t_nude.brst2_sz,9999) )     
                        or ( cf.rn=1 and t_nude.brst1 is null ) or (cf.rn=2 and t_nude.brst2 is null ) )
                   having count(*) between 1 and 2
                   ) loop
        t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' BELL '||ce.bell||' ds '||ce.ds||' sz '||ce.sz||' lr ' ||ce.lr||' prob ' ||ce.prob||chr(13);
        if    cf.rn=1 then
          t_nude.bell1:=substr(ce.bell,1,13);
          t_nude.bell1_prob:=ce.prob;
          t_nude.bell1_ds:=ce.ds;
          t_nude.bell1_sz:=ce.sz;
          t_nude.clas:=insc(t_nude.clas,4,'E');
        elsif cf.rn=2 then
          t_nude.bell2:=substr(ce.bell,1,13);
          t_nude.bell2_prob:=ce.prob;
          t_nude.bell2_ds:=ce.ds;
          t_nude.bell2_sz:=ce.sz;
          t_nude.clas:=insc(t_nude.clas,11,'E');
        end if;
        t_minx:=ce.minx;
        t_maxx:=ce.maxx;
        update nude_y set face=cf.hashid where fname=c#.fname and face is null and obj like '%BELLY%' and
                   ce.bell like '%'||lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),1000000),6,'0')||'%' ;
        bell_cnt:=bell_cnt+SQL%ROWCOUNT;                   
      end loop; -- ce
      t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' XXXX-LIMITS dsf ['||(cf.ds+2*cf.sz)||' # '||(cf.ds+5*cf.sz)||
                                                           '] szf ['||(0.2*cf.sz)||' # '||(2.1*cf.sz)||
                                                           '] lrf [' ||(cf.lr-1.5*cf.sz)||' # '||(cf.lr+1.5*cf.sz)||
                                                           ']';
      if cf.rn=1 and t_nude.bell1 is not null then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.bell1_ds+0.5*t_nude.bell1_sz)||' # '||(t_nude.bell1_ds+2.5*t_nude.bell1_sz)||
                                '] lrb [' ||(nvl(t_minx,0))||' # '||(nvl(t_maxx,9999))||']'||chr(13);
      elsif cf.rn=2 and t_nude.bell2 is not null then
        t_nude.dbg:=t_nude.dbg||' dsb ['||(t_nude.bell2_ds+0.5*t_nude.bell2_sz)||' # '||(t_nude.bell2_ds+2.5*t_nude.bell2_sz)||
                                '] lrb [' ||(nvl(t_minx,0))||' # '||(nvl(t_maxx,9999))||']'||chr(13);
      else t_nude.dbg:=t_nude.dbg||chr(13); end if;
      for cx in ( select listagg(hashid,'+') xxxx, min(ds) ds, max(sz) sz, avg(prob) prob, round(avg(lr)) lr
                    from nude_y_v 
                   where obj='XXXX' and fname=c#.fname and face is null
                     and ds between cf.ds+2*cf.sz and cf.ds+5*cf.sz -- agains face
                     and sz between 0.2*cf.sz and 2.1*cf.sz                 
                     and lr between cf.lr-1.5*cf.sz and cf.lr+1.5*cf.sz
                     and ( (cf.rn=1 and t_nude.bell1 is not null and -- against belly
                            ds between t_nude.bell1_ds+0.5*t_nude.bell1_sz and t_nude.bell1_ds+2.5*t_nude.bell1_sz and 
                            lr between nvl(t_minx,0) and nvl(t_maxx,9999) )
                        or (cf.rn=2 and t_nude.bell2 is not null and 
                            ds between t_nude.bell2_ds+0.5*t_nude.bell2_sz and t_nude.bell2_ds+2.5*t_nude.bell2_sz and 
                            lr between nvl(t_minx,0) and nvl(t_maxx,9999) ) 
                        or ( cf.rn=1 and t_nude.bell1 is null ) or (cf.rn=2 and t_nude.bell2 is null ) )                            
                   having count(*) between 1 and 2 ) loop
        t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' XXXX '||cx.xxxx||' ds '||cx.ds||' sz '||cx.sz||' lr ' ||cx.lr||' prob ' ||cx.prob||chr(13);
        if    cf.rn=1 then
          t_nude.xxxx1:=substr(cx.xxxx,1,13);
          t_nude.xxxx1_prob:=cx.prob;
          t_nude.xxxx1_ds:=cx.ds;
          t_nude.xxxx1_sz:=cx.sz;
          t_nude.clas:=insc(t_nude.clas,5,'X');
        elsif cf.rn=2 then
          t_nude.xxxx2:=substr(cx.xxxx,1,13);
          t_nude.xxxx2_prob:=cx.prob;
          t_nude.xxxx2_ds:=cx.ds;
          t_nude.xxxx2_sz:=cx.sz;
          t_nude.clas:=insc(t_nude.clas,12,'X');
        end if;
        update nude_y set face=cf.hashid where fname=c#.fname and face is null and -- obj like '%' and
                   cx.xxxx like '%'||lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),1000000),6,'0')||'%' ;
        xxxx_cnt:=xxxx_cnt+SQL%ROWCOUNT;
      end loop; -- cx
      t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' FEET-LIMITS dsf ['||(cf.ds+3.5*cf.sz)||' # '||(cf.ds+11*cf.sz)||
                                                           '] szf ['||(0.3*cf.sz)||' # '||(1.8*cf.sz)||
                                                           '] lrf [' ||(cf.lr-1.5*cf.sz)||' # '||(cf.lr+1.5*cf.sz)||']'||chr(13);
      for ct in ( select listagg(hashid,'+') feet, min(ds) ds, max(sz) sz, avg(prob) prob, round(avg(lr)) lr
                    from nude_y_v 
                   where obj='FEET' and fname=c#.fname and face is null
                     and ds between cf.ds+3.5*cf.sz and cf.ds+11*cf.sz
                     and sz between 0.3*cf.sz and 1.8*cf.sz                 
                     and lr between cf.lr-1.5*cf.sz and cf.lr+1.5*cf.sz
                   having count(*) between 1 and 4 ) loop
        t_nude.dbg:=t_nude.dbg||'FACE #'||face_n||' FEET '||ct.feet||' ds '||ct.ds||' sz '||ct.sz||' lr ' ||ct.lr||' prob ' ||round(ct.prob,3)||chr(13);
        if    cf.rn=1 then
          t_nude.feet1:=substr(ct.feet,1,20);
          t_nude.feet1_prob:=round(ct.prob,3);
          t_nude.feet1_ds:=ct.ds;
          t_nude.feet1_sz:=ct.sz;
          t_nude.clas:=insc(t_nude.clas,6,'T');
        elsif cf.rn=2 then
          t_nude.feet2:=substr(ct.feet,1,20);
          t_nude.feet2_prob:=round(ct.prob,3);
          t_nude.feet2_ds:=ct.ds;
          t_nude.feet2_sz:=ct.sz;
          t_nude.clas:=insc(t_nude.clas,13,'T');
        end if;
        update nude_y set face=cf.hashid where fname=c#.fname and face is null and obj like '%FEET%' and
                   ct.feet like '%'||lpad(mod(dbms_utility.get_hash_value(obj||x||y||w||h||prob,0,1073741824),1000000),6,'0')||'%' ;
        feet_cnt:=feet_cnt+SQL%ROWCOUNT;                   
      end loop; -- ct
    end loop; -- cf
-- lost detections
    face_n:=0;
    for cz in ( select obj, prob, ds, sz, lr, hashid
                  from nude_y_v 
                 where fname=c#.fname and face is null
              order by ds ) loop
       t_nude.dbg:=t_nude.dbg||'LOST '||cz.obj||' hash '||cz.hashid||' ds '||cz.ds||' sz '||cz.sz||' lr '||cz.lr||' prob ' ||cz.prob||chr(13);
       if    cz.obj='BRST' then brst_lost:=brst_lost+1;
       elsif cz.obj='ARMP' then armp_lost:=armp_lost+1;       
       elsif cz.obj='BELL' then bell_lost:=bell_lost+1;
       elsif cz.obj='XXXX' then xxxx_lost:=xxxx_lost+1;       
       elsif cz.obj='FEET' then feet_lost:=feet_lost+1; end if;
       face_n:=face_n+1;
    end loop; -- cz
-- finally    
    t_nude.clas:=rpad(t_nude.clas,13,'-')||face_n;
--    begin
      insert into nude values t_nude;
--    exception when others then null; end;  
    i_cnt:=i_cnt+1;
  end loop; -- c#
  dbms_output.put_line('STOP '||p_batch_id||' +'||i_cnt
                     ||' BRST found '||brst_cnt||' lost '||brst_lost
                     ||' ARMP found '||armp_cnt||' lost '||armp_lost                     
                     ||' BELL found '||bell_cnt||' lost '||bell_lost
                     ||' XXXX found '||xxxx_cnt||' lost '||xxxx_lost
                     ||' FEET found '||feet_cnt||' lost '||feet_lost                     
                     ||' @ '||round(extract(SECOND FROM(systimestamp-t_start)),1)||' sec');
  commit;
end proc;

begin
  -- Initialization
  null;
end NUDP;
/

prompt
prompt Creating trigger ARCH_EXIF_2021A_BR
prompt ===================================
prompt
CREATE OR REPLACE TRIGGER ARCH_EXIF_2021A_BR before insert on "ARCH_EXIF_2021A" for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.sourcefile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.sourcefile,'FID');
  :new.copyr:=booru_fname.GET_ELEM(:new.sourcefile,'COPYR');
  :new.dtm:=sysdate;
end ARCH_EXIF_2021A_BR;
/

prompt
prompt Creating trigger ARCH_MD5_2021A_BR
prompt ==================================
prompt
CREATE OR REPLACE TRIGGER ARCH_MD5_2021A_BR before insert or update on ARCH_MD5_2021A for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.fname,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.fname,'FID');
  :new.fpath:=booru_fname.GET_ELEM(:new.fname,'FPATH');
  :new.fname:=booru_fname.GET_ELEM(:new.fname,'FNAME');
end ARCH_MD5_2021A_BR;
/

prompt
prompt Creating trigger ARCH_MD5_G2_BR
prompt ===============================
prompt
CREATE OR REPLACE TRIGGER ARCH_MD5_G2_BR before insert or update on ARCH_MD5_G2 for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.fname,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.fname,'FID');
  :new.fpath:=booru_fname.GET_ELEM(:new.fname,'FPATH');
  :new.fname:=booru_fname.GET_ELEM(:new.fname,'FNAME');
end ARCH_MD5_G2_BR;
/

prompt
prompt Creating trigger BCT_IM_BR
prompt ==========================
prompt
create or replace trigger BCT_IM_BR before insert or update on BCT_IM for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end BCT_IM_BR;
/

prompt
prompt Creating trigger KONA_IMM_BR
prompt ============================
prompt
create or replace trigger kona_IMM_BR before insert on kona_IMM for each row
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end kona_IMM_BR;
/

prompt
prompt Creating trigger KONA_IM_BR
prompt ===========================
prompt
create or replace trigger kona_IM_BR before insert on kona_IM for each row
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end kona_IM_BR;
/

prompt
prompt Creating trigger LOAD_EXIF_BR
prompt =============================
prompt
create or replace trigger LOAD_EXIF_BR before insert or update on LOAD_EXIF for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.sourcefile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.sourcefile,'FID');
  :new.dtm:=sysdate;
end LOAD_EXIF_BR;
/

prompt
prompt Creating trigger LOAD_EXIF_C_BR
prompt ===============================
prompt
create or replace trigger LOAD_EXIF_C_BR before insert or update on LOAD_EXIF_C for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.sourcefile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.sourcefile,'FID');
  :new.copyr:=booru_fname.GET_ELEM(:new.sourcefile,'COPYR');
  :new.dtm:=sysdate;
end LOAD_EXIF_C_BR;
/

prompt
prompt Creating trigger LOAD_EXIF_G_BR
prompt ===============================
prompt
create or replace trigger LOAD_EXIF_G_BR before insert or update on LOAD_EXIF_G for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.sourcefile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.sourcefile,'FID');
  :new.dtm:=sysdate;
end LOAD_EXIF_G_BR;
/

prompt
prompt Creating trigger LOAD_FACE_BR
prompt =============================
prompt
create or replace trigger LOAD_FACE_BR before insert or update on LOAD_FACE for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ffile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ffile,'FID');
  :new.dtm:=sysdate;
end LOAD_FACE_BR;
/

prompt
prompt Creating trigger LOAD_IM_BR
prompt ===========================
prompt
create or replace trigger LOAD_IM_BR before insert or update on LOAD_IM for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end LOAD_IM_BR;
/

prompt
prompt Creating trigger LOAD_IM_G_BR
prompt =============================
prompt
create or replace trigger LOAD_IM_G_BR before insert or update on LOAD_IM_G for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end LOAD_IM_G_BR;
/

prompt
prompt Creating trigger YNDR_IM_BR
prompt ===========================
prompt
create or replace trigger YNDR_IM_BR before insert or update on YNDR_IM for each row
declare
  -- local variables here
begin
  :new.booru:=booru_fname.GET_ELEM(:new.ifile,'BOORU');
  :new.fid:=booru_fname.GET_ELEM(:new.ifile,'FID');
  :new.dtm:=sysdate;
end YNDR_IM_BR;
/


prompt Done
spool off
set define on
