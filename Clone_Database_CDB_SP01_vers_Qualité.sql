#cloner ADS_PDB vers ADSQ_PDB
# il faudra passer la CDB en archivelog:
#	shutdown immediate
#	startup mount
#	alter database archivelog
#	alter database open

# sur la nouvelle CDB, il faudra créer un remote user:
CREATE USER c##remote_clone_user IDENTIFIED BY remote_clone_user CONTAINER=ALL;
GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO c##remote_clone_user CONTAINER=ALL;

dbca -silent \
  -createPluggableDatabase \
    -pdbName ADSQ_PDB \
    -sourceDB CDB_SQ01 \
  -createFromRemotePDB \
    -remotePDBName ADS_PDB \
    -remoteDBConnString sfhvora10:1541/ADS_PDB\
    -remoteDBSYSDBAUserName sys \
    -remoteDBSYSDBAUserPassword Oracle19 \
    -dbLinkUsername c##remote_clone_user \
    -dbLinkUserPassword remote_clone_user