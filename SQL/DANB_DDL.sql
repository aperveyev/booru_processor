-- посты Danbooru_2018 (2017) и привязанная к ним информация
create table DANB
(
  id           NUMBER,
  created_at   DATE,
  score        NUMBER,
  rating       VARCHAR2(3),
  image_width  NUMBER,
  image_height NUMBER,
  file_ext     VARCHAR2(8),
  parent_id    NUMBER,
  file_size    NUMBER,
  updated_at   DATE,
  favs         NUMBER default 0,
  tags_gen     NUMBER default 0,
  tags_art     NUMBER default 0,
  tags_copy    NUMBER default 0,
  tags_char    NUMBER default 0,
  tags_etc     NUMBER default 0,
  score_17     NUMBER,
  rating_17    VARCHAR2(1),
  flags        VARCHAR2(8),
  face_id      NUMBER,
  ulx          NUMBER,
  uly          NUMBER,
  lrx          NUMBER,
  lry          NUMBER,
  conf         NUMBER
) ;
create unique index UI_DANB on DANB (ID) ;

-- теги Danbooru и связанная информация, в т.ч. корреляция с Myanimelist
create table DANB_TG
(
  tag_id     NUMBER,
  tag_name   VARCHAR2(2000),
  tag_cat    NUMBER,
  cnt        NUMBER,
  min_id     NUMBER,
  min_dt     DATE,
  max_id     NUMBER,
  max_dt     DATE,
  parent_id  NUMBER,
  group_id   NUMBER,
  mal_id     NUMBER,
  other_info VARCHAR2(4000)
) ;
create unique index UI1_DANB_TG on DANB_TG (TAG_ID) ;
create unique index UI2_DANB_TG on DANB_TG (TAG_NAME) ;
create unique index UI_DANB_TG_MAL on DANB_TG (TAG_CAT, NVL(MAL_ID,(-1)*TAG_ID)) ;
create index IG_DANB_TG on DANB_TG (GROUP_ID) ;

-- теги по постам
create table DANB_DT
(
  id      NUMBER,
  tag_id  NUMBER,
  tag_cat NUMBER
) ;
create index II_DANB_DT on DANB_DT (ID) ;
create index IT_DANB_DT on DANB_DT (TAG_ID) ;
