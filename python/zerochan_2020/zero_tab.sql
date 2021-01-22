-- table for key posts data from JSON
create table ZERO
(
  id         NUMBER,
  furl       VARCHAR2(400),
  created_at DATE,
  iwidth     NUMBER,
  iheight    NUMBER,
  enc        VARCHAR2(4)
) ;
create unique index ZERO_UI on ZERO (ID) ;

-- one more table for fciv and exiftool results
create table ZERO_F
(
  fid       NUMBER,
  fname     VARCHAR2(400),
  fpath     VARCHAR2(40),
  fmd5      VARCHAR2(32),
  imagesize VARCHAR2(12),
  filesize  NUMBER,
  ifmt      VARCHAR2(4)
) ;
create unique index ZERO_F_UI on ZERO_F (FID)

-- posts tags loaded by sqlldr
create table ZERO_DT
(
  id      NUMBER,
  tcat    VARCHAR2(30),
  tag     VARCHAR2(300),
  tag_cat NUMBER,
  tag_id  NUMBER,
  r       NUMBER
) ;
create unique index ZERO_DT_UI on ZERO_DT (ID, TAG)

-- load EXIFTOOL info here
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

-- external table to use some texts (JSON grabbed, FCIV results) without dedicated sqlldr/ctl stuff
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
