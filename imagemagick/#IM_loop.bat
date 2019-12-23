magick identify -format """%%f"";%%d;%%B;%%[width];%%[height];%%[bit-depth];%%x;%%y;%%U;%%@;%%m;%%Q;%%C;%%r;%%#;" %1 >> %3
magick convert -resize 512x512 -extent 512x512 -gravity center -background black %1 %2
magick convert %2 -fuzz 3%% -trim +repage %4
magick identify -format "%%B;%%[width];%%[height];%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" %4 >> %3
magick convert %4 -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> %3
magick convert %4 -channel   red -format "%%[fx:mean];" info: >> %3
magick convert %4 -channel green -format "%%[fx:mean];" info: >> %3
magick convert %4 -channel  blue -format "%%[fx:mean];" info: >> %3
magick convert %4 -edge 2 -format "%%[fx:mean];" info: >> %3
magick convert %4 -fuzz 15%% -trim +repage %4
magick identify -format "%%[width];%%[height];%%[entropy]\n" %4 >> %3
