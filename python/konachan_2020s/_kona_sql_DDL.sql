-- to load JSON grabbed
create table KONA_LOAD
(
  id NUMBER,
  j  VARCHAR2(28000),  -- set MAX_STRING_SIZE = EXTENDED
  jj VARCHAR2(28000)   -- to arrange konachan-specific JSON content
) ;
create unique index KONA_LOAD_UI on KONA_LOAD (ID) ;

-- main POSTS info from JSON
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
) ;
create unique index KONA_UI on KONA (ID) ;
create unique index KONA_UMD5 on KONA (FMD5) ;

-- parse tags from JSON in-built list
create table KONA_DT
(
  id      NUMBER,
  x       NUMBER,
  tag     VARCHAR2(2400),
  tag_cat NUMBER, -- tag types recoded to Danbooru standards
  tag_id  NUMBER  -- tag_id from Danbooru when matched
) ;
create unique index KONA_DT_UI on KONA_DT (TAG, ID) ;

-- control table for samples/images grabbing
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
) ;

-- for Image Magick calculation results
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
  fid        NUMBER        -- parsed from file name
) ;
create unique index KONA_IM_UI on KONA_IM (FID) ;

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
