LOAD DATA
APPEND
INTO TABLE yndr_im
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
(
ifile char(600),
ipath,
IBytes,
Iwidth,
Iheight,
bits,
resx,
resy,
resunit,
boundbox,
filefmt,
compqual,
comptype,
colorspace,
IHASH,
ientr,
iskew,
imean,
istddev,
icolors,
meanG,
maximaG,
Rmean,
Gmean,
Bmean,
edge
)
