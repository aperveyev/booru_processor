for %%f in (B:\BCTO\2014-7x10__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2014-7x10__\%%~nf.txt"
for %%f in (B:\BCTO\2015-7x10__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2015-7x10__\%%~nf.txt"

exit

for %%f in (L:\BCTO\2015-1x1___\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2015-1x1___\%%~nf.txt"
for %%f in (L:\BCTO\2014-1x1__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2014-1x1__\%%~nf.txt"
for %%f in (L:\BCTO\2014-3x2__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2014-3x2__\%%~nf.txt"
for %%f in (L:\BCTO\2015-3x2__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2015-3x2__\%%~nf.txt"

for %%f in (B:\BCTO\2014-3x4__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2014-3x4__\%%~nf.txt"
for %%f in (B:\BCTO\2015-3x4__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2015-3x4__\%%~nf.txt"
for %%f in (B:\BCTO\2014-1x2__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2014-1x2__\%%~nf.txt"
for %%f in (B:\BCTO\2015-1x2__\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 null: >> "2015-1x2__\%%~nf.txt"

exit

:for %%f in (D:\BCTO\2014-1x1\*.jpg) do magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=128000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 +write "OUT\%%~nf.png" null: >> "%%~nf.txt"


for %%f in (y*.jpg) do (
:echo|set /p= "%%~nf" >> is.txt
magick convert "%%f" -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=100000 -define connected-components:mean-color=true -define connected-components:exclude-header=true -connected-components 4 +write "OUT\%%~nf.png" null: >> "%%~nf.txt"
)

exit

magick convert %1 -threshold 84%% -shave 5x5 -bordercolor white -border 5 -blur 0x1.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=10000 -define connected-components:mean-color=true -connected-components 4 +write %1_1.png null:

exit

magick convert %1 -threshold 95%% -shave 5x5 -bordercolor white -border 5 -blur 0x2.5 -threshold 99%% -type bilevel -define connected-components:verbose=true -define connected-components:area-threshold=20 -define connected-components:mean-color=true -connected-components 4 +write zz.png null:

Threshold your image to keep the white areas and make all else black. Then use -connected-components to get the bounding regions of each of the white regions. Take the largest white region which will be the first white region in the list, since they are listed in order of decreasing area.

In Imagemagick, you can threshold the image to keep from getting too much noise, then blur it and then threshold again to make large regions of black connected. Then use -connected-components to filter out small regions, especially of white and then find the bounding boxes of the black regions. 

https://imagemagick.org/script/connected-components.php
