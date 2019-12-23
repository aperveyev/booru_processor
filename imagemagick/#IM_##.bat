echo [file];[path];[IBytes];[Iwidth];[Iheight];[bits];[resx];[resy];[resunit];[boundbox];[filefmt];[compqual];[comptype];[colorspace];[IHASH];[tbytes];[twidth];[theight];[tentr];[tskew];[tmean];[tstddev];[tcolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge];[width2];[height2];[entr2] > #REAW_3x4##.csv

for /R E:\##   %%J in (*.JPG) do call #IM_loop.bat "%%J" "A:\#LOAD_IM\3x4##\%%~nJ.jpg" #REAW_3x4##.csv _tmp_##.jpg

del _tmp_##.jpg
