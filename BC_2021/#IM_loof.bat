magick identify -format """%%f"";%%d;%%@;%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" %1 >> %2
magick convert %1 -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> %2
magick convert %1 -edge 3 -format "%%[fx:mean]\n" info: >> %2
