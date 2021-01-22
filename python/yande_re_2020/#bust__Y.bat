echo [file];[level];[x];[y];[w];[h] > #bust__ys.csv

for /R B:\#YNDS\18xxxx %%J in (*.JPG) do python #bust_looY.py "%%J" "B:\#YNDSB\18xxxx\%%~nJ_bust" >> #bust__ys.csv
