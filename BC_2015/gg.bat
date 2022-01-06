:magick convert %1 -fuzz 10%% -edge 2 +write %2_EE.jpg -format ""%2";%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation]\n" info: >> %3

magick convert %1 -edge 1 _g1.jpg
:-format ""%2";%%[entropy];%%[fx:mean];" info: >> %3
magick convert %1 -blur 0x0.7 -edge 1 _g2.jpg
:-format "%%[fx:mean]\n" info: >> %3

magick convert _g1.jpg -format ""%2";%%[entropy];%%[fx:mean];" info: >> %3
magick convert _g2.jpg -format "%%[fx:mean]\n" info: >> %3

:-fuzz 40%%

:magick #.jpg -format ""%2.jpg"""";%%[fx:mean]\n" info: >> %3

:magick convert %1 -edge %2 %1__%2.jpg
:magick %1__%2.jpg -format "%%[fx:mean];%2;" info: >> g.out
:echo %1 >> g.out
