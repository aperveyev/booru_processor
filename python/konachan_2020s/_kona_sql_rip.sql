-- tricky SQL to build a table for grabbing job and create (using tags) informative file names
-- drop table kona_rip
-- create table kona_rip as 
with y as (
select round( PERCENT_RANK() OVER ( PARTITION BY floor(id/10000), rating ORDER BY score DESC) , 3 ) rnk, y.*
from ( select * -- count(*) -- 143921 -- check it
from kona
where rating in ('s','q') -- ID 91817 = 30.12.2010 change in sampling from 2000 to 1500
 and greatest(i_height,i_width)>=1200 -- not too small
 and least(i_height,i_width)>=1000
 and i_height*i_width>=1310720 -- (1280*1024)
 and i_width/i_height between 0.4 and 2.1 -- not too disproportional
) y
),
t as (
-- replacing some symbols evidently bad for file namimg
select id, translate(tag,' /:''&%*"?=','___') tag, x, tag_cat, rank() over (partition by id, tag_cat order by x) r
from kona_dt
where tag_cat in (1,3,4)
order by id desc, x  
) 
select y.id, y.created_at, y.score, y.rating, y.rnk, y.i_width, y.i_height, y.f_size, y.f_url, y.s_width, y.s_height, y.s_size, y.s_url, y.j_size, y.j_url,
       case when y.id<91817 and (f_size<s_size or (j_size<s_size and j_size!=0) or i_width*i_height=s_width*s_height) then case when j_size!=0 then 'JO' else 'FO' end
            when s_size=0 and j_size=0 then 'F'
            when s_size=0 then 'J'
            else 'S' end d_src, -- choose what to download
       case when y.id<91817 and (f_size<s_size or (j_size<s_size and j_size!=0) or i_width*i_height=s_width*s_height) then case when j_size!=0 then j_url else f_url end
            when s_size=0 and j_size=0 then f_url
            when s_size=0 then j_url
            else s_url end d_url, -- choose what to download
       'konachan.com - '||lpad(y.id,6,'0')||' - '||nvl2(tc,tc,'misc')||' ~ '||nvl(substr(tp,1,greatest(140-nvl(length(tc),0)-nvl(length(ta),0),5)),'unknown')
                                                                        ||' ('||nvl(ta,'anonymous')||').jpg' fname,
       0 done
from y -- base id list
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) tc from t where tag_cat=3 and r in (1,2,3) group by id ) c on c.id=y.id
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) tp from t where tag_cat=4 and r in (1,2,3,4,5) group by id ) p on p.id=y.id
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) ta from t where tag_cat=1 and r in (1,2) group by id ) a on a.id=y.id
where 1=1 -- y.id not in ( select id from kona_rip ) -- for iterational usage
order by y.id

-- we need more patches for future filenames
-- update kona_rip set fname=replace(fname,'\\_','_') where fname like '%\\%' -- 5317
-- update kona_rip set fname=replace(fname,'\\u0026','') where fname like '%\\u0026%' -- 681
-- update kona_rip set fname=replace(fname,'\','') where fname like '%\%' -- 5
-- discover non-asscii remainder
select REGEXP_REPLACE(ASCIISTR(fname),'\\[[:xdigit:]]{4}','') f, 
       replace(asciistr(fname),'\005C','') f2,
       fname
from kona_rip r
where ASCIISTR(fname)!=fname

-- control GRAB status when grab_files_DB.py running
select rating, done, d_src, count(*) cnt, sum(decode(d_src,'S',s_size,'J',j_size,'F',f_size,'FO',f_size,'JO',j_size)) d_size, min(id) minid, max(id) maxid 
from kona_rip group by rating, done, d_src order by 1, 2, 3
