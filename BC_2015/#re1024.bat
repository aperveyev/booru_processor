magick mogrify -path C:\BCT\2014-1x1## -verbose -quality 94 "C:\BCT\2014-1x1#\*.jpg"
magick mogrify -path C:\BCT\2015-1x1## -verbose -quality 94 "C:\BCT\2015-1x1#\*.jpg"

magick mogrify -path C:\BCT\2014-1x2## -verbose -quality 94 "C:\BCT\2014-1x2#\*.jpg"
magick mogrify -path C:\BCT\2015-1x2## -verbose -quality 94 "C:\BCT\2015-1x2#\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2014-1x1    > #exifz_2014-1x1.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2014-1x1##  > #exifz_2014-1x1##.csv

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2015-1x1    > #exifz_2015-1x1.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2015-1x1##  > #exifz_2015-1x1##.csv

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2014-1x2    > #exifz_2014-1x2.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2014-1x2##  > #exifz_2014-1x2##.csv

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2015-1x2    > #exifz_2015-1x2.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r  Ñ:\BCT\2015-1x2##  > #exifz_2015-1x2##.csv
