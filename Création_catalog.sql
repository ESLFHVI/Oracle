## creation d'un catalog rman

##sur chaque base

sqh
create tablespace RMAN_TBS
datafile '/oracle/ORA_RMAN/rmantbs/ora_rman_rmantbs01.dbf' size 100M
extent management local
uniform size 128k
segment space management auto;


-- creation du schema proprietaire du catalogue
CREATE USER rman IDENTIFIED BY rman
TEMPORARY TABLESPACE temp
DEFAULT TABLESPACE RMAN_TBS
QUOTA UNLIMITED ON RMAN_TBS;
-- privileges pour maintenir et requeter le recovery Catalog
GRANT RECOVERY_CATALOG_OWNER TO rman;
GRANT CONNECT, RESOURCE TO rman;

-- suite à install, regeneration des stats


rman catalog rman/rman
create catalog;

connect target /;
register database;



# pb avec catalog
rman target / catalog=rman/rman@rman
resync catalog;



 connect catalog *
 run
 {
 delete noprompt expired archivelog all;
 delete noprompt expired backup;
 backup incremental level 0 database;
 backup current controlfile;
 }

