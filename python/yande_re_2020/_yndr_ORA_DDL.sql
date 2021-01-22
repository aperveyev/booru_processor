-- for raw JSON
create table yndr_load ( id number, j varchar2(12000) ) ;

-- for posts info parsed from JSON
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
) ;
create unique index YNDR_UI on YNDR (ID) ;
create unique index YNDR_UI_MD5 on YNDR (FMD5) ;

-- for tags parsed from JSON
create table YNDR_DT
(
  id      NUMBER,
  x       NUMBER,
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  tag_id  NUMBER
) ;
create unique index YNDR_DT_UI on YNDR_DT (TAG, ID) ;

-- subset for samples grabbing
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
) ;
create unique index YNDR_RIP_UI on YNDR_RIP (ID) ;

-- for Image Magick results
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
) ;
create unique index YNDR_IM_UI on YNDR_IM (FID) ;

-- for stats by tag
create table YNDR_TG
(
  tag     VARCHAR2(2400),
  tag_cat NUMBER,
  cnt     NUMBER,
  tag_id  NUMBER
) ;
create unique index YNDR_TG_UI on YNDR_TG (TAG) ;

-- for pools and pool posts
create table YNDR_POOLS
(
  pid   NUMBER,
  pname VARCHAR2(400),
  pcnt  NUMBER
) ;
create unique index YNDR_POOLS_UI on YNDR_POOLS (PID) ;
create table YNDR_PPOSTS
(
  id    NUMBER,
  tid   NUMBER,
  pid   NUMBER,
  ppid  NUMBER,
  ppseq NUMBER
) ;
create unique index YNDR_PPOSTS_UI on YNDR_PPOSTS (PID, ID) ;

-- load results of "exiftool -filecreatedate -imagesize -filesize# -filetype -csv -r" here
create table LOAD_EXIF
(
  sourcefile     VARCHAR2(300),
  filecreatedate DATE,
  imagesize      VARCHAR2(12),
  filesize       NUMBER,
  booru          VARCHAR2(30), -- parse from file name, code not provided
  fid            NUMBER,       -- parse from file name, code not provided
  dtm            DATE default sysdate,
  ifmt           VARCHAR2(30)
) ;
create unique index LOAD_EXIF_O_UI on LOAD_EXIF (SOURCEFILE) ;
create index LOAD_EXIF_O_FID on LOAD_EXIF (FID) ;

-- external table to use some texts (e.g. "dir /b /s") without dedicated sqlldr/ctl stuff
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

-- external table to interpret "fciv -r" results
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
