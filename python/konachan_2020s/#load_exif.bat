@REM -- sqlldr direct without CTL-file (last field must be mandatory !)
sqlldr usr/pwd@db control=#load_exif.ctl data=%1 skip=1 errors=10000000 log=%1.log
