-- here are some samples of code - non complete and only partially ordered

-- fill posts table directly from JSON
insert into zero ( id, furl, created_at, iwidth, iheight, enc )
select distinct
       regexp_substr(substr(furl,length(furl)-10,7),'[0-9]+',1) fid,
       t.furl, to_date(substr(t.dt,5),'MON DD HH24:MI:SS YYYY') dt,
       to_number(replace(t.iwidth,' px','')) iwidth, to_number(replace(t.iheight,' px','')) iheight, t.enc
from DIR_BS_EXT e,
     json_table (    
       e.fline, '$'     
       columns (    
        author path '$.author',
        furl path '$.contentUrl',
        turl path '$.thumbnail',
        enc path '$.encodingFormat',
        dt path '$.datePublished',
        iname path '$.name',
        iwidth path '$.width',
        iheight path '$.height',
        isize path '$.contentSize' ) ) t

-- fill another posts table with MD5 (FCIV) data
insert /*+ ignore_row_on_dupkey_index ( zero_f_ui ) */
into zero_f ( fname, fpath, fid, fmd5 )
select replace(booru_fname.GET_ELEM(substr(fline,34),'FNAME'),chr(13),'') fname,
       booru_fname.GET_ELEM(substr(fline,34),'FPATH') fpath,
       booru_fname.GET_ELEM(substr(fline,34),'FID') fid,
       substr(fline,1,32) fmd5
from DIR_BS_EXT 

-- tags table filled not at once, so adjust calculated fields with merge
merge into zero_dt o using (
select id, tag, tag_cat, rank() over (partition by id, tag_cat order by tag) r
from (
select id, tag, -- some tags throwed out to category -1 not to use them in filenaming
  decode(tag,'Pixiv',-1,'Fanart',-1,'Fanart From Pixiv',-1,
             'Manga Cover',-1,'Novel Illustration',-1,'Scan',-1,
             'Character Request',-1,'Official Art',-1,'Fanart From DeviantART',-1,
             'Twitter',-1,'Render',-1,'Edited',-1,
             'Tumblr',-1,'deviantART',-1,'Wallpaper',-1,'TAGFAIL',-1,'Mobile Wallpaper',-1,
             'Revision',-1,'Sketch',-1,'Official Card Illustratio...',-1,'Artist Request',-1,
             'Cover Image',-1,'Comic',-1,'CG Art',-1,'Fanart From Tumblr',-1,'Self Scanned',-1,
             'Magazine (Source)',-1,'Self Made',-1,'Animated GIF',-1,'Vector',-1,
             'Character Sheet',-1,'Translation Request',-1,'Screenshot',-1,'3D',-1,'PNG Conversion',-1,
             'Copyright Request',-1,'Official Character Inform...',-1,'Dakimakura',-1,'Manga Page',-1,
             'DVD (Source)',-1,'Commission',-1,'Watercolor',-1,'Magazine Page',-1,
             'Comic Market',-1,'CD (Source)',-1,'Newtype Magazine (Source)',-1,
             'Calendar (Source)',-1,'Chapter Cover',-1,'Doujinshi Cover',-1,'4K Ultra HD Wallpaper',-1,
              decode(tcat,'Meta',-1,'Artbook',3,'Character',4,'Visual Novel',3,'Series, OVA',3,'Series, Game',3,'Game',3,
                          'Series',3,'Series, Visual Novel',3,'Studio',-1,'OVA',3,'Mangaka',1,'Character Group',4,
                          'Source',3)) tag_cat
from zero_dt )
) n on (o.id=n.id and o.tag=n.tag and ( n.tag_cat!=o.tag_cat or o.r!=n.r or o.r is null ) )
when matched then update set o.tag_cat=n.tag_cat, o.r=n.r

-- MUST DE-UNICODE TAGS !!!
select tag, tag_cat, ASCIISTR(tag), count(*) c 
from zero_dt 
where REGEXP_REPLACE(ASCIISTR(tag),'\\[[:xdigit:]]{4}','')!=tag
group by tag, tag_cat, ASCIISTR(tag)
order by 4 desc
-- update zero_dt set tag=REPLACE(tag,'&amp;','') where tag like '%&amp;%' -- 4.257
-- update zero_dt set tag=REPLACE(tag,'...','_') where tag like '%...%' -- 20.582
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E9','e') where ASCIISTR(tag) like '%\00E9%' -- e 16.484
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\2019','')  where ASCIISTR(tag) like '%\2019%' -- ` 821
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E8','e') where ASCIISTR(tag) like '%\00E8%' -- e 552
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E4','a') where ASCIISTR(tag) like '%\00E4%' -- a 628
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00C9','E') where ASCIISTR(tag) like '%\00C9%' -- E 241
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00EB','e') where ASCIISTR(tag) like '%\00EB%' -- e 275
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00FA','u') where ASCIISTR(tag) like '%\00FA%' -- u 1187
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E1','a') where ASCIISTR(tag) like '%\00E1%' -- a 163
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00BD','1_2') where ASCIISTR(tag) like '%\00BD%' -- 125
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00F6','o') where ASCIISTR(tag) like '%\00F6%' -- o 125
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00FC','u') where ASCIISTR(tag) like '%\00FC%' -- u 78
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00FB','u') where ASCIISTR(tag) like '%\00FB%' -- u 10
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E7','c') where ASCIISTR(tag) like '%\00E7%' -- c 30
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00F3','o') where ASCIISTR(tag) like '%\00F3%' -- o 18
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E6','e') where ASCIISTR(tag) like '%\00E6%' -- e 14
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00B0','') where ASCIISTR(tag) like '%\00B0%' --     79
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00E2','a') where ASCIISTR(tag) like '%\00E2%' -- a  48
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00D7','x') where ASCIISTR(tag) like '%\00D7%' -- x  121
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00ED','u') where ASCIISTR(tag) like '%\00ED%' -- i  87
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00D8','O') where ASCIISTR(tag) like '%\00D8%' -- O  29
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\2013','-') where ASCIISTR(tag) like '%\2013%' -- -  28
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00EF','i') where ASCIISTR(tag) like '%\00EF%' -- i  23
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00D6','O') where ASCIISTR(tag) like '%\00D6%' -- O  29
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\2020','_') where ASCIISTR(tag) like '%\2020%' --    26
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00C4','A') where ASCIISTR(tag) like '%\00C4%' -- A  12
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00B3','3') where ASCIISTR(tag) like '%\00B3%' -- 3  6
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\00B2','2') where ASCIISTR(tag) like '%\00B2%' -- 2  11
-- update zero_dt set tag=REPLACE(ASCIISTR(tag),'\005C','') where ASCIISTR(tag) like '%\005C%' --     41
-- remainder
select tag, tag_cat, REGEXP_REPLACE(ASCIISTR(tag),'\\[[:xdigit:]]{4}','_') treg, ASCIISTR(tag), count(*) c 
from zero_dt 
where REGEXP_REPLACE(ASCIISTR(tag),'\\[[:xdigit:]]{4}','')!=tag
group by tag, tag_cat, REGEXP_REPLACE(ASCIISTR(tag),'\\[[:xdigit:]]{4}','_'), ASCIISTR(tag)

-- here we generate BAT file (piece by piece), copy-paste and execute its results
with t as (
select id, translate(replace(REGEXP_REPLACE(ASCIISTR(tag),'\\[[:xdigit:]]{4}','_'),'...',')'),' /:''&%*"?`=+','___') tag, 
       tag itag, tag_cat, rank() over (partition by id, tag_cat order by tag) r
from zero_dt
where tag_cat in (1,3,4) and tag not in ('TAGFAIL')
order by id desc, tag_cat
) 
select d.fid id,
-- most tricky part among all stuff
       'move "'||d.fpath||'\'||d.fname||'" "'|| 
       nvl2(d.ifmt,replace(d.fpath,'xxxx',substr(d.fid,4,1)||'xxx'),substr(d.fpath,1,length(d.fpath)-8)) -- JPG not garanteed, use renamer to fix
             ||'\www.zerochan.net - '||d.fid||' - '
             ||nvl2(tc,tc,'misc')||' ~ '||nvl(substr(tp,1,greatest(150-nvl(length(tc),0)-nvl(length(ta),0),5)),'unknown') -- to avoid extremely long name
             ||' ('||nvl(ta,'anonymous')||').'||nvl(d.ifmt,'jpg')||'" ' fname
       , y.created_at, y.iwidth, y.iheight, d.fmd5, y.furl
from zero_f d -- base table
left join zero y on d.fid=y.id -- JSON from site, sometimes with misplaced id
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) tc from t where tag_cat=3 and r in (1,2,3) group by id ) c on c.id=d.fid
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) tp from t where tag_cat=4 and r in (1,2,3,4,5) group by id ) p on p.id=d.fid
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) ta from t where tag_cat=1 and r in (1,2) group by id ) a on a.id=d.fid
where d.fid between 2860000 and 2879999
order by d.fid 
