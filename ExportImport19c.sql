philippe.vuagniaux@fhvi.ch : nHf7FyCDEd59EXS

##ne fonctionne pas erreur avec loop synonyms...
##expdp dumpfile=hojg11.dmp flashback_time=systimestamp  FULL=y exclude=schema:\"IN \(\'SYS\',\'SYSTEM\'\)\" logfile=hojg11.log reuse_dumpfiles=yes EXCLUDE=STATISTICS VERSION=12 TRANSPORTABLE=ALWAYS

expdp dumpfile=hojg11.dmp flashback_time=systimestamp  FULL=y exclude=schema:\"IN \(\'SYS\',\'SYSTEM\'\)\" logfile=hojg11.log reuse_dumpfiles=yes EXCLUDE=STATISTICS VERSION=12

ALTER TABLESPACE ROLLBACK_BLOBDATA READ ONLY;
ALTER TABLESPACE USERS READ ONLY;
ALTER TABLESPACE USER_ACCOUNT READ ONLY;
ALTER TABLESPACE USER_INDEX READ ONLY;
ALTER TABLESPACE USER_DATA READ ONLY;
ALTER TABLESPACE USER_BLOB READ ONLY;


scp des fichiers 

ALTER TABLESPACE ROLLBACK_BLOBDATA READ WRITE;
ALTER TABLESPACE USERS READ WRITE;
ALTER TABLESPACE USER_ACCOUNT READ WRITE;
ALTER TABLESPACE USER_INDEX READ WRITE;
ALTER TABLESPACE USER_DATA READ WRITE;
ALTER TABLESPACE USER_BLOB READ WRITE;

EHN:

sur sfhvora10 nettoyer les archivelogs:
rman target /
crosscheck archivelog all;
delete noprompt expired archivelog all;


run {
allocate channel ch1 type disk;
backup incremental level 0 database format '${BE_ORA_ADMIN_SID}/backup/inc0_%d_${DATE}_s%s_p%p';
backup current controlfile for standby format '${BE_ORA_ADMIN_SID}/backup/stby_ctl_%d_${DATE}_s%s_p%p';
sql "alter system archive log current";
backup archivelog all format '${BE_ORA_ADMIN_SID}/backup/arc_%d_${DATE}_s%s_p%p';
release channel ch1;
}
exit;


Set de l'environnement: backup de toute la base
rman target /
run {
backup database;
backup current controlfile;
backup archivelog all;
}



expdp dumpfile=ehng11.dmp FULL=y exclude=schema:\"IN \(\'SYS\',\'SYSTEM\'\)\" logfile=ehng11.log EXCLUDE=STATISTICS VERSION=12
create or replace directory expdp11g as '/db_backup/FRA/EHN/';
impdp system@ehnq_pdb directory=expdp11g  dumpfile=ehng11.dmp logfile=DATA_PUMP_DIR:ehng11_imp.log EXCLUDE=statistics


rman
connect target *
run {
restore controlfile to '/u01/prod//redo/EHN/controlfile/EHN_control.dbf' from '/db_backup/FRA/EHN/autobackup/2022_02_14/o1_mf_s_1096639993_k0nocbdf_.bkp';
}


rman connect target *

run {
catalog start with '/db_backup/FRA/EHN/archivelog' noprompt;
catalog start with '/db_backup/FRA/EHN/backupset' noprompt;
catalog start with '/db_backup/FRA/EHN/onlinelog' noprompt;
set newname for database to '/u01/prod/oradata/EHN/%b';
restore database;
switch datafile all;
switch tempfile all;
recover database;
}

si message erreur:
RMAN-06023: no backup or copy of datafile 12 found to restore
RMAN-06023: no backup or copy of datafile 11 found to restore
RMAN-06023: no backup or copy of datafile 10 found to restore

Il faut dans le step1.sh comment les deux lignes suivantes :
#echo *.db_recovery_file_dest=\'$DEST_PATH'FRA'\' 
#echo *.db_recovery_file_dest_size=90000m


