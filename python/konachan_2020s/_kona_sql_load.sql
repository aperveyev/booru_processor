-- a lot of fixes for konachan-specific JSON required to continue
-- step by step
update kona_load set jj=replace(j,' False,',' "False",') where jj is null and j is not json and replace(j,' False,',' "False",') is json 
-- 3549 of 4472
update kona_load set jj=replace(j,'\''','_') where jj is null and j is not json and replace(j,'\''','_') is json 
-- 326
update kona_load set jj=replace(j,'\\"','_') where jj is null and j is not json and replace(j,'\\"','_') is json 
-- 48
update kona_load set jj=replace(replace(j,'\\"','_'),'\''','_') where jj is null and j is not json and replace(replace(j,'\\"','_'),'\''','_') is json 
-- maybe some minor fixes forgotten, KONA_JSON.tsv must be bug-free 

-- fill main POSTS table
insert into kona (id, tid, created_at, score, rating, i_width, i_height, f_size, f_url, s_width, s_height, s_size, s_url, j_size, j_url, creator_id, author, fmd5, parent_id)
select e.id, t.tid, to_date('1970-01-01','YYYY-MM-DD')+numtodsinterval(t.created_at,'SECOND') created_at, t.score, t.rating, 
       t.i_width, t.i_height, t.f_size, replace(asciistr(t.f_url),'\005C','') f_url, t.s_width, t.s_height, t.s_size, 
       replace(asciistr(t.s_url),'\005C','') s_url, j_size, replace(asciistr(t.j_url),'\005C','') j_url,
       t.creator_id, t.author, t.fmd5, t.parent_id
from kona_load e,     
     json_table (    
       nvl(e.jj,e.j), '$' -- default
       columns (    
        tid number path '$.posts[0].id',
        created_at path '$.posts[0].created_at',
        score number path '$.posts[0].score',
        rating varchar2(40) path '$.posts[0].rating',
        i_width number path '$.posts[0].width',
        i_height number path '$.posts[0].height',
        s_width number path '$.posts[0].sample_width',
        s_height number path '$.posts[0].sample_height',
        s_size number path '$.posts[0].sample_file_size',
        s_url varchar2(400) path '$.posts[0].sample_url',
        j_size number path '$.posts[0].jpeg_file_size',
        j_url varchar2(400) path '$.posts[0].jpeg_url',
        f_size number path '$.posts[0].file_size',
        f_url varchar2(400) path '$.posts[0].file_url',
        creator_id number path '$.posts[0].creator_id',
        author varchar2(200) path '$.posts[0].author',
        fmd5 varchar2(32)path '$.posts[0].md5',
        parent_id number path '$.posts[0].parent_id' ) ) t
where e.id not in ( select id from kona ) -- for iterative usage
order by 1 desc

-- fill tags parsed from list
insert into kona_dt (id, x, tag, tag_cat, tag_id)
select id, x, substr(tag,1,i-1) tag, decode(substr(tag,i+1),'artist',1,'character',4,'circle',3,'copyright',3,'faults',-1,'style',-1,'general',0) tag_cat, 0 tag_id 
from (
  select id, x, replace(replace(tag,'{',''),'}','') tag, instr(replace(replace(tag,'{',''),'}',''),':',-1,1) i
    from (
      with y as (
        select e.id, t.id tid, t.tags -- , j
        from kona_load e,     
             json_table (    
               nvl(e.jj,e.j), '$'     -- main code
               columns (    
                id path '$.posts[0].id',
                tags format json path '$.tags' ) ) t
        where e.id not in ( select distinct id from kona_dt ) -- for iterative usage
                 )
      select id, tags, x, substr(replace(regexp_substr(tags,'[^,]+', 1, x),'"',''),1,150) tag
      from y, lateral ( select level x from dual connect by regexp_substr(tags, '[^,]+', 1, level) is not null )
         )
     )
order by 1, 2


-- supplementary table with stats by tag
-- drop table kona_tg
-- create table kona_tg as
merge into kona_tg o using (
select tag, tag_cat, count(*) cnt, 0 tag_id 
from kona_dt
group by tag, tag_cat ) n
on (o.tag=n.tag and o.tag_cat=n.tag_cat)
when matched then update set o.cnt=n.cnt
when not matched then insert (tag, tag_cat, cnt, tag_id) values (n.tag, n.tag_cat, n.cnt, n.tag_id) ;

-- detect tag-ids with DANBOORU tag list (not provided here)
update kona_tg e
set e.tag_id=(select tag_id from danb_tg t where t.tag_name=e.tag and t.tag_cat=e.tag_cat )
where e.tag in ( select tag_name from danb_tg where tag_cat in (0,1,3,4) ) and e.tag_id=0

-- totals over it 
select tag_cat, count(*) tags, sum(decode(tag_id,0,0,1)) tag_ids, sum(cnt) cnt from kona_tg group by tag_cat

-- POOLS not used widely in konachan so I provide this code only as example (no DATA exported)
-- pools
create table kona_pools as
-- insert into kona_pools
select -- e.id, t.tid, 
       distinct t.pid, t.pname, t.pcnt
from kona_load e,     
     json_table (    
       nvl(e.jj,e.j), '$'     -- main code
       columns (    
        tid number path '$.posts[0].id',
        nested path '$.pools[*]'
           columns ( pid number path '$.id',
                     pname varchar2(400) path '$.name',
                     pcnt number path '$.post_count' ) ) ) t
where t.pid is not null
-- and t.pid not in ( select pid from kona_pools )
-- create unique index kona_pools_ui on kona_pools ( pid )
-- select pid, pname, pcnt from kona_pools order by 1 for update -- only 214 POOLS @ ID=310100

-- pool_posts
create table kona_pposts as
-- insert into kona_pposts
select e.id, t.tid, t.pid, t.ppid, t.ppseq
from kona_load e,     
     json_table (    
       nvl(e.jj,e.j), '$'     -- main code
       columns (    
        tid number path '$.posts[0].id',
        nested path '$.pool_posts[*]'
           columns ( ppid number path '$.id',
                     pid number path '$.pool_id',
                     ppseq number path '$.sequence' ) ) ) t
where t.ppid is not null
-- and e.id not in ( select distinct id from kona_pposts )
-- create unique index kona_pposts_ui on kona_pposts ( ppid, pid )
-- select count(*) from kona_pposts -- 10854 @ ID=310100
