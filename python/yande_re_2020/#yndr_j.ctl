LOAD DATA
APPEND
INTO TABLE yndr_load
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
(
id,
j char(12000)
)