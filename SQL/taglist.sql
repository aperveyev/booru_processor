select tag_cat, count(*) cnt, sum(nvl2(group_id,1,0)) fred, sum(nvl2(mal_id,1,0)) maled from (

select t.tag_cat||';'||t.tag_id||';'||replace(replace(t.tag_name,'"',''),';','_')
       ||';'||t.cnt||';'|| nvl(t.group_id,(select decode(count(*),0,'',t.tag_id) from danb_tg i where i.group_id=t.tag_id and i.tag_cat=3 group by t.tag_id))
       ||';'||t.mal_id||';'||replace(replace(m.title,'"',''),';','_')||';'||m.t_members, 
       t.tag_cat, t.cnt, t.tag_id, t.tag_name, t.group_id, t.mal_id, m.title, m.t_members
from danb_tg t
left join mal_titles m on t.mal_id=m.anime_id -- and m.t_members>=5
where t.tag_cat=3 and t.cnt>=5
union
select t.tag_cat||';'||t.tag_id||';'||replace(replace(t.tag_name,'"',''),';','_')
       ||';'||t.cnt||';'||t.group_id||';'||t.mal_id||';'||replace(replace(m.char_name,'"',''),';','_')||';'||m.char_favs, 
       t.tag_cat, t.cnt, t.tag_id, t.tag_name, t.group_id, t.mal_id, m.char_name, m.char_favs
from danb_tg t
left join mal_chars m on t.mal_id=m.char_id -- and m.char_favs>=2
where t.tag_cat=4 and t.cnt>=5
order by 2, 3 desc

) group by tag_cat
