@REM -- grabber with output redirects (+ zero_grab.json as hardcoded output)
python zero_grab.py >> zero_grab.tsv 2>> zero_grab.err

@REM -- load tags to table
sqlldr booru/pwd@db control=zero_dt.ctl data=zero_grab.tsv errors=10000000 log=zero_grab_tsv.log

@REM -- simple file list (to use via external table)
dir /b /s D:\ZERO > dir_bs.txt

@REM -- make file info with MD5 (to use via external table)
fciv -r D:\ZERO > dir_bs.txt

@REM -- get some images info (to load via sqlldr)
exiftool -filecreatedate -imagesize -filesize# -filetype -csv -r D:\ZERO  > zero_exif.csv

@REM -- load exif info (see above)
sqlldr booru/pwd@db control=zero_exif.ctl data=zero_exif.csv skip=1 errors=10000000 log=zero_exif_csv.log

@REM -- zip in loop example
for /d %%s in (27*) do 7z a -r -tzip -mx1 "E:\ZERO\%%s" "%%s\*.*"
