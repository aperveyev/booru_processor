magick identify -format """%%f"";%%d;%%B;%%[width];%%[height];%%[bit-depth];%%x;%%y;%%U;%%@;%%m;%%Q;%%C;%%r;%%#;" %1 >> A:\#LOAD_IM\0000.csv
magick convert -resize 512x512 -extent 512x512 -gravity center -background black %1 %2
magick convert %2 -fuzz 3%% -trim +repage A:\#LOAD_IM\_.jpg
magick identify -format "%%B;%%[width];%%[height];%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" A:\#LOAD_IM\_.jpg >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -channel   red -format "%%[fx:mean];" info: >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -channel green -format "%%[fx:mean];" info: >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -channel  blue -format "%%[fx:mean];" info: >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -edge 2 -format "%%[fx:mean];" info: >> A:\#LOAD_IM\0000.csv
magick convert A:\#LOAD_IM\_.jpg -fuzz 15%% -trim +repage A:\#LOAD_IM\_.jpg
magick identify -format "%%[width];%%[height];%%[entropy]\n" A:\#LOAD_IM\_.jpg >> A:\#LOAD_IM\0000.csv
