echo [file];[path];[IBytes];[Iwidth];[Iheight];[bits];[resx];[resy];[resunit];[boundbox];[filefmt];[compqual];[comptype];[colorspace];[IHASH];[ientr];[iskew];[imean];[istddev];[icolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge] > #im__kss.csv

for /R B:\#KONA\KONASS %%J in (*.JPG) do call #IM_looy.bat "%%J" #im__kss.csv

echo [file];[path];[IBytes];[Iwidth];[Iheight];[bits];[resx];[resy];[resunit];[boundbox];[filefmt];[compqual];[comptype];[colorspace];[IHASH];[ientr];[iskew];[imean];[istddev];[icolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge] > #im__kqs.csv

for /R B:\#KONA\KONAQS %%J in (*.JPG) do call #IM_looy.bat "%%J" #im__kqs.csv
