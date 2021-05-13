Помимо визуального summary персонажного anime/CG/game арта, BOORU CHARS dataset может быть использован для
создания функции "визуальной привлекательности" рисованных изображений на основе статистических характеристик
позволяющей ранжировать их или, как минимум, группировать по подобию.

В листинге BC_posts.tsv ряд полей описывают некоторые характеристики, посчитанные с помощью Image Magick :
    magick identify -format """%%f"";%%d;%%@;%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" "file_name" >> "log"
    magick convert "file_name" -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> "log"
    magick convert "file_name" -edge 3 -format "%%[fx:mean]\n" info: >> "log"
которые заняли место в полях :
BOUNDBOX - фрейм с содержательной частью картинки за вычетом однородный полей
TENTR - enthropy, мера "сложности" картинки, обширный однородный фон снижает энтропию, артефакты сканирования - повышают
TSKEW - skewness, мера "яркости", значительные "-" знаменуют приоритет светлых/белых тонов, "+" победила тьма
TSTDDEV - standard deviation, мера контрастности картинки в целом
TCOLORS - количество разных цветов, бОльшее число характеризует широкую цветовую гамму
MEANG - mean grey, мера насыщенности цветов для картинки в целом
EDGE - canny edge detector, мера количества линий разграничения между объектами, в отличии от энтропии отражает "макро" сложность
Значения этих характеристик (кроме BOUNDBOX) образуют многомерное "облако", позиция в котором некоторым образом коррелирует
с визуально-эстетическими свойствами изображения (да и других характеристик существует обширное множество).

Что полезного можно почерпнуть из этого ? Я попытался.
Сразу же стало понятно, что в многомерном "облаке" стат характеристик арта нет обособленных областей (кластеров) 
и сколько нибудь заметных внутренних водоразделов. Внешний вид картинки определяло нахождение в какой то части облака,
которое становилось значимым только при приближении к его краю (экстремальным значениям) одновременно по нескольким параметрам.
А многомерное облако требовалось превратить в какой то одномерный список.
Интересным инструментом анализа оказались XY диаграммы Excel (как например в BCI_V00_diagrams.xls для пары топовых томов
и BCI_Vnn_diagrams.xls для томов в конце обоих рейтингов), бесконечная возня с которыми и привела к "весовой функции".

Мне удалось соотнести визуальную характеристику "яркая, контрастная, насыщенная картинка" (это не значит, что она привлекательна
по смыслу, но это хоть как то отражает ее стилистику и качество) с одновременно высокими значениями tcolors, tentr, tstddev и meang.
Никакия единая зависимость функция не описывала достаточно хорошо весь возможный диапазон комбинаций значений,
поэтому я решил использовать "основную весовую функцию" MAIN rating 
(tentr-0.3)*(log(10,tcolors)-3)*(tstddev-0.1) DESC
и "обратную весовую функцию" REVERSE rating
(tentr+0.3)*(meang+0.1)*(tstddev+0.1) ASC
проведя "водораздел" между ними условием (отбирающим в среднем 2:1 количества картинок в пользу главного рейтинга)
(tcolors>50000 and tentr>0.5 and tstddev>0.15 and meang>0.1)
Ранжирование выполнялось в пределах тома (~40.000-120.000 картинок) и позволило создавать до сотни папок/архивов Mxx/Rxx
для главного и обратного рейтинга соответственно.
Оказалось, что нижние части рейтингов визуально не подобны между собой - и так даже интереснее.

Полная версия запроса генерации главного рейтинга
select b.booru, b.fid, ipath, b.sourcefile,
       tentr, rank() over (partition by ipath order by tentr desc) r_entr,
       tskew, 
       tstddev, rank() over (partition by ipath order by tstddev desc) r_sdev,
       tcolors, rank() over (partition by ipath order by tcolors desc) r_color, round(log(10,tcolors)-3,4) lc, 
       meang, rank() over (partition by ipath order by meang desc) r_meang,
       edge, rank() over (partition by ipath order by edge desc) r_edge,
       rank() over (partition by ipath order by (tentr-0.3)*(log(10,tcolors)-3)*(tstddev-0.1) desc) r_ALL
from bct_im d join bct_exif b on b.booru=d.booru and b.fid=d.fid
where (tcolors>50000 and tentr>0.5 /* >0.6 for 2018-7x10 >> <100 vols */ and tstddev>0.15 and meang>0.1)
и обратного
select b.booru, b.fid, ipath, b.sourcefile,
       tentr, rank() over (partition by ipath order by tentr) d_entr,
       tskew, 
       tstddev, rank() over (partition by ipath order by tstddev) d_sdev,
       tcolors, rank() over (partition by ipath order by tcolors ) d_color, round(ln(tcolors+16),3) lc,
       meang, rank() over (partition by ipath order by meang) d_meang,
       edge, rank() over (partition by ipath order by edge) d_edge,
       rank() over (partition by ipath order by (tentr+0.3)*(meang+0.1)*(tstddev+0.1)) d_ALL
from bct_im d join bct_exif b on b.booru=d.booru and b.fid=d.fid
where not (tcolors>50000 and tentr>0.5 /*>0.6@2018-7x10*/ and tstddev>0.15 and meang>0.1)
Их результаты затем использовались для раскидывания (move) картинок по папкам.
