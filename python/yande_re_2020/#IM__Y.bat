echo [file];[path];[IBytes];[Iwidth];[Iheight];[bits];[resx];[resy];[resunit];[boundbox];[filefmt];[compqual];[comptype];[colorspace];[IHASH];[ientr];[iskew];[imean];[istddev];[icolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge] > #im__ys.csv

for /R D:\TORR\Yande_re_2020\69xxxx %%J in (*.JPG) do call #IM_looy.bat "%%J" #im__ys.csv
