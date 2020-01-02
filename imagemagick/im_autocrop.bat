@REM -- autocrop borders with ImageMagick for directory, initial files will be overwritten ! 
@REM -- set last parameter "PATH\%%~nJ [CROP].jpg" to avoid this

@REM -- gently with +20 borders
for %%J in (*.JPG) do magick "%%J" ( +clone -virtual-pixel edge -blur 0x15 -fuzz 3%% -trim  -set option:fuzzy_trim %%[fx:w+40]x%%[fx:h+40]+%%[fx:page.x-20]+%%[fx:page.y-20] +delete ) -crop %%[fuzzy_trim] "%%J"

@REM - average tolerance no border
for %%J in (*.JPG) do magick "%%J" ( +clone -virtual-pixel edge -blur 0x15 -fuzz 10%% -trim  -set option:fuzzy_trim %%[fx:w]x%%[fx:h]+%%[fx:page.x]+%%[fx:page.y] +delete ) -crop %%[fuzzy_trim] "%%J"

@REM hadrcrop with -5 deeper cut
for %%J in (*.JPG) do magick "%%J" ( +clone -virtual-pixel edge -blur 0x15 -fuzz 35%% -trim  -set option:fuzzy_trim %%[fx:w-10]x%%[fx:h-10]+%%[fx:page.x+5]+%%[fx:page.y+5] +delete ) -crop %%[fuzzy_trim] "%%J"
