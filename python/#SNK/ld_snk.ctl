LOAD DATA
APPEND
INTO TABLE snk_ld
FIELDS TERMINATED BY '\t' TRAILING NULLCOLS
(
  fid    ,
  tags   CHAR(8000),
  rate   ,
  ratn   ,
  fdate  "to_date(:fdate,'YYYY-MM-DD HH24:MI')",
  fsize   "case when :iwidth!='EOL' then :fsize end",
  iwidth  "case when :iwidth!='EOL' then :iwidth end",
  iheight "case when :iwidth!='EOL' then :iheight end",
  furl    "case when :iwidth!='EOL' then :furl end",
  rating  "case when :iwidth!='EOL' then :rating else :fsize end",
  eol     "case when :iwidth!='EOL' then :eol else :iwidth end"
)
