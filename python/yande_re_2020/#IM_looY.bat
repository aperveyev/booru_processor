magick identify -format """%%f"";%%d;%%B;%%[width];%%[height];%%[bit-depth];%%x;%%y;%%U;%%@;%%m;%%Q;%%C;%%r;%%#;" %1 >> %2
magick identify -format "%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" %1 >> %2
magick convert %1 -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> %2
magick convert %1 -channel   red -format "%%[fx:mean];" info: >> %2
magick convert %1 -channel green -format "%%[fx:mean];" info: >> %2
magick convert %1 -channel  blue -format "%%[fx:mean];" info: >> %2
magick convert %1 -edge 2 -format "%%[fx:mean]\n" info: >> %2
