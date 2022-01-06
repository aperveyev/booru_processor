-- BOORU CHARS 2015 PL/SQL code snippets
-- in all scripts below BCO is "posts" table


create or replace function ioua ( x1 number, y1 number, w1 number, h1 number,
                                  x2 number, y2 number, w2 number, h2 number, 
                                  inn number default null ) return number as
-- INTERSECTION AREA DETECTION for BOX-style (relative size) boundboxes (x,y,w,h)
-- determine the (noncentered) coordinates of the intersection rectangle
    xa number:=greatest(x1,x2);
    ya number:=greatest(y1,y2);
    xb number:=least(x1+w1,x2+w2);
    yb number:=least(y1+h1,y2+h2);
    iarea number;
begin
-- compute the area of intersection rectangle  
    iarea:=abs(greatest(xB-xA,0)*greatest(yB-yA,0));
    if    iarea=0 then return 0;
-- intersection area related to BOX1    
    elsif inn=1   then return round(iarea/(w1*h1),4);
-- intersection area related to BOX2
    elsif inn=2   then return round(iarea/(w2*h2),4);
-- intersection area ABSOLUTE VALUE    
    elsif inn=9   then return round(iarea,6);
-- intersection area CLASSIC DEFINITION - default
    else               return round(iarea/(w1*h1+w2*h2-iarea),4); 
    end if;
end ioua ;
/


-- ranking and merging is trivial within Oracle
-- next statement of rank-merge devoted to stat characteristics
merge into bco o using (
select rank() over (order by
       round( ( substr(boundbox,1,instr(boundbox,'x')-1) * substr(boundbox,instr(boundbox,'x')+1,instr(boundbox,'+')-instr(boundbox,'x')-1) ) /
              ( substr(s_isize,1,instr(s_isize,'x')-1) * substr(s_isize,instr(s_isize,'x')+1) )       
              ,2) ) bb_r,
       rank() over (order by tentr) ent_r,
       rank() over (order by abs(tskew) desc) skew_r,
       rank() over (order by tstddev) sdev_r,
       rank() over (order by tcolors) colr_r,
       rank() over (order by meang) grey_r,
       rank() over (order by maximag) gmax_r,       
       rank() over (order by edge) edge_r,
       rank() over (order by emean) emean_r,
       rank() over (order by emeanbl) ebl_r,
       rank() over (order by txsize desc nulls last) txs_r,
       rank() over (order by txcnt desc nulls last) txn_r,       
       rank() over (order by k1280+k640+k320 desc nulls last) txe_r,       
       booru, fid
from bco a
) n on (o.booru=n.booru and o.fid=n.fid)
when matched then update set
  o.bb_r=n.bb_r, o.ent_r=n.ent_r, o.skew_r=n.skew_r, o.sdev_r=n.sdev_r, o.colr_r=n.colr_r,
  o.grey_r=n.grey_r, o.gmax_r=n.gmax_r, o.edge_r=n.edge_r, o.emean_r=n.emean_r, o.ebl_r=n.ebl_r,
  o.txs_r=n.txs_r, o.txn_r=n.txn_r, o.txe_r=n.txe_r
/


-- merge YOLO faces count and sizes
merge into bco o using ( select booru, fid, round(avg(w*h),4) avgs, round(max(w*h),4) maxs, count(*) yface, sum(nvl2(odn,1,0)) yfacej
              from YOLOBO t where obj=0 and suppr is null group by booru, fid ) n on(o.booru=n.booru and o.fid=n.fid)
when matched then update set o.yface=n.yface, o.yfacej=n.yfacej, o.yfmax=n.maxs, o.yfavg=n.avgs
/
-- calculate and merge YOLO-faces rank
merge into bco o using (
select booru, fid,
       rank() over (order by 
-- mystic rank criteria deal with head count (pair is ideal, too many is bad), unjoined head count (even worse) 
-- and average head size (too big and too small penaltied)
          nvl(abs(yface-2),3)+3*nvl(yface-yfacej,3)+16*abs(-1.2-log(10,nvl(yfavg,0.1))) desc) r
from bco 
) n on (o.booru=n.booru and o.fid=n.fid)
when matched then update set o.yf_r=n.r
/


-- define almost-non-intersected and dencely filled areas
-- I can't avoid temporary table because of complex "with" subquery
-- also temporary table is very helpful to control intermediate results
create private temporary table ORA$PTT_aa as
with s as (
select i.booru, i.fid, i.nn, i.bbox, i.cx, i.cy, i.sz, i.colr,
       substr(bbox,1,instr(bbox,'x')-1) w, substr(bbox,instr(bbox,'x')+1,instr(bbox,'+')-instr(bbox,'x')-1) h,
       substr(bbox,instr(bbox,'+')+1,instr(bbox,'+',1,2)-instr(bbox,'+')-1) x, substr(bbox,instr(bbox,'+',1,2)+1) y,
       round( ( substr(bbox,1,instr(bbox,'x')-1) * substr(bbox,instr(bbox,'x')+1,instr(bbox,'+')-instr(bbox,'x')-1) ) /
              ( substr(s_isize,1,instr(s_isize,'x')-1) * substr(s_isize,instr(s_isize,'x')+1) )       
              ,2) prob, -- bbox against full image
       round(i.sz/( substr(bbox,1,instr(bbox,'x')-1) * substr(bbox,instr(bbox,'x')+1,instr(bbox,'+')-instr(bbox,'x')-1) ),2) oprob -- fill against bbox
from bc_is i
join bco b on i.booru=b.booru and i.fid=b.fid 
)
select a.*, ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h) ioua, ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h,1) ioua1, ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h,2) ioua2,
       b.nn b_nn, b.bbox b_bbox, b.prob b_prob, b.oprob b_oprob, acnt, aprob, aoprob
from s a
join s b on a.booru=b.booru and a.fid=b.fid and a.nn>b.nn and b.prob<0.9 and b.oprob>0.8 and b.colr='B'
-- ALL (black) objects count (vs dence-non-intersepting oblects)
join (select booru, fid, count(*) acnt, avg(prob) aprob, avg(oprob) aoprob 
        from s where prob<0.9 and colr='B' group by booru, fid) i on a.booru=i.booru and a.fid=i.fid
where a.prob<0.9 and a.oprob>0.8 and a.colr='B'
  and ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h)<0.1
  and greatest(ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h,1),ioua(a.x,a.y,a.w,a.h,b.x,b.y,b.w,b.h,2))<0.2
-- order by (a.prob+b.prob) fetch first 100 rows only  
/
-- place results into main table
merge into bco o using (
select booru, fid, 
       decode(count(*),1,2,3,3,6,4,10,5,15,6,count(*)) isovr, round(avg(prob+b_prob)/2,4) isoarea,
       avg(acnt) isall, round(avg(aprob),4) isavg
from ORA$PTT_aa group by booru, fid 
) n on(o.booru=n.booru and o.fid=n.fid)
when matched then update set o.isovr=n.isovr, o.isoarea=n.isoarea, o.isall=n.isall, o.isavg=n.isavg
where o.isall is null
/


-- next scary-looking and mostly commented code block contains almost all wisdom about
---- ranking images using 3 different methods of outlining and discovering it's results
---- producing windows commands to handle files (copy, move) and folders (create) for visual rank estimation, re-foldering etc
---- and finally place "attractiveness" rank into main table (uncommented code) 

-- select distinct replace('md '||cc||'\'||cc||'-'||lpad(floor(ccrr/1000),2,'0'),'7x1','7x10') dd from (
merge into bco o using ( -- 464878
select booru, fid, replace(cc||'\'||cc||'-'||lpad(floor(ccrr/1000),2,'0'),'7x1','7x10') dd, ccrr
from (
select  -- bb_r, ent_r, skew_r, sdev_r, edge_r, colr_r, grey_r, txs_r, txn_r, txe_r, yf_r,
       substr(ycomp,1,3)||'-'||nvl(least(yface,3),0) cc, 
-- 'move "'||spath||'\'||fname||'" B:\BC\'||substr(lower(spath),14,3)||'\'||substr(lower(spath),9) mvs, -- move samples FULL PATH
-- 'move "'||replace(upper(fpath),'F:','N:')||'\'||fname||'" "B:\BC\'||substr(lower(fpath),8)||'\'||fname||'"' mvf, -- move originals  FULL PATH
 'echo F|xcopy "'||spath||'\'||fname||'" "B:\BC\#'||
                          substr(ycomp,1,3)||'-'||nvl(least(yface,3),0)||'-'||
 lpad(rank() over (partition by substr(ycomp,1,3), nvl(least(yface,3),0)
  order by sqrt(txn_r+txs_r)+sqrt(txe_r)+sqrt(yf_r)+sqrt(colr_r+grey_r) desc),5,'0')||'#'||fname||'"' xcsr,
--                          lpad( rank() over (partition by substr(ycomp,1,3) order by sqrt(skew_r)+sqrt(ent_r)+sqrt(sdev_r)+sqrt((colr_r+grey_r)/2))
--       lpad( rank() over (partition by substr(ycomp,1,3) order by skew_r*skew_r+ent_r*ent_r+sdev_r*sdev_r+greatest(colr_r,grey_r)*greatest(colr_r,grey_r))
--                          lpad(rank() over (order by sqrt(txn_r)+sqrt(txe_r)+sqrt(txs_r)+sqrt(yf_r)),5,'0')||'_'||
--substr(ycomp,1,3)||'-'||nvl(least(yface,3),0)||'#'||lpad(       rank() over (partition by substr(ycomp,1,3) order by 
--                                 sqrt(txn_r)+sqrt(txs_r)+sqrt(txe_r)+sqrt(yf_r)+sqrt((colr_r+grey_r)/2))
--    lpad( rank() over (partition by substr(ycomp,1,3) order by least(txn_r,txs_r)*least(txn_r,txs_r)+txe_r*txe_r+/*txs_r*txs_r+yf_r*yf_r+*/(colr_r+grey_r)*(colr_r+grey_r) ) 
--                       ,5,'0')||'#'||fname||'"' xcsr, -- copy samples to root ENUMERATED
--       percent_rank() over (partition by substr(ycomp,1,3) order by sqrt(skew_r)+sqrt(ent_r)+sqrt(sdev_r)+sqrt((colr_r+grey_r)/2) desc) ccr,
--       percent_rank() over (partition by substr(ycomp,1,3) order by skew_r*skew_r+ent_r*ent_r+sdev_r*sdev_r+greatest(colr_r,grey_r)*greatest(colr_r,grey_r) desc) ccr,
       percent_rank() over (partition by substr(ycomp,1,3), nvl(least(yface,3),0)
        order by sqrt(txn_r+txs_r)+sqrt(txe_r)+sqrt(yf_r)+sqrt(colr_r+grey_r) desc) ccr,
       rank() over (partition by substr(ycomp,1,3), nvl(least(yface,3),0)
        order by sqrt(txn_r+txs_r)+sqrt(txe_r)+sqrt(yf_r)+sqrt(colr_r+grey_r) desc) ccrr,
--                                 sqrt(txn_r)+sqrt(txs_r)+sqrt(txe_r)+sqrt(yf_r)+sqrt((colr_r+grey_r)/2) desc, tentr desc) ccr,                    
--                             least(txn_r,txs_r)*least(txn_r,txs_r)+txe_r*txe_r+/*txs_r*txs_r+yf_r*yf_r+*/(colr_r+grey_r)*(colr_r+grey_r) desc ) ccr,
       booru, fid, fpath, spath, ycomp
-- select count(*) cnt       
from bco where spath is not null
-- where txn_r<3000 or txe_r<3000 or txs_r<3000 or yf_r<3000 -- 11.100
--  order by sqrt(txn_r)+sqrt(txe_r)+sqrt(txs_r)+sqrt(yf_r) -- 30.000
-- where bb_r<300 or ent_r<300 or skew_r<300 or edge_r<300 or colr_r<300 -- 1.238
--  order by sqrt(bb_r)+sqrt(ent_r)+sqrt(skew_r)+sqrt(grey_r)+sqrt(edge_r)+sqrt(colr_r) -- 3000
-- where isovr is not null order by isoarea+isavg
-- fetch first 100 rows only
-- OFFSET 100 ROWS FETCH NEXT 100 ROWS ONLY
) ) n on (o.booru=n.booru and o.fid=n.fid)
when matched then update set o.rpath=n.dd, o.rnk=n.ccrr
/

-- make windows batch to insert key tags into image metadata
-- the same method once used to place tags into file name
with t as (
select booru, id, translate(orig_tag,' /:\''&%*"?`=+#"','___') tag, 
       tag_cat, rank() over (partition by booru, id, tag_cat order by orig_tag) r
from bco_dt
where tag_cat in (1,3,4)
) 
select d.booru, d.fid id,
'exiftool -P -overwrite_original_in_place -EXIF:Copyright="'||nvl(tc,'misc_copyright')||'" -EXIF:Software="'||d.booru||' - '||d.fid||
                                       '" -EXIF:Artist="'||nvl(ta,'anonymous_artist')||'" -EXIF:Make="'||nvl(tc,'misc_copyright')||' ['||nvl(ta,'anonymous_artist')||
                                       ']" -EXIF:Model="'||nvl(tp,'unknown_character')||
                                         '" "D:\BCTO\'||d.rpath||'\'||d.fname||'"' cm
from bco d
left join ( select booru, id, listagg(tag,' +') WITHIN GROUP (ORDER BY tag) tc from t where tag_cat=3 and r in (1,2,3) group by booru, id ) c on d.booru=c.booru and c.id=d.fid
left join ( select booru, id, listagg(tag,' +') WITHIN GROUP (ORDER BY tag) tp from t where tag_cat=4 and r in (1,2,3,4,5) group by booru, id ) p on d.booru=p.booru and p.id=d.fid
left join ( select booru, id, listagg(tag,' +') WITHIN GROUP (ORDER BY tag) ta from t where tag_cat=1 and r in (1,2) group by booru, id ) a on d.booru=a.booru and a.id=d.fid
-- directory by directory
where d.rpath like '3x2-0%' 
and d.booru in ('safebooru.org','e-shuushuu.net','chan.sankakucomplex.com','danbooru.donmai.us','anime-pictures.net','konachan.com','yande.re','www.zerochan.net')
order by d.rpath, d.fname
/

-- as a final note:
-- Oracle is extremely effective handling 0.5M records for images and 5-15M supplementary records on typical desktop
-- no action (even millions of IOU function calls within complex query) took more then several 10s of seconds
-- no tricks but effective indexes, multiply hash-joins of 2-20M records tables also went easy
-- but nobody will use Oracle for pet projects, I'm alone with it

