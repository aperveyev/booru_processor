LOAD DATA
TRUNCATE
INTO TABLE load_exif
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
(
  sourcefile char(600), 
  filecreatedate "to_date(replace(substr(:filecreatedate,1,10),':','.')||substr(:filecreatedate,11,9),'YYYY.MM.DD HH24:MI:SS')", 
  imagesize, 
  filesize,
  ifmt
)
