LOAD DATA
APPEND
INTO TABLE load_im
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
(
ifile char(600),
ipath,
boundbox,
tentr,
tskew,
tmean,
tstddev,
tcolors,
meanG,
maximaG,
edge
)
