@REM -- sqlldr direct without CTL-file (last field must be mandatory !)
sqlldr usr/pwd@db control=#kona_load.ctl data=%1 errors=10000000 log=%1_log.log
