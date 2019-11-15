### ImageMagick - пакетная обработка изображений (Windows ВАТ-файлы)

**Генерация изображений "иконок" и расчет мета-данных:**
основной 0000.bat выполняемый в цикле 0000_loop.bat (дурацкие названия, поменяю).

#### Смысл статистических характеристик изображения, рассчитываемых Imagick и их получение

Способ получения **magick identify -format "маска_текста" входной_файл >> выходной_файл** В BAT-файлах символ "процент" должен быть удвоен.

**Основные характеристики (по заголовку файла, не ресурсоемкие):**
- %f - имя файла
- %d - путь к файлу
- %B - размер в байтах (чувствительны к регистру !)
- %[width] - ширина в точках (квадратные скобки !)
- %[height] - высота в точках 
- %[bit-depth] - глубина цвета
- %x - разрешение по Х
- %y - разрешение по Y
- %U - единица измерения разрешения
- %m - формат файла (можен не соппадать с формальным расширением файла !)
- %Q - качество компрессии
- %C - тип компрессии
- %r - цветовое пространство
- %# - инфо-хеш изображения, потенциальный уникальный ключ, для поиска подобий непригоден

**Расчетные характеристики, ресурсоемкие для крупных изображений:**
- %@ - bound_box в формате WIDTHxHEIGHT+X+Y для "чистой" (без блюра) обрезки

[tentr];[tskew];[tmean];[tstddev];[tcolors];[meanG];[maximaG];[Rmean];[Gmean];[Bmean];[edge];[width2];[height2];[entr2] > A:\#LOAD_IM\0000.csv


for /R D:\#RESB\2x3 %%J in (*.JPG) do call A:\#LOAD_IM\0000_loop.bat "%%J" "A:\#LOAD_IM\D_#RESB_2x3\%%~nJ.jpg"

del A:\#LOAD_IM\_.jpg

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


#### Типичные преобразования с помощью Imagick

