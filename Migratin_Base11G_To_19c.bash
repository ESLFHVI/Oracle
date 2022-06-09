--Migration base
ALTER PLUGGABLE DATABASE pdb2 CLOSE;
DROP PLUGGABLE DATABASE pdb2 INCLUDING DATAFILES;


create pluggable database ADSQ_PDB admin user PDBDBA identified by Oracle19;
alter session set container=ADSQ_PDB;
startup
alter pluggable database save state;

-- Create des tablespace
Create tablespace USER_DATA;
Create tablespace USER_INDEX;
Create tablespace USER_BLOB;
Create tablespace USER_ACCOUNT;
CREATE TEMPORARY TABLESPACE "TEMPORARY_DATA";
CREATE TEMPORARY TABLESPACE temp_guido;
Create tablespace ROLLBACK_BLOBDATA;
Create tablespace USERS;
Create tablespace UNDOTBS;


-- Export de tous les schémas sauf system, etccc
expdp dumpfile=adsg11.dmp flashback_time=systimestamp  FULL=y exclude=schema:\"IN \(\'SYS\',\'SYSTEM\'\)\" logfile=adsg11.log reuse_dumpfiles=yes version=12 EXCLUDE=STATISTICS


--dans la PDB:
ALTER SYSTEM SET STREAMS_POOL_SIZE=100M SCOPE=both; pour accélérer Datapump
create or replace directory expdp11g as '/db_backup/FRA/HOJG/';

-- Import de la base:
impdp system@ADSQQ_pdb directory=expdp11g dumpfile=adsg11.dmp logfile=DATA_PUMP_DIR:adsg11_imp.log  FULL=YES remap_tablespace=temp_guido:temp

--trouver les objets invalides
COLUMN object_name FORMAT A30
SELECT owner,
       object_type,
       object_name,
       status
FROM   dba_objects
WHERE  status = 'INVALID'
ORDER BY owner, object_type, object_name;

OU
show errors


-- corriger les objets invalides
-- Schema level.
EXEC UTL_RECOMP.recomp_serial('ECBERN');
EXEC UTL_RECOMP.recomp_parallel(4, 'ECBERN');

--Passer le script :ALTER_SESSION_POLYPOINT.sql




