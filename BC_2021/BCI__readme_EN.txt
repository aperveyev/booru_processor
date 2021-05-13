BOORU CHARS dataset can be used (and used) for visual ranking similar images using
TENTR - enthropy (micro complexity)
TSKEW - skewness (darkness)
TSTDDEV - standard deviation (contrast)
TCOLORS - colorfulness
MEANG - color saturation
EDGE - canny edge detector (macro complexity)

This multi-dimensional paramentic cloud was analyzed with XY Excel diagrams (e.g. BCI_V00_diagrams.xls, 
BCI_Vnn_diagrams.xls with SQL queries included) and leads me to 2 "weigth functions"
MAIN rating = (tentr-0.3)*(log(10,tcolors)-3)*(tstddev-0.1) DESC
REVERSE rating = (tentr+0.3)*(meang+0.1)*(tstddev+0.1) ASC
with boundary condition (Main:REV ~ 2:1 by count)
(tcolors>50000 and tentr>0.5 and tstddev>0.15 and meang>0.1)
This results in zip-folders Mxx/Rxx released.

Full query for MAIN rating
select b.booru, b.fid, ipath, b.sourcefile,
       tentr, rank() over (partition by ipath order by tentr desc) r_entr,
       tskew, 
       tstddev, rank() over (partition by ipath order by tstddev desc) r_sdev,
       tcolors, rank() over (partition by ipath order by tcolors desc) r_color, round(log(10,tcolors)-3,4) lc, 
       meang, rank() over (partition by ipath order by meang desc) r_meang,
       edge, rank() over (partition by ipath order by edge desc) r_edge,
       rank() over (partition by ipath order by (tentr-0.3)*(log(10,tcolors)-3)*(tstddev-0.1) desc) r_ALL
from bct_im d join bct_exif b on b.booru=d.booru and b.fid=d.fid
where (tcolors>50000 and tentr>0.5 /* >0.6 for volume 2018-7x10 */ and tstddev>0.15 and meang>0.1)
for REVERSE
select b.booru, b.fid, ipath, b.sourcefile,
       tentr, rank() over (partition by ipath order by tentr) d_entr,
       tskew, 
       tstddev, rank() over (partition by ipath order by tstddev) d_sdev,
       tcolors, rank() over (partition by ipath order by tcolors ) d_color, round(ln(tcolors+16),3) lc,
       meang, rank() over (partition by ipath order by meang) d_meang,
       edge, rank() over (partition by ipath order by edge) d_edge,
       rank() over (partition by ipath order by (tentr+0.3)*(meang+0.1)*(tstddev+0.1)) d_ALL
from bct_im d join bct_exif b on b.booru=d.booru and b.fid=d.fid
where not (tcolors>50000 and tentr>0.5 /*>0.6@2018-7x10*/ and tstddev>0.15 and meang>0.1)


