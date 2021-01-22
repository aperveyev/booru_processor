create table ESS_LD
(
  id    NUMBER,
  fname VARCHAR2(32),
  fdt   DATE,
  isize VARCHAR2(12),
  favn  NUMBER,          -- favorites count
  tags  VARCHAR2(8000),  -- general tags
  tagc  VARCHAR2(6000),  -- copyright tags
  tagp  VARCHAR2(6000),  -- character tags
  taga  VARCHAR2(6000),  -- artist tags
  eol   VARCHAR2(3)
) ;
create unique index ESS_LD_UI on ESS_LD (ID) ;

create table ESS_DT_LD
(
  id      NUMBER,
  tag     VARCHAR2(160),
  n       NUMBER,
  tag_cat NUMBER  -- 3=copyright 4=character 1=artist
) ;
create unique index ESS_DT_LD_UI on ESS_DT_LD (TAG, ID, TAG_CAT) ;

-- after-loader patch, in some rare cases fields were misplaced
update ess_ld set taga=substr(tags,7), tags=null where taga is null and tags like 'ARTIS:%' ;
update ess_ld set tagp=substr(tags,7), tags=null where tagp is null and tags like 'CHARS:%' ;
update ess_ld set tagc=substr(tags,8), tags=null where tagc is null and tags like 'COPYRS:%' ;
update ess_ld set tags=null where tags='EOL' ;
commit ;

-- example how to parse delimited tags from single field into set of rows
insert into ESS_DT_LD
select id, tag, x, 3 /* tag_cat for copyrights field TAGC */ from (
select l.id, tagc,
       substr(replace(regexp_substr(replace(tagc,'" "','"$"'),'[^$]+', 1, x),'"',''),1,150) tag, x
from ess_ld l, lateral (
  select level x from dual 
  connect by regexp_substr(replace(tagc,'" "','"$"'), '[^$]+', 1, level) is not null
) where l.id between 1046000 and 1047000 /* subset for example */
) where tagc is not null order by 1 desc


-- the most tricky part - how to generate file names from tags
with t as (
select id, translate(tag,' /:\''&%*"?`=+!','___') tag, -- some symbols prohibited for file name 
       tag itag, tag_cat, rank() over (partition by id, tag_cat order by tag) r
from ess_dt_ld
where tag_cat in (1,3,4) 
order by id desc, tag_cat
) 
select d.fid id,
       'move "'||d.fline||'" "'|| 
                 substr(d.fpath,1,15)||'\e-shuushuu.net - '||d.fid||' - '
             ||nvl2(tc,tc,'misc')||' ~ '||nvl(substr(tp,1,greatest(140-nvl(length(tc),0)-nvl(length(ta),0),5)),'unknown')
             ||' ('||nvl(ta,'anonymous')||').'||decode(d.fext,'jpeg','jpg',d.fext)||'"' r_fname
from ( select fnum1 fid, fline, fpath, fext from dir_bs_ext_v ) d -- external table over "dir /b /s" on current file location
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) tc from t where tag_cat=3 and r in (1,2,3) group by id ) c on c.id=d.fid
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) tp from t where tag_cat=4 and r in (1,2,3,4,5) group by id ) p on p.id=d.fid
left join ( select id, listagg(tag,'+') WITHIN GROUP (ORDER BY tag) ta from t where tag_cat=1 and r in (1,2) group by id ) a on a.id=d.fid
where 1=1
order by 1 
