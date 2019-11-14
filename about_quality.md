### Пояснения по "критериям качества" изображений, включаемых в наборы данных

Практика показывает, что в общей массе рисованных / CG изображений очень существенную часть составляют, 
скажем так, не самые выдающиеся - как по эстетическим, так и по техническим канонам.. 
Я с большим уважением отношуть к создателям арта (сам то рисовать толком не умею), но вынужден ограничить
поставленную перед собой задачу некими "достижимыми" рамками, изначально выполняя "техническую" фильтрацию
раздобытых изображений, а затем и их визуальный контроль и отсев. 

Идея состоит в том, чтобы отобранные "оригиналы" изображений были сами по себе приятны глазу и достаточно 
качественны для разнообразного применения (обои, печать, композиции, ...). 
А затем уже они превращаются в "иконки" и (вместе с сопутствующими тегами) служат материалом для всяческого анализа.
Правила отбора со временем несколько эволюционируют и ретроспективно не действуют, но это не столь существенно.

**"Технические" прообразования и фильтрация состоят в следующем:**
- конверсия PNG/GIF -> JPG (качество 94% без субдискретизации цвета), другие форматы не расматриваются
- отбор по размерам width>=900 height>=900 MPixels>=1.2 filesize>=80000 bytes (уже в JPG). 
  Очень изредка практикую "наращивание" монохромного фона для достижения требуемого минимального размера
- структурирование по соотношению сторон: 1x1@20%, 3x4@8%, 3x2@40%, 2x3@40% очень хорошо разделяет сценически 
  разнородные картинки - хотя границы довольно условны. Непропорциональные картинки я изредка наращиваю, обрезаю
  или разрезаю, чтобы попасть в требуемые диапазоны пропорций. Также ручная постооработка иногда приводит к переходу
  картинки из одной пропорции в другую.
- уменьшение до 9000 по длинной стороне и/или 60 MPix экстремально больших картинок (на них спотыкаются / падают 
  программы просмотра и преобразований, зачем усложнять жизнь)

Изначально не рассматриваются хентай (rating:explicit) и источники, где его нельзя автоматически избежать.
Изначально, где это возможно, фильтруются комиксы (-comic).

**"Вмзуальный" контроль приводит к отсеву или преобразованиям:**
- удаляются косплей и другие реальные фото, даже очень интересные (они не являются темой датасета)
- удаляются натюрморты и пейзажи без персонажей (опять же, они могут быть прекрасны - но не в этом датасете)
- удаляются не отсеявшиеся по тегу комиксы, мозаичные изображения и примитивные скетчи, черно-белость сама по себе не грех
- удаляются сильно затекстованные страницы и обложки артбуков, когда текст (субъективно) сильно затеняет персонажей
- удаляются нецензурированная грудь и прочая откровенная и/или вульгарная эротика (субъективно, да) 
  то что остается имеет рейтинг примерно 12+
- во многих (хотя и не во всех) случаях выполняется обрезка полей и сегментация на несколько файлов составных картинок
- в очевидно напрашивающихся случаях применяется гамма-коррекция, увеличение контраста и другие нетривиальные фильтры
- увеличение размера не практикуется, наращивание фона - только для удовлетворения минимальных размеров или диапазонов пропорций

Также осуществляется весьма основательная дедубликация изображений - остаются изображения лучшего качества 
(технического и/или визуального). Из серий подобных изображений выбираются некоторые "самые разные".
Вариаций с мимикой, немного разными элементами одежды, отличиями фона масса - всем не угодить, уж как есть.
Предпочтение отдается картинкам с минимумом текста, открытыми глазами и ... субъективно более интересным, короче.