LOAD DATA
APPEND
INTO TABLE tbib_dt
FIELDS TERMINATED BY '\t'
(
  id,
  tag_cat "decode(:tag_cat,'[''tag-type-artist'', ''tag'']',1,'[''tag-type-copyright'', ''tag'']',3,'[''tag-type-character'', ''tag'']',4,0)",
  tag
)
