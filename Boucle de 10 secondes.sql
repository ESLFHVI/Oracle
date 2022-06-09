set serverout on;
declare
 ltime date;
 begin
 ltime:=sysdate;
 dbms_output.put_line(to_char(lTime, 'dd-mm-yyyy hh24:mi:ss'));
 loop
 exit when sysdate = lTime + interval '10' second;
  end loop;
 dbms_output.put_line(to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss'));
  end;
 /
