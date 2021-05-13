prompt PL/SQL Developer Export User Objects for user BOORU@HH19
set define off
spool HH19_booru_tables_202105.log

prompt
prompt Creating table APIC
prompt ===================
prompt
create table APIC
(
  id       NUMBER,
  pid      NUMBER,
  pubtime  DATE,
  score    NUMBER,
  scorn    NUMBER,
  downl    NUMBER,
  ero      NUMBER,
  ext      VARCHAR2(6),
  i_width  NUMBER,
  i_height NUMBER,
  i_size   NUMBER,
  fmd5     VARCHAR2(32),
  color    VARCHAR2(40),
  status   NUMBER,
  spoiler  NUMBER,
  alpha    NUMBER,
  userid   NUMBER,
  f_url    VARCHAR2(400),
  fmd5jpg  VARCHAR2(32)
)
nologging;
create index APIC_I_MD5 on APIC (FMD5)
  nologging;
create unique index APIC_UI_ID on APIC (ID)
  nologging;

prompt
prompt Creating table APIC_DT
prompt ======================
prompt
create table APIC_DT
(
  pid     NUMBER,
  tag     VARCHAR2(400),
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create index APIC_DT_I_PID on APIC_DT (PID)
  nologging;
create unique index APIC_DT_UI on APIC_DT (TAG, TAG_CAT, PID)
  nologging;

prompt
prompt Creating table APIC_RIP
prompt =======================
prompt
create table APIC_RIP
(
  id       NUMBER,
  pubtime  DATE,
  score    NUMBER,
  scorn    NUMBER,
  downl    NUMBER,
  ero      NUMBER,
  ext      VARCHAR2(6),
  fmd5     VARCHAR2(32),
  i_width  NUMBER,
  i_height NUMBER,
  i_size   NUMBER,
  f_url    VARCHAR2(400),
  fname    VARCHAR2(32767),
  done     NUMBER
)
nologging;

prompt
prompt Creating table ARCH_DIR_BS
prompt ==========================
prompt
create table ARCH_DIR_BS
(
  fline VARCHAR2(400),
  fname VARCHAR2(327),
  fpath VARCHAR2(327),
  fid   NUMBER,
  booru VARCHAR2(32),
  copyr VARCHAR2(327)
)
nologging;
create unique index ARCH_DIR_BS_UI on ARCH_DIR_BS (FID, BOORU)
  nologging;

prompt
prompt Creating table ARCH_EXIF_2021A
prompt ==============================
prompt
create table ARCH_EXIF_2021A
(
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30),
  fid            NUMBER,
  copyr          VARCHAR2(300),
  dtm            DATE default sysdate,
  ifmt           VARCHAR2(8),
  jq             NUMBER
)
nologging;
create unique index ARCH_EXIF_2021A_UI on ARCH_EXIF_2021A (FID, BOORU)
  nologging;

prompt
prompt Creating table ARCH_MD5_2021A
prompt =============================
prompt
create table ARCH_MD5_2021A
(
  booru VARCHAR2(30),
  fid   NUMBER,
  fmd5  VARCHAR2(32),
  fname VARCHAR2(300),
  fpath VARCHAR2(300)
)
nologging;
create index ARCH_MD5_2021A_MD5 on ARCH_MD5_2021A (FMD5)
  nologging;
create unique index ARCH_MD5_2021A_UI on ARCH_MD5_2021A (FID, BOORU)
  nologging;

prompt
prompt Creating table ARCH_MD5_ALT
prompt ===========================
prompt
create table ARCH_MD5_ALT
(
  booru VARCHAR2(30),
  fid   NUMBER,
  fmd5  VARCHAR2(32),
  fext  VARCHAR2(30)
)
nologging;
create index ARCH_MD5_ALT_I on ARCH_MD5_ALT (FMD5)
  nologging;

prompt
prompt Creating table ARCH_MD5_G2
prompt ==========================
prompt
create table ARCH_MD5_G2
(
  fname VARCHAR2(32767),
  fpath VARCHAR2(32767),
  booru VARCHAR2(32767),
  fid   VARCHAR2(32767),
  fmd5  VARCHAR2(128)
)
nologging;

prompt
prompt Creating table ARCH_MD5_GONE
prompt ============================
prompt
create table ARCH_MD5_GONE
(
  area  CHAR(32),
  fmd5  VARCHAR2(32),
  fname VARCHAR2(300),
  fpath VARCHAR2(300)
)
nologging;
create index ARCH_MD5_GONE_MD5 on ARCH_MD5_GONE (FMD5)
  nologging;

prompt
prompt Creating table BCT
prompt ==================
prompt
create table BCT
(
  booru    VARCHAR2(32),
  fid      NUMBER,
  ipath    VARCHAR2(310),
  fname    VARCHAR2(1200),
  s_fsize  NUMBER,
  s_isize  VARCHAR2(97),
  s_jq     NUMBER,
  r_all    NUMBER,
  tentr    NUMBER,
  r_entr   NUMBER,
  tskew    NUMBER,
  tstddev  NUMBER,
  r_sdev   NUMBER,
  tcolors  NUMBER,
  r_color  NUMBER,
  meang    NUMBER,
  r_meang  NUMBER,
  edge     NUMBER,
  r_edge   NUMBER,
  o_fsize  NUMBER,
  o_isize  VARCHAR2(12),
  o_jq     NUMBER,
  o_fmd5   VARCHAR2(32),
  p_dt     DATE,
  ratn     VARCHAR2(4),
  scor     NUMBER,
  favs     NUMBER,
  fext     VARCHAR2(8),
  p_fsize  NUMBER,
  p_isize  VARCHAR2(81),
  p_fmd5   VARCHAR2(4000),
  boundbox VARCHAR2(20),
  tags_c   NUMBER,
  tags_p   NUMBER,
  tags_a   NUMBER,
  tags_g   NUMBER,
  tags_x   NUMBER
)
nologging;
create unique index BCT_UI on BCT (FID, BOORU)
  nologging;

prompt
prompt Creating table BCT_DT
prompt =====================
prompt
create table BCT_DT
(
  booru    VARCHAR2(32),
  id       NUMBER,
  orig_tag VARCHAR2(600),
  tag_id   NUMBER,
  tag_cat  NUMBER,
  tag_name VARCHAR2(200)
)
nologging;
create unique index BCT_DT_UI on BCT_DT (ID, BOORU, ORIG_TAG)
  nologging;

prompt
prompt Creating table BCT_EXIF
prompt =======================
prompt
create table BCT_EXIF
(
  booru      VARCHAR2(32),
  fid        NUMBER,
  filesize   NUMBER,
  iw         VARCHAR2(48),
  ih         VARCHAR2(48),
  px         NUMBER,
  jq         NUMBER,
  fpath      VARCHAR2(30),
  fname      VARCHAR2(230),
  fext       VARCHAR2(40),
  sourcefile VARCHAR2(300)
)
nologging;
create unique index BCT_EXIF_UI on BCT_EXIF (FID, BOORU)
  nologging;

prompt
prompt Creating table BCT_IM
prompt =====================
prompt
create table BCT_IM
(
  ifile    VARCHAR2(600),
  ipath    VARCHAR2(300),
  boundbox VARCHAR2(30),
  tentr    NUMBER,
  tskew    NUMBER,
  tmean    NUMBER,
  tstddev  NUMBER,
  tcolors  NUMBER,
  meang    NUMBER,
  maximag  NUMBER,
  edge     NUMBER,
  booru    VARCHAR2(30),
  fid      NUMBER,
  dtm      DATE default sysdate,
  flags    CHAR(8) default '--------'
)
nologging;
create index BCT_IM_UI on BCT_IM (FID, BOORU)
  nologging;

prompt
prompt Creating table BCT_NL
prompt =====================
prompt
create table BCT_NL
(
  fname  VARCHAR2(15968),
  hashid VARCHAR2(24),
  prob   NUMBER,
  x      NUMBER,
  y      NUMBER,
  w      NUMBER,
  h      NUMBER,
  obj    CHAR(4),
  oprob  NUMBER,
  ox     NUMBER,
  oy     NUMBER,
  ow     NUMBER,
  oh     NUMBER
)
nologging;

prompt
prompt Creating table BCT_P
prompt ====================
prompt
create table BCT_P
(
  booru VARCHAR2(32),
  id    NUMBER,
  dt    DATE,
  ratn  VARCHAR2(16),
  scor  NUMBER,
  favs  NUMBER,
  fsize NUMBER,
  iw    NUMBER,
  ih    NUMBER,
  fext  VARCHAR2(8)
)
nologging;
create unique index BCT_P_UI on BCT_P (ID, BOORU)
  nologging;

prompt
prompt Creating table DANB
prompt ===================
prompt
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
  conf         NUMBER,
  score_19     NUMBER,
  rating_19    VARCHAR2(6),
  favs_19      NUMBER
)
nologging;
create unique index DANB_UI on DANB (ID)
  nologging;

prompt
prompt Creating table DANB_DT
prompt ======================
prompt
create table DANB_DT
(
  id      NUMBER,
  tag_id  NUMBER,
  tag_cat NUMBER
)
partition by list (TAG_CAT)
(
  partition P3 values (3)
    tablespace USERS_MAN,
  partition P4 values (4)
    tablespace USERS_MAN,
  partition P0 values (0)
    tablespace USERS_MAN,
  partition PZ values (default)
    tablespace USERS_MAN
);

prompt
prompt Creating table DANB_EXT
prompt =======================
prompt
create table DANB_EXT
(
  jdata VARCHAR2(32000)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS TERMINATED BY 0x'0A' LDRTRIM
  )
  location (B:'danb.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table DANB_LOAD
prompt ========================
prompt
create table DANB_LOAD
(
  id NUMBER,
  j  VARCHAR2(18000),
  jj VARCHAR2(18000),
  fx VARCHAR2(8000)
)
nologging;
create unique index DANB_LOAD_UI on DANB_LOAD (ID)
  nologging;

prompt
prompt Creating table DANB_TG
prompt ======================
prompt
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
  other_info VARCHAR2(4000),
  cnt_19     NUMBER,
  cat_19     NUMBER,
  cnt_20     NUMBER
)
compress;
create index DANB_TG_IG on DANB_TG (GROUP_ID)
  nologging;
create unique index DANB_TG_UI on DANB_TG (TAG_ID)
  nologging;
create unique index DANB_TG_UIM on DANB_TG (TAG_CAT, NVL(MAL_ID,(-1)*TAG_ID))
  nologging;
create unique index DANB_TG_UIT on DANB_TG (TAG_NAME)
  nologging;

prompt
prompt Creating table DANB_TG_ALIAS
prompt ============================
prompt
create table DANB_TG_ALIAS
(
  antecedent_name VARCHAR2(520),
  consequent_name VARCHAR2(520),
  id              NUMBER,
  created_at      DATE,
  a_id            NUMBER,
  c_id            NUMBER,
  booru           VARCHAR2(32),
  tag_cat         NUMBER
)
nologging;
create index DANB_TG_ALIAS_A on DANB_TG_ALIAS (ANTECEDENT_NAME)
  nologging;
create index DANB_TG_ALIAS_C on DANB_TG_ALIAS (CONSEQUENT_NAME)
  nologging;

prompt
prompt Creating table DANB_TG_IMPL
prompt ===========================
prompt
create table DANB_TG_IMPL
(
  antecedent_name VARCHAR2(120),
  consequent_name VARCHAR2(120),
  id              NUMBER,
  created_at      DATE
)
nologging;

prompt
prompt Creating table DANN
prompt ===================
prompt
create table DANN
(
  id           NUMBER,
  score        NUMBER,
  rating       VARCHAR2(3),
  created_at   DATE,
  updated_at   DATE,
  image_width  NUMBER,
  image_height NUMBER,
  file_ext     VARCHAR2(8),
  file_size    NUMBER,
  favs         NUMBER default 0
)
nologging;
create unique index DANN_UI on DANN (ID)
  nologging;

prompt
prompt Creating table DANN_DT
prompt ======================
prompt
create table DANN_DT
(
  id      NUMBER,
  tag_id  NUMBER,
  tag_cat NUMBER
)
nologging;

prompt
prompt Creating table DANN_TG
prompt ======================
prompt
create table DANN_TG
(
  tag_id   NUMBER,
  tag_name VARCHAR2(2000),
  tag_cat  NUMBER,
  cnt      NUMBER,
  min_id   NUMBER,
  min_dt   DATE,
  max_id   NUMBER,
  max_dt   DATE
)
nologging;
create unique index DANN_TG_UI on DANN_TG (TAG_ID)
  nologging;
create unique index DANN_TG_UN on DANN_TG (TAG_NAME)
  nologging;

prompt
prompt Creating table DIR_BS_EXT
prompt =========================
prompt
create table DIR_BS_EXT
(
  fline VARCHAR2(4000)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS TERMINATED BY '>' LDRTRIM
  )
  location (B:'dir_bs.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table DIR_BS_TAB
prompt =========================
prompt
create table DIR_BS_TAB
(
  fname VARCHAR2(400),
  fpath VARCHAR2(400),
  booru VARCHAR2(40),
  fid   VARCHAR2(40),
  copyr VARCHAR2(400),
  chars VARCHAR2(400),
  artis VARCHAR2(400),
  frest VARCHAR2(400),
  ifile VARCHAR2(400),
  id    NUMBER
)
nologging;
create unique index DIR_BS_TAB_UI on DIR_BS_TAB (FID, BOORU)
  nologging;

prompt
prompt Creating table E621
prompt ===================
prompt
create table E621
(
  fid        NUMBER,
  feat       VARCHAR2(40),
  ind        NUMBER,
  conf       NUMBER,
  xmin       NUMBER,
  ymin       NUMBER,
  xmax       NUMBER,
  ymax       NUMBER,
  f_url      VARCHAR2(400),
  rating     VARCHAR2(4),
  score      NUMBER,
  file_size  NUMBER,
  tags       VARCHAR2(8000),
  artist     VARCHAR2(8000),
  copyrights VARCHAR2(8000),
  characters VARCHAR2(8000),
  species    VARCHAR2(8000),
  done       NUMBER,
  fname      VARCHAR2(400)
)
nologging;

prompt
prompt Creating table E621_DTE
prompt =======================
prompt
create table E621_DTE
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  n       NUMBER not null,
  tag_cat NUMBER
)
nologging;
create unique index E621_DTE_UI on E621_DTE (ID, TAG)
  nologging;

prompt
prompt Creating table E621_TGE
prompt =======================
prompt
create table E621_TGE
(
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER,
  nnn     NUMBER
)
nologging;
create index E621_TGE_UI on E621_TGE (TAG)
  nologging;

prompt
prompt Creating table ESS
prompt ==================
prompt
create table ESS
(
  dt   DATE,
  id   NUMBER,
  fext VARCHAR2(120),
  tags VARCHAR2(3400)
)
nologging;
create unique index ESS_UI on ESS (ID)
  nologging;

prompt
prompt Creating table ESS_DT
prompt =====================
prompt
create table ESS_DT
(
  id      NUMBER,
  tag     VARCHAR2(160),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index ESS_DT_UI on ESS_DT (ID, TAG)
  nologging;

prompt
prompt Creating table ESS_DT_C
prompt =======================
prompt
create table ESS_DT_C
(
  id      NUMBER,
  tag     VARCHAR2(160),
  n       NUMBER,
  f       CHAR(1),
  l       CHAR(1),
  tag_cat NUMBER
)
nologging;
create index ESS_DT_C_TAG on ESS_DT_C (TAG)
  nologging;
create unique index ESS_DT_C_UI on ESS_DT_C (ID, TAG)
  nologging;

prompt
prompt Creating table ESS_DT_LD
prompt ========================
prompt
create table ESS_DT_LD
(
  id      NUMBER,
  tag     VARCHAR2(160),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index ESS_DT_LD_UI on ESS_DT_LD (TAG, ID, TAG_CAT)
  nologging;

prompt
prompt Creating table ESS_LD
prompt =====================
prompt
create table ESS_LD
(
  id    NUMBER,
  fname VARCHAR2(32),
  fdt   DATE,
  isize VARCHAR2(12),
  favn  NUMBER,
  tags  VARCHAR2(8000),
  tagc  VARCHAR2(6000),
  tagp  VARCHAR2(6000),
  taga  VARCHAR2(6000),
  eol   VARCHAR2(3)
)
nologging;
create unique index ESS_LD_UI on ESS_LD (ID)
  nologging;

prompt
prompt Creating table ESS_TG_C
prompt =======================
prompt
create table ESS_TG_C
(
  tag     VARCHAR2(160),
  cnt     NUMBER,
  cntf    NUMBER,
  cntl    NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create index ESS_TG_C_TI on ESS_TG_C (TAG_ID)
  nologging;
create unique index ESS_TG_C_UI on ESS_TG_C (TAG)
  nologging;

prompt
prompt Creating table ESS_ZIP
prompt ======================
prompt
create table ESS_ZIP
(
  fid      NUMBER,
  filesize NUMBER,
  iw       VARCHAR2(48),
  ih       VARCHAR2(48),
  ifmt     VARCHAR2(30),
  fmd5     VARCHAR2(32),
  fname    VARCHAR2(1200),
  fpath    VARCHAR2(4787)
)
nologging;
create unique index ESS_ZIP_UI on ESS_ZIP (FID)
  nologging;
create unique index ESS_ZIP_UM on ESS_ZIP (FMD5)
  nologging;

prompt
prompt Creating table EXIF_EXT
prompt =======================
prompt
create table EXIF_EXT
(
  sourcefile     VARCHAR2(300),
  filecreatedate VARCHAR2(30),
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  ifmt           VARCHAR2(30),
  jq             VARCHAR2(20)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS TERMINATED BY ',' optionally enclosed by '"' LDRTRIM
    (
     sourcefile,
     filecreatedate,
     imagesize,
     filesize,
     ifmt,
     jq
     )
  )
  location (B:'exif.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table FCIV_EXT
prompt =======================
prompt
create table FCIV_EXT
(
  fmd5  CHAR(32),
  fname VARCHAR2(300)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS (fmd5 CHAR(32), e1 CHAR(1), fname CHAR(300))
  )
  location (B:'fciv.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table GLB_ARCH
prompt =======================
prompt
create table GLB_ARCH
(
  id         NUMBER,
  score      NUMBER,
  rating     VARCHAR2(12),
  created_at DATE,
  iwidth     NUMBER,
  iheight    NUMBER,
  tags       VARCHAR2(4000)
)
nologging;
create unique index GLB_ARCH_UI on GLB_ARCH (ID)
  nologging;

prompt
prompt Creating table GLB_DTO
prompt ======================
prompt
create table GLB_DTO
(
  id     NUMBER,
  tag    VARCHAR2(600),
  cat    NUMBER,
  x      NUMBER,
  tag_id NUMBER
)
nologging;

prompt
prompt Creating table GLB_LOAD
prompt =======================
prompt
create table GLB_LOAD
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(40),
  i_width    NUMBER,
  i_height   NUMBER,
  s_width    NUMBER,
  s_height   NUMBER,
  owner      VARCHAR2(40),
  fmd5       VARCHAR2(32),
  i_url      VARCHAR2(430),
  tags       VARCHAR2(12000)
)
nologging;
create unique index GLB_LOAD_UI on GLB_LOAD (ID)
  nologging;

prompt
prompt Creating table GRAB_LOG
prompt =======================
prompt
create table GRAB_LOG
(
  lcase      VARCHAR2(20) not null,
  booru      VARCHAR2(32) not null,
  fid        NUMBER not null,
  copyright  VARCHAR2(800),
  artist     VARCHAR2(200),
  tagall     VARCHAR2(4000),
  fdate      DATE not null,
  frating    VARCHAR2(16),
  fscore     NUMBER,
  fline      VARCHAR2(4000),
  sizes      VARCHAR2(12),
  fext       VARCHAR2(4),
  characters VARCHAR2(2000),
  rdir       VARCHAR2(20),
  new_copyr  VARCHAR2(200),
  new_chars  VARCHAR2(200),
  new_art    VARCHAR2(200)
)
nologging;
create unique index GRAB_LOG_UI on GRAB_LOG (FID, BOORU, LCASE)
  nologging;

prompt
prompt Creating table GRAB_LOG_2021
prompt ============================
prompt
create table GRAB_LOG_2021
(
  booru      VARCHAR2(32),
  fid        VARCHAR2(32),
  copyright  VARCHAR2(767),
  artist     VARCHAR2(327),
  characters VARCHAR2(32767),
  tagall     VARCHAR2(32767),
  fdate      DATE,
  frating    VARCHAR2(32),
  fscore     VARCHAR2(32767),
  sizes      VARCHAR2(32767),
  fext       VARCHAR2(32767),
  new_copyr  VARCHAR2(2000),
  new_chars  VARCHAR2(2000),
  new_art    VARCHAR2(2000)
)
nologging;
create unique index GRAB_LOG_2021A_UI on GRAB_LOG_2021 (FID, BOORU)
  nologging;

prompt
prompt Creating table GRAB_LOG_2021_DT
prompt ===============================
prompt
create table GRAB_LOG_2021_DT
(
  booru VARCHAR2(32),
  fid   NUMBER,
  tag   VARCHAR2(600),
  cat   NUMBER
)
nologging;
create unique index GRAB_LOG_2021A_DT_UI on GRAB_LOG_2021_DT (FID, TAG, BOORU)
  nologging;

prompt
prompt Creating table GRAB_LOG_TAGS
prompt ============================
prompt
create table GRAB_LOG_TAGS
(
  booru  VARCHAR2(32) not null,
  fid    NUMBER not null,
  tag    VARCHAR2(150) not null,
  cat    NUMBER,
  tag_id NUMBER
)
nologging;
create index GRAB_LOG_TAGS_I on GRAB_LOG_TAGS (FID, BOORU)
  nologging;
create unique index GRAB_LOG_TAGS_UI on GRAB_LOG_TAGS (TAG, BOORU, FID)
  nologging;

prompt
prompt Creating table GRAB_TXT_EXT
prompt ===========================
prompt
create table GRAB_TXT_EXT
(
  fline VARCHAR2(16000)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS (fline CHAR(16000))
  )
  location (B:'grab.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table KONA
prompt ===================
prompt
create table KONA
(
  id         NUMBER,
  tid        NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(40),
  i_width    NUMBER,
  i_height   NUMBER,
  f_size     NUMBER,
  f_url      VARCHAR2(4000),
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(4000),
  j_size     NUMBER,
  j_url      VARCHAR2(4000),
  creator_id NUMBER,
  author     VARCHAR2(200),
  fmd5       VARCHAR2(32),
  parent_id  NUMBER
)
nologging;
create unique index KONA_UI on KONA (ID)
  nologging;
create unique index KONA_UMD5 on KONA (FMD5)
  nologging;

prompt
prompt Creating table KONA_DT
prompt ======================
prompt
create table KONA_DT
(
  id      NUMBER,
  x       NUMBER,
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index KONA_DT_UI on KONA_DT (TAG, ID)
  nologging;
create index KONA_IID on KONA_DT (ID)
  nologging;

prompt
prompt Creating table KONA_IM
prompt ======================
prompt
create table KONA_IM
(
  ifile      VARCHAR2(600),
  ipath      VARCHAR2(300),
  ibytes     NUMBER,
  iwidth     NUMBER,
  iheight    NUMBER,
  bits       NUMBER,
  resx       NUMBER,
  resy       NUMBER,
  resunit    VARCHAR2(60),
  boundbox   VARCHAR2(30),
  filefmt    VARCHAR2(30),
  compqual   NUMBER,
  comptype   VARCHAR2(30),
  colorspace VARCHAR2(30),
  ihash      VARCHAR2(64),
  ientr      NUMBER,
  iskew      NUMBER,
  imean      NUMBER,
  istddev    NUMBER,
  icolors    NUMBER,
  meang      NUMBER,
  maximag    NUMBER,
  rmean      NUMBER,
  gmean      NUMBER,
  bmean      NUMBER,
  edge       NUMBER,
  booru      VARCHAR2(30),
  fid        NUMBER,
  dtm        DATE default sysdate,
  flags      CHAR(8) default '--------'
)
nologging;
create unique index KONA_IM_UI on KONA_IM (FID)
  nologging;

prompt
prompt Creating table KONA_IMM
prompt =======================
prompt
create table KONA_IMM
(
  ifile      VARCHAR2(600),
  ipath      VARCHAR2(300),
  ibytes     NUMBER,
  iwidth     NUMBER,
  iheight    NUMBER,
  bits       NUMBER,
  resx       NUMBER,
  resy       NUMBER,
  resunit    VARCHAR2(60),
  boundbox   VARCHAR2(30),
  filefmt    VARCHAR2(30),
  compqual   NUMBER,
  comptype   VARCHAR2(30),
  colorspace VARCHAR2(30),
  ihash      VARCHAR2(64),
  ientr      NUMBER,
  iskew      NUMBER,
  imean      NUMBER,
  istddev    NUMBER,
  icolors    NUMBER,
  meang      NUMBER,
  maximag    NUMBER,
  rmean      NUMBER,
  gmean      NUMBER,
  bmean      NUMBER,
  edge       NUMBER,
  booru      VARCHAR2(30),
  fid        NUMBER,
  dtm        DATE default sysdate,
  flags      CHAR(8) default '--------'
)
nologging;
create unique index KONA_IMM_UI on KONA_IMM (FID)
  nologging;

prompt
prompt Creating table KONA_LOAD
prompt ========================
prompt
create table KONA_LOAD
(
  id NUMBER,
  j  VARCHAR2(28000),
  jj VARCHAR2(28000)
)
nologging;
create unique index KONA_LOAD_UI on KONA_LOAD (ID)
  nologging;

prompt
prompt Creating table KONA_POOLS
prompt =========================
prompt
create table KONA_POOLS
(
  pid   NUMBER,
  pname VARCHAR2(400),
  pcnt  NUMBER
)
nologging;
create unique index KONA_POOLS_UI on KONA_POOLS (PID)
  nologging;

prompt
prompt Creating table KONA_PPOSTS
prompt ==========================
prompt
create table KONA_PPOSTS
(
  id    NUMBER,
  tid   NUMBER,
  pid   NUMBER,
  ppid  NUMBER,
  ppseq NUMBER
)
nologging;
create unique index KONA_PPOSTS_UI on KONA_PPOSTS (PPID, PID)
  nologging;

prompt
prompt Creating table KONA_RIP
prompt =======================
prompt
create table KONA_RIP
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(40),
  rnk        NUMBER,
  i_width    NUMBER,
  i_height   NUMBER,
  f_size     NUMBER,
  f_url      VARCHAR2(4000),
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(4000),
  j_size     NUMBER,
  j_url      VARCHAR2(4000),
  d_src      VARCHAR2(2),
  d_url      VARCHAR2(4000),
  fname      VARCHAR2(32767),
  done       NUMBER
)
nologging;

prompt
prompt Creating table KONA_RIPE
prompt ========================
prompt
create table KONA_RIPE
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(40),
  rnk        NUMBER,
  i_width    NUMBER,
  i_height   NUMBER,
  f_size     NUMBER,
  f_url      VARCHAR2(4000),
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(4000),
  j_size     NUMBER,
  j_url      VARCHAR2(4000),
  d_src      VARCHAR2(2),
  d_url      VARCHAR2(4000),
  fname      VARCHAR2(32767),
  done       NUMBER
)
nologging;

prompt
prompt Creating table KONA_TG
prompt ======================
prompt
create table KONA_TG
(
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  cnt     NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index KONA_TG_UI on KONA_TG (TAG)
  nologging;

prompt
prompt Creating table LOAD_EXIF
prompt ========================
prompt
create table LOAD_EXIF
(
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30),
  fid            NUMBER,
  dtm            DATE default sysdate,
  ifmt           VARCHAR2(30),
  jq             NUMBER
)
nologging;
create index LOAD_EXIF_IFS on LOAD_EXIF (FILESIZE, IMAGESIZE)
  nologging;
create index LOAD_EXIF_O_FID on LOAD_EXIF (FID)
  nologging;
create unique index LOAD_EXIF_O_UI on LOAD_EXIF (SOURCEFILE)
  nologging;

prompt
prompt Creating table LOAD_EXIF_C
prompt ==========================
prompt
create table LOAD_EXIF_C
(
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30),
  fid            NUMBER,
  copyr          VARCHAR2(300),
  dtm            DATE default sysdate,
  ifmt           VARCHAR2(8)
)
nologging;
create index LOAD_EXIF_C_COPYR on LOAD_EXIF_C (COPYR)
  nologging;
create index LOAD_EXIF_C_FID on LOAD_EXIF_C (FID)
  nologging;
create unique index LOAD_EXIF_C_UI on LOAD_EXIF_C (BOORU, FID)
  nologging;

prompt
prompt Creating table LOAD_EXIF_G
prompt ==========================
prompt
create table LOAD_EXIF_G
(
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30),
  fid            NUMBER,
  dtm            DATE default sysdate
)
nologging;
create index LOAD_EXIF_G_FID on LOAD_EXIF_G (FID)
  nologging;
create unique index LOAD_EXIF_G_UI on LOAD_EXIF_G (SOURCEFILE)
  nologging;

prompt
prompt Creating table LOAD_FACE
prompt ========================
prompt
create table LOAD_FACE
(
  ffile VARCHAR2(600),
  facex NUMBER,
  facey NUMBER,
  facew NUMBER,
  faceh NUMBER,
  booru VARCHAR2(30),
  fid   NUMBER,
  dtm   DATE default sysdate
)
nologging;
create index LOAD_FACE_BF on LOAD_FACE (FID, BOORU)
  nologging;
create unique index LOAD_FACE_UI on LOAD_FACE (FFILE, FACEX, FACEY)
  nologging;

prompt
prompt Creating table LOAD_IM
prompt ======================
prompt
create table LOAD_IM
(
  ifile      VARCHAR2(600),
  ipath      VARCHAR2(300),
  ibytes     NUMBER,
  iwidth     NUMBER,
  iheight    NUMBER,
  bits       NUMBER,
  resx       NUMBER,
  resy       NUMBER,
  resunit    VARCHAR2(60),
  boundbox   VARCHAR2(30),
  filefmt    VARCHAR2(30),
  compqual   NUMBER,
  comptype   VARCHAR2(30),
  colorspace VARCHAR2(30),
  ihash      VARCHAR2(64),
  tbytes     NUMBER,
  twidth     NUMBER,
  theight    NUMBER,
  tentr      NUMBER,
  tskew      NUMBER,
  tmean      NUMBER,
  tstddev    NUMBER,
  tcolors    NUMBER,
  meang      NUMBER,
  maximag    NUMBER,
  rmean      NUMBER,
  gmean      NUMBER,
  bmean      NUMBER,
  edge       NUMBER,
  width2     NUMBER,
  height2    NUMBER,
  entr2      NUMBER,
  booru      VARCHAR2(30),
  fid        NUMBER,
  dtm        DATE default sysdate,
  flags      CHAR(8) default '--------'
)
nologging;
create index LOAD_IM_BF on LOAD_IM (FID, BOORU)
  nologging;
create unique index LOAD_IM_UI on LOAD_IM (IFILE)
  nologging;

prompt
prompt Creating table LOAD_IM_DANB
prompt ===========================
prompt
create table LOAD_IM_DANB
(
  ifile   VARCHAR2(600),
  ibpp    NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  tentr   NUMBER,
  tskew   NUMBER,
  tcolors NUMBER,
  meang   NUMBER,
  width2  NUMBER,
  height2 NUMBER,
  entr2   NUMBER
)
nologging;
create unique index LOAD_IM_DANB_UI on LOAD_IM_DANB (IFILE)
  nologging;

prompt
prompt Creating table LOAD_IM_G
prompt ========================
prompt
create table LOAD_IM_G
(
  ifile      VARCHAR2(600),
  ipath      VARCHAR2(300),
  ibytes     NUMBER,
  iwidth     NUMBER,
  iheight    NUMBER,
  bits       NUMBER,
  resx       NUMBER,
  resy       NUMBER,
  resunit    VARCHAR2(60),
  boundbox   VARCHAR2(30),
  filefmt    VARCHAR2(30),
  compqual   NUMBER,
  comptype   VARCHAR2(30),
  colorspace VARCHAR2(30),
  ihash      VARCHAR2(64),
  tbytes     NUMBER,
  twidth     NUMBER,
  theight    NUMBER,
  tentr      NUMBER,
  tskew      NUMBER,
  tmean      NUMBER,
  tstddev    NUMBER,
  tcolors    NUMBER,
  meang      NUMBER,
  maximag    NUMBER,
  rmean      NUMBER,
  gmean      NUMBER,
  bmean      NUMBER,
  edge       NUMBER,
  width2     NUMBER,
  height2    NUMBER,
  entr2      NUMBER,
  booru      VARCHAR2(30),
  fid        NUMBER,
  dtm        DATE default sysdate,
  flags      CHAR(8) default '--------'
)
nologging;
create index LOAD_IM_G_BF on LOAD_IM_G (FID, BOORU)
  nologging;
create unique index LOAD_IM_G_UI on LOAD_IM_G (IFILE)
  nologging;

prompt
prompt Creating table MAIN
prompt ===================
prompt
create table MAIN
(
  booru       VARCHAR2(48),
  fid         NUMBER,
  xdate       DATE,
  xbytes      NUMBER,
  xwidth      NUMBER,
  xheight     NUMBER,
  boundw      NUMBER,
  boundh      NUMBER,
  boundx      NUMBER,
  boundy      NUMBER,
  tbytes      NUMBER,
  twidth      NUMBER,
  theight     NUMBER,
  tentr       NUMBER,
  tskew       NUMBER,
  tmean       NUMBER,
  tstddev     NUMBER,
  tcolors     NUMBER,
  meang       NUMBER,
  maximag     NUMBER,
  rmean       NUMBER,
  gmean       NUMBER,
  bmean       NUMBER,
  edge        NUMBER,
  resx        NUMBER,
  resy        NUMBER,
  resunit     VARCHAR2(60),
  compqual    NUMBER,
  colorspace  VARCHAR2(30),
  ihash       VARCHAR2(64),
  frest       VARCHAR2(300),
  sourcefile  VARCHAR2(300),
  ifile       VARCHAR2(600),
  ipath       VARCHAR2(300),
  copyr       VARCHAR2(300),
  chars       VARCHAR2(300),
  artis       VARCHAR2(300),
  fr          VARCHAR2(300),
  copyr_tag_1 NUMBER,
  copyr_tag_2 NUMBER,
  chars_tag_1 NUMBER,
  chars_tag_2 NUMBER,
  chars_tag_3 NUMBER,
  artis_tag_1 NUMBER,
  dtm         DATE default sysdate
)
nologging;
create unique index MAIN_B_UI1 on MAIN (FID, BOORU)
  nologging;

prompt
prompt Creating table MAIN_2019
prompt ========================
prompt
create table MAIN_2019
(
  booru       VARCHAR2(48),
  fid         NUMBER,
  ipath       VARCHAR2(300),
  ifile       VARCHAR2(600),
  xbytes      NUMBER,
  xwidth      NUMBER,
  xheight     NUMBER,
  boundw      NUMBER,
  boundh      NUMBER,
  boundx      NUMBER,
  boundy      NUMBER,
  tbytes      NUMBER,
  twidth      NUMBER,
  theight     NUMBER,
  tentr       NUMBER,
  tskew       NUMBER,
  tmean       NUMBER,
  tstddev     NUMBER,
  tcolors     NUMBER,
  meang       NUMBER,
  maximag     NUMBER,
  rmean       NUMBER,
  gmean       NUMBER,
  bmean       NUMBER,
  edge        NUMBER,
  faces       VARCHAR2(600),
  copyr_tag_1 NUMBER,
  copyr_tag_2 NUMBER,
  chars_tag_1 NUMBER,
  chars_tag_2 NUMBER,
  chars_tag_3 NUMBER,
  artis_tag_1 NUMBER
)
nologging;
create unique index MAIN_2019_UI1 on MAIN_2019 (FID, BOORU)
  nologging;

prompt
prompt Creating table MAL_CHARS
prompt ========================
prompt
create table MAL_CHARS
(
  char_id   NUMBER,
  char_name VARCHAR2(200),
  char_favs NUMBER,
  animelist VARCHAR2(4000)
)
compress;
create unique index MAL_CHARS_UI on MAL_CHARS (CHAR_ID)
  nologging;

prompt
prompt Creating table MAL_TC
prompt =====================
prompt
create table MAL_TC
(
  anime_id  NUMBER,
  char_id   NUMBER,
  char_role VARCHAR2(200)
)
compress;
create unique index MAL_TC_UI on MAL_TC (CHAR_ID, ANIME_ID)
  nologging;

prompt
prompt Creating table MAL_TIT
prompt ======================
prompt
create table MAL_TIT
(
  mal_id        NUMBER,
  tname         VARCHAR2(800),
  score         NUMBER,
  genres        VARCHAR2(800),
  english_name  VARCHAR2(800),
  japanese_name VARCHAR2(800),
  typ           VARCHAR2(800),
  episodes      NUMBER,
  aired         VARCHAR2(800),
  premiered     VARCHAR2(800),
  producers     VARCHAR2(800),
  licensors     VARCHAR2(800),
  studios       VARCHAR2(800),
  sourc         VARCHAR2(800),
  duration      VARCHAR2(800),
  rating        VARCHAR2(800),
  ranked        NUMBER,
  popularity    NUMBER,
  members       NUMBER,
  favorites     NUMBER,
  watching      NUMBER,
  completed     NUMBER,
  onhold        NUMBER,
  dropped       NUMBER,
  planw         NUMBER,
  score10       NUMBER,
  score9        NUMBER,
  score8        NUMBER,
  score7        NUMBER,
  score6        NUMBER,
  score5        NUMBER,
  score4        NUMBER,
  score3        NUMBER,
  score2        NUMBER,
  score1        NUMBER
)
nologging;

prompt
prompt Creating table MAL_TITLES
prompt =========================
prompt
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
)
compress
nologging;
create unique index MAL_TITLES_UI on MAL_TITLES (ANIME_ID)
  nologging;

prompt
prompt Creating table MAL_TREL
prompt =======================
prompt
create table MAL_TREL
(
  anime_id  NUMBER,
  title     VARCHAR2(200),
  rel_type  VARCHAR2(19),
  rel_id    VARCHAR2(4000),
  rel_title VARCHAR2(4000)
)
compress;
create unique index MAL_TREL_UI on MAL_TREL (REL_ID, ANIME_ID, REL_TYPE)
  nologging;

prompt
prompt Creating table MAL_USERS
prompt ========================
prompt
create table MAL_USERS
(
  user_id      NUMBER,
  username     VARCHAR2(200),
  gender       VARCHAR2(20),
  usr_location VARCHAR2(200),
  birth_date   DATE,
  join_date    DATE
)
nologging;

prompt
prompt Creating table MAL_USER_MATCHES
prompt ===============================
prompt
create table MAL_USER_MATCHES
(
  anime_id NUMBER,
  score    NUMBER,
  status   NUMBER,
  eps      NUMBER,
  user_id  NUMBER
)
nologging;

prompt
prompt Creating table NUDE
prompt ===================
prompt
create table NUDE
(
  batch_id   VARCHAR2(8) not null,
  booru      VARCHAR2(30),
  fid        NUMBER,
  fname      VARCHAR2(300) not null,
  clas       VARCHAR2(44),
  face1      VARCHAR2(4),
  face1_prob NUMBER,
  face1_ds   NUMBER,
  face1_sz   NUMBER,
  brst1      VARCHAR2(20),
  brst1_prob NUMBER,
  brst1_ds   NUMBER,
  brst1_sz   NUMBER,
  armp1      VARCHAR2(20),
  armp1_prob NUMBER,
  armp1_ds   NUMBER,
  armp1_sz   NUMBER,
  bell1      VARCHAR2(13),
  bell1_prob NUMBER,
  bell1_ds   NUMBER,
  bell1_sz   NUMBER,
  xxxx1      VARCHAR2(13),
  xxxx1_prob NUMBER,
  xxxx1_ds   NUMBER,
  xxxx1_sz   NUMBER,
  feet1      VARCHAR2(20),
  feet1_prob NUMBER,
  feet1_ds   NUMBER,
  feet1_sz   NUMBER,
  face2      VARCHAR2(4),
  face2_prob NUMBER,
  face2_ds   NUMBER,
  face2_sz   NUMBER,
  brst2      VARCHAR2(20),
  brst2_prob NUMBER,
  brst2_ds   NUMBER,
  brst2_sz   NUMBER,
  armp2      VARCHAR2(20),
  armp2_prob NUMBER,
  armp2_ds   NUMBER,
  armp2_sz   NUMBER,
  bell2      VARCHAR2(13),
  bell2_prob NUMBER,
  bell2_ds   NUMBER,
  bell2_sz   NUMBER,
  xxxx2      VARCHAR2(13),
  xxxx2_prob NUMBER,
  xxxx2_ds   NUMBER,
  xxxx2_sz   NUMBER,
  feet2      VARCHAR2(20),
  feet2_prob NUMBER,
  feet2_ds   NUMBER,
  feet2_sz   NUMBER,
  dbg        VARCHAR2(4000)
)
nologging;
create unique index NUDE_UF on NUDE (FNAME, BATCH_ID)
  nologging;
create unique index NUDE_UI on NUDE (FID, BOORU, BATCH_ID)
  nologging;

prompt
prompt Creating table NUDE_Y
prompt =====================
prompt
create table NUDE_Y
(
  fname    VARCHAR2(300),
  obj      VARCHAR2(30),
  prob     NUMBER,
  x        NUMBER,
  y        NUMBER,
  w        NUMBER,
  h        NUMBER,
  suppr    NUMBER,
  face     VARCHAR2(4),
  batch_id VARCHAR2(8)
)
nologging;
create index NUDE_Y_FNAME on NUDE_Y (FNAME)
  nologging;

prompt
prompt Creating table RUTR
prompt ===================
prompt
create table RUTR
(
  id    NUMBER,
  dt    DATE,
  sz    NUMBER,
  ttl   VARCHAR2(4000),
  trid  NUMBER,
  hsh   VARCHAR2(80),
  fid   NUMBER,
  rdir  VARCHAR2(400),
  lmin  NUMBER,
  del   NUMBER,
  rfile VARCHAR2(400)
)
nologging;
create unique index UI_RUTR on RUTR (ID)
  nologging;

prompt
prompt Creating table RUTRACKER
prompt ========================
prompt
create table RUTRACKER
(
  ln    NUMBER,
  tline VARCHAR2(32000),
  tid   NUMBER
)
compress
nologging;

prompt
prompt Creating table RUTRACKER_EXT
prompt ============================
prompt
create table RUTRACKER_EXT
(
  tline VARCHAR2(32000)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A' CHARACTERSET AL32UTF8 fields terminated by '^^^^' ldrtrim missing field values are null
  )
  location (B:'rutracker.xml')
)
reject limit UNLIMITED;

prompt
prompt Creating table RUTR_FILE
prompt ========================
prompt
create table RUTR_FILE
(
  id    NUMBER,
  fpath VARCHAR2(4000),
  fname VARCHAR2(4000),
  ln    NUMBER,
  sz    NUMBER
)
nologging;
create unique index UI_RUTR_FILE on RUTR_FILE (ID, LN)
  nologging;

prompt
prompt Creating table RUTR_FORUM
prompt =========================
prompt
create table RUTR_FORUM
(
  fid NUMBER,
  fnm VARCHAR2(400)
)
nologging;
create unique index UI_RUTR_FORUM on RUTR_FORUM (FID)
  nologging;

prompt
prompt Creating table SB
prompt =================
prompt
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
  created_dt    DATE,
  flags         VARCHAR2(6)
)
nologging;
create unique index SB_UI on SB (ID)
  nologging;

prompt
prompt Creating table SB_DT
prompt ====================
prompt
create table SB_DT
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER
)
partition by list (TAG_CAT)
(
  partition P3 values (3)
    tablespace USERS_MAN,
  partition P4 values (4)
    tablespace USERS_MAN,
  partition P0 values (0)
    tablespace USERS_MAN,
  partition PZ values (default)
    tablespace USERS_MAN
);
create index SB_DT_II on SB_DT (ID)
  nologging  local;
create index SB_DT_IT on SB_DT (TAG)
  nologging  local;

prompt
prompt Creating table SB_DTG
prompt =====================
prompt
create table SB_DTG
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER
)
nologging;
create unique index SB_DTG_UI on SB_DTG (ID, TAG)
  nologging;

prompt
prompt Creating table SB_LOAD
prompt ======================
prompt
create table SB_LOAD
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(40),
  i_width    NUMBER,
  i_height   NUMBER,
  s_width    NUMBER,
  s_height   NUMBER,
  owner      VARCHAR2(40),
  fmd5       VARCHAR2(32),
  i_url      VARCHAR2(430),
  tags       VARCHAR2(12000)
)
nologging;
create unique index SB_LOAD_UI on SB_LOAD (ID)
  nologging;

prompt
prompt Creating table SB_TAGS
prompt ======================
prompt
create table SB_TAGS
(
  tag        VARCHAR2(160) not null,
  posts      NUMBER not null,
  tag_id     NUMBER,
  tag_cat    NUMBER not null,
  posts_2020 NUMBER
)
nologging;
create index SB_TAGS_TAG on SB_TAGS (TAG)
  nologging;

prompt
prompt Creating table SNK_21
prompt =====================
prompt
create table SNK_21
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300),
  fname   VARCHAR2(327)
)
nologging;
create unique index SNK_21_UI on SNK_21 (FID)
  nologging;

prompt
prompt Creating table SNK_22
prompt =====================
prompt
create table SNK_22
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300),
  fname   VARCHAR2(327)
)
nologging;
create unique index SNK_22_UI on SNK_22 (FID)
  nologging;

prompt
prompt Creating table SNK_23
prompt =====================
prompt
create table SNK_23
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300),
  fname   VARCHAR2(327)
)
nologging;
create unique index SNK_23_UI on SNK_23 (FID)
  nologging;

prompt
prompt Creating table SNK_DTO
prompt ======================
prompt
create table SNK_DTO
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index SNK_DTO_UI on SNK_DTO (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DTOC
prompt =======================
prompt
create table SNK_DTOC
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER,
  f       NUMBER,
  l       NUMBER
)
nologging;
create unique index SNK_DTOC_UI on SNK_DTOC (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_21
prompt ========================
prompt
create table SNK_DT_21
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index SNK_DT_21_UI on SNK_DT_21 (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_21C
prompt =========================
prompt
create table SNK_DT_21C
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER,
  f       NUMBER,
  l       NUMBER
)
nologging;
create unique index SNK_DT_21C_UI on SNK_DT_21C (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_22
prompt ========================
prompt
create table SNK_DT_22
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index SNK_DT_22_UI on SNK_DT_22 (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_22C
prompt =========================
prompt
create table SNK_DT_22C
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER,
  f       NUMBER,
  l       NUMBER
)
nologging;
create unique index SNK_DT_22C_UI on SNK_DT_22C (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_23
prompt ========================
prompt
create table SNK_DT_23
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index SNK_DT_23_UI on SNK_DT_23 (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_DT_23C
prompt =========================
prompt
create table SNK_DT_23C
(
  fid     NUMBER,
  tag     VARCHAR2(600),
  n       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER,
  f       NUMBER,
  l       NUMBER
)
nologging;
create unique index SNK_DT_23C_UI on SNK_DT_23C (FID, TAG)
  nologging;

prompt
prompt Creating table SNK_LD
prompt =====================
prompt
create table SNK_LD
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300)
)
nologging;
create unique index SNK_LD_UI on SNK_LD (FID)
  nologging;

prompt
prompt Creating table SNK_LDA
prompt ======================
prompt
create table SNK_LDA
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300)
)
nologging;
create unique index SNK_LDA_UI on SNK_LDA (FID)
  nologging;

prompt
prompt Creating table SNK_LDO
prompt ======================
prompt
create table SNK_LDO
(
  fid     NUMBER,
  tags    VARCHAR2(9600),
  rate    NUMBER,
  ratn    NUMBER,
  fdate   DATE,
  fsize   NUMBER,
  iwidth  NUMBER,
  iheight NUMBER,
  furl    VARCHAR2(300),
  rating  VARCHAR2(20),
  eol     VARCHAR2(300)
)
nologging;
create unique index SNK_LDO_UI on SNK_LDO (FID)
  nologging;

prompt
prompt Creating table SNK_SL
prompt =====================
prompt
create table SNK_SL
(
  fid    NUMBER,
  tags   VARCHAR2(9600),
  rate   NUMBER,
  ratn   NUMBER,
  fdate  DATE,
  fdim   VARCHAR2(12),
  furl   VARCHAR2(300),
  rating VARCHAR2(20),
  eol    VARCHAR2(300)
)
nologging;
create unique index SNK_SL_UI on SNK_SL (FID)
  nologging;

prompt
prompt Creating table TAGS_EXT
prompt =======================
prompt
create table TAGS_EXT
(
  id      NUMBER,
  tag_cat VARCHAR2(80),
  tag     VARCHAR2(200)
)
organization external
(
  type ORACLE_LOADER
  default directory B
  access parameters 
  (
    RECORDS DELIMITED BY 0x'0A'
    FIELDS TERMINATED BY 0x'09' optionally enclosed by '"' LDRTRIM ( id, tag_cat, tag )
  )
  location (B:'tags.txt')
)
reject limit UNLIMITED;

prompt
prompt Creating table TBIB
prompt ===================
prompt
create table TBIB
(
  id     NUMBER,
  chang  DATE,
  score  NUMBER,
  rating VARCHAR2(20),
  iw     NUMBER,
  ih     NUMBER,
  dir    VARCHAR2(4),
  img    VARCHAR2(60),
  tags   VARCHAR2(6000),
  owner  VARCHAR2(30),
  fmd5   VARCHAR2(32)
)
nologging;
create unique index TBIB_UI on TBIB (ID)
  nologging;

prompt
prompt Creating table TBIBO
prompt ====================
prompt
create table TBIBO
(
  id     NUMBER,
  chang  DATE,
  score  NUMBER,
  rating VARCHAR2(20),
  iw     NUMBER,
  ih     NUMBER,
  dir    VARCHAR2(4),
  img    VARCHAR2(60),
  tags   VARCHAR2(6000),
  owner  VARCHAR2(30),
  fmd5   VARCHAR2(32)
)
nologging;
create unique index TBIBO_UI on TBIBO (ID)
  nologging;

prompt
prompt Creating table TBIB_2020
prompt ========================
prompt
create table TBIB_2020
(
  id       NUMBER,
  dtm      DATE,
  ratn     VARCHAR2(20),
  tiw      NUMBER,
  tih      NUMBER,
  dir      VARCHAR2(4),
  img      VARCHAR2(60),
  tfmd5    VARCHAR2(32),
  filesize NUMBER,
  iw       VARCHAR2(48),
  ih       VARCHAR2(48),
  jq       NUMBER,
  fpath    VARCHAR2(1200),
  fname    VARCHAR2(1200),
  fmd5     CHAR(32)
)
nologging;

prompt
prompt Creating table TBIB_2021
prompt ========================
prompt
create table TBIB_2021
(
  id     NUMBER,
  chang  DATE,
  score  NUMBER,
  rating VARCHAR2(20),
  iw     NUMBER,
  ih     NUMBER,
  dir    VARCHAR2(4),
  img    VARCHAR2(60),
  tags   VARCHAR2(6000),
  owner  VARCHAR2(30),
  fmd5   VARCHAR2(32)
)
nologging;
create unique index TBIB_2021_UI on TBIB_2021 (ID)
  nologging;

prompt
prompt Creating table TBIB_DT
prompt ======================
prompt
create table TBIB_DT
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER
)
nologging;
create unique index TBIB_DT_UI on TBIB_DT (ID, TAG)
  nologging;

prompt
prompt Creating table TBIB_DTE
prompt =======================
prompt
create table TBIB_DTE
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  n       NUMBER not null,
  tag_cat NUMBER
)
nologging;
create unique index TBIB_DTE_UI on TBIB_DTE (ID, TAG)
  nologging;

prompt
prompt Creating table TBIB_DTE_2021
prompt ============================
prompt
create table TBIB_DTE_2021
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  n       NUMBER not null,
  tag_cat NUMBER
)
nologging;
create unique index TBIB_DTE_2021_UI on TBIB_DTE_2021 (ID, TAG)
  nologging;

prompt
prompt Creating table TBIB_DTO
prompt =======================
prompt
create table TBIB_DTO
(
  id      NUMBER,
  tag     VARCHAR2(2400),
  x       NUMBER,
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;

prompt
prompt Creating table TBIB_DT_2021
prompt ===========================
prompt
create table TBIB_DT_2021
(
  id      NUMBER not null,
  tag     VARCHAR2(600) not null,
  tag_cat NUMBER
)
nologging;
create unique index TBIB_DT_2021_UI on TBIB_DT_2021 (ID, TAG)
  nologging;

prompt
prompt Creating table X2020D
prompt =====================
prompt
create table X2020D
(
  booru    VARCHAR2(32767),
  fid      VARCHAR2(32767),
  fname    VARCHAR2(1200),
  fdate    DATE,
  frating  VARCHAR2(16000),
  fscore   VARCHAR2(16000),
  sizes    VARCHAR2(16000),
  fext     VARCHAR2(16000),
  filesize NUMBER,
  fdim     VARCHAR2(97),
  jq       NUMBER,
  fmd5     VARCHAR2(32),
  fpath    VARCHAR2(4788),
  copyr    VARCHAR2(15988),
  chars    VARCHAR2(16000),
  artis    VARCHAR2(15988),
  tagall   VARCHAR2(16000)
)
nologging;

prompt
prompt Creating table X2021A
prompt =====================
prompt
create table X2021A
(
  booru       VARCHAR2(32),
  fid         NUMBER,
  fpath       VARCHAR2(52),
  fname       VARCHAR2(327),
  torr_md5    CHAR(32),
  orig_ext    VARCHAR2(3),
  orig_md5    VARCHAR2(32),
  torr_fsize  NUMBER,
  torr_width  VARCHAR2(48),
  torr_height VARCHAR2(48),
  torr_jq     NUMBER,
  tc          VARCHAR2(1327),
  tp          VARCHAR2(2327),
  ta          VARCHAR2(327)
)
nologging;

prompt
prompt Creating table X2021A_DTO
prompt =========================
prompt
create table X2021A_DTO
(
  booru          VARCHAR2(32),
  id             NUMBER,
  tag_name       VARCHAR2(600),
  tag_id         NUMBER,
  tag_cat        NUMBER,
  danb_franchise VARCHAR2(2000)
)
nologging;

prompt
prompt Creating table YNDR
prompt ===================
prompt
create table YNDR
(
  id         NUMBER,
  tid        NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(400),
  i_width    NUMBER,
  i_height   NUMBER,
  f_ext      VARCHAR2(400),
  f_size     NUMBER,
  f_url      VARCHAR2(400),
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(400),
  j_size     NUMBER,
  j_url      VARCHAR2(400),
  x_tags     VARCHAR2(1),
  author     VARCHAR2(200),
  fmd5       VARCHAR2(32),
  parent_id  NUMBER
)
nologging;
create unique index YNDR_UI on YNDR (ID)
  nologging;
create unique index YNDR_UI_MD5 on YNDR (FMD5)
  nologging;

prompt
prompt Creating table YNDR_ADD
prompt =======================
prompt
create table YNDR_ADD
(
  id         NUMBER,
  tid        NUMBER,
  creator_id NUMBER,
  author     VARCHAR2(200),
  fmd5       VARCHAR2(32),
  parent_id  NUMBER
)
nologging;

prompt
prompt Creating table YNDR_DT
prompt ======================
prompt
create table YNDR_DT
(
  id      NUMBER,
  x       NUMBER,
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  tag_id  NUMBER
)
nologging;
create index YNDR_DT_TAG on YNDR_DT (TAG)
  nologging;
create unique index YNDR_DT_UI on YNDR_DT (TAG, ID)
  nologging;

prompt
prompt Creating table YNDR_IM
prompt ======================
prompt
create table YNDR_IM
(
  ifile      VARCHAR2(600),
  ipath      VARCHAR2(300),
  ibytes     NUMBER,
  iwidth     NUMBER,
  iheight    NUMBER,
  bits       NUMBER,
  resx       NUMBER,
  resy       NUMBER,
  resunit    VARCHAR2(60),
  boundbox   VARCHAR2(30),
  filefmt    VARCHAR2(30),
  compqual   NUMBER,
  comptype   VARCHAR2(30),
  colorspace VARCHAR2(30),
  ihash      VARCHAR2(64),
  ientr      NUMBER,
  iskew      NUMBER,
  imean      NUMBER,
  istddev    NUMBER,
  icolors    NUMBER,
  meang      NUMBER,
  maximag    NUMBER,
  rmean      NUMBER,
  gmean      NUMBER,
  bmean      NUMBER,
  edge       NUMBER,
  booru      VARCHAR2(30),
  fid        NUMBER,
  dtm        DATE default sysdate,
  flags      CHAR(8) default '--------'
)
nologging;
create unique index YNDR_IM_UI on YNDR_IM (FID)
  nologging;

prompt
prompt Creating table YNDR_LOAD
prompt ========================
prompt
create table YNDR_LOAD
(
  id NUMBER,
  j  VARCHAR2(12000)
)
nologging;
alter table YNDR_LOAD
  add constraint YNDR_LOAD_J
  check (j is json)
  disable
  novalidate;

prompt
prompt Creating table YNDR_POOLS
prompt =========================
prompt
create table YNDR_POOLS
(
  pid   NUMBER,
  pname VARCHAR2(400),
  pcnt  NUMBER
)
nologging;
create unique index YNDR_POOLS_UI on YNDR_POOLS (PID)
  nologging;

prompt
prompt Creating table YNDR_PPOSTS
prompt ==========================
prompt
create table YNDR_PPOSTS
(
  id    NUMBER,
  tid   NUMBER,
  pid   NUMBER,
  ppid  NUMBER,
  ppseq NUMBER
)
nologging;
create unique index YNDR_PPOSTS_UI on YNDR_PPOSTS (PID, ID)
  nologging;

prompt
prompt Creating table YNDR_RIP
prompt =======================
prompt
create table YNDR_RIP
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(4),
  rnk        NUMBER,
  i_width    NUMBER,
  i_height   NUMBER,
  f_size     NUMBER,
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(400),
  f_url      VARCHAR2(400),
  fname      VARCHAR2(400),
  done       NUMBER
)
nologging;
create unique index YNDR_RIP_UI on YNDR_RIP (ID)
  nologging;

prompt
prompt Creating table YNDR_RIPE
prompt ========================
prompt
create table YNDR_RIPE
(
  id         NUMBER,
  created_at DATE,
  score      NUMBER,
  rating     VARCHAR2(400),
  rnk        NUMBER,
  i_width    NUMBER,
  i_height   NUMBER,
  f_size     NUMBER,
  s_width    NUMBER,
  s_height   NUMBER,
  s_size     NUMBER,
  s_url      VARCHAR2(400),
  f_url      VARCHAR2(400),
  fname      VARCHAR2(32767),
  done       NUMBER
)
nologging;

prompt
prompt Creating table YNDR_TG
prompt ======================
prompt
create table YNDR_TG
(
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  cnt     NUMBER,
  tag_id  NUMBER
)
nologging;
create unique index YNDR_TG_UI on YNDR_TG (TAG)
  nologging;

prompt
prompt Creating table ZERO_2008_OUT
prompt ============================
prompt
create table ZERO_2008_OUT
(
  fid        NUMBER,
  img        VARCHAR2(8),
  s_size     NUMBER,
  s_width    VARCHAR2(48),
  s_height   VARCHAR2(48),
  i_fmd5     CHAR(32),
  i_size     NUMBER,
  i_width    VARCHAR2(48),
  i_height   VARCHAR2(48),
  i_ar       NUMBER,
  i_px       NUMBER,
  i_fmt      VARCHAR2(30),
  i_jq       NUMBER,
  fname      VARCHAR2(1200),
  furl       VARCHAR2(400),
  created_at DATE,
  iwidth     NUMBER,
  iheight    NUMBER,
  enc        VARCHAR2(8)
)
nologging;
create unique index ZERO_2008_UI on ZERO_2008_OUT (FID)
  nologging;

prompt
prompt Creating table ZERO_2008_S
prompt ==========================
prompt
create table ZERO_2008_S
(
  fid      NUMBER,
  filesize NUMBER,
  iw       VARCHAR2(48),
  ih       VARCHAR2(48),
  ar       NUMBER,
  px       NUMBER,
  ifmt     VARCHAR2(30),
  jq       NUMBER,
  fpath    VARCHAR2(1200),
  fname    VARCHAR2(1200),
  fmd5     CHAR(32),
  fext     VARCHAR2(1200)
)
nologging;

prompt
prompt Creating table ZERO_2010_MGRFY
prompt ==============================
prompt
create table ZERO_2010_MGRFY
(
  booru          VARCHAR2(32),
  fid            VARCHAR2(32),
  filesize       NUMBER,
  iw             VARCHAR2(48),
  ih             VARCHAR2(48),
  ar             NUMBER,
  px             NUMBER,
  filecreatedate DATE,
  ifmt           VARCHAR2(30),
  jq             NUMBER,
  fpath          VARCHAR2(1200),
  fname          VARCHAR2(1200),
  ldir           VARCHAR2(1200),
  fext           VARCHAR2(1200),
  sourcefile     VARCHAR2(300)
)
nologging;
create index ZZ_EXIF_Z_J on ZERO_2010_MGRFY (FID)
  nologging;

prompt
prompt Creating table ZERO_2014
prompt ========================
prompt
create table ZERO_2014
(
  id         NUMBER,
  furl       VARCHAR2(400),
  created_at DATE,
  iwidth     NUMBER,
  iheight    NUMBER,
  enc        VARCHAR2(8)
)
nologging;
create unique index ZERO_2014_UI on ZERO_2014 (ID)
  nologging;

prompt
prompt Creating table ZERO_2014_CMP
prompt ============================
prompt
create table ZERO_2014_CMP
(
  fpath      VARCHAR2(32767),
  fname      VARCHAR2(32767),
  fid        VARCHAR2(32767),
  fmd5       CHAR(32),
  filesize   NUMBER,
  iw         VARCHAR2(48),
  ih         VARCHAR2(48),
  ar         NUMBER,
  px         NUMBER,
  ifmt       VARCHAR2(30),
  jq         NUMBER,
  furl       VARCHAR2(400),
  created_at DATE,
  r_torr     VARCHAR2(30),
  r_name     VARCHAR2(300),
  a_path     VARCHAR2(300),
  a_name     VARCHAR2(300),
  t_booru    VARCHAR2(30),
  t_fid      NUMBER,
  g_area     VARCHAR2(32),
  g_fpath    VARCHAR2(300),
  g_fname    VARCHAR2(300),
  reason     NUMBER
)
nologging;

prompt
prompt Creating table ZERO_2014_MGRFY
prompt ==============================
prompt
create table ZERO_2014_MGRFY
(
  booru          VARCHAR2(32),
  fid            VARCHAR2(32),
  filesize       NUMBER,
  iw             VARCHAR2(48),
  ih             VARCHAR2(48),
  ar             NUMBER,
  px             NUMBER,
  filecreatedate DATE,
  ifmt           VARCHAR2(30),
  jq             NUMBER,
  fpath          VARCHAR2(1200),
  fname          VARCHAR2(1200),
  ldir           VARCHAR2(1200),
  fext           VARCHAR2(1200),
  sourcefile     VARCHAR2(300)
)
nologging;
create index ZZ_EXIF_Z_I on ZERO_2014_MGRFY (FID)
  nologging;

prompt
prompt Creating table ZERO_2020
prompt ========================
prompt
create table ZERO_2020
(
  id         NUMBER,
  furl       VARCHAR2(400),
  created_at DATE,
  iwidth     NUMBER,
  iheight    NUMBER,
  enc        VARCHAR2(8)
)
nologging;
create unique index ZERO_2020_UI on ZERO_2020 (ID)
  nologging;

prompt
prompt Creating table ZERO_DT
prompt ======================
prompt
create table ZERO_DT
(
  id      NUMBER,
  tcat    VARCHAR2(30),
  tag     VARCHAR2(300),
  tag_cat NUMBER,
  tag_id  NUMBER,
  r       NUMBER
)
nologging;
create unique index ZERO_DT_UI on ZERO_DT (ID, TAG)
  nologging;

prompt
prompt Creating table ZERO_DTL
prompt =======================
prompt
create table ZERO_DTL
(
  id      NUMBER,
  tcat    VARCHAR2(30),
  tag     VARCHAR2(300),
  tag_cat NUMBER,
  tag_id  NUMBER,
  r       NUMBER
)
nologging;
create unique index ZERO_DTL_UI on ZERO_DTL (ID, TAG)
  nologging;

prompt
prompt Creating table ZERO_OUT
prompt =======================
prompt
create table ZERO_OUT
(
  fid        NUMBER,
  ifile      VARCHAR2(15932),
  fmd5       VARCHAR2(32),
  iw         VARCHAR2(48),
  ih         VARCHAR2(48),
  ar         NUMBER,
  pix        NUMBER,
  filesize   NUMBER,
  furl       VARCHAR2(400),
  created_at VARCHAR2(16)
)
nologging;
create unique index ZERO_OUT_UI on ZERO_OUT (FID)
  nologging;

prompt
prompt Creating table ZIP_EXIF
prompt =======================
prompt
create table ZIP_EXIF
(
  torr           VARCHAR2(30),
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30),
  fid            NUMBER,
  ifmt           VARCHAR2(8),
  zpath          VARCHAR2(30),
  zseq           NUMBER generated always as identity (start with 10000000 maxvalue 99999999 minvalue 10000000 cycle cache 200 order)
)
nologging;
create unique index ZIP_EXIF_UI on ZIP_EXIF (SOURCEFILE, TORR)
  nologging;

prompt
prompt Creating table ZIP_MD5
prompt ======================
prompt
create table ZIP_MD5
(
  torr  VARCHAR2(30),
  fmd5  VARCHAR2(32),
  fname VARCHAR2(300),
  zpath VARCHAR2(30),
  zseq  NUMBER generated always as identity (start with 10000000 maxvalue 99999999 minvalue 10000000 cycle cache 200 order)
)
nologging;
create index ZIP_MD5_FNAME on ZIP_MD5 (FNAME)
  nologging;
create unique index ZIP_MD5_UI on ZIP_MD5 (FMD5, TORR)
  nologging;


prompt Done
spool off
set define on
