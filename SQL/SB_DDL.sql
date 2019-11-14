-- посты Safebooru и сопутствующая мета-информация
create table SB
(
  id            NUMBER not null,
  created_at    NUMBER not null,
  score         NUMBER not null,
  sample_width  NUMBER not null,
  sample_height NUMBER not null,
  tags_gen      NUMBER not null,
  tags_art      NUMBER not null,
  tags_copy     NUMBER not null,
  tags_char     NUMBER not null,
  tags_etc      NUMBER not null,
  created_dt    DATE
) ;
create unique index UI_SB on SB (ID) ;

-- теги Safebooru (retrofit из дампа) в т.ч. их связь с Danbooru
create table SB_TAGS
(
  tag       VARCHAR2(160) not null,
  posts     NUMBER not null,
  tagtype   VARCHAR2(40),
  tagttype2 VARCHAR2(40),
  tag_id    NUMBER,         /* danbooru */
  tag_cat   NUMBER not null /* danbooru */
) ;
create unique index UI_SB_TAGS on SB_TAGS (TAG) ;

-- теги по постам
create table SB_DT
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER
) ;
create index II_SB_DT on SB_DT (ID) ;
create index IT_SB_DT on SB_DT (TAG) ;
