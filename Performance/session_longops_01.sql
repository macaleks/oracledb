SELECT a.username ,
  a.opname ,
  b.sql_text ,
  TO_CHAR(a.start_time,'DD-MON-YY HH24:MI') start_time ,
  a.elapsed_seconds how_long ,
  a.time_remaining secs_left ,
  a.sofar ,
  a.totalwork ,
  ROUND(a.sofar/a.totalwork*100,2) percent
FROM v$session_longops a ,
  v$sql b
WHERE a.sql_address  = b.address
AND a.sql_hash_value = b.hash_value
AND a.sofar         <> a.totalwork
AND a.totalwork     != 0;