@REM -- fast file list
dir /b /s B:\#KONA > dir_bs.txt

@REM -- make file info with MD5 (to use via external table)
fciv -r B:\#KONA > fciv.txt

@REM -- get some images info (to load via sqlldr)
exiftool -filecreatedate -imagesize -filesize# -filetype -csv -r B:\#KONA  > load_exif.csv
