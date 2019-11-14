echo [file];[path];[IBytes];[Iwidth];[Iheight];[bits];[resx];[resy];[resunit];[boundbox];[filefmt];[compqual];[comptype];[colorspace];[IHASH];[tbytes];[twidth];[theight];[tentr];[tskew];[tmean];[tstddev];[tcolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge];[width2];[height2];[entr2] > A:\#LOAD_IM\0000.csv

for /R D:\#RESB\2x3 %%J in (*.JPG) do call A:\#LOAD_IM\0000_loop.bat "%%J" "A:\#LOAD_IM\D_#RESB_2x3\%%~nJ.jpg"

del A:\#LOAD_IM\_.jpg
