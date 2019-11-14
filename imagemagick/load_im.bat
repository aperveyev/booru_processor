@REM -- sqlldr direct without CTL-file (last field must be mandatory !)
sqlldr booru/alexp@hh19 control=load_im.ctl data=%1 skip=1 errors=10000000
