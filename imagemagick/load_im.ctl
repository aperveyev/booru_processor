LOAD DATA
APPEND
INTO TABLE load_im_i
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
tbytes,
twidth,
theight,
tentr,
tskew,
tmean,
tstddev,
tcolors,
meanG,
maximaG,
Rmean,
Gmean,
Bmean,
edge,
width2,
height2,
entr2
)
