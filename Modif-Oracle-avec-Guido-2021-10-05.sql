philippe.vuagniaux@fhvi.ch : nHf7FyCDEd59EXS

oracle19 sur sfhvora11:7XWU8zHrqajG$ECO*!&V
PSVJ:
Database time zone version is 14. It is older than current release time
zone version 32. Time zone upgrade is needed using the DBMS_DST package.

--Pb avec le tablespace temporary_DATA qui est taillé en smallfile au lieu de BIGFILE:
create bigfile temporary tablespace temp_guido tempfile '/u2/prod/oradata/HOJG/temp_guido.dbf' size 100M autoextend on next 10M;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp_guido;
DROP TABLESPACE TEMPORARY_DATA
create bigfile temporary tablespace temp_guido tempfile '/u2/prod/oradata/PSPE/temp_guido.dbf' size 100M autoextend on next 10M;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp_guido;


RIV:
SQLCODE
-- Modif SGA à 5Go.


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

run {
backup archivelog all;
}
 ++ changement timezone --> mail Guido
 https://dba010.com/2020/08/21/upgrade-the-database-time-zone-file-using-the-dbms_dst-package-in-19c/
 
 
 Modifier le pga limit --> script Guido --> dans le script rest_step1.sh
 
 -- PB sur le CDB avec des bases en version Enterprise, le CDB est en standard, du coup ces bases ne peuvent pas migrer car les options n''existent pas.
 ce sont des options payantes.
 
 Drop des packages en trop sur la Qual pour test:
 $ORACLE_HOME/rdbms/admin/catnoqm.sql
 $ORACLE_HOME/rdbms/admin/catproc.sql
 $ORACLE_HOME/rdbms/admin/catnojava.sql
 $ORACLE_HOME/rdbms/admin/rmxml.sql
 $ORACLE_HOME/rdbms/admin/utlrp.sql
 delete from registry$ where status='99' and cid in ('XML','JAVAVM','CATJAVA');
 commit;
  

@/u01/oracle/db19s/rdbms/admin/catnoqm.sql
@/u01/oracle/db19s/rdbms/admin/catproc.sql
@/u01/oracle/db19s/rdbms/admin/catnojava.sql
@/u01/oracle/db19s/rdbms/admin/rmxml.sql
sqh



en ligne de commande:
$ORACLE_HOME/perl/bin/perl $ORACLE_HOME/rdbms/admin/catcon.pl -n 1 -c 'HRCMIG' -b rmjvm -d /u01/oracle/db19s/rdbms/admin rmjvm.sql



select name,cause,type,message,status from PDB_PLUG_IN_VIOLATIONs order by name;
VOIR LES OPTIONS DE LA BASE
select COMP_NAME, STATUS, STARTUP from DBA_REGISTRY order by 1;

  
 voir les mails de Guido pour supprimer les packages dans l'ordre.
 Attention: les scripts Olap ont disparu, il faut les exécuter depuis la version 19c/
 
 -- VOIR LES PACKAGES INVALIDES
col comp_name format a25
col version format a25
col status format a15
select comp_name, version, status
from dba_registry
where status='INVALID';


col comp_name format a25
col version format a25
col status format a15
select comp_name, version, status
from dba_registry
where comp_name='Spatial';


 -- List invalids
select owner, object_name, object_type
from dba_objects
where status='INVALID'
and owner='MDSYS';



@?/rdbms/admin/catcmprm.sql ORDIM; -- ORACLE MULTI MEDIA

13 OCTOBRE 2021

SUPPRESSION DES OPTIONS :
@?/rdbms/admin/catcmprm.sql ORDIM
@?/rdbms/admin/utlrp.sql

JAVAVM
@?/rdbms/admin/catnojav.sql
@?/xdk/admin/rmxml.sql
@?/javavm/install/rmjvm.sql
@?/rdbms/admin/utlrp.sql
delete from registry$ where status='99' and cid in ('XML','JAVAVM','CATJAVA');
commit;

CONTEXT:
@?/ctx/admin/catnoctx.sql
drop procedure sys.validate_context;

drop package XDB.dbms_xdbt;
drop procedure xdb.xdb_datastore_proc;
start ?/rdbms/admin/utlrp.sql



