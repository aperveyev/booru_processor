LOAD DATA
APPEND
INTO TABLE ess_ld
FIELDS TERMINATED BY '\t' TRAILING NULLCOLS
( 
  fname,
  fdt    "to_date(replace(replace(replace(replace(:fdt,'th,',''),'st,',''),'nd,',''),'rd,',''),'MONTH DD YYYY HH:MI PM')",
  isize  "substr(:isize,1,instr(:isize,'(')-2)",
  favn,
  tags   char(8000) "trim(:tags)",
  tagc   char(6000) "trim(case when nvl(:tagc,'X') not like 'COPYRS:%' then to_char(null) else substr(:tagc,8) end)",
  tagp   char(6000) "trim(case when nvl(:tagp,'X') not like 'CHARS:%' then case when nvl(:tagc,'X') not like 'CHARS:%' then to_char(null) else substr(:tagc,7) end else substr(:tagp,7) end)",
  taga   char(6000) "trim(case when nvl(:taga,'X') not like 'ARTIS:%' then case when nvl(:tagp,'X') not like 'ARTIS:%' then case when nvl(:tagc,'X') not like 'ARTIS:%' then to_char(null) else substr(:tagc,7) end else substr(:tagp,7) end else substr(:taga,7) end)",
  eol    char(6000) "case when :tags='EOL' or :tagc='EOL' or :tagp='EOL' or :taga='EOL' or :eol='EOL' then 'EOL' else 'UND' end",
  id     "substr(:fname,12,instr(:fname,'.')-12)"
)
