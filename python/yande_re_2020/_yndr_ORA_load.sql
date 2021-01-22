-- parse POSTS from JSON
insert into yndr (id, tid, created_at, score, rating, i_width, i_height, f_ext, f_size, f_url, s_width, s_height, s_size, s_url, j_size, j_url)
select e.id, to_number(t.id) tid, to_date('1970-01-01','YYYY-MM-DD')+numtodsinterval(t.created_at,'SECOND') created_at, to_number(t.score) score, t.rating, 
       to_number(t.i_width) i_width, to_number(t.i_height) i_height, t.f_ext, to_number(t.f_size) f_size, t.f_url,
       to_number(t.s_width) s_width, to_number(t.s_height) s_height, to_number(t.s_size) s_size, t.s_url, j_size, t.j_url
from yndr_load e,     
     json_table (    
       e.j, '$' -- default
--       replace(e.j,'\''',''), '$' -- patch 1
--       replace(e.j,'\\"',''), '$' -- patch 2
       columns (    
        id path '$.posts[0].id',
        created_at path '$.posts[0].created_at',
        score path '$.posts[0].score',
        rating path '$.posts[0].rating',
        i_width path '$.posts[0].width',
        i_height path '$.posts[0].height',
        s_width path '$.posts[0].sample_width',
        s_height path '$.posts[0].sample_height',
        s_size path '$.posts[0].sample_file_size',
        s_url path '$.posts[0].sample_url',
        j_size path '$.posts[0].jpeg_file_size',
        j_url path '$.posts[0].jpeg_url',
        f_ext path '$.posts[0].file_ext',
        f_size path '$.posts[0].file_size',
        f_url path '$.posts[0].file_url' ) ) t
where e.id not in ( select id from yndr ) -- for repetitive addon
order by 1 desc

-- parse POST TAGS from JSON
insert into yndr_dt (id, x, tag, tag_cat, tag_id)
select id, x, substr(tag,1,i-1) tag, decode(substr(tag,i+1),'artist',1,'character',4,'circle',3,'copyright',3,'faults',-1,'general',0) tag_cat, 0 tag_id from (
select id, x, replace(replace(tag,'{',''),'}','') tag, instr(replace(replace(tag,'{',''),'}',''),':',-1,1) i
from (
with y as (
select e.id, t.id tid, t.tags, j
from yndr_load e,     
     json_table (    
       e.j, '$'     -- main code
--       replace(e.j,'\''',''), '$' -- patch 1
--       replace(e.j,'\\"',''), '$' -- patch 2
       columns (    
        id path '$.posts[0].id',
        tags format json path '$.tags' ) ) t
where e.id not in ( select distinct id from yndr_dt ) -- for repetitive addon
)
select id, tags, x, substr(replace(regexp_substr(tags,'[^,]+', 1, x),'"',''),1,150) tag
from y, lateral ( select level x from dual connect by regexp_substr(tags, '[^,]+', 1, level) is not null )
)
) order by 1, 2

-- update stat-by-tag
merge into yndr_tg o using (
select tag, tag_cat, count(*) cnt, 0 tag_id 
from yndr_dt
group by tag, tag_cat ) n
on (o.tag=n.tag and o.tag_cat=n.tag_cat)
when matched then update set o.cnt=n.cnt
when not matched then insert (tag, tag_cat, cnt, tag_id) values (n.tag, n.tag_cat, n.cnt, n.tag_id)

-- parse POOLS from JSON
insert into yndr_pools
select -- e.id, t.tid, 
       distinct t.pid, t.pname, t.pcnt
from yndr_load e,     
     json_table (    
       e.j, '$'     -- main code
--       replace(e.j,'\''',''), '$' -- patch 1
--       replace(e.j,'\\"',''), '$' -- patch 2
       columns (    
        tid number path '$.posts[0].id',
        nested path '$.pools[*]'
           columns ( pid number path '$.id',
                     pname varchar2(400) path '$.name',
                     pcnt number path '$.post_count' ) ) ) t
where t.pid is not null
and t.pid not in ( select pid from yndr_pools )

-- POOL POSTS
insert into yndr_pposts
select e.id, t.tid, t.pid, t.ppid, t.ppseq
from yndr_load e,     
     json_table (    
--       e.j, '$'     -- main code
--       replace(e.j,'\''',''), '$' -- patch 1
       replace(e.j,'\\"',''), '$' -- patch 2       
       columns (    
        tid number path '$.posts[0].id',
        nested path '$.pool_posts[*]'
           columns ( ppid number path '$.id',
                     pid number path '$.pool_id',
                     ppseq number path '$.sequence' ) ) ) t
where t.ppid is not null
and e.id not in ( select distinct id from yndr_pposts )

-- match tags with DANBOORU catalog, you can not reproduce this
update yndr_tg e
set e.tag_id=(select tag_id from danb_tg t where t.tag_name=e.tag and t.tag_cat=e.tag_cat )
where e.tag in ( select tag_name from danb_tg where tag_cat in (1,3,4) ) and e.tag_id=0
