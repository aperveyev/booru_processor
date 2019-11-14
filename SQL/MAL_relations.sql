-- парсим related в анимехах
insert into mal_trel 
select * from (
select t.anime_id, t.title, 'Side_story' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( replace(t.related,'Side story','Side_story'), '$'     
                           columns ( nested path '$.Side_story[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Alternative_version' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( replace(t.related,'Alternative version','Alternative_version'), '$'     
                           columns ( nested path '$.Alternative_version[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Alternative_setting' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( replace(t.related,'Alternative setting','Alternative_setting'), '$'     
                           columns ( nested path '$.Alternative_setting[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Spin_off' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( replace(t.related,'Spin-off','Spin_off'), '$'     
                           columns ( nested path '$.Spin_off[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Sequel' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( t.related, '$'     
                           columns ( nested path '$.Sequel[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Character' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( t.related, '$'     
                           columns ( nested path '$.Character[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Summary' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( t.related, '$'     
                           columns ( nested path '$.Summary[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Prequel' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( t.related, '$'     
                           columns ( nested path '$.Prequel[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
union all
select t.anime_id, t.title, 'Other' rel_type, r.rel_id, rel_title 
from MAL_TITLES t, json_table ( t.related, '$'     
                           columns ( nested path '$.Other[*]' columns ( mal_type path '$.type', rel_title path '$.title', rel_id  path '$.mal_id' ) ) ) r
where mal_type='anime'
) 
order by 1, 3

-- парсим animelist персонажей
declare
  jobj json_object_t;
  keys json_key_list;
  crole varchar2(200);
begin
  for cc in ( select char_id, char_name, char_favs, replace(translate(animelist,'<>''','"""'),'Anime id: ','') alist
                from mal_chars
               where replace(translate(animelist,'<>''','"""'),'Anime id: ','') is json and length(animelist)>3 ) loop  
    jobj := json_object_t ( cc.alist );
    keys := jobj.get_keys;
    for i in 1 .. keys.count loop
      crole:=jobj.get_string(keys(i));
--      dbms_output.put_line(cc.char_id||'>>'||keys(i)||'=='||jobj.get_string(keys(i)));
      insert into mal_tc ( char_id, anime_id, char_role ) 
        values ( cc.char_id, keys(i), crole ) ;
    end loop;
  end loop;  
end;
/  
