@REM -- grabber with output redirects (+ zero_grab.json as hardcoded output)
python yndr_grab_json.py >> yndr_grab_json.tsv 2>> yndr_grab_json_err.csv

@REM -- load json to database
sqlldr usr/pwd@db control=#yndr_j.ctl data=%1 errors=1000 log=%1_log.log

@REM -- simple file list (to use via external table)
dir /b /s D:\TORR\Yande_re_2020 > dir_bs.txt

@REM -- make file info with MD5 (to use via external table)
fciv -r D:\TORR\Yande_re_2020 > dir_bs.txt

@REM -- get some images info (to load via sqlldr)
exiftool -filecreatedate -imagesize -filesize# -filetype -csv -r D:\TORR\Yande_re_2020 > yndr_exif.csv

@REM -- load exif info (see above)
sqlldr usr/pwd@db control=#yndr_exif.ctl data=yndr_exif.csv skip=1 errors=1000 log=yndr_exif_csv.log

@REM -- load image magick results
sqlldr usr/pwd@db control=#yndr_im.ctl data=%1 skip=1 errors=1000

@REM -- some massive exports
sqlplus usr/pwd@db @#yndr_out.sql
