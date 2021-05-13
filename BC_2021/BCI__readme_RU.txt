������ ����������� summary ������������ anime/CG/game ����, BOORU CHARS dataset ����� ���� ����������� ���
�������� ������� "���������� �����������������" ���������� ����������� �� ������ �������������� �������������
����������� ����������� �� ���, ��� �������, ������������ �� �������.

� �������� BC_posts.tsv ��� ����� ��������� ��������� ��������������, ����������� � ������� Image Magick :
    magick identify -format """%%f"";%%d;%%@;%%[entropy];%%[skewness];%%[fx:mean];%%[fx:standard_deviation];%%k;" "file_name" >> "log"
    magick convert "file_name" -colorspace HCL -format "%%[fx:mean.g];%%[fx:maxima.g];" info: >> "log"
    magick convert "file_name" -edge 3 -format "%%[fx:mean]\n" info: >> "log"
������� ������ ����� � ����� :
BOUNDBOX - ����� � �������������� ������ �������� �� ������� ���������� �����
TENTR - enthropy, ���� "���������" ��������, �������� ���������� ��� ������� ��������, ��������� ������������ - ��������
TSKEW - skewness, ���� "�������", ������������ "-" ��������� ��������� �������/����� �����, "+" �������� ����
TSTDDEV - standard deviation, ���� ������������� �������� � �����
TCOLORS - ���������� ������ ������, ������� ����� ������������� ������� �������� �����
MEANG - mean grey, ���� ������������ ������ ��� �������� � �����
EDGE - canny edge detector, ���� ���������� ����� ������������� ����� ���������, � ������� �� �������� �������� "�����" ���������
�������� ���� ������������� (����� BOUNDBOX) �������� ����������� "������", ������� � ������� ��������� ������� �����������
� ���������-������������� ���������� ����������� (�� � ������ ������������� ���������� �������� ���������).

��� ��������� ����� ���������� �� ����� ? � ���������.
����� �� ����� �������, ��� � ����������� "������" ���� ������������� ���� ��� ������������ �������� (���������) 
� ������� ������ �������� ���������� ������������. ������� ��� �������� ���������� ���������� � ����� �� ����� ������,
������� ����������� �������� ������ ��� ����������� � ��� ���� (������������� ���������) ������������ �� ���������� ����������.
� ����������� ������ ����������� ���������� � ����� �� ���������� ������.
���������� ������������ ������� ��������� XY ��������� Excel (��� �������� � BCI_V00_diagrams.xls ��� ���� ������� �����
� BCI_Vnn_diagrams.xls ��� ����� � ����� ����� ���������), ����������� ����� � �������� � ������� � "������� �������".

��� ������� ��������� ���������� �������������� "�����, �����������, ���������� ��������" (��� �� ������, ��� ��� ��������������
�� ������, �� ��� ���� ��� �� �������� �� ���������� � ��������) � ������������ �������� ���������� tcolors, tentr, tstddev � meang.
������� ������ ����������� ������� �� ��������� ���������� ������ ���� ��������� �������� ���������� ��������,
������� � ����� ������������ "�������� ������� �������" MAIN rating 
(tentr-0.3)*(log(10,tcolors)-3)*(tstddev-0.1) DESC
� "�������� ������� �������" REVERSE rating
(tentr+0.3)*(meang+0.1)*(tstddev+0.1) ASC
������� "����������" ����� ���� �������� (���������� � ������� 2:1 ���������� �������� � ������ �������� ��������)
(tcolors>50000 and tentr>0.5 and tstddev>0.15 and meang>0.1)
������������ ����������� � �������� ���� (~40.000-120.000 ��������) � ��������� ��������� �� ����� �����/������� Mxx/Rxx
��� �������� � ��������� �������� ��������������.
���������, ��� ������ ����� ��������� ��������� �� ������� ����� ����� - � ��� ���� ����������.

������ ������ ������� ��������� �������� ��������
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
� ���������
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
�� ���������� ����� �������������� ��� ������������ (move) �������� �� ������.
