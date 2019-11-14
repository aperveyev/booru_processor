-- произведения
create table MAL_TITLES
(
  anime_id          NUMBER,
  title             VARCHAR2(200),
  title_english     VARCHAR2(200),
  title_synonyms    VARCHAR2(2000),
  t_type            VARCHAR2(40),
  t_source          VARCHAR2(40),
  episodes          NUMBER,
  aired             VARCHAR2(60),
  duration          VARCHAR2(40),
  rating            VARCHAR2(40),
  score             NUMBER,
  scored_by         NUMBER,
  t_rank            NUMBER,
  t_popularity      NUMBER,
  t_members         NUMBER,
  t_favorites       NUMBER,
  related           VARCHAR2(4000),
  studio            VARCHAR2(200),
  genre             VARCHAR2(200),
  duration_min      NUMBER,
  aired_from_year   NUMBER,
  title_old         VARCHAR2(200),
  title_english_old VARCHAR2(200),
  rating_old        VARCHAR2(40),
  score_old         NUMBER,
  scored_by_old     NUMBER,
  t_rank_old        NUMBER,
  t_popularity_old  NUMBER,
  t_members_old     NUMBER,
  t_favorites_old   NUMBER,
  related_old       VARCHAR2(4000)
) ;
create unique index UI_MAL_TITLES on MAL_TITLES (ANIME_ID) ;
-- персонажи
create table MAL_CHARS
(
  char_id   NUMBER,
  char_name VARCHAR2(200),
  char_favs NUMBER,
  animelist VARCHAR2(4000)
) ;
create unique index UI_MAL_CHARS on MAL_CHARS (CHAR_ID) ;
-- соотношения между произведениями
create table MAL_TREL
(
  anime_id  NUMBER,
  title     VARCHAR2(200),
  rel_type  VARCHAR2(19),
  rel_id    VARCHAR2(4000),
  rel_title VARCHAR2(4000)
) ;
create unique index UI_MAL_TREL on MAL_TREL (REL_ID, ANIME_ID, REL_TYPE) ;
-- отношение (роли) персонажей к произведениям
create table MAL_TC
(
  anime_id  NUMBER,
  char_id   NUMBER,
  char_role VARCHAR2(200)
) ;
create unique index UI_MAL_TC on MAL_TC (CHAR_ID, ANIME_ID) ;
