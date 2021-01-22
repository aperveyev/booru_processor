-- create "list" for samples grab "job" controlled via database
create table yndr_rip as 
with y as (
select round( PERCENT_RANK() OVER ( PARTITION BY floor(id/10000), rating ORDER BY score DESC) , 3 ) rnk, y.*
from ( select yndr.*
from yndr
where f_ext in ('jpg','png') and rating in ('s','q') and YNDR.ID>165352
 and greatest(i_height,i_width)>=1200
 and least(i_height,i_width)>=1000
 and i_height*i_width>=1310720
 and i_width/i_height between 0.4 and 2.1 
) y
),
t as (
select id, translate(tag,' /:''&%*"?=','___') tag, x, tag_cat, rank() over (partition by id, tag_cat order by x) r
from yndr_dt
where tag_cat in (1,3,4)
order by id desc, x  
) 
select y.id, y.created_at, y.score, y.rating, y.rnk, y.i_width, y.i_height, y.f_size, y.s_width, y.s_height, y.s_size, y.s_url, y.f_url, 
       'yande.re - '||lpad(y.id,6,'0')||' - '||nvl2(tc,tc,'misc')||' ~ '||nvl(substr(tp,1,greatest(140-nvl(length(tc),0)-nvl(length(ta),0),5)),'unknown')
                                                                        ||' ('||nvl(ta,'anonymous')||').jpg' fname,
       0 done
from y -- base id list
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) tc from t where tag_cat=3 and r in (1,2,3) group by id ) c on c.id=y.id
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) tp from t where tag_cat=4 and r in (1,2,3,4,5) group by id ) p on p.id=y.id
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY x) ta from t where tag_cat=1 and r in (1,2) group by id ) a on a.id=y.id
where 1=1
order by y.id ;

create unique index yndr_rip_ui on yndr_rip ( id ) ;


-- you have to suppress non-ascii symbols in planned file names
-- targeted replace desirable for exact known cases
-- update yndr_rip set fname=REPLACE(ASCIISTR(fname),'\00E9','e') where ASCIISTR(fname) like '%\00E9%' -- pokemon
select *
from yndr_rip
-- update yndr_rip set fname=REGEXP_REPLACE(ASCIISTR(fname),'\\[[:xdigit:]]{4}','') -- kill them all
where REGEXP_REPLACE(ASCIISTR(fname),'\\[[:xdigit:]]{4}','')!=fname

-- to control job progress
select rating, done, count(*) cnt, sum(s_size) s_size, min(id) minid, max(id) maxid from yndr_rip group by rating, done order by 1, 2