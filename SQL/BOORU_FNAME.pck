create or replace package BOORU_FNAME as
  FUNCTION RECROP ( p_w in number, p_h in number, p_x in number, p_y in number,
                    p_iw in number, p_ih in number, p_log in number default 0 ) return varchar2 ;
  PROCEDURE PARSE_FNAME( p_FullName in varchar2, o_FPath out varchar2, o_FName out varchar2, o_booru out varchar2, o_fid out varchar2,
                         o_copyr out varchar2, o_chars out varchar2, o_artis out varchar2, o_frest out varchar2 ) ;
  FUNCTION GET_ELEM( p_FullName in varchar2, p_element in varchar2 ) return varchar2 ;
end;
/
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
  else
    null;
  end if;
  o_booru:=t_booru;
-- trim trailing extension and suffixes
  t_frest:=replace(t_frest,'.jpg','');
  if t_frest like '% [PNG]%' then t_frest:=replace(t_frest,' [PNG]',''); t_PNG:=1; end if;
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
  if t_fid is null and t_booru='Animepaper' then
    if instr(t_frest,'_',-1)>=length(t_frest)-6  then
      t_fid:=substr(t_frest,instr(t_frest,'_',-1)+1);
      if translate(t_fid,'0123456789','          ') is null then
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
