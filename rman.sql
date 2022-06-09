startup nomount pfile='?/dbs/initHRCQ.ora'
run {
restore controlfile to '/u01/qas/redo/HRC/controlfile/HRC_control.dbf' from 'l/2021_09_29/o1_mf_s_1084542299_jo8nfvlr_.bkp';}

run {
restore controlfile to '/u01/qas//redo/PSPE/controlfile/PSPE_control.dbf' from/db_backup/FRA/PSPE/autobackup/o1_mf_s_1085027956_jontbnv8_.bkp//db_backup/FRA/PSPE/autobackup/o1_mf_s_1085038552_joo4or84_.bkp';}

 run {
 catalog start with '/db_backup/FRA/PSPE/archivelog' noprompt;
 catalog start with '/db_backup/FRA/PSPE/backupset' noprompt;
 catalog start with '/db_backup/FRA/PSPE/onlinelog' noprompt;
 set newname for database to '/u01/qas/oradata/PSPE/%b';
 restore database;
 switch datafile all;
 switch tempfile all;
 recover database;
}
alter database mount



HDC

 run {
catalog start with '/db_backup/FRA/HDC/archivelog' noprompt;
catalog start with '/db_backup/FRA/HDC/backupset' noprompt;
catalog start with '/db_backup/FRA/HDC/onlinelog' noprompt;
set newname for database to '/u01/qas/oradata/HDC/%b';
restore database;
switch datafile all;
switch tempfile all;
recover database;


run {
 catalog start with '/db_backup/FRA/HRC/archivelog' noprompt;
 catalog start with '/db_backup/FRA/HRC/backupset' noprompt;
 catalog start with '/db_backup/FRA/HRC/onlinelog' noprompt;
 set newname for database to '/u01/qas/oradata/HRCQ/%b';
 restore database;
 switch datafile all;
 switch tempfile all;
 recover database;
}
alter database mount


update backup directory:
create or replace directory data_pump_dir as '/db_backup/FRA/PSPE


##CONFIG RMAN
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 30 DAYS;
CONFIGURE BACKUP OPTIMIZATION OFF; # default
CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default
CONFIGURE MAXSETSIZE TO UNLIMITED; # default
CONFIGURE ENCRYPTION FOR DATABASE OFF; # default
CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default
CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default
CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/u1/app/oracle/product/11.2.0/dbhome_prd/dbs/snapcf_PSPE.f'; # default
