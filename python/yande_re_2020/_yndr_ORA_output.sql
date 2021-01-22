-- ANALYSIS EXAMPLES
-- posts popularity by rating and tag presense
select tag, cnt, tag_id,
       sum(decode(rating,'s',1,0)) c_s, sum(decode(rating,'q',1,0)) c_q, sum(decode(rating,'e',1,0)) c_e, 
       round(sum(decode(rating,'s',score,0))/greatest(sum(decode(rating,'s',1,0)),1)) a_s, 
       round(sum(decode(rating,'q',score,0))/greatest(sum(decode(rating,'q',1,0)),1)) a_q, 
       round(sum(decode(rating,'e',score,0))/greatest(sum(decode(rating,'e',1,0)),1)) a_e
from (
select y.score, y.rating, d.id, g.tag, g.cnt, g.tag_id
from yndr_dt d
join yndr_tg g on d.tag=g.tag
join yndr_rip y on d.id=y.id
where g.tag_cat=0 ---1 or g.tag_cat is null
  and g.cnt>=20
order by d.id
)
group by tag, cnt, tag_id
order by 2 desc

-- you can play XCOPY-ing (or moving) samples from unzipped folders to eye-controlled area
select 'xcopy "D:\TORR\yande_re_2020'||substr(i.ipath,9)||'\'||y.fname||'" C:\SORT\ ' xcpy from ...

-- copyrights and characters bundled with DANBOORU franchises and MYANIMELIST entries
select u.tag, u.tag_cat, u.cnt, u.tag_id,
       nvl(d.group_id,d.tag_id) fr_id, g.tag_name fr_name, nvl(d.mal_id,g.mal_id) mal_id, nvl(t.title,c.char_name) mal_name
from yndr_tg u
left join danb_tg d on d.tag_id=u.tag_id
left join danb_tg g on nvl(d.group_id,d.tag_id)=g.tag_id
left join mal_titles t on nvl(d.mal_id,g.mal_id)=t.anime_id and u.tag_cat=3
left join mal_chars c on nvl(d.mal_id,g.mal_id)=c.char_id  and u.tag_cat=4
where u.tag_cat in (3,4)
order by 5, 2, 3 desc
-- wherever possible

-- relative BW score against average by copyright
select tag, rating, cnt, score, cnt_bw, score_bw, round(score_bw/score,2) bw_good from (
select t.tag, y.rating, count(*) cnt, round(avg(score),1) score, 
                        sum(case when i.meang < 0.02 then 1 else 0 end) cnt_bw,
                        round(sum(case when i.meang < 0.02 then score else 0 end)/
                              greatest(1,sum(case when i.meang < 0.02 then 1 else 0 end))) score_bw
from yndr_rip y
join yndr_dt d on y.id=d.id 
join yndr_tg t on d.tag=t.tag and t.tag_cat=3
join yndr_im i on i.fid=d.id
group by t.tag, y.rating
having count(*)>49
) where cnt_bw>19 and score_bw>9 order by 7 desc
