 # Loop through each host name . . .
for host in `cat ~oracle/.rhosts|cut -d"." -f1|awk '{print $1}'|sort -u`
do
  echo " "
  echo "****************SCOPE=BOTH SID='*'
********"
  echo "$host"
  echo "************************"
  # Loop through each database name on the host /etc/oratab . . .
  for db in `cat /etc/oratab|egrep ':N|:Y'|grep -v \*|\
  cut -f1 -':'"`
  do
          grep {db}|cut -f2 -d':'"`
     echo " "
     echo "database is $db"
     sqlplus system/manager@$db <<!
     select * from v\$database;
     exit;
!
  done





for db in `cat /etc/oratab
do
 egrep -v '^#|^$' |  egrep 'CDB_'| grep {db}|cut -f2 -d':'"`
 echo " "
 echo "database is $db"
 sqlplus system/Oracle19@$db <<!
 select name from v\$database;
 exit;
!
done





for db in `cat /etc/oratab 
do
 egrep -v '^#|^$' |  egrep 'CDB_'| grep {db}|cut -f2 -d':'"`
 echo " "
 echo "database is $db"
 sqlplus system/Oracle19@$db <<!
 col name     format a32
col size_mb  format 999,999,999
col used_mb  format 999,999,999
col pct_used format 999

select
   name,
   ceil( space_limit / 1024 / 1024) size_mb,
   ceil( space_used / 1024 / 1024) used_mb,
   decode( nvl( space_used, 0),0, 0,
   ceil ( ( space_used / space_limit) * 100) ) pct_used
from
    v$recovery_file_dest
order by
   name desc;
 exit;
!
done
