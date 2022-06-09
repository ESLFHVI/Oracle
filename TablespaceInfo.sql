
-- Afficher les tablespaces
set pagesize 9999
set linesize 9999
SELECT TABLESPACE_NAME, BLOCK_SIZE, STATUS, CONTENTS, EXTENT_MANAGEMENT, ALLOCATION_TYPE, SEGMENT_SPACE_MANAGEMENT FROM DBA_TABLESPACES ORDER BY TABLESPACE_NAME;

-- La même chose mais avec les noms de fichier
set pagesize 9999
set linesize 9999
SELECT TABLESPACE_NAME, FILE_NAME, FILE_ID, BYTES, STATUS, MAXBYTES FROM DBA_DATA_FILES
          UNION
          SELECT TABLESPACE_NAME, FILE_NAME, FILE_ID, BYTES, STATUS, MAXBYTES FROM DBA_TEMP_FILES
          ORDER BY TABLESPACE_NAME, FILE_NAME;
		  
-- Affichier l'espace disque utiliser par tablespace
set pagesize 9999
set linesize 9999
SELECT TABLESPACE_NAME, TABLESPACE_SIZE, USED_SPACE, ROUND(USED_PERCENT, 2) FROM DBA_TABLESPACE_USAGE_METRICS ORDER BY TABLESPACE_NAME;	

	  
-- retailler un tablespace
select dbms_metadata.get_ddl('TABLESPACE', 'USR_DATA') from dual;

alter database datafile '/u2/prod/oradata/PSVJ/userts02.dbf' resize 3G
alter database datafile '/u2/prod/oradata/PSVJ/blobts02.dbf' resize 4G 

alter database datafile 'path_to_your_file\that_file.DBF' autoextend on maxsize unlimited;

set echo off
set termout off
set feedback off
set head on
set pages 10000
set lines 400
set pagesize 5000
set pause off
Spool C:\fichier.txt ou xls ou CSV...
SELECT....etc
/
spool off
exit