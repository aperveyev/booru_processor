echo [file];[path];[boundbox];[tentr];[tskew];[tmean];[tstddev];[tcolors];[meanG];[maximaG];[edge] > #im2014_1x1.csv
for /R C:\BCT\2014-1x1 %%J in (*.JPG) do call #IM_loof.bat "%%J"                                     #im2014_1x1.csv
