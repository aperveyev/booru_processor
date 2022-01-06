LOAD DATA
APPEND
INTO TABLE bc_kc_det
FIELDS TERMINATED BY '\t'
(
FNAME char(300),
t_n,
t_x,
t_y,
t_w,
t_h
)
