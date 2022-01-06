echo FNAME;entropy;fxmean;meanbl > 2014-7x10___gg.csv
for %%f in (B:\BCTO\2014-7x10__\*.jpg) do call gg.bat "%%f" "%%~nf" 2014-7x1___gg.csv

echo FNAME;entropy;fxmean;meanbl > 2014-1x2___gg.csv
for %%f in (B:\BCTO\2014-1x2__\*.jpg) do call gg.bat "%%f" "%%~nf" 2014-1x2___gg.csv

echo FNAME;entropy;fxmean;meanbl > 2014-3x4___gg.csv
for %%f in (B:\BCTO\2014-3x4__\*.jpg) do call gg.bat "%%f" "%%~nf" 2014-3x4___gg.csv



echo FNAME;entropy;fxmean;meanbl > 2015-7x1___gg.csv
for %%f in (B:\BCTO\2015-7x10__\*.jpg) do call gg.bat "%%f" "%%~nf" 2015-7x1___gg.csv

echo FNAME;entropy;fxmean;meanbl > 2015-1x2___gg.csv
for %%f in (B:\BCTO\2015-1x2__\*.jpg) do call gg.bat "%%f" "%%~nf" 2015-1x2___gg.csv

echo FNAME;entropy;fxmean;meanbl > 2015-3x4___gg.csv
for %%f in (B:\BCTO\2015-3x4__\*.jpg) do call gg.bat "%%f" "%%~nf" 2015-3x4___gg.csv
