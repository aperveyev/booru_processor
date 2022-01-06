for /d %%r in (D:\BC7\V2021A.7x10\*) do magick mogrify -path B:\BCT\V2021A.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC3\V2021A.3x4\*)  do magick mogrify -path B:\BCT\V2021A.3x4  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC1\V2021A.1x2\*)  do magick mogrify -path B:\BCT\V2021A.1x2  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2021A.7x10 > #exifz_V2021A.7x10.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2021A.3x4  > #exifz_V2021A.3x4.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2021A.1x2  > #exifz_V2021A.1x2.csv

exit

for /d %%r in (D:\BC7\V2016.7x10\*)  do magick mogrify -path B:\BCT\V2016.7x10  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2016.7x10  > #exifz_V2016_7x10.csv

exit

for /d %%r in (D:\BC7\V2019.7x10\*)  do magick mogrify -path B:\BCT\V2019.7x10  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2019.7x10  > #exifz_V2019_7x10.csv


for /d %%r in (D:\BC7\V2018.7x10s\*)  do magick mogrify -path B:\BCT\V2018.7x10s  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2018.7x10z\*)  do magick mogrify -path B:\BCT\V2018.7x10z  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2018.7x10\*)  do magick mogrify -path B:\BCT\V2018.7x10  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2018.7x10s  > #exifz_V2018_7x10s.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2018.7x10z  > #exifz_V2018_7x10z.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2018.7x10  > #exifz_V2018_7x10.csv

exit

for /d %%r in (D:\BC7\V2019.7x10\*)  do magick mogrify -path B:\BCT\V2019.7x10  -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2020A.7x10\*) do magick mogrify -path B:\BCT\V2020A.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2020B.7x10\*) do magick mogrify -path B:\BCT\V2020B.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2020C.7x10\*) do magick mogrify -path B:\BCT\V2020C.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"
for /d %%r in (D:\BC7\V2020D.7x10\*) do magick mogrify -path B:\BCT\V2020D.7x10 -verbose -thumbnail 1280x1280^ "%%r\*.jpg"

exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2019.7x10  > #exifz_V2019_7x10.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2020A.7x10 > #exifz_V2020A_7x10.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2020B.7x10 > #exifz_V2020B_7x10.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2020C.7x10 > #exifz_V2020C_7x10.csv
exiftool -filecreatedate -imagesize -filesize# -filetype -JPEGQualityEstimate -csv -r B:\BCT\V2020D.7x10 > #exifz_V2020D_7x10.csv
